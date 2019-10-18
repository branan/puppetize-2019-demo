#!/opt/puppetlabs/puppet/bin/ruby

require 'net/http'
require 'json'
require 'openssl'


TOKEN=`echo 'A Password!' | puppet access login admin --print 2>&1 | grep -v 'Enter your' | grep -v 'Password' | tr -d '\n'`

user = {
    login: "someone_else",
    email: "example@example.com",
    role_ids: [],
    password: "A Password!",
    display_name: "Someone Else"
}

uri = URI('https://localhost:4433/rbac-api/v1/users')
req = Net::HTTP::Post.new(uri)
req['X-Authentication'] = TOKEN
req['Content-Type'] = 'Application/json'
req.body = JSON.dump(user)

res = Net::HTTP.start('localhost', 4433, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
  http.request(req)
end

puts "#{res.body}"
user = res['Location'].split('/').last

role = {
  permissions: [
    {
      object_type: "console_page",
      action: "view",
      instance: "*"
    },
    {
      object_type: "orchestrator",
      action: "view",
      instance: "*",
    }     
  ],
  user_ids: [user],
  group_ids: [],
  display_name: "Another Team",
  description: '"That" Team'
}

uri = URI('https://localhost:4433/rbac-api/v1/roles')
req = Net::HTTP::Post.new(uri)
req['X-Authentication'] = TOKEN
req['content-type'] = 'application/json'
req.body = JSON.dump(role)

res = Net::HTTP.start('localhost', 4433, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
  http.request(req)
end

