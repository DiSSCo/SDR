require 'json'
require 'optparse' #TODO - implement options parser to make args optional

catalog_number = 'MNHN-IM-2013-8488'
image_license = 'CC BY 4.0'
image_URI = 'http://mediaphoto.mnhn.fr/media/1427463506459UAeHPJw9jXoET1sF'
object_type = 'Alcohol, 95%'
rights_holder = 'MNHN'
registered_institution_url = 'https://ror.org/03wkt5x30'
higher_classification = 'Gastropoda'
person_name = 'Laurence Livermore'
person_identifier = 'LL123'

open_DS = Hash.new

open_DS[:authoritative] = { :physicalSpecimenId => catalog_number, :institution => [rights_holder, registered_institution_url], :materialType => object_type }
open_DS[:images] = { :availableImages => [{:source => image_URI, :license => image_license }] }
open_DS[:higher_classification] = higher_classification
open_DS[:person_name] = person_name 
open_DS[:person_identifier] = person_identifier

open_DS.to_json
