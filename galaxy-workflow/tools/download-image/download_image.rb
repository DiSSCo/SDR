require 'net/http'
require 'optparse' 
require 'securerandom'
require 'json'
require 'fastimage'

options = {}
OptionParser.new do |opts|
  opts.on("--opends=OPENDS") do |open_ds|
    options[:open_ds] = open_ds
  end
end.parse!

##### Get the OpenDS object
open_ds = JSON.parse(File.read(options[:open_ds]))

##### Create a file name
image_uri = open_ds["images"]["availableImages"][0]["source"]
ext = FastImage.type(image_uri).to_s #get file type by mime type
file_name = "#{SecureRandom.uuid}.#{ext}" 
File.write(file_name, Net::HTTP.get(URI.parse(image_uri)))

##### Read file metadata
size_array = FastImage.size(file_name)
open_ds["payloads"] = Hash.new
open_ds["payloads"]["name"] = 'original image'
open_ds["payloads"]["filename"] = file_name
open_ds["payloads"]["width"] = size_array[0]
open_ds["payloads"]["height"] = size_array[1]
open_ds["payloads"]["mediaType"] = "image/#{ext}"
open_ds["payloads"]["size n"] = File.size(file_name)


puts open_ds.to_json

