require "net/http"
require 'resolv-replace'
require "uri"

DNS_SERVERS = %w[192.168.1.199 192.168.1.215]
DOMAINS = %w[www.ford.com www.toyota.com www.nissan.com www.jaguar.com]

def iterate_through_servers
  DNS_SERVERS.each do |server|
    puts "*********\n\n"
    puts "Testing DNS Server #{server}."

    `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`
    resolver = Resolv::DNS.new(:nameserver => [server],
                               :search => ['ruby-lang.org'],
                               :ndots => 1)

    iterate_through_domains(resolver)
  end
end

def iterate_through_domains(resolver)
  DOMAINS.each do |domain|
    puts "Testing #{domain}"
    begin
      res = resolver.getaddress(domain)
      pp res.to_name.to_s
    rescue Exception => exc
      puts exc.message
      #puts exc.backtrace
    end
  end
  resolver.close
end

iterate_through_servers
