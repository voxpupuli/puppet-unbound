# @summary
# @param enable
#   Whether to enable dnstap.
# @param bidirectional
#   Whether to enable bidirectional dnstap.
# @param socket_path
#   The path to the dnstap socket.
# @param ip
#   The IP address for dnstap.
# @param tls
#   Whether to enable TLS for dnstap.
# @param tls_host
#   The TLS host for dnstap.
# @param tls_cert_bundle
#   The path to the TLS certificate bundle.
# @param tls_cert_key_file
#   The path to the TLS certificate key file.
# @param tls_cert_cert_file
#   The path to the TLS certificate file.
# @param send_identity
#   Whether to send the identity in dnstap messages.
# @param send_version
#   Whether to send the version in dnstap messages.
# @param identity
#   The identity to send in dnstap messages.
# @param version
#   The version to send in dnstap messages.
# @param sample_rate
#   The sample rate for dnstap messages.
# @param log_resolver_query_messages
#   Whether to log resolver query messages.
# @param log_resolver_response_messages
#   Whether to log resolver response messages.
# @param log_client_query_messages
#   Whether to log client query messages.
# @param log_client_response_messages
#   Whether to log client response messages.
# @param log_forwarder_query_messages
#   Whether to log forwarder query messages.
# @param log_forwarder_response_messages
#   Whether to log forwarder response messages.
class unbound::dnstap (
  Boolean                        $enable                          = true,  # version 1.11
  Boolean                        $bidirectional                   = true,   # version 1.11
  Optional[Stdlib::Absolutepath] $socket_path                     = undef,  # version 1.11
  Optional[Unbound::Address]     $ip                              = undef,  # version 1.11
  Boolean                        $tls                             = true,   # version 1.11
  Optional[Stdlib::Host]         $tls_host                        = undef,  # version 1.11
  Optional[Stdlib::Absolutepath] $tls_cert_bundle                 = undef,  # version 1.11
  Optional[Stdlib::Absolutepath] $tls_cert_key_file               = undef,  # version 1.11
  Optional[Stdlib::Absolutepath] $tls_cert_cert_file              = undef,  # version 1.11
  Boolean                        $send_identity                   = false,  # version 1.11
  Boolean                        $send_version                    = false,  # version 1.11
  Optional[String[1]]            $identity                        = undef,  # version 1.11
  Optional[String[1]]            $version                         = undef,  # version 1.11
  Integer[0,1000]                $sample_rate                     = 0,      # version 1.21
  Boolean                        $log_resolver_query_messages     = false,  # version 1.11
  Boolean                        $log_resolver_response_messages  = false,  # version 1.11
  Boolean                        $log_client_query_messages       = false,  # version 1.11
  Boolean                        $log_client_response_messages    = false,  # version 1.11
  Boolean                        $log_forwarder_query_messages    = false,  # version 1.11
  Boolean                        $log_forwarder_response_messages = false,  # version 1.11

) {
  include unbound
  if $enable and $socket_path == undef and $ip == undef {
    fail('Either ip or socket_path is required when dnstap is enabled')
  }
  if $enable {
    $ip_config = $ip.then |$v| {
      @("CONFIG")
        ${unbound::print_config('dnstap-ip', $v, '1.11')}
        ${unbound::print_config('dnstap-tls', $tls, '1.11')}
        ${unbound::print_config('dnstap-tls-host', $tls_host, '1.11')}
        ${unbound::print_config('dnstap-tls-cert-bundle', $tls_cert_bundle, '1.11')}
        ${unbound::print_config('dnstap-tls-cert-key-file', $tls_cert_key_file, '1.11')}
        ${unbound::print_config('dnstap-tls-cert-cert-file', $tls_cert_cert_file, '1.11')}
        | CONFIG
    }
    $config = @("CONFIG")
      dnstap:
      ${unbound::print_config('dnstap-enable', $enable, '1.11')}
      ${unbound::print_config('dnstap-bidirectional', $bidirectional, '1.11')}
      ${unbound::print_config('dnstap-socket-path', $socket_path, '1.11')}
      ${$ip_config}
      ${unbound::print_config('dnstap-send-identity', $send_identity, '1.11')}
      ${unbound::print_config('dnstap-send-version', $send_version, '1.11')}
      ${unbound::print_config('dnstap-identity', $identity, '1.11')}
      ${unbound::print_config('dnstap-version', $version, '1.11')}
      ${unbound::print_config('dnstap-sample-rate', $sample_rate, '1.21')}
      ${unbound::print_config('dnstap-log-resolver-query-messages', $log_resolver_query_messages, '1.11')}
      ${unbound::print_config('dnstap-log-resolver-response-messages', $log_resolver_response_messages, '1.11')}
      ${unbound::print_config('dnstap-log-client-query-messages', $log_client_query_messages, '1.11')}
      ${unbound::print_config('dnstap-log-client-response-messages', $log_client_response_messages, '1.11')}
      ${unbound::print_config('dnstap-log-forwarder-query-messages', $log_forwarder_query_messages, '1.11')}
      ${unbound::print_config('dnstap-log-forwarder-response-messages', $log_forwarder_response_messages, '1.11')}
      | CONFIG
    concat::fragment { 'unbound-dnstap':
      order   => '20',
      target  => $unbound::config_file,
      content => $config.split("\n").filter |$x| { !$x.empty }.join("\n"),
    }
  }
}
