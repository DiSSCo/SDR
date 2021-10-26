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
local_folder = '/home/paulb1/tempImages'
image_uri = open_ds["images"]["availableImages"][0]["source"]
ext = FastImage.type(image_uri).to_s #get file type by mime type
file_name = "#{SecureRandom.uuid}.#{ext}" 
concat_file_name = File.join(local_folder, file_name)
File.write(concat_file_name, Net::HTTP.get(URI.parse(image_uri)))

##### Read file metadata
size_array = FastImage.size(concat_file_name)
open_ds["payloads"] = Hash.new
open_ds["payloads"]["name"] = 'original image'
open_ds["payloads"]["filename"] = concat_file_name
open_ds["payloads"]["width"] = size_array[0]
open_ds["payloads"]["height"] = size_array[1]
open_ds["payloads"]["mediaType"] = "image/#{ext}"
open_ds["payloads"]["size n"] = File.size(concat_file_name)


puts open_ds.to_json

