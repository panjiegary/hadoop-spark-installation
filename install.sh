#!/bin/bash

echo "Updating repository..."  

apt-get update --assume-yes  

echo "Installing  Java....."    
apt-get install default-jdk -y  
echo "Installation completed...."  

echo "Installed java version is...."  

java -version  

#Installing SSH
echo "Installing SSH"
apt-get install openssh-server -y  

/etc/init.d/ssh status  

/etc/init.d/ssh start  

echo "Installing Hadoop"
cd /usr/local
wget http://www-us.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz

tar -xzf hadoop-2.7.3.tar.gz  
echo "create hadoop folder"
mkdir hadoop  

mv hadoop-2.7.3/* hadoop/  

wget https://archive.apache.org/dist/spark/spark-2.1.0/spark-2.1.0-bin-hadoop2.7.tgz

tar -zxf spark-2.1.0-bin-hadoop2.7.tgz
echo "create spark folder"
mkdir spark
mv spark-2.1.0-bin-hadoop2.7/* /usr/local/spark/

cat >> ~/.bashrc << EOL
export SPARK_HOME=/usr/local/spark/
EOL

source ~/.bashrc

cd  /usr/local/spark

echo "Spark has been installed! "
