# -*- mode: ruby -*-
# vi: set ft=ruby :
$script = <<-SCRIPT

echo updating package information
yum update -y >/dev/null 2>&1
yum -y install wget
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install jenkins -y
yum install java -y
echo '====================Removing older versions of Docker ======================='
 yum -y  remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

echo '====================Install devicemapper storage driver dependencies ==========='
  yum install -y yum-utils curl device-mapper-persistent-data lvm2 unzip
  yum install -y wget

echo '====================Setup the stable docker repository.  ======================'
  yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo



echo '=========================== Installting Docker  ===========================' 
 yum -y install docker-ce
 systemctl start docker


echo '=========================== Installing Docker Compose =========================='
curl -L https://github.com/docker/compose/releases/download/1.21.1/docker-compose-`uname -s`-`uname -m` > ./docker-compose
 mv docker-compose /usr/local/bin/
 chown root:root /usr/local/bin/docker-compose
 chmod +x /usr/local/bin/docker-compose
 ls -lrt /usr/local/bin/

echo '=========================== Creating Docker Network =========================='
if ! docker network create ${CUSTOM_NETWORK_NAME} &> /dev/null; then
      echo "Network already exists: ${CUSTOM_NETWORK_NAME}"
else
      echo "Created Docker network: ${CUSTOM_NETWORK_NAME}"
fi
echo '============================== Installing AWS CLI =============================' 
wget https://bootstrap.pypa.io/get-pip.py 
python get-pip.py 
pip install awscli
ln -s /bin/aws /usr/local/bin/aws
chmod +x -R  /usr/local/bin/
usermod -a -G docker jenkins
SCRIPT
Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant" 
  config.vm.box = "minimal/centos7"
  config.vm.box_version = "7.0"
  config.vm.network "private_network", ip: "192.168.33.20"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.provision "shell", inline: $script 
end