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
#   IP:         10.1.1.x                                    #
#   Máscara:    255.255.255.0                               #
#   Gateway:    10.1.1.1                                    #
#   DNS:        208.67.222.222, 208.67.220.220              #
#############################################################

function config_ip () {

	echo "Digite o IP dessa máquina: "
	read IP

	interfaces="
	#########################################################################\n
	#  IP HADOOP fica armazenado em	/etc/network/interfaces			#\n
	#########################################################################\n
	# interfaces(5) file used by ifup(8) and ifdown(8)\n
	auto lo\n
	iface lo inet loopback\n
	\n
	auto eth0\n
	iface eth0 inet static\n
	address $IP\n
	netmask 255.255.240.0\n
	network 192.168.0.0\n
	broadcast 192.168.0.255\n
	gateway 192.168.15.254\n
	#dns\n
	dns-search crp.ufv.br\n
	dns-nameservers 208.67.222.222 208.67.220.220 192.168.15.253"

	echo -e $interfaces > /etc/network/interfaces

}

while true; do

	echo "==========================================================="
	echo "|                  Configuração de IP                     |"
	echo "|=========================================================|"
	echo "|     Esse procedimento invalida a configuração de ip     |"
	echo "|   pela interface gráfica. Deseja continuar?             |"
	echo "|   (s) Sim                                               |"
	echo "|   (n) Não                                               |"
	echo "|                                                         |"
	echo "|   EXIT - Voltar para o menu                             |"
	echo "==========================================================="

	read OPCAO

	if [ "$OPCAO" == "s" ]; then 
		config_ip
		break

	elif [ "$OPCAO" == "n" ]; then
		exit

	else
		echo "Opção inválida!"
	fi

done






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
shutdown -r now
