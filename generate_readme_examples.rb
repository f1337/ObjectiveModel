#!/usr/bin/env ruby

output = ''

# locate all the OMActiveModel helpers under the validator directories
Dir.glob('ObjectiveModel/Validations/*/OMActiveModel+*.h') do |path|
  # skip if the path is not a file
  next if (! File.file?(path))

  # open the file for reading
  file = File.open(path, "r")
  # read the file source
  source = file.read

  # find the headerdoc: /*! ... */
  if ( match = source.match(/^\/\*!\s+(.+?(?=\*\/))/im) ) then
    # infer the validator class name from the file name
    name = File.basename(path, ".h").sub('OMActiveModel+', 'OM').sub('Validation', 'Validator')
    # write the output heading
    output += "### #{name}\n\n" unless name.empty?
    # remove @params from the description
    description = match[1].gsub(/\n@param[^\n]+/, '')
    # write the output description, sans padding
    output += description.chomp
    # write the output footnote
    output += "\n\n(cf: <https://github.com/f1337/ObjectiveModel/tree/master/#{path}>)\n\n\n\n"
  end

end

puts output
