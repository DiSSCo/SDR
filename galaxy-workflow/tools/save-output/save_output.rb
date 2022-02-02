require 'json'
require 'optparse'
require 'fileutils'

options = {}
OptionParser.new do |opts|
  opts.on("--opends=OPENDS", "Opends") do |opends|
    options[:opends] = opends
  end
  opts.on("--output_dir=OUTPUT_DIR", "Output Dir") do |output_dir|
    options[:output_dir] = output_dir
  end
  opts.on("--batch_id=BATCH_ID", "Batch Id") do |batch_id|
    options[:batch_id] = batch_id
  end

end.parse!

rootdir = "/var/www/html/galaxy/results" + options[:output_dir]
batchdir =  File.join(rootdir, options[:batch_id])
outputfile = File.join(batchdir, File.basename(options[:opends]))
file_listing = File.join(rootdir, "files")

unless File.directory?(rootdir)
  FileUtils.mkdir_p(rootdir)
end

unless File.directory?(batchdir)
  FileUtils.mkdir_p(batchdir)
end

unless File.file?(rootdir)
  FileUtils.touch file_listing
end
	
FileUtils.cp(options[:opends], outputfile)

open('file_listing', 'a') do |f|
  f.puts outputfile
end