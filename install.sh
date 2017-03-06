#!/bin/bash

# check input arguments
if [ "$#" -ne 2 ]; then
    echo "Please specify version of Hadoop and Spark" && exit 1
fi

hadoop_version=$1
spark_version=$2
echo "Hadoop:$hadoop_version"
echo "Spark:$spark_version"
