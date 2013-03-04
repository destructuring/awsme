# Setting up AWS credentials

You can set environmental variables for `JAVA_HOME`, `AWS_ACCESS_KEY`,
`AWS_SECRET_KEY`, `EC2_PRIVATE_KEY`, and `EC2_CERT` outside of this
project.  The scripts will set them up if necessary/possible.

Credentials can also be written to `config/aws.yml`.  See
`config/aws.yml.example` for a template.

Certificates can be stored in `config/certificate.pem` and `config/private-key.pem`.

A convenient script `bin/shell` will configure all of this in a bash
sub-shell with PATH adjusted.

If everything is configured, try running `ec2ver` and `ec2din`.

LICENSE
=======

tvd-awsme - YYY

Author: NAME (<EMAIL>)
Copyright: Copyright (c) YYYY-YYYY WHO
License: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
