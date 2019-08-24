# Create binary files from base64 encoded data
#
# The type accepts the parameter 'properties' that contains file names as keys
# with associated attributes of each file.  The attributes of a binary are the
# same as native 'file' resources, with the difference being that 'content' is
# a base64 encoded string that is decoded and written to the target file.
# The 'defaults' parameter can also be passed as a simple 'key'='value' hash
# that may be useful in reducing the amount of data to be defined for each
# resource.

define basic::binary (
  Hash $properties,
  $defaults = lookup('basic::binary::defaults', Hash, 'hash', {})
) {
  $content = base64('decode',$properties[$name]['content'])
  $data = { $name => merge($properties[$name], { content => $content}) }

  $data.each |String $file, Hash $options| {
    File {
      $file:   * => $options;
      default: * => $defaults;
    }
  }
}

