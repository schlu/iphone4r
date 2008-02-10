puts "-----------------------------"
puts "Iphone On Rails"
puts "Open a browser to http://#{self.defaults[:host]}:#{self.defaults[:port]}/ibug/firebug.html"
puts "_____________________________"

require 'thread'

$command_queue = Queue.new
$response_queue = Queue.new

class HttpComet
  def initialize(response)
    @response = response
  end

  def write(data)
    size = data.size
    @response.write(sprintf("%x;\r\n", size))
    @response.write(data)
    @response.write("\r\n")
    @response.flush
  end

  def close
    @response.write("0;\r\n")
    @response.done = true
    @response = nil
  end
end
  
class Mongrel::HttpResponse
  def comet(type,  status=200)
    write("HTTP/1.1 %d %s\r\nContent-Type: %s\r\nTransfer-Encoding: chunked\r\nConnection: close\r\n" % [status, HTTP_STATUS_CODES[status], type])
    write("\r\n")
    return HttpComet.new(self)
  end

  def flush
    @socket.flush
  end
end

class IbugPhone < Mongrel::HttpHandler
  def process(request, response)
    comet = response.comet("text/html")
    comet.write(PHONE)
    while true
      value = $command_queue.pop
      comet.write "<script type=\"application/x-javascript\">command('#{escapeJavaScript(value)}')</script>"
    end
    comet.write("</body></html>")
    comet.close
  end
  
  def escapeJavaScript(text)
    text.gsub(/\'/, "\\\\'").gsub(/\\n/, "\\\\n").gsub(/\\r/, "")
  end
end

class IbugBrowser < Mongrel::HttpHandler
  def process(request, response)
    comet = response.comet("text/html")
    comet.write(BROWSER)
    while true
      value = $response_queue.pop
      comet.write "<script type=\"application/x-javascript\">command('#{escapeJavaScript(value)}')</script>"
    end
    comet.write("</body></html>")
    comet.close
  end
  
  def escapeJavaScript(text)
    text.gsub(/\'/, "\\\\'").gsub(/\\n/, "\\\\n").gsub(/\\r/, "")
  end
end

class IbugResponse < Mongrel::HttpHandler
  def process(request, response)
    response.start(200) do |head, out|
      head["Content-Type"] = "text/html"
      $response_queue << Mongrel::HttpRequest.query_parse(request.params["QUERY_STRING"])["message"]
    end
  end
end

class IbugCommand < Mongrel::HttpHandler
  def process(request, response)
    response.start(200) do |head, out|
      head["Content-Type"] = "text/html"
      $command_queue << Mongrel::HttpRequest.query_parse(request.params["QUERY_STRING"])["message"]
    end
  end
end
uri "/ibug/phone", :handler => IbugPhone.new, :in_front => true
uri "/ibug/command", :handler => IbugCommand.new, :in_front => true
uri "/ibug/response", :handler => IbugResponse.new, :in_front => true
uri "/ibug/browser", :handler => IbugBrowser.new, :in_front => true


PHONE = <<-END
<html>
<head></head>
<body>
<script type="application/x-javascript">

var host = window.location.host;

function command(text)
{
    parent.console.command(text);
}
    
function respond(text)
{
    // Send the message using an img instead of XMLHttpRequest to avoid cross-domain security
    var img = document.createElement("img");
    img.style.visibility = "hidden";
    document.body.appendChild(img);
    img.onerror = function() { img.parentNode.removeChild(img); }

    var message = escape(text);
    img.src = "/ibug/response?message=" + message;
}

parent.console.handshake(respond);

</script>
END

BROWSER = <<-END
<html>
<head></head>
<body>
<script type="application/x-javascript">

function command(text)
{
    parent.command(text);
}

</script>
END
