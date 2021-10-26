require 'json'
require 'optparse'
require 'json-schema'

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
json = File.read(options[:open_ds])
valid = valid_json?(json)

#now check against schema
schema = File.read("/home/paulb1/galaxy/tools/sdr/validate-opends/opends_schema.json")
if(valid) then
  valid = JSON::Validator.validate(schema, json)
end

puts valid