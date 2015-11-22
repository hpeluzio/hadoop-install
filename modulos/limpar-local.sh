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

while true; do
	
	echo "==========================================================="
	echo "|                 Deletar Configurações                   |"
	echo "|  Deseja realmente deletar as configurações do cluster?  |"
	echo "|  Sim (s)                                                |"
	echo "|  Não (n)                                                |"
	echo "==========================================================="

	read opcao

	if [ "$opcao" == "s" ] || [ "$opcao" == "n" ]; then 
		break
	fi
done

function funcao_limpando() {

	# Voltando as variáveis de ambiente para original
	if grep "#TOKENVAHADOOP" ~/.bashrc; then
		echo ""
		echo "==========================================================="
		echo "|                         LIMPANDO                        |"
		echo "==========================================================="
		echo "[X] Limpando as variaveis de ambiente"
		grep -v "#TOKENVAHADOOP" ~/.bashrc > ~/.bashrc-token
		cp ~/.bashrc-token ~/.bashrc
		rm ~/.bashrc-token
		
	else
		echo "[-] Variáveis de ambiente já excluídas."
	fi

	# Voltando hosts ao original
	if [ -e "/etc/hosts-original" ]; then
		echo "[X] Limpando Hosts"
		cp -r /etc/hosts-original /etc/hosts
		rm /etc/hosts-original

	else
		echo "[-] Hosts já estão como original."
	fi

	#Deletando as pastas do hadoop, mahout e spark
	if [ -e "/usr/local/hadoop" ]; then
		echo "[X] Deletando pasta hadoop."
		sudo rm -rf /usr/local/hadoop

	else
		echo "[-] Pasta do Hadoop já removida."
	fi

	#Deletando as pastas do hadoop
	if [ -e "/usr/local/spark" ]; then
		echo "[X] Deletando pasta spark."
		sudo rm -rf /usr/local/spark
	else
		echo "[-] Pasta spark já removida."
	fi

	#Deletando as pastas do mahout
	if [ -e "/usr/local/mahout" ]; 	then
		echo "[X] Deletando pasta mahout."
		sudo rm -rf /usr/local/mahout

	else
		echo "[-] Pasta mahout já removida."
	fi

	#Deletando grupo hadoop
	if groupdel hadoop;	then
		echo "[X] Deletando grupo hadoop."

	else
		echo "[-] Grupo hadoop já deletado."
	fi
}

if [ "$opcao" == "s" ]; then
	funcao_limpando

elif [ "$opcao" == "n" ]; then
	echo "[-] Voltando ao menu principal"
	exit
fi





