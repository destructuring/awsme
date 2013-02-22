# Setting up AWS credentials

You can set environmental variables for `JAVA_HOME`, `AWS_ACCESS_KEY`,
`AWS_SECRET_KEY`, `EC2_PRIVATE_KEY`, and `EC2_CERT` outside of this
project.  The scripts will set them up if necessary/possible.

Credentials can also be written to `config/aws.yml`.  See
`config/aws.yml.example` for a template.

Certificates can be stored in `config/certificate.pem` and `config/private-key.pem`.

The ec2 command line tools are in `install/bin` which can be added to
your PATH.

A convenient script `bin/shell` will configure all of this in a bash
sub-shell.

If everything is configured, try running `ec2ver` and `ec2din`.
