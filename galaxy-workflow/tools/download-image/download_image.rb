require 'net/http'
require 'optparse' #TODO - implement options parser to make args optional

image_URI = 'http://google.com'
local_folder = ''
file_name = 'test.name'

concat_file_name = File.join(local_folder, file_name)

File.write(concat_file_name, Net::HTTP.get(URI.parse(image_URI)))

sleep(5000)
concat_file_name