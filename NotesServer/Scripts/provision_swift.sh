
# Download Swift

download_swift() {
  sudo apt-get install -y clang libicu-dev
  curl -sSL https://swift.org/builds/swift-4.0-branch/ubuntu1610/swift-4.0-DEVELOPMENT-SNAPSHOT-2017-10-07-a/swift-4.0-DEVELOPMENT-SNAPSHOT-2017-10-07-a-ubuntu16.10.tar.gz > swift-4.0-DEVELOPMENT-SNAPSHOT-2017-10-07-a-ubuntu16.10.tar.gz
  curl -sSL https://swift.org/builds/swift-4.0-branch/ubuntu1610/swift-4.0-DEVELOPMENT-SNAPSHOT-2017-10-07-a/swift-4.0-DEVELOPMENT-SNAPSHOT-2017-10-07-a-ubuntu16.10.tar.gz.sig > swift-4.0-DEVELOPMENT-SNAPSHOT-2017-10-07-a-ubuntu16.10.tar.gz.sig
}

# Install Swift

install_swift() {
  tar xzf swift-4.0-DEVELOPMENT-SNAPSHOT-2017-10-07-a-ubuntu16.10.tar.gz
  sudo mv swift-4.0-DEVELOPMENT-SNAPSHOT-2017-10-07-a-ubuntu16.10/usr /usr/lib/swift
  sudo chown -R root:root /usr/lib/swift
  sudo chmod a+x /usr/lib/swift/bin/*
  sudo chmod -R a+r /usr/lib/swift/lib
  sudo ln -s ../lib/swift/bin/swift /usr/bin/swift
}

# Clean up

clean_up() {
  rm -df swift-4.0-DEVELOPMENT-SNAPSHOT-2017-10-07-a-ubuntu16.10*
}

download_swift
install_swift
clean_up
