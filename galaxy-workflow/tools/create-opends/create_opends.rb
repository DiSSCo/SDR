require 'json'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on("--catalog_number", "Catalog number") do |catalog_number|
    options[:catalog_number] = catalog_number
  end
    opts.on("--image_license", "Image license") do |image_license|
    options[:image_license] = image_license
  end
    opts.on("--image_uri", "Image URI") do |image_uri|
    options[:image_uri] = image_uri
  end
    opts.on("--object_type", "Object Type") do |object_type|
    options[:object_type] = object_type
  end
    opts.on("--rights_holder", "Rights Holder") do |rights_holder|
    options[:rights_holder] = rights_holder
  end
    opts.on("--registered_institution_url", "Registered Institution URL number") do |registered_institution_url|
    options[:registered_institution_url] = registered_institution_url
  end
    opts.on("--higher_classification", "Higher Classification") do |higher_classification|
    options[:higher_classification] = higher_classification
  end
    opts.on("--person_name", "Person Name") do |person_name|
    options[:person_name] = person_name
  end
    opts.on("--person_identifier", "Person Identifier") do |person_identifier|
    options[:person_identifier] = person_identifier
  end
    opts.on("--output", "Output") do |output|
    options[:output] = output
  end
end.parse!

#Add reqd args here
raise OptionParser::MissingArgument if options[:catalog_number].nil?
raise OptionParser::MissingArgument if options[:image_license].nil?
raise OptionParser::MissingArgument if options[:image_uri].nil?
raise OptionParser::MissingArgument if options[:object_type].nil?
raise OptionParser::MissingArgument if options[:rights_holder].nil?
raise OptionParser::MissingArgument if options[:registered_institution_url].nil?
raise OptionParser::MissingArgument if options[:higher_classification].nil?

open_DS = Hash.new

open_DS[:authoritative] =
  { :physicalSpecimenId => options[:catalog_number],
    :institution => [
      options[:rights_holder],
      options[:registered_institution_url]
    ],
    :materialType => options[:object_type] }
open_DS[:images] = {
  :availableImages => [{
                         :source => options[:image_uri],
                         :license => options[:image_license] }]
}
open_DS[:higher_classification] = options[:higher_classification]
if(!options[:person_name].nil?)
  open_DS[:person_name] = options[:person_name]
end
if(!options[:person_identifier].nil?)
  open_DS[:person_identifier] = options[:person_identifier]
end

puts open_DS.to_json
