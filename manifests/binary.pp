# Create binary files from base64 encoded data
#
# The type accepts a single parameter, 'file' that is a hash containing the
# same keys as a standard 'file' resource.  The difference is that 'content'
# is a base64 encoded string that is decoded and written to the target file.

define basic::binary(
  Hash $file,
) {
  $content = base64('decode',$file['content'])
  $data = { $name => merge($file, { content => $content}) }
  create_resources('File',$data)
}
