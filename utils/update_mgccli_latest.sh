#!/bin/bash

function check_dependences() {
    CURL_RESULT=$(whereis curl|cut -d\: -f2)

    if [ -z "$CURL_RESULT" ]; then
    echo "o binário CURL não está instalado, satisfaça a dependencia antes de continuar"
    echo "Ex: apt update && apt install curl tar gzip unzip -y"
    exit 1
    fi

    UNZIP_RESULT=$(whereis unzip|cut -d\: -f2)

    if [ -z "$UNZIP_RESULT" ]; then
    echo "o binário UNZIP não está instalado, satisfaça a dependencia antes de continuar"
    echo "Ex: apt update && apt install curl tar gzip unzip -y"
    exit 1
    fi

    if [ $(whoami) != "root" ]; then
    echo "Usuário precisa ter permissão de root, use sudo ou vire root"
    exit 1
    fi
}



check_dependences

#Definie OS
MACOS="Darwin"
LINUX="Linux"
GITBASH_01="MSYS"
GITBASH_02="MINGW32"
GET_OS=$(uname -s)
ARCH=$(uname -m)

function update_linux() {
    TIMESTAMP=$(date +%Y%M%d%H%M%S)
    DIR_DOWNLOAD="/tmp/mgccli/$TIMESTAMP"
    mkdir -p $DIR_DOWNLOAD
        
    echo "Baixando a ultima versão"
    sleep 2

    if [ "$ARCH" == "x86_64" ]; then

    curl -L $(curl -s https://api.github.com/repos/MagaluCloud/mgccli/releases/latest|grep browser_download_url|cut -d\: -f2,3|grep -E "(tar.gz)"|grep linux|grep "amd64"|cut -d\" -f2) -o $DIR_DOWNLOAD/mgccli.tar.gz

    else

    curl -L $(curl -s https://api.github.com/repos/MagaluCloud/mgccli/releases/latest|grep browser_download_url|cut -d\: -f2,3|grep -E "(tar.gz)"|grep linux|grep "arm64"|cut -d\" -f2) -o $DIR_DOWNLOAD/mgccli.tar.gz

    fi
    
    echo "Descompactando"
    sleep 2

    tar xzf $DIR_DOWNLOAD/mgccli.tar.gz -C $DIR_DOWNLOAD
    
    echo "Intalando a ultima versão"
    sleep 2

    mv $DIR_DOWNLOAD/mgc /usr/bin/mgc
    chmod +x /usr/bin/mgc
}

function update_macos() {
    TIMESTAMP=$(date +%Y%M%d%H%M%S)
    DIR_DOWNLOAD="~/mgccli/$TIMESTAMP"
    mkdir -p $DIR_DOWNLOAD
        
    echo "Baixando a ultima versão"
    sleep 2

    if [ "$ARCH" == "x86_64" ]; then

    curl -L $(curl -s https://api.github.com/repos/MagaluCloud/mgccli/releases/latest|grep browser_download_url|cut -d\: -f2,3|grep -E "(tar.gz)"|grep darwin|grep "amd64"|cut -d\" -f2) -o $DIR_DOWNLOAD/mgccli.tar.gz

    else

    curl -L $(curl -s https://api.github.com/repos/MagaluCloud/mgccli/releases/latest|grep browser_download_url|cut -d\: -f2,3|grep -E "(tar.gz)"|grep darwin|grep "arm64"|cut -d\" -f2) -o $DIR_DOWNLOAD/mgccli.tar.gz

    fi
    
    echo "Descompactando"
    sleep 2

    tar xzf $DIR_DOWNLOAD/mgccli.tar.gz -C $DIR_DOWNLOAD/
    
    echo "Intalando a ultima versão"
    sleep 2

    mv $DIR_DOWNLOAD//mgc ~/bin/mgc
    chmod +x ~/bin/mgc
}

function update_gitbash() {
    TIMESTAMP=$(date +%Y%M%d%H%M%S)
    DIR_DOWNLOAD="~/mgccli/$TIMESTAMP"
    mkdir -p $DIR_DOWNLOAD
    
    echo "Baixando a ultima versão"
    sleep 2

    if [ "$ARCH" == "x86_64" ]; then

    curl -L $(curl -s https://api.github.com/repos/MagaluCloud/mgccli/releases/latest|grep browser_download_url|cut -d\: -f2,3|grep -E "(zip)"|grep windows|grep "amd64"|cut -d\" -f2) -o $DIR_DOWNLOAD/mgccli.zip

    else

    curl -L $(curl -s https://api.github.com/repos/MagaluCloud/mgccli/releases/latest|grep browser_download_url|cut -d\: -f2,3|grep -E "(zip)"|grep windows|grep "arm64"|cut -d\" -f2) -o $DIR_DOWNLOAD/mgccli.zip

    fi
    
    
    echo "Descompactando a ultima versão"
    sleep 2

    unzip $DIR_DOWNLOAD/mgccli.zip -d $DIR_DOWNLOAD/
    
    echo "Instalando a ultima versão"
    sleep 2

    mv $DIR_DOWNLOAD/mgc.exe /usr/local/bin/mgc.exe
    chmod +x /usr/local/bin/mgc.exe
}

### Install ON Linux
if [ $GET_OS == $LINUX ]; then
update_linux

    if [ $? -eq 0 ]; then
        echo "Para testar, use o comando: mgc --help ou mgc --version"
    else
        echo "Falha na instalação"
    fi
fi


### Install ON MacOS
if [ $GET_OS == $MACOS ]; then
update_macos

    if [ $? -eq 0 ]; then
        echo "Para testar, use o comando: mgc --help ou mgc --version"
    else
        echo "Falha na instalação"
    fi

fi


### Install ON Gitbash
if [ $GET_OS == $GITBASH_01 ] || [ $GET_OS == $GITBASH_02 ]; then
update_gitbash

    if [ $? -eq 0 ]; then
        echo "Para testar, use o comando: mgc.exe --help"
    else
        echo "Falha na instalação"
    fi

fi