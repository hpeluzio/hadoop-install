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

echo "==========================================================="
echo "|                         Hosts                           |"
echo "==========================================================="

function hosts ()  {

	if [ -e "/etc/hosts-original" ]; then
		echo "[-] Hosts já configurados."
		exit
	else

		echo "[X] Configuração de hosts concluída."
		cp -r /etc/hosts /etc/hosts-original 	
		cp -r conf/hosts /etc/hosts
	fi
}

hosts
