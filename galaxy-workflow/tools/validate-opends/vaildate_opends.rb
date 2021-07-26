require 'json'
require 'optparse'

def valid_json?(json)
  JSON.parse(json)
  return true
rescue JSON::ParserError => e
  return false
end

options = {}
OptionParser.new do |opts|
  opts.on("--opends=OPENDS", "openDS") do |open_ds|
    options[:open_ds] = open_ds
  end

end.parse!

#first check that we have valid JSON
json = File.open(options[:open_ds]).read




puts valid_json?(json)
