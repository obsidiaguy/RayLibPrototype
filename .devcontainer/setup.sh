#!/bin/bash
set -e

echo ">>> Installing system dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq \
  build-essential \
  git \
  cmake \
  python3 \
  libasound2-dev \
  libx11-dev \
  libxrandr-dev \
  libxi-dev \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  libxcursor-dev \
  libxinerama-dev

echo ">>> Installing RayLib..."
RAYLIB_VERSION="5.0"
cd /tmp
git clone --depth 1 --branch ${RAYLIB_VERSION} https://github.com/raysan5/raylib.git
cd raylib
mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=ON ..
make -j$(nproc)
sudo make install
sudo ldconfig
cd /

echo ">>> Installing Emscripten (for web/WebAssembly builds)..."
cd ~
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
echo 'source ~/emsdk/emsdk_env.sh' >> ~/.bashrc

echo ">>> Setup complete! RayLib and Emscripten are ready."
echo ">>> To build for web: make web"
echo ">>> To serve the game: make serve"
