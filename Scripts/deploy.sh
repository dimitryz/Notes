#
# Configuration variables
#

DEPLOY_USER=deploy
SSH_HOST=127.0.0.1
SSH_PORT=2222

# Directory with the different code bases
DEPLOY_HOME=/home/deploy
DEPLOY_DIR=`date  +%Y%m%dT%H%M%S`
DEPLOY_ROOT="$DEPLOY_HOME/$DEPLOY_DIR"
DEPLOY_SHARED_ROOT="$DEPLOY_ROOT/NotesShared"
DEPLOY_SERVER_ROOT="$DEPLOY_ROOT/NotesServer"
DEPLOY_BUILD_PATH="$DEPLOY_SERVER_ROOT/.build"

APP_HOME=/home/app
APP_LINK_PATH="$APP_HOME/build"

#
# Starts the deploy process
# 

# Copies both the shared and server code to the remote server
rsync -av -e "ssh -p $SSH_PORT" NotesShared NotesServer \
	--exclude=*.xcodeproj \
	--exclude=.build \
	$DEPLOY_USER@$SSH_HOST:$DEPLOY_ROOT

# Compiles the code on the remote server.
# The git code is necessary because of the way swift packages work: they
# require the presence of a git repo to link one package to another. So
# this script creates a v1.0.0 git release for the shared code on
# the server and links that package to the server's package.

ssh -T $DEPLOY_USER@$SSH_HOST -p$SSH_PORT << EOSSH

echo "-- Initializing Git in the shared code root"
cd $DEPLOY_SHARED_ROOT
git config --global user.email "$DEPLOY_USER@localhost"
git config --global user.name "deploy"
git init
git add .
git commit -am "NotesShared"
git tag 1.0.0

echo "-- Building the server"
cd $DEPLOY_SERVER_ROOT
sed -i 's/dependencies:\s*\[/dependencies: [\n    .Package(url: "\.\.\/NotesShared", majorVersion: 1),/g' Package.swift
swift build -c release

echo "-- Stopping supervisor"
supervisorctl stop all

echo "-- Linking the app"
[ ! -f $APP_LINK_PATH ] || rm $APP_LINK_PATH
ln -s $DEPLOY_BUILD_PATH $APP_LINK_PATH
chown -R deploy:app $DEPLOY_BUILD_PATH
chmod 0750 $DEPLOY_BUILD_PATH

echo "-- Restarting supervisor"
supervisorctl start all

exit

EOSSH

