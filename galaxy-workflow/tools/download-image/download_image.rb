require 'net/http'
require 'optparse' 
require 'securerandom'
require 'json'
require 'exifr'

options = {}
OptionParser.new do |opts|
  opts.on("--opends=OPENDS") do |open_ds|
    options[:open_ds] = open_ds
  end
end.parse!



open_ds=JSON.parse(options[:open_ds])
image_uri = open_DS[:images][:availableImages][0][:source]
ext = image_uri.split('.')[-1]
local_folder = '/home/paulb1/tempImages'
file_name = "#{SecureRandom.uuid}.#{ext}"

concat_file_name = File.join(local_folder, file_name)

File.write(concat_file_name, Net::HTTP.get(image_uri))

open_ds=JSON.parse(options[:open_ds])

#####read file metadata
EXIFR::JPEG.new('IMG_6841.JPG').width                  


#####create json payload
open_DS[:images][:availableImages][0][:imageWidth] = EXIFR::JPEG.new('IMG_6841.JPG').width               



#####put json payload into opends



opends = options[:open_ds] + "text"
