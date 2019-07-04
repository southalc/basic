# Create binary files from base64 encoded data
#
# The type accepts a single parameter, 'properties', that contains file names
# as keys with associated attributes of each file.  The attributes of a binary
# are the same as native 'file' resources, with the difference being that
# 'content' is a base64 encoded string that is decoded and written to the
# target file.

define basic::binary (
  Hash $properties,
) {
  $content = base64('decode',$properties[$name]['content'])
  $data = { $name => merge($properties[$name], { content => $content}) }
  create_resources('File',$data)
}
