SWIFT_BUILD_DIR=/tmp/swift

# Installs dependancies
echo "-- Installing dependancies"
sudo apt update
sudo apt-get install -y libssl-dev
sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y nginx
sudo apt-get install -y supervisor
sudo apt-get install -y clang libicu-dev

# Builds swift
echo "-- Building swift"
mkdir $SWIFT_BUILD_DIR
cd $SWIFT_BUILD_DIR
curl -sSL https://swift.org/builds/swift-4.0-release/ubuntu1610/swift-4.0-RELEASE/swift-4.0-RELEASE-ubuntu16.10.tar.gz > swift.tar.gz

tar xzf swift.tar.gz
sudo mv swift-4.0-RELEASE-ubuntu16.10/usr /usr/lib/swift
sudo chown -R root:root /usr/lib/swift
sudo chmod a+x /usr/lib/swift/bin/*
sudo chmod -R a+r /usr/lib/swift/lib
sudo ln -s ../lib/swift/bin/swift /usr/bin/swift

rm -fr swift*
swift --version
