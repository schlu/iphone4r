# Install hook code here
def copy_files(source_path, destination_path, directory)
  source, destination = File.join(directory, source_path), File.join(RAILS_ROOT, destination_path)
  FileUtils.mkdir(destination) unless File.exist?(destination)
  FileUtils.cp(Dir.glob(source+'/*'), destination)
end
directory = File.join(RAILS_ROOT, "vendor", "plugins", "iphone4r", "copy_on_install")
copy_files("/script", "/script", directory)
copy_files("/public/ibug", "/public/ibug", directory)