#!/bin/bash

#############################################################
#                                                           #
#      Script de instalação do Hadoop, Spark e Mahout       #
#                                                           #
#############################################################
#         Criado por: Henrique Arruda Peluzio               #
#############################################################
#                                                           #
#      Script criado para auxiliar os alunos do curso       #
#   de Sistemas de Informação da UFV - Rio Paranaíba        #
#                                                           #   
#############################################################


# Guarda opção master ou slave
MASTEROUSLAVE="MASTER OU SLAVE?"
#########################################

function masterouslave () {

	while true; do

		echo "==========================================================="
		echo "|     Essa máquina será master, slave ou singlenode?      |"
		echo "|                                                         |"
		echo "|   (m) Para MASTER                                       |"
		echo "|   (s) Para SLAVE                                        |"
		echo "|   (single) Para SINGLENODE                              |"
		echo "|                                                         |"
		echo "|   EXIT - Voltar para o menu                             |"
		echo "==========================================================="

		read MASTEROUSLAVE

		if [ "$MASTEROUSLAVE" == "m" ] || [ "$MASTEROUSLAVE" == "s" ] || [ "$MASTEROUSLAVE" == "single" ]; then 
			break
		else
			echo "Opção inválida!"
		fi

	done
}


function func_hadoop () {

	if [ -e "/usr/local/hadoop" ]; then
		echo "[-] Diretório hadoop já existe."

	else
		if [ "$1" == "2.7.1" ]; then
			echo "[X] Copiando pastas do Hadoop $1."
			tar -xzvf local/hadoop-2.7.1.tar.gz -C /usr/local
			mv /usr/local/hadoop-2.7.1/ /usr/local/hadoop

		elif [ "$1" == "2.4.0" ]; then
			echo "[X] Copiando pastas do Hadoop $1."
			tar -xzvf local/hadoop-2.4.0.tar.gz -C /usr/local
			mv /usr/local/hadoop-2.4.0/ /usr/local/hadoop
		fi 
	
		echo "[X] Copiando configurações do Hadoop $1."
		#Comum
		cp -r conf/etc-hadoop/core-site.xml /usr/local/hadoop/etc/hadoop
		cp -r conf/etc-hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop
		cp -r conf/etc-hadoop/mapred-site.xml /usr/local/hadoop/etc/hadoop
		cp -r conf/etc-hadoop/yarn-site.xml /usr/local/hadoop/etc/hadoop
		
		#Master
		if [ "$MASTEROUSLAVE" == "m" ]; then
			#Comum
			cp -r conf/etc-hadoop/core-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/mapred-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/yarn-site.xml /usr/local/hadoop/etc/hadoop
			
			cp -r conf/slaves /usr/local/hadoop/etc/hadoop 
			cp -r conf/etc-hadoop/hdfs-site-MASTER.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
			mkdir -p /usr/local/hadoop/hdfs/{datanode,namenode}

		#Slave
		elif [ "$MASTEROUSLAVE" == "s" ]; then
			#Comum
			cp -r conf/etc-hadoop/core-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/mapred-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/yarn-site.xml /usr/local/hadoop/etc/hadoop

			mkdir -p /usr/local/hadoop/hdfs/datanode
			cp -r conf/etc-hadoop/hdfs-site-SLAVES.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
		#Singlenode
		elif [ "$MASTEROUSLAVE" == "single" ]; then
			#Single
			cp -r conf/etc-hadoop/singlenode/core-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/singlenode/hadoop-env.sh /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/singlenode/mapred-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/singlenode/yarn-site.xml /usr/local/hadoop/etc/hadoop

			cp -r conf/etc-hadoop/singlenode/slaves /usr/local/hadoop/etc/hadoop 
			cp -r conf/etc-hadoop/singlenode/hdfs-site.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
			mkdir -p /usr/local/hadoop/hdfs/{datanode,namenode}
		fi
	fi
}

