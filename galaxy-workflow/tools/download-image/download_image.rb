require 'net/http'
require 'optparse' 

options = {}
OptionParser.new do |opts|
  opts.on("--image_URI=IMAGEURI") do |image_URI|
    options[:image_URI] = image_URI
  end
  opts.on("--local_folder=LOCALFOLDER") do |local_folder|
    options[:local_folder] = local_folder
  end
    opts.on("--file_name=FILENAME") do |file_name|
    options[:file_name] = file_name
  end
end.parse!

concat_file_name = File.join(options[:local_folder], options[:file_name])

File.write(concat_file_name, Net::HTTP.get(URI.parse(options[:image_URI])))

concat_file_name