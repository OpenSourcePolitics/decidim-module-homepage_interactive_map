PROJVERSION="proj-9.1.1"

sudo apt-get update && sudo apt install cmake sqlite libtiff-dev curl libcurl4-openssl-dev libssl-dev -y

if [ ! -d $PROJVERSION ]; then
  curl https://download.osgeo.org/proj/${PROJVERSION}.tar.gz -o ${PROJVERSION}.tar.gz
  tar -xzf ${PROJVERSION}.tar.gz
fi

cd $PROJVERSION || exit

if [ ! -d "build" ]; then
  mkdir build
fi

cd build || exit
cmake ..
sudo cmake --build . -j "$(nproc)" --target install
sudo ldconfig
