#!/bin/bash

echo "Node Linux Installer by www.github.com/taaem"
echo "Get Latest Version Number..."

node_latest=$(curl http://nodejs.org/dist/latest/ 2>/dev/null)
if [[ ! $node_latest ]]
    then
        echo "ERROR: No Internet Connection" >&2
        exit 1
fi

ARCH=$(uname -m)

if [ $ARCH = arm64 ] || [ $ARCH = aarch64 ]
    then
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-arm64.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-arm64.tar.gz') 

    elif [ $ARCH = armv6l ]
    then
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-armv6l.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-armv6l.tar.gz') 

    elif [ $ARCH = armv7l ]
    then
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-armv7l.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-armv7l.tar.gz') 
        
    elif [ $ARCH = x86_64 ]
    then
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-x64.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-x64.tar.gz') 

    else
        NAME=$(echo "$node_latest" | grep -o '>node-v.*-linux-x86.tar.gz' )
        VER=$(echo "$NAME" | grep -o 'node-v.*-linux-x86.tar.gz') 
fi

echo "Done"

[ -d bin ] || mkdir bin
[ -d .nodejs ] || mkdir nodejs

echo "Downloading latest stable Version $VER..."

URL=http://nodejs.org/dist/latest/$VER
FILE_PATH=${HOME}/tmp/node.tar.gz

curl -o $FILE_PATH $URL 2>/dev/null
exit_status=$(echo "$?")
if [[ $exit_status -ne "0" ]]
    then
        echo "ERROR: Target tar not found"
        exit $exit_status
fi

echo "Done"

echo "Installing..."
tar --strip-components 1 -xzf ${FILE_PATH} -C ${HOME}/.nodejs
exit_status=$(echo "$?")
if [[ $exit_status -ne "0" ]]
    then
        echo "ERROR: Couldn't extract tar"
        exit $exit_status
fi

ln -f ${HOME}/nodejs/bin/node ${HOME}/bin/node
ln -f ${HOME}/nodejs/bin/npm ${HOME}/bin/npm

rm $FILE_PATH

echo "Finished installing!"
exit 0
