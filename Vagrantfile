# -*- mode: ruby -*-
# vi: set ft=ruby :
$script = <<-SCRIPT

echo updating package information
yum update -y >/dev/null 2>&1

echo installing development/networking tools and EPEL repos
yum install -y net-tools build-essential epel-release  >/dev/null 2>&1
yum install -y rubygems
echo updating package information
yum update -y >/dev/null 2>&1
yum -y install wget
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install jenkins -y
yum install java -y

echo '====================Install devicemapper storage driver dependencies ==========='
  yum install -y yum-utils curl device-mapper-persistent-data lvm2 unzip
  yum install -y wget vim

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
if ! docker network create local_network &> /dev/null; then
      echo "Network already exists: local_network"
else
      echo "Created Docker network: local_network"
fi
echo '============================== Installing AWS CLI =============================' 
wget https://bootstrap.pypa.io/get-pip.py 
python get-pip.py 
pip install awscli



echo '=========================== Installing Terraform =========================='  
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip    
unzip terraform_0.11.7_linux_amd64.zip   
mv terraform /usr/local/bin/  

echo '=========================== Installing Kubectl =========================='  
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl

chmod +x -R  /usr/local/bin/
usermod -a -G docker jenkins

export PATH=$PATH:/usr/local/bin/

echo installing Ruby 2.5.1 via RVM

if su - vagrant -c ' gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'; then
   echo "key download successfuly"
else 
     echo "key download successfuly in 2nd attempt"
    su - vagrant -c  'curl -sSL https://rvm.io/mpapis.asc | gpg2 --import'
fi 

su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable'  # >/dev/null 2>&1
su - vagrant -c 'rvm rvmrc warning ignore allGemfiles'  #>/dev/null 2>&1
su - vagrant -c 'source $HOME/.rvm/scripts/rvm'  >> ~/.bash_profile
su - vagrant -c 'rvm install "ruby-2.5.1"'

echo "installing bundler"
su - vagrant -c 'gem install bundler'  #>/dev/null 2>&1
su - vagrant -c 'rvm use  2.5.1 --default'     
su - vagrant -c 'gem install rails'
su - vagrant -c 'bundle update sqlite3'


SCRIPT
Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant" 
  config.vm.box = "minimal/centos7"
  config.vm.box_version = "7.0"
  config.vm.network "private_network", ip: "192.168.33.20"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 4000, host: 3000
  config.vm.provision "shell", inline: $script 
end