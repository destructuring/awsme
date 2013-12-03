require 'yaml'
aws_secrets = YAML.load(File.read("#{ENV['AWSME']}/config/aws.yml"))

node.default[:aws][:access_key] = aws_secrets["aws_access_key_id"] || aws_secrets["AWS_ACCESS_KEY"]
node.default[:aws][:secret_key] = aws_secrets["aws_secret_access_key"] || aws_secrets["AWS_SECRET_KEY"]

template "#{ENV['AWSME']}/config/aws.txt" do
  source "aws.txt.erb"
  mode 0600
end
