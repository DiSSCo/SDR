require 'net/http'
require 'optparse' 

options = {}
OptionParser.new do |opts|
  opts.on("--image_uri=IMAGEURI") do |image_uri|
    options[:image_uri] = image_uri
  end
    opts.on("--file_name=FILENAME") do |file_name|
    options[:file_name] = file_name
  end
end.parse!

local_folder = '/home/paulb1/tempImages'

concat_file_name = File.join(local_folder, options[:file_name])

File.write(concat_file_name, Net::HTTP.get(URI.parse(options[:image_uri])))

concat_file_name