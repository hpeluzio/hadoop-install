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
hadoops[0]="OPCAO INVALIDA"
sparks[0]="OPCAO INVALIDA"
mahouts[0]="OPCAO INVALIDA"
arrayopcao[0,0]="OPCAO INVALIDA"

function loadLocal () {
	i=1
	for var in $(ls local/hadoop); 
	do 
			hadoops[$i]=$var
			#echo ${hadoops[$i]}
			i=$((i+1))
	done

	i=1
	for var in $(ls local/spark); 
	do 
			sparks[$i]=$var
			#echo ${sparks[$i]}
			i=$((i+1))
	done

	i=1
	for var in $(ls local/mahout); 
	do 
			mahouts[$i]=$var	
			i=$((i+1))
	done
}

loadLocal



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

function funcInstall () {

	if [ -e "/usr/local/hadoop" ]; then
		echo "[-] Diretório hadoop já existe."

	else
		echo "[X] Copiando pastas do $1."
		mkdir /usr/local/hadoop
		tar -xzvf local/hadoop/$1 -C /usr/local/hadoop
		var=`ls /usr/local/hadoop`
		mv /usr/local/hadoop/$var/* /usr/local/hadoop
		rm -r /usr/local/hadoop/$var

		echo "[X] Copiando configurações do $1."
		#Comum
		cp -r conf/etc-hadoop/core-site.xml /usr/local/hadoop/etc/hadoop
		cp -r conf/etc-hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop
		./modulos/mapred_yarn.sh

		#Master
		if [ "$MASTEROUSLAVE" == "m" ]; then
			#Comum
			cp -r conf/etc-hadoop/core-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop
			./modulos/mapred_yarn.sh

			cp -r conf/slaves /usr/local/hadoop/etc/hadoop 
			cp -r conf/etc-hadoop/hdfs-site-MASTER.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
			mkdir -p /usr/local/hadoop/hdfs/{datanode,namenode}

		#Slave
		elif [ "$MASTEROUSLAVE" == "s" ]; then
			#Comum
			cp -r conf/etc-hadoop/core-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop
			./modulos/mapred_yarn.sh

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

	if [ -e "/usr/local/spark" ]; then	
		echo "[-] Diretório Spark já existe."

	else
		echo "[X] Copiando pastas do  $2."

		mkdir /usr/local/spark
		tar -xzvf local/spark/$2 -C /usr/local/spark
		var=`ls /usr/local/spark`
		mv /usr/local/spark/$var/* /usr/local/spark
		rm -r /usr/local/spark/$var

		if [ "$MASTEROUSLAVE" == "m" ]; then 
			echo "[X] Copiando configurações $2."
			cp -r conf/sparkslaves /usr/local/spark/conf/slaves
		elif [ "$MASTEROUSLAVE" == "single" ]; then 
			echo "[X] Copiando configurações do $2."
			cp -r conf/etc-hadoop/singlenode/slaves /usr/local/spark/conf/slaves
		fi
	fi

	if [ -e "/usr/local/mahout" ]; then 
		echo "[-] Diretório Mahout já existe."
		exit

	else 
		echo "[X] Copiando pastas do Mahout $3."
		tar -xzvf local/mahout/$3 -C /usr/local	
	fi

echo $1
echo $2
echo $3

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
		#cp -r conf/etc-hadoop/mapred-site.xml /usr/local/hadoop/etc/hadoop
		#cp -r conf/etc-hadoop/yarn-site.xml /usr/local/hadoop/etc/hadoop
		#Já coloca o mapred-site.xml e yarn-site.xml com todos atributos de acordo com a máquina
		./modulos/mapred_yarn.sh		

		#Master
		if [ "$MASTEROUSLAVE" == "m" ]; then
			#Comum
			cp -r conf/etc-hadoop/core-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop

			#cp -r conf/etc-hadoop/mapred-site.xml /usr/local/hadoop/etc/hadoop
			#cp -r conf/etc-hadoop/yarn-site.xml /usr/local/hadoop/etc/hadoop
			#Já coloca o mapred-site.xml e yarn-site.xml com todos atributos de acordo com a máquina
			./modulos/mapred_yarn.sh

			cp -r conf/slaves /usr/local/hadoop/etc/hadoop 
			cp -r conf/etc-hadoop/hdfs-site-MASTER.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
			mkdir -p /usr/local/hadoop/hdfs/{datanode,namenode}

		#Slave
		elif [ "$MASTEROUSLAVE" == "s" ]; then
			#Comum
			cp -r conf/etc-hadoop/core-site.xml /usr/local/hadoop/etc/hadoop
			cp -r conf/etc-hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop

			#cp -r conf/etc-hadoop/mapred-site.xml /usr/local/hadoop/etc/hadoop
			#cp -r conf/etc-hadoop/yarn-site.xml /usr/local/hadoop/etc/hadoop
			#Já coloca o mapred-site.xml e yarn-site.xml com todos atributos de acordo com a máquina
			./modulos/mapred_yarn.sh

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
		echo "============================================================================="
		echo "|     Escolha a versão do Hadoop que deseja instalar:                       |"
		echo "|                                                                           |"
		opcaocount=1
		
		for ((x=1; x < ${#hadoops[*]}; x++)) ; do
			for ((y=1; y < ${#sparks[*]}; y++)) ; do
				for ((z=1; z < ${#mahouts[*]}; z++)) ; do
					echo "| ($opcaocount) - ${hadoops[x]} - ${sparks[y]} - ${mahouts[z]} |"
					arrayopcao[$opcaocount,0]=${hadoops[x]}
					arrayopcao[$opcaocount,1]=${sparks[y]}
					arrayopcao[$opcaocount,2]=${mahouts[z]}
					opcaocount=$((opcaocount+1))
				done
			done
		done
		echo "|                                                                           |"
		echo "|  EXIT - Voltar para o menu                                                |"
		echo "============================================================================="
		opcaocount=$((opcaocount-1))		
		
		#echo $opcaocount
		#for ((y=1; y <= opcaocount; y++)) ; do

		#	echo "$y: ${arrayopcao[y,0]}"
		#	echo "$y: ${arrayopcao[y,1]}"
		#	echo "$y: ${arrayopcao[y,2]}"
		#	echo "  "
		#done

		read OPCAO




		case "$OPCAO" in

			[1-$opcaocount]*)

				# Copiar arquivos 
				masterouslave #Pegar a opcao master ou slave
			    funcInstall ${arrayopcao[$OPCAO,0]} ${arrayopcao[$OPCAO,1]} ${arrayopcao[$OPCAO,2]}
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








