#!/usr/bin/env ruby

README_PATH = './README.md'
SOURCE_GLOB = 'ObjectiveModel/Validations/*/OMActiveModel+*.h'
SOURCE_BASE_URL = 'https://github.com/f1337/ObjectiveModel/tree/master/'



###################################
# PARSE THE SOURCE COMMENTS
###################################

output = ''

# locate all the OMActiveModel helpers under the validator directories
Dir.glob(SOURCE_GLOB) do |path|
  # skip if the path is not a file
  next if (! File.file?(path))

  # read the file source
  next unless (source = File.open(path, "r").read)

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
    output += "\n\n(cf: <#{SOURCE_BASE_URL}#{path}>)\n\n\n\n"
  end

end



###################################
# PARSE THE SOURCE COMMENTS
###################################

# open the README file
if ( readme = File.open(README_PATH, "r").read ) then
  # replace the content between
  #   <!-- BEGIN EXAMPLES --> 
  # and
  #   <!-- END EXAMPLES -->
  # with the parsed source code examples
  puts readme.sub(/(<!\-\- BEGIN EXAMPLES \-\->).+?(?=<!\-\- END EXAMPLES \-\->)/m, "\\1\n\n#{output}")
end

#puts output
