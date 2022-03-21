#!/bin/bash

cd ../

if ! -d "installs" ; then
    mkdir "installs"
    cd installs
else
    cd installs
fi

if which wget >/dev/null ; then
    echo "Downloading via wget."
    wget $1 
else
    echo "Cannot download, wget is not avaliable."
fi