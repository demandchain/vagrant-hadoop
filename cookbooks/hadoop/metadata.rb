maintainer       "Robin Wenglewski"
maintainer_email "robin@wenglewski.de"
license          "All rights reserved"
description      "Installs/Configures hadoop"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends %w-apt java-

recipe "hadoop", "same as hadoop::cloudera"
recipe "hadoop::source", "installs hadoop from source"
recipe "hadoop::cloudera", "installs hadoop from the cloudera repository"

%w{ ubuntu }.each do |os|
  supports os
end
