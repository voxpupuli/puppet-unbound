# @summary function to split TXT records. Long TXT records must be broken into strings of 255 characters as per RFC 4408
# @param data A TXT record to split
# @return A string of 255 character strings
function unbound::split_txt(
  String[1] $data
) >> String[1] {
  $data.slice(255).map |$slice| { "\"${slice.join}\"" }.join
}
