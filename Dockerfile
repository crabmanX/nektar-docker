FROM debian:9

MAINTAINER <Kilian Lackhove> "<kilian@lackhove.de>"


RUN apt-get update && \
    apt-get install -y build-essential cmake git clang gfortran flex \
    "libboost*-dev" libhdf5-mpi-dev libptscotch-dev zlibc libfftw3-dev \
    libarpack2-dev libvtk6-dev liboce-foundation-dev liboce-ocaf-dev tetgen \
    petsc-dev

RUN groupadd nektar && useradd -m -g nektar nektar
USER nektar:nektar
WORKDIR /home/nektar

RUN git clone https://gitlab.nektar.info/nektar/nektar.git
RUN mkdir build && \
    cd build && \
    CC=/usr/bin/clang CXX=/usr/bin/clang++ FC=/usr/bin/gfortran cmake \
    -DCMAKE_BUILD_TYPE:STRING=Debug -DNEKTAR_FULL_DEBUG:BOOL=ON \
    -DNEKTAR_TEST_ALL:BOOL=ON -DNEKTAR_BUILD_TIMINGS:BOOL=ON \
    -DNEKTAR_USE_ARPACK:BOOL=ON -DNEKTAR_USE_FFTW:BOOL=ON \
    -DNEKTAR_USE_VTK:BOOL=ON -DNEKTAR_USE_MPI:BOOL=ON \
    -DNEKTAR_USE_SCOTCH:BOOL=ON -DNEKTAR_USE_PETSC:BOOL=ON \
    -DNEKTAR_USE_HDF5:BOOL=ON \
    -DTHIRDPARTY_BUILD_GSMPI:BOOL=ON -DTHIRDPARTY_BUILD_TINYXML:BOOL=ON \
    -DTHIRDPARTY_BUILD_SCOTCH:BOOL=ON -DNEKTAR_TEST_USE_HOSTFILE=ON \
    ../nektar/ && \
    CC=/usr/bin/clang CXX=/usr/bin/clang++ FC=/usr/bin/gfortran make -j 8


#     -DNEKTAR_USE_MESHGEN:BOOL=ON


