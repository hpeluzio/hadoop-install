#!/bin/bash

# Pega CORES total do processador
V_CORES=`egrep "^processor" /proc/cpuinfo | wc -l`

# Pega memoria total em GB
MEM_TOTAL=`grep "^MemTotal" /proc/meminfo|awk '{print $2}'`
MEM_GB=`echo "$MEM_TOTAL / 1048576" | bc`
MEM_GB_TOTAL=`echo "$MEM_GB + 1" | bc`

echo "VCORES: $V_CORES"
echo "MEM_TOTAL: $MEM_GB_TOTAL"

python modulos/mapred.py -c $V_CORES -m $MEM_GB_TOTAL -d 1 -k False > /usr/local/hadoop/etc/hadoop/mapred-site.xml
python modulos/yarn.py -c $V_CORES -m $MEM_GB_TOTAL -d 1 -k False > /usr/local/hadoop/etc/hadoop/yarn-site.xml

sed -i '1i\<?xml version="1.0"?>\' /usr/local/hadoop/etc/hadoop/mapred-site.xml
sed -i '2i\<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>\' /usr/local/hadoop/etc/hadoop/mapred-site.xml
sed -i '1i\<?xml version="1.0"?>\' /usr/local/hadoop/etc/hadoop/yarn-site.xml
