require 'json'

ssh_config = `vagrant ssh-config`

hosts = []
host = nil
match = ENV['PT_match']

ssh_config.lines().each do |line|
  bits = line.strip().split(' ').compact()
  key = bits[0]
  value = bits[1]
  if key == "Host"
    host = {}
    hosts << host
  end
  host.merge!({ key => value})
end

hosts.map! do |host|
  {
    "name" => host["Host"],
    "config" => {
      "transport" => "ssh",
      "ssh" => {
        "host" => host["HostName"],
        "user" => host["User"],
        "port" => host["Port"],
        "host-key-check" => false,
        "private-key" => host["IdentityFile"],
        "run-as" => "root"
      }
    }
  }
end

hosts.select! do |host|
  host['name'].include? match
end

puts JSON.dump({'value' => hosts})
