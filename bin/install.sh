#!/bin/bash
# Server installer
export $(cat .env | xargs)
echo "${APP_NAME}"

### 1 - Install repositories
install_repos()
{
  echo 'Install Server'
  # A - Install Server
  rm -r -f ./server
  git clone https://github.com/mikbry/server.git

  echo 'Install Webservices'
  # B - Install Webservices
  rm -r -f ./webservices
  git clone https://github.com/mikbry/webservices.git ./webservices

}

### 3 - Self certificate
setup_cerficates() 
{
  echo 'setup cerficates'
  mkdir -p ./certs
  if [ -f ./certs/main.key ]
  then
    echo "Certificates already exist, delete files if you know what you do !"
  else
    openssl req -newkey rsa:2048 -nodes -keyout certs/main.key -x509 -days 365 -out certs/main.crt
  fi
}

### 4 - Configure WebServer
configure_webserver() 
{
  echo 'configure Webserver'
  if [ ! -f ./public/images ]; then
    echo 'copy images'
    cp -r ./server/public/images ./public
  fi

  if [ ! -f ./public/index.html ]; then
      echo 'copy index.html'
    cp ./server/public/index.html ./public
  fi

  if [ ! -f ./public/favicon.ico ]; then
    echo 'copy favicon.ico'
    cp ./server/public/favicon.ico ./public
  fi

  if [ ! -f ./public/ext ]; then
    echo 'copy & build ext'
    mkdir -p ./tmp_ext/public
    cp -r ./server/extensions ./tmp_ext
    mkdir -p ./tmp_ext/extensions/packages/import/src/images
    cd ./tmp_ext/extensions
    rm -rf ./node_modules
    rm -f ./yarn.lock
    yarn --production=false
    yarn build
    cd ../..
    cp -r ./tmp_ext/public/ext ./public
  fi
}

### 5 - Run Docker-Compose

### 6 - Install datasets

### -- Main

#install_repos

setup_cerficates

configure_webserver