function func_spark () {

	if [ -e "/usr/local/spark" ]; then	
		echo "[-] Diretório Spark já existe."

	else
		if [ "$1" == "1.5.2" ]; then
			echo "[X] Copiando pastas do Spark $1."
			tar -xzf local/spark-1.5.2-bin-hadoop2.6.tgz -C /usr/local
			mv /usr/local/spark-1.5.2-bin-hadoop2.6/ /usr/local/spark

		elif [ "$1" == "1.3.1" ]; then
			echo "[X] Copiando pastas do Spark $1."
			tar -xzf local/spark-1.3.1-bin-hadoop2.4.tgz -C /usr/local
			mv /usr/local/spark-1.3.1-bin-hadoop2.4/ /usr/local/spark
		fi

		if [ "$MASTEROUSLAVE" == "m" ]; then 
			echo "[X] Copiando configurações do Spark $1."
			cp -r conf/sparkslaves /usr/local/spark/conf/slaves
		elif [ "$MASTEROUSLAVE" == "single" ]; then 
			echo "[X] Copiando configurações do Spark $1."
			cp -r conf/etc-hadoop/singlenode/slaves /usr/local/spark/conf/slaves
		fi
	fi
}

function func_mahout () {

	if [ -e "/usr/local/mahout" ]; then 
		echo "[-] Diretório Mahout já existe."
		exit

	else 
		echo "[X] Copiando pastas do Mahout 0.11.2."
		tar -xzvf local/mahout.tar.gz -C /usr/local	
	fi
}

menu () {

	while true; do

		echo ""
		echo ""
		echo "==========================================================="
		echo "|     Escolha a versão do Hadoop que deseja instalar:     |"
		echo "|                                                         |"
		echo "|  1 - Instalar Hadoop 2.7.1, Spark 1.5.2 e Mahout 0.11.2 |"
		echo "|  2 - Instalar Hadoop 2.7.1, Spark 1.3.1 e Mahout 0.11.2 |"
		echo "|  3 - Instalar Hadoop 2.4.0, Spark 1.5.1 e Mahout 0.11.2 |"
		echo "|  4 - Instalar Hadoop 2.4.0, Spark 1.3.1 e Mahout 0.11.2 |"
		echo "|                                                         |"
		echo "|  EXIT - Voltar para o menu                              |"
		echo "==========================================================="
		read OPCAO

		case "$OPCAO" in

			1)
				# Copiar arquivos do hadoop 2.7.1 para /usr/local
				masterouslave #Pegar a opcao master ou slave
				func_hadoop "2.7.1"
				# Copiar arquivos do spark 1.5.2 para /usr/local
				func_spark "1.5.2"
				# Copiar arquivos do mahout para /usr/local
				func_mahout
				exit
			;;
			#
			2)
				# Copiar arquivos do hadoop 2.7.1 para /usr/local
				masterouslave #Pegar a opcao master ou slave
				func_hadoop "2.7.1"
				# Copiar arquivos do spark 1.3.1 para /usr/local
				func_spark "1.3.1"
				# Copiar arquivos do mahout para /usr/local
				func_mahout
				exit
			;;
			3)
				# Copiar arquivos do hadoop 2.4.0 para /usr/local
				masterouslave #Pegar a opcao master ou slave
				func_hadoop "2.4.0"
				# Copiar arquivos do spark 1.5.2 para /usr/local
				func_spark "1.5.2"
				# Copiar arquivos do mahout para /usr/local
				func_mahout
				exit
			;;
			4)
				# Copiar arquivos do hadoop 2.4.0 para /usr/local
				masterouslave #Pegar a opcao master ou slave
				func_hadoop "2.4.0"
				# Copiar arquivos do spark 1.3.1 para /usr/local
				func_spark "1.3.1"
				# Copiar arquivos do mahout para /usr/local
				func_mahout
				exit
			;;
			#
			exit|EXIT)
				echo "Voltando para o menu principal"
				exit;
			;;
			#
			*)
				echo "Opção inválida!"
		esac
	done

}

menu








