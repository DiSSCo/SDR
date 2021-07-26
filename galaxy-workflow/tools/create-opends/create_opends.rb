require 'json'
require 'optparse' #TODO - implement options parser to make args optional

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
    opts.on("--object_type", "Object Type") do |ot|
    options[:object_type] = ot
  end
    opts.on("--rights_holder", "Rights Holder") do |rh|
    options[:rights_holder] = rh
  end
    opts.on("--registered_institution_url", "Registered Institution URL number") do |riu|
    options[:registered_institution_url] = riu
  end
    opts.on("--higher_classification", "Higher Classification") do |hc|
    options[:higher_classification] = hc
  end
    opts.on("--person_name", "Person Name") do |pn|
    options[:person_name] = pn
  end
    opts.on("--person_identifier", "Person Identifier") do |pi|
    options[:person_identifier] = i
  end
    opts.on("--output", "Output") do |o|
    options[:output] = o
  end

end.parse!

#Add reqd args here
raise OptionParser::MissingArgument if options[:image_uri].nil?



open_DS = Hash.new

open_DS[:authoritative] = { :physicalSpecimenId => options[:catalog_number], :institution => [options[:rights_holder], options[:registered_institution_url]], :materialType => options[:object_type] }
open_DS[:images] = { :availableImages => [{:source => options[:image_uri], :license => options[:image_license] }] }
open_DS[:higher_classification] = options[:higher_classification]
open_DS[:person_name] = options[:person_name] 
open_DS[:person_identifier] = options[:person_identifier]

puts open_DS.to_json


#catalog_number = 'MNHN-IM-2013-8488'
#image_license = 'CC BY 4.0'
#image_URI = 'http://mediaphoto.mnhn.fr/media/1427463506459UAeHPJw9jXoET1sF'
#object_type = 'Alcohol, 95%'
#rights_holder = 'MNHN'
#registered_institution_url = 'https://ror.org/03wkt5x30'
#higher_classification = 'Gastropoda'
#person_name = 'Laurence Livermore'
#person_identifier = 'LL123'