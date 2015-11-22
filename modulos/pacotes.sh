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


#	Instalando Pacotes
echo "==========================================================="
echo "|              INSTALANDO PACOTES NECESSÁRIOS             |"
echo "==========================================================="
apt-get update -y
apt-get upgrade -y
apt-get install default-jdk -y
apt-get install ssh -y
apt-get install openssh-server -y
apt-get install openssh-client -y
apt-get install rsync -y


while true; do

	echo "==========================================================="
	echo "|                         Reboot                          |"
	echo "|  Será necessário reiniciar a máquina. Deseja reiniciar  |"
	echo "|  agora?                                                 |"
	echo "|  Sim (s)                                                |"
	echo "|  Não (n)                                                |"
	echo "==========================================================="

	read opcao

	if [ "$opcao" == "s" ]; then 
		echo "Reiniciando"
		shutdown -r now
	elif [ "$opcao" == "n" ]; then 
		echo "Voltando para o menu principal"
		exit
	fi
done



