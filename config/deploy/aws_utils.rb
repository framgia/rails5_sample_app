require "yaml"
require "aws-sdk"

def get_ec2_targets
  init_data
  targets = {}
  @instance_name_tags.each do |role_name, tag_names|
    targets[role_name] = @ec2.describe_instances(filters:[{ name: "tag:Name", values: tag_names }, { name: "instance-state-name", values: ["running"] }]).reservations
      .map(&:instances).flatten.map(&:private_ip_address).compact
  end
  targets
end

def update_ec2_tags ref_type, ref_name, last_commit
  init_data
  @ec2.describe_instances(filters:[{ name: "tag:Name", values: @instance_name_tags.values }, { name: "instance-state-name", values: ["running"] }]).reservations
    .map(&:instances).flatten.compact.each do |instance|
      @ec2.create_tags({
        resources: [instance.instance_id],
        tags: [
          {key: "DEPLOY_REF_TYPE", value: ref_type},
          {key: "DEPLOY_REF", value: ref_name},
          {key: "LAST_COMMIT", value: last_commit},
        ]
      })
      puts <<-EOM
An EC2 instance #{instance.private_ip_address} has been tagged as follows:
- DEPLOY_REF_TYPE: #{ref_type}
- DEPLOY_REF: #{ref_name}
- LAST_COMMIT: #{last_commit}
EOM
    end
end

private
def init_data
  deploying_roles = ENV["DEPLOYING_ROLES"].split(",")
  @instance_name_tags ||= YAML
    .load_file(ENV["SETTING_FILE"] || "config/deploy/settings.yml")["instance_name_tags"][ENV["RAILS_ENV"]]
    .select { |role_name, _| deploying_roles.include? role_name }
  @ec2 ||= Aws::EC2::Client.new(region: ENV["AWS_REGION"])
end
