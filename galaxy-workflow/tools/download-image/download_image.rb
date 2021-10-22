require 'net/http'
require 'optparse' 
require 'securerandom'

options = {}
OptionParser.new do |opts|
  opts.on("--image_uri=IMAGEURI") do |image_uri|
    options[:image_uri] = image_uri
  end
end.parse!

ext = options[:image_uri].split('.')[-1]
local_folder = '/home/paulb1/tempImages'
file_name = "#{SecureRandom.uuid}.#{ext}"

concat_file_name = File.join(local_folder, file_name)

File.write(concat_file_name, Net::HTTP.get(URI.parse(options[:image_uri])))

concat_file_name