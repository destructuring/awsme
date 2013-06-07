SHELL := /bin/bash

all: ready

ready:
	@git submodule update --init --recursive
	@bundle check 2>&1 >/dev/null || { bundle --local --path vendor/bundle 2>&1 > /dev/null || bundle check; }
	@bin/cook -j config/microwave.json

vivify:
	@mkdir -p vendor/projects

pyaws: .awscli/bin/aws
	
.awscli/bin/aws: .awscli/bin/python
	set +u; source .awscli/bin/activate; pip install --index-url=file://`pwd`/vendor/cache/pip/simple awscli

.awscli/bin/python:
	python libexec/virtualenv.py --extra-search-dir=vendor --never-download .awscli

awscli: \
	vendor/projects/AWSCloudFormation-cli.zip vendor/projects/AWSCloudFormation-cli.zip vendor/projects/AutoScaling-2011-01-01.zip \
	vendor/projects/CloudWatch-2010-08-01.zip vendor/projects/ElasticLoadBalancing.zip vendor/projects/IAMCli.zip \
	vendor/projects/ec2/bin/ec2-version vendor/projects/ec2/bin/ec2-ami-tools-version

vendor/projects/AWSCloudFormation-cli.zip: vivify
	@cd vendor/projects && wget https://s3.amazonaws.com/cloudformation-cli/AWSCloudFormation-cli.zip
	@ln -nfs AWSCloudFormation-1.0.12 vendor/projects/cfn
	@cd vendor/projects && unzip AWSCloudFormation-cli.zip

vendor/projects/AmazonElastiCacheCli-latest.zip: vivify
	@cd vendor/projects && wget https://s3.amazonaws.com/elasticache-downloads/AmazonElastiCacheCli-latest.zip
	@ln -nfs AmazonElastiCacheCli-1.8.000 vendor/projects/elasticache
	@cd vendor/projects && unzip AmazonElastiCacheCli-latest.zip

vendor/projects/AutoScaling-2011-01-01.zip: vivify
	@cd vendor/projects && wget http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip
	@ln -nfs AutoScaling-1.0.61.2 vendor/projects/as
	@cd vendor/projects && unzip AutoScaling-2011-01-01.zip

vendor/projects/CloudWatch-2010-08-01.zip: vivify
	@cd vendor/projects && wget http://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip
	@ln -nfs CloudWatch-1.0.13.4 vendor/projects/mon
	@cd vendor/projects && unzip CloudWatch-2010-08-01.zip

vendor/projects/ElasticLoadBalancing.zip: vivify
	@cd vendor/projects && wget http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip
	@ln -nfs ElasticLoadBalancing-1.0.17.0 vendor/projects/elb
	@cd vendor/projects && unzip ElasticLoadBalancing.zip

vendor/projects/IAMCli.zip: vivify
	@cd vendor/projects && wget http://awsiammedia.s3.amazonaws.com/public/tools/cli/latest/IAMCli.zip
	@ln -nfs IAMCli-1.5.0 vendor/projects/iam
	@cd vendor/projects && unzip IAMCli.zip

vendor/projects/ec2-api-tools.zip: vivify
	@cd vendor/projects && wget http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip
	@cd vendor/projects && unzip ec2-api-tools.zip

vendor/projects/ec2-ami-tools.zip: vivify
	@cd vendor/projects && wget http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip
	@cd vendor/projects && unzip ec2-ami-tools.zip

vendor/projects/ec2/bin/ec2-version: vendor/projects/ec2-api-tools.zip
	@mkdir -p vendor/projects/ec2
	@rsync -ia vendor/projects/ec2-api-tools-1.6.7.3/. vendor/projects/ec2/

vendor/projects/ec2/bin/ec2-ami-tools-version: vendor/projects/ec2/bin/ec2-version vendor/projects/ec2-ami-tools.zip
	@rsync -ia vendor/projects/ec2-ami-tools-1.4.0.9/. vendor/projects/ec2/

