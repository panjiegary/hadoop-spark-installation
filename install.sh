#!/bin/bash

# check input arguments
if [ "$#" -ne 2 ]; then
    echo "Please specify version of Hadoop and Spark" && exit 1
fi

hadoop_version=$1
spark_version=$2
echo "Hadoop:$hadoop_version"
echo "Spark:$spark_version"
# purge existing jdk if exists
sudo apt-get purge openjdk-\* -y   --assume-yes
echo "Updating repository..."  
sudo apt-get update --assume-yes
# install java
echo "Installing  Java....."    
sudo apt-get install default-jdk -y
echo "Installation completed...."  
echo "Installed java version is...."  
java -version
# install hadoop
echo "Installing Hadoop"
cd /usr/local  
wget http://www-us.apache.org/dist/hadoop/common/hadoop-$hadoop_version/hadoop-$hadoop_version.tar.gz
tar xvf hadoop-$hadoop_version.tar.gz
mkdir hadoop  
mv hadoop-$hadoop_version/* hadoop/

echo "Now script is updating Bashrc for export Path etc"  
cat >> ~/.bashrc << EOL  
export HADOOP_HOME=/usr/local/hadoop  
export HADOOP_MAPRED_HOME=/usr/local/hadoop  
export HADOOP_COMMON_HOME=/usr/local/hadoop  
export HADOOP_HDFS_HOME=/usr/local/hadoop  
export YARN_HOME=/usr/local/hadoop  
export HADOOP_COMMON_LIB_NATIVE_DIR=/usr/local/hadoop/lib/native  
export JAVA_HOME=/usr/  
export PATH=$PATH:/usr/local/hadoop/sbin:/usr/local/hadoop/bin:$(readlink -f /usr/bin/java | sed "s:bin/java::")/bin  
EOL  
cat ~/.bashrc  
source ~/.bashrc  

echo "Now script is updating hadoop configuration files"  
cat >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh << EOL  
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")  
EOL 

cd /usr/local/hadoop/etc/hadoop 
cat > core-site.xml << EOL  
<configuration>  
<property>  
<name>fs.default.name</name>  
<value>hdfs://localhost:9000</value>  
</property>  
</configuration>  
EOL 

cp mapred-site.xml.template mapred-site.xml  
cat > mapred-site.xml << EOL  
<configuration>  
<property>  
<name>mapreduce.framework.name</name>  
<value>yarn</value>  
</property>  
</configuration>  
EOL  

cat > yarn-site.xml << EOL  
<configuration>  
<property>  
<name>yarn.nodemanager.aux-services</name>  
<value>mapreduce_shuffle</value>  
</property>  
</configuration>  
EOL  

cat > hdfs-site.xml << EOL  
<configuration>  
<property>  
<name>dfs.replication</name>  
<value>1</value>  
</property>  
<property>  
<name>dfs.name.dir</name>  
<value>file:///home/hadoop/hadoopinfra/hdfs/namenode </value>  
</property>  
<property>  
<name>dfs.data.dir</name>  
<value>file:///home/hadoop/hadoopinfra/hdfs/datanode </value >  
</property>  
</configuration>  
EOL  

echo "Completed process Now Reloading Bash Profile...."  
cd ~  

echo "You may require reloading bash profile, you can reload using following command."  
echo "source ~/.bashrc"  

echo "To Start you need to format Name Node Once you can use following command."  
echo "hdfs namenode -format"  

echo "Hadoop configured. now you can start hadoop using following commands. "  
echo "start-dfs.sh"  
echo "start-yarn.sh"  

echo "To stop hadoop use following scripts."  
echo "stop-dfs.sh"  
echo "stop-yarn.sh"
