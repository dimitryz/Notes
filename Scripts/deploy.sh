DEPLOY_USER=deploy
SSH_HOST=192.168.1.99
SSH_PORT=1234
APP_HOME=/home/app

# Creates a new directory under: /var/app/DATE
APP_DIR=`date  +%Y%m%dT%H%M%S`

# The directory to which we'll deploy the app
APP_ROOT="$APP_HOME/$APP_DIR"

# Directory with the different code bases
APP_SHARED_ROOT="$APP_ROOT/NotesShared"
APP_SERVER_ROOT="$APP_ROOT/NotesServer"

# Copies both the shared and server code to the remote server
rsync -av -e "ssh -p $SSH_PORT" NotesShared NotesServer \
	--exclude=*.xcodeproj \
	--exclude=.build \
	$DEPLOY_USER@$SSH_HOST:$APP_ROOT

# Compiles the code on the remote server.
# The git code is necessary because of the way swift packages work: they
# require the presence of a git repo to link one package to another. So
# this script creates a v1.0.0 git release for the shared code on
# the server and links that package to the server's package.

ssh -T $DEPLOY_USER@$SSH_HOST -p$SSH_PORT << EOSSH

cd $APP_SHARED_ROOT

git config --global user.email "$DEPLOY_USER@localhost"
git config --global user.name "deploy"
git init
git add .
git commit -am "NotesShared"
git tag 1.0.0

cd $APP_SERVER_ROOT

sed -i 's/dependencies:\s*\[/dependencies: [\n    .Package(url: "\.\.\/NotesShared", majorVersion: 1),/g' Package.swift
swift build -c release

EOSSH
