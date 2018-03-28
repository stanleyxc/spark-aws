#!/bin/bash
## install packages needed by spark
apt-get update
apt-get install -y default-jre scala scala-library ntp


# get spark
wget http://mirror.cc.columbia.edu/pub/software/apache/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz -P /tmp
cd /tmp
tar -zxvf ./spark-2.3.0-bin-hadoop2.7.tgz
mv /tmp/spark-2.3.0-bin-hadoop2.7 /usr/local/spark


#configure spark
cat >> /etc/profile.d/Z99-spark.sh <<'END_PATH'
## configure spark
export SPARK_HOME=/usr/local/spark
export PATH=$PATH:$SPARK_HOME/bin
export SPARK_MASTER=10.0.0.33
### end spark

###AWS s3
export AWS_KEY=AKA	
export AWS_SECRET=XYZ
export AWS_LOG_DIR=spark-test-0101/logs
export AWS_CHECKPOINT_DIR=spark-test-0101/checkpoints
### end AWS

END_PATH

source /etc/profile.d/Z99-spark.sh
cat > $SPARK_HOME/conf/spark-env.sh <<END_SPARK_CONF

export JAVA_HOME=/usr
export SPARK_WORKER_CORES=2
#export SPARK_WORKER_MEMORY=2048
#export SPARK_DAEMON_MEMORY=1048

END_SPARK_CONF

## get spark apps
cd /usr/local/spark/
git clone https://github.com/stanleyxc/sample-spark.git apps

cd /usr/local/spark/apps/releases
tar -zxvf ./uber-log-analyzer-2.0.jar.tar.gz
chown -R ubuntu:root /usr/local/spark


## start spark worker node
/usr/local/spark/sbin/start-slave.sh spark://$SPARK_MASTER:7077