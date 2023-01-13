sudo apt-get update && sudo apt install cmake sqlite libtiff-dev curl libcurl4-openssl-dev libssl-dev -y
curl https://download.osgeo.org/proj/proj-9.1.1.tar.gz -o proj-9.1.1.tar.gz
tar -xzf proj-9.1.1.tar.gz
cd proj-9.1.1
mkdir build
cd build
cmake ..
cmake --build . -j "$(nproc)"
sudo cmake --build . --target install