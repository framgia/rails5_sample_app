instances = fetch(:instances)

instances.each do |role_name, hosts|
  role(role_name.to_sym, hosts.map { |host| fetch(:deployer) + "@" + host })
end

instances.each do |role_name, hosts|
  hosts.each do |host|
    server(host, user: fetch(:deployer), roles: [role_name])
  end
end
