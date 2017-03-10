#!/bin/bash

echo "Updating repository..."  

sudo apt-get update --assume-yes  

echo "Installing  Java....."    
sudo apt-get install default-jdk -y  
echo "Installation completed...."  

echo "Installed java version is...."  

java -version  

#Installing SSH
echo "Installing SSH"
sudo apt-get install openssh-server -y  

/etc/init.d/ssh status  

/etc/init.d/ssh start  

echo "Installing Hadoop"
cd /usr/local
wget http://www-us.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz

tar -xzvf hadoop-2.7.3.tar.gz  

sudo mkdir hadoop  

mv hadoop-2.7.3/* hadoop/  

echo "Now script is updating hadoop configuration files"  

cat >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh << EOL  
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")  
EOL  

wget https://archive.apache.org/dist/spark/spark-2.1.0/spark-2.1.0-bin-hadoop2.7.tgz

tar -zxvf spark-2.1.0-bin-hadoop2.7.tgz
sudo mkdir spark
mv spark-2.1.0-bin-hadoop2.7/* /usr/local/spark/

cat >> ~/.bashrc << EOL
export SPARK_HOME=/usr/local/spark/
EOL

source ~/.bashrc

cd  /usr/local/spark

echo "Spark has been installed! "
