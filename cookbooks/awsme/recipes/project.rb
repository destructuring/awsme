require 'yaml'
aws_secrets = YAML.load(File.read(File.join(node[:release_dir], "config", "aws.yml")))

node.default[:aws][:access_key] = aws_secrets["AWS_ACCESS_KEY"]
node.default[:aws][:secret_key] = aws_secrets["AWS_SECRET_KEY"]

template "#{node[:release_dir]}/config/aws.txt" do
  source "aws.txt.erb"
  mode 0600
end
