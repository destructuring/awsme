SHELL := /bin/bash
AWSME_CLI := $(AWSME)/vendor/projects

all: ready

ready:
	@git submodule update --init --recursive
	@bundle check 2>&1 >/dev/null || { bundle --local --path vendor/bundle 2>&1 > /dev/null || bundle check; }
	@bin/cook -j config/microwave.json

$(AWSME_CLI)/.gitignore:
	@mkdir -p $(AWSME_CLI)
	@touch $(AWSME_CLI)/.gitignore

pyaws: .awscli/bin/aws
	
.awscli/bin/aws: .awscli/bin/python
	set +u; source .awscli/bin/activate; pip install --index-url=file://`pwd`/vendor/cache/pip/simple awscli

.awscli/bin/python:
	python libexec/virtualenv.py --extra-search-dir=vendor --never-download .awscli

awscli: \
	$(AWSME_CLI)/AWSCloudFormation-cli.zip $(AWSME_CLI)/AWSCloudFormation-cli.zip $(AWSME_CLI)/AutoScaling-2011-01-01.zip \
	$(AWSME_CLI)/CloudWatch-2010-08-01.zip $(AWSME_CLI)/ElasticLoadBalancing.zip $(AWSME_CLI)/IAMCli.zip \
	$(AWSME_CLI)/ec2/bin/ec2-version $(AWSME_CLI)/ec2/bin/ec2-ami-tools-version

$(AWSME_CLI)/AWSCloudFormation-cli.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && wget https://s3.amazonaws.com/cloudformation-cli/AWSCloudFormation-cli.zip
	@ln -nfs AWSCloudFormation-1.0.12 $(AWSME_CLI)/cfn
	@cd $(AWSME_CLI) && unzip AWSCloudFormation-cli.zip

$(AWSME_CLI)/AmazonElastiCacheCli-latest.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && wget https://s3.amazonaws.com/elasticache-downloads/AmazonElastiCacheCli-latest.zip
	@ln -nfs AmazonElastiCacheCli-1.8.000 $(AWSME_CLI)/elasticache
	@cd $(AWSME_CLI) && unzip AmazonElastiCacheCli-latest.zip

$(AWSME_CLI)/AutoScaling-2011-01-01.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && wget http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip
	@ln -nfs AutoScaling-1.0.61.2 $(AWSME_CLI)/as
	@cd $(AWSME_CLI) && unzip AutoScaling-2011-01-01.zip

$(AWSME_CLI)/CloudWatch-2010-08-01.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && wget http://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip
	@ln -nfs CloudWatch-1.0.13.4 $(AWSME_CLI)/mon
	@cd $(AWSME_CLI) && unzip CloudWatch-2010-08-01.zip

$(AWSME_CLI)/ElasticLoadBalancing.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && wget http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip
	@ln -nfs ElasticLoadBalancing-1.0.17.0 $(AWSME_CLI)/elb
	@cd $(AWSME_CLI) && unzip ElasticLoadBalancing.zip

$(AWSME_CLI)/IAMCli.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && wget http://awsiammedia.s3.amazonaws.com/public/tools/cli/latest/IAMCli.zip
	@ln -nfs IAMCli-1.5.0 $(AWSME_CLI)/iam
	@cd $(AWSME_CLI) && unzip IAMCli.zip

$(AWSME_CLI)/ec2-api-tools.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && wget http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip
	@cd $(AWSME_CLI) && unzip ec2-api-tools.zip

$(AWSME_CLI)/ec2-ami-tools.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && wget http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip
	@cd $(AWSME_CLI) && unzip ec2-ami-tools.zip

$(AWSME_CLI)/ec2/bin/ec2-version: $(AWSME_CLI)/ec2-api-tools.zip
	@mkdir -p $(AWSME_CLI)/ec2
	@rsync -ia $(AWSME_CLI)/ec2-api-tools-1.6.7.3/. $(AWSME_CLI)/ec2/

$(AWSME_CLI)/ec2/bin/ec2-ami-tools-version: $(AWSME_CLI)/ec2/bin/ec2-version $(AWSME_CLI)/ec2-ami-tools.zip
	@rsync -ia $(AWSME_CLI)/ec2-ami-tools-1.4.0.9/. $(AWSME_CLI)/ec2/

