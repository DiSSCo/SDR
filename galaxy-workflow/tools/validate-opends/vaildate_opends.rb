require 'json'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on("--opends=OPENDS", "openDS") do |open_ds|
    options[:open_ds] = open_ds
  end

end.parse!

