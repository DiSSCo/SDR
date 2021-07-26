require 'json'
require 'optparse' #TODO - implement options parser to make args optional

options = {}
OptionParser.new do |opts|
  opts.on("-cn", "--[catalog_number", "Catalog number") do |cn|
    options[:catalog_number] = cn
  end
    opts.on("-il", "--[image_license", "Image license") do |il|
    options[:image_license] = cn
  end
    opts.on("-iu", "--[image_uri", "Image URI") do |iu|
    options[:image_uri] = iu
  end
    opts.on("-ot", "--[object_type", "Object Type") do |ot|
    options[:object_type] = ot
  end
    opts.on("-rh", "--[rights_holder", "Rights Holder") do |rh|
    options[:rights_holder] = rh
  end
    opts.on("-riu", "--[registered_institution_url", "Registered Institution URL number") do |riu|
    options[:registered_institution_url] = riu
  end
    opts.on("-hc", "--[higher_classification", "Higher Classification") do |hc|
    options[:higher_classification] = hc
  end
    opts.on("-pn", "--[person_name", "Person Name") do |pn|
    options[:person_name] = pn
  end
    opts.on("-pi", "--[person_identifier", "Person Identifier") do |pi|
    options[:person_identifier] = i
  end
    opts.on("-o", "--[output", "Output") do |o|
    options[:output] = o
  end
end.parse!

#catalog_number = 'MNHN-IM-2013-8488'
#image_license = 'CC BY 4.0'
#image_URI = 'http://mediaphoto.mnhn.fr/media/1427463506459UAeHPJw9jXoET1sF'
#object_type = 'Alcohol, 95%'
#rights_holder = 'MNHN'
#registered_institution_url = 'https://ror.org/03wkt5x30'
#higher_classification = 'Gastropoda'
#person_name = 'Laurence Livermore'
#person_identifier = 'LL123'

open_DS = Hash.new

open_DS[:authoritative] = { :physicalSpecimenId => options[:catalog_number], :institution => [options[:rights_holder], options[:registered_institution_url]], :materialType => options[:object_type] }
open_DS[:images] = { :availableImages => [{:source => options[:image_uri], :license => options[:image_license] }] }
open_DS[:higher_classification] = options[:higher_classification]
open_DS[:person_name] = options[:person_name] 
open_DS[:person_identifier] = options[:person_identifier]

open_DS.to_json
