SHELL := /bin/bash

LATEST_CFN ?= $(shell ls -d $(AWSME_CLI)/AWSCloudFormation-* | bin/latest-release)
LATEST_ELASTICACHE ?= $(shell ls -d $(AWSME_CLI)/AmazonElastiCacheCli-* | bin/latest-release)
LATEST_AS ?= $(shell ls -d $(AWSME_CLI)/AutoScaling-* | bin/latest-release)
LATEST_MON ?= $(shell ls -d $(AWSME_CLI)/CloudWatch-* | bin/latest-release)
LATEST_CS ?= $(shell ls -d $(AWSME_CLI)/cloud-search-tools-* | bin/latest-release)
LATEST_ELB ?= $(shell ls -d $(AWSME_CLI)/ElasticLoadBalancing-* | bin/latest-release)
LATEST_IAM ?= $(shell ls -d $(AWSME_CLI)/IAMCli-* | bin/latest-release)
LATEST_RDS ?= $(shell ls -d $(AWSME_CLI)/RDSCli-* | bin/latest-release)
LATEST_EC2 ?= $(shell ls -d $(AWSME_CLI)/ec2-api-tools-* | bin/latest-release)
LATEST_AMI ?= $(shell ls -d $(AWSME_CLI)/ec2-ami-tools-* | bin/latest-release)

all: ready

ready:
	@git submodule update --init --recursive
	@bundle check --path vendor/bundle 2>&1 >/dev/null || bundle --local --path vendor/bundle 2>&1 > /dev/null
	@bin/cook -j config/microwave.json

$(AWSME_CLI)/.gitignore:
	@mkdir -p $(AWSME_CLI)
	@touch $(AWSME_CLI)/.gitignore

cli: \
	$(AWSME_CLI)/AWSCloudFormation-cli.zip $(AWSME_CLI)/AWSCloudFormation-cli.zip \
	$(AWSME_CLI)/ElasticLoadBalancing.zip $(AWSME_CLI)/IAMCli.zip \
	$(AWSME_CLI)/AmazonElastiCacheCli-latest.zip $(AWSME_CLI)/RDSCli.zip \
	$(AWSME_CLI)/AutoScaling-2011-01-01.zip \
	$(AWSME_CLI)/CloudWatch-2010-08-01.zip \
	$(AWSME_CLI)/cloud-search-tools-1.0.2.3-2013.08.02.tar.gz \
	$(AWSME_CLI)/ec2/bin/ec2-version $(AWSME_CLI)/ec2/bin/ec2-ami-tools-version $(AWSME_CLI)/ec2/bin/ec2-metadata
	@ln -nfs $(LATEST_CFN) $(AWSME_CLI)/cfn
	@ln -nfs $(LATEST_ELASTICACHE) $(AWSME_CLI)/elasticache
	@ln -nfs $(LATEST_AS) $(AWSME_CLI)/as
	@ln -nfs $(LATEST_MON) $(AWSME_CLI)/mon
	@ln -nfs $(LATEST_CS) $(AWSME_CLI)/cs
	@ln -nfs $(LATEST_ELB) $(AWSME_CLI)/elb
	@ln -nfs $(LATEST_IAM) $(AWSME_CLI)/iam
	@ln -nfs $(LATEST_RDS) $(AWSME_CLI)/rds

$(AWSME_CLI)/AWSCloudFormation-cli.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://s3.amazonaws.com/cloudformation-cli/AWSCloudFormation-cli.zip
	@cd $(AWSME_CLI) && unzip -o $@

$(AWSME_CLI)/AmazonElastiCacheCli-latest.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://s3.amazonaws.com/elasticache-downloads/AmazonElastiCacheCli-latest.zip
	@cd $(AWSME_CLI) && unzip -o $@

$(AWSME_CLI)/ElasticLoadBalancing.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip
	@cd $(AWSME_CLI) && unzip -o $@

$(AWSME_CLI)/IAMCli.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://awsiammedia.s3.amazonaws.com/public/tools/cli/latest/IAMCli.zip
	@cd $(AWSME_CLI) && unzip -o $@

$(AWSME_CLI)/RDSCli.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://s3.amazonaws.com/rds-downloads/RDSCli.zip
	@cd $(AWSME_CLI) && unzip -o $@

$(AWSME_CLI)/AutoScaling-2011-01-01.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip
	@cd $(AWSME_CLI) && unzip -o $@

$(AWSME_CLI)/CloudWatch-2010-08-01.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip
	@cd $(AWSME_CLI) && unzip -o $@

$(AWSME_CLI)/cloud-search-tools-1.0.2.3-2013.08.02.tar.gz: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://s3.amazonaws.com/amazon-cloudsearch-data/cloud-search-tools-1.0.2.3-2013.08.02.tar.gz
	@cd $(AWSME_CLI) && tar xvfz $@

$(AWSME_CLI)/ec2-api-tools.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip
	@cd $(AWSME_CLI) && unzip -o $@

$(AWSME_CLI)/ec2-ami-tools.zip: $(AWSME_CLI)/.gitignore
	@cd $(AWSME_CLI) && curl -O http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip
	@cd $(AWSME_CLI) && unzip -o $@

$(AWSME_CLI)/ec2/bin/ec2-version: $(AWSME_CLI)/ec2-api-tools.zip $(AWSME_CLI)/ec2-ami-tools.zip
	@mkdir -p $(AWSME_CLI)/ec2
	@rsync -iaO --exclude license.txt --exclude notice.txt $(LATEST_EC2)/. $(AWSME_CLI)/ec2/

$(AWSME_CLI)/ec2/bin/ec2-metadata: $(AWSME_CLI)/ec2/bin/ec2-version
	curl http://s3.amazonaws.com/ec2metadata/ec2-metadata > $@.tmp
	chmod 755 $@.tmp
	mv $@.tmp $@

$(AWSME_CLI)/ec2/bin/ec2-ami-tools-version: $(AWSME_CLI)/ec2/bin/ec2-metadata
	@rsync -ia $(LATEST_AMI)/. $(AWSME_CLI)/ec2/
