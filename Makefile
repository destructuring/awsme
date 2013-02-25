all: ready pyaws

ready:
	@git submodule update --init --recursive
	@bundle check 2>&1 >/dev/null || { bundle --local --path vendor/path > /dev/null && bundle check; }

pyaws: .awscli/bin/aws
	
.awscli/bin/aws: .awscli/bin/python
	@set +u; source .awscli/bin/activate; pip install --index-url=file://`pwd`/vendor/cache/pip/simple awscli

.awscli/bin/python:
	@python libexec/virtualenv.py --extra-search-dir=vendor --never-download .awscli
