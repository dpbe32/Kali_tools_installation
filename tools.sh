#!/bin/bash

function ctrl_c(){
	echo -e "\n\n[!] Saliendo....\n"
	tput cnorm; exit 1
}

trap ctrl_c INT

tools=(seclists proxychains proxychains4 bloodhound exploitdb rlwrap mlocate)

install_tools(){
	for tool in ${tools[@]}; do 
		echo -e "[+] Actualizando repositorios"
		apt update &>/dev/null 
		echo -e "[+] Actualizando el sistema..."
		apt upggrade &>/dev/null
		echo -e "[+] Istalando paquetes necesarios...."
		apt install $tool &>/dev/null
	done
}

install_neo4j(){
	echo -e "[+] Añadiendo repositorio..."
	wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add - &>/dev/null
	echo 'deb https://debian.neo4j.com stable 5' | sudo tee -a /etc/apt/sources.list.d/neo4j.list &>/dev/null
	echo -e "[+] Actualizando repositorios"
	apt-get update
	echo "[+] Instalando neo4j...."
	sudo apt-get install neo4j=1:5.5.0 &>/dev/null
}

python3_solution(){
	echo -e "[+] Solucionando problema de python3...."
	apt --purge remove python3-pip &>/dev/null
	apt --purge remove python3 &>/dev/null
	$file=$(wget https://www.python.org/ftp/python/3.10.10/Python-3.10.10.tgz &>/dev/null)
	tar -xf $file &>/dev/null
	cd Python-3.10.10/ &>/dev/null
	chmod +x *.* -R &>/dev/null
	./configure --enable-optimizations &>/dev/null
	make -j 2 &>/dev/null
	sudo make install &>/dev/null
	sudo python3.10 -m pip install &>/dev/null
	sudo python3.10 -m pip install --upgrade &>/dev/null
}

pip3_programs(){
	programs=(crackmapexec impacket)
	for program in ${programs[@]}; do
		echo -e "[+] Instalando programas de python...."
		pip3 install $program &>/dev/null
	done
}

python2.7_installation(){
	sudo apt install pỳthon2.7 &>/dev/null
	curl https://bootstrap.pypa.io/pip/2.7/get-pip.py  -o get-pip.py &>/dev/null
	sudo python2.7 get-pip.py &>/dev/null
}

main() {
	install_tools
	install_neo4j
	python3_solution
	pip3_programs
	python2.7_installation
}

if [ "$(id -u)" == "0" ];
	main
else
	echo -e "[+] Necesitas ser root para ejecutar este programa..."
fi
