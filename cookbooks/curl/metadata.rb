maintainer       "Morton Jonuschat"
maintainer_email "yabawock@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures curl"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe "curl::default", "Installs the curl CLI tool and library"
