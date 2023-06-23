#!/bin/sh

: '

This shell script helps the WRF-Chem users to install the Weather Research and Forecasting (WRF) model coupled with Chemistry (WRF-Chem) version 4.5 and Kinetic PreProcessor (KPP) on Ubuntu 22.04.2 LTS in 64-bit system.

Author: Yusuf Aydin (Yusuf Alizade Govarchin Ghale)
***************************************************
PhD
Department of Climate and Marine Sciences
Eurasia Institute of Earth Sciences
Istanbul Technical University
Maslak 34469, Istanbul, Turkey
Email: yusufalizade2000@gmail.com
Email: yusufaydin@itu.edu.tr
Email: alizade@itu.edu.tr
Tel:   +90 537 919 7953

'
#***********************************************************************************************************************************************

# Install required libraries including HDF5, NetCDF-C, NetCDF-Fortran, Jasper, Libpng, Zlib and MPICH

echo "******************************************************************************************************************************************"
echo 								"Install basic libraries"
echo "******************************************************************************************************************************************"

sudo apt update
sudo apt upgrade
sudo apt install -y tcsh git libcurl4-openssl-dev
sudo apt install -y make gcc cpp gfortran openmpi-bin libopenmpi-dev
sudo apt install libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview ncl-ncarg build-essential unzip mlocate byacc flex

#*******************************************************************************

# Make required directories

# Change current directory to home directory and export environmental variables as child processes without affecting the existing environmental variable

echo "*******************************************************************************************************************************************"
echo 					"Make required directories and set environment variables and compilers"
echo "*******************************************************************************************************************************************"

export HOME=`cd;pwd`
mkdir $HOME/Models
mkdir $HOME/Models/WRF-Chem
export WRFCHEM_HOME=$HOME/Models/WRF-Chem
cd $WRFCHEM_HOME
mkdir Downloads
mkdir Libs
mkdir Libs/grib2
mkdir Libs/NETCDF
mkdir Libs/MPICH
export DIR=$WRFCHEM_HOME/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran

#***********************************************************************************************************************************************

# Download and install Zlib library

echo "******************************************************************************************************************************************"
echo					 "Download and install Zlib library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCHEM_HOME/Downloads
wget -c https://www.zlib.net/zlib-1.2.13.tar.gz
tar -xzvf zlib-1.2.13.tar.gz
cd zlib-1.2.13
./configure --prefix=$DIR/grib2
make 
make install

#***********************************************************************************************************************************************

# Download and install hdf5 library 

echo "******************************************************************************************************************************************"
echo 					"Download and install hdf5 library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCHEM_HOME/Downloads
wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.13/hdf5-1.13.2/src/hdf5-1.13.2.tar.gz
tar -xvzf hdf5-1.13.2.tar.gz
cd hdf5-1.13.2
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make 
make install
export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

#***********************************************************************************************************************************************

# Download and install Netcdf C library

echo "******************************************************************************************************************************************"
echo 					"Download and install Netcdf C library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCHEM_HOME/Downloads
wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz -O netcdf-c-4.9.0.tar.gz
tar -xzvf netcdf-c-4.9.0.tar.gz
cd netcdf-c-4.9.0
export CPPFLAGS=-I$DIR/grib2/include
export LDFLAGS=-L$DIR/grib2/lib
./configure --prefix=$DIR/NETCDF --disable-dap
make
make install
export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF

#***********************************************************************************************************************************************

# Download and install Netcdf fortran library

echo "******************************************************************************************************************************************"
echo 					"Download and install Netcdf fortran library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCHEM_HOME/Downloads
wget -c https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.0/netcdf-fortran-4.6.0.tar.gz
tar -xvzf netcdf-fortran-4.6.0.tar.gz
cd netcdf-fortran-4.6.0
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include
export LDFLAGS=-L$DIR/NETCDF/lib
./configure --prefix=$DIR/NETCDF --disable-shared
make
make install

#***********************************************************************************************************************************************

# Download and install Jasper library

echo "******************************************************************************************************************************************"
echo 					"Download and install Jasper library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCHEM_HOME/Downloads
wget -c  http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip
unzip jasper-1.900.1.zip
cd jasper-1.900.1
autoreconf -i
./configure --prefix=$DIR/grib2
make
make install
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

#***********************************************************************************************************************************************

# Download and install Libpng library

echo "******************************************************************************************************************************************"
echo					 "Download and install Libpng library and set environment variables" 
echo "******************************************************************************************************************************************"

cd $WRFCHEM_HOME/Downloads
wget -c https://sourceforge.net/projects/libpng/files/libpng16/1.6.39/libpng-1.6.39.tar.gz
tar -xzvf libpng-1.6.39.tar.gz
cd libpng-1.6.39/
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
./configure --prefix=$DIR/grib2
make
make install

#***********************************************************************************************************************************************

# Download and install Mpich library

echo "******************************************************************************************************************************************"
echo 					"Download and install Mpich library and set environment variables"
echo "******************************************************************************************************************************************"

cd $WRFCHEM_HOME/Downloads
wget -c https://www.mpich.org/static/downloads/4.0.3/mpich-4.0.3.tar.gz
tar -xzvf mpich-4.0.3.tar.gz
cd mpich-4.0.3
./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS=-fallow-argument-mismatch FCFLAGS=-fallow-argument-mismatch
make
make install
export PATH=$DIR/MPICH/bin:$PATH

#***********************************************************************************************************************************************

# Download and install WRF-Chem library

echo "******************************************************************************************************************************************"
echo 					"Download and install WRF-Chem and set environment variables"
echo "******************************************************************************************************************************************"

cd $WRFCHEM_HOME/Downloads
wget -c https://github.com/wrf-model/WRF/releases/download/v4.5/v4.5.tar.gz -O wrf-4.5.tar.gz
tar -xzvf wrf-4.5.tar.gz -C $WRFCHEM_HOME
cd $WRFCHEM_HOME/WRFV4.5
ulimit -s unlimited
export WRF_EM_CORE=1
export WRF_NMM_CORE=0  
export WRF_CHEM=1
export WRF_KPP=1 
export YACC='/usr/bin/yacc -d' 
export FLEX=/usr/bin/flex
export FLEX_LIB_DIR=/usr/lib/x86_64-linux-gnu/ 
export KPP_HOME=$WRFCHEM_HOME/WRFV4.5/chem/KPP/kpp/kpp-2.1
export WRF_SRC_ROOT_DIR=$WRFCHEM_HOME/WRFV4.5
export PATH=$KPP_HOME/bin:$PATH
export SED=/usr/bin/sed
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
cd chem/KPP
sed -i -e 's/="-O"/="-O0"/' configure_kpp
cd -

: '

If you want to install the model line by line use the vim editor to edit configure file before running it;

vi configure

# Go to the line 925 and change  if [ "SUSENETCDFPAR" == "1" ] ; then  to  if ["SUSENETCDFPAR" = "1" ] ; then

now you can run configure

'
sed -i -e 's/if [ "$USENETCDFPAR" == "1" ] ; then/if [ "$USENETCDFPAR" = "1" ] ; then/' configure

./configure
# Select option 34 (dmpar GNU) for gfortran/gcc and option 1 (basic) for compilefor nesting

# Compile WRF-Chem

./compile em_real 2>&1 | tee wrfchem_compile.log
# Wait about 60 minitues to complete the installation

export WRF_DIR=$WRFCHEM_HOME/WRFV4.5

: '

Check the existence of executable files in the following links using;

ls -lah main/*.exe
ls -lah run/*.exe
ls -lah test/em_real/*.exe

If you see all of the executable files including;

ndown.exe
real.exe 
tc.exe 
wrf.exe 

the installation is successfully completed. 

Check the wrfchem_compile.log file if there is any error.

'
#***********************************************************************************************************************************************

# Compile the WRF-Chem external emissions conversion code

echo "******************************************************************************************************************************************"
echo 					"Compile the WRF-Chem external emissions conversion code"
echo "******************************************************************************************************************************************"

./compile emi_conv 2>1 | tee emission_compile.log

: '

Check the existence of executable file (convert_emiss.exe) using;

ls -lah test/em_real/*.exe

If you see the convert_emiss.exe, the compilation has been successfully done.

'

#***********************************************************************************************************************************************

# Download and install WPS library

echo "******************************************************************************************************************************************"
echo 					"Download and install WPS and set environment variables"
echo "******************************************************************************************************************************************"

cd $WRFCHEM_HOME/Downloads
wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.5.tar.gz -O wps-4.5.tar.gz
tar -xzvf wps-4.5.tar.gz -C $WRFCHEM_HOME
cd $WRFCHEM_HOME/WPS-4.5

export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

./configure
# Select option 3 (Linux x86-64) gfortran (dmpar) for gfortran and distributed memory
./compile
export PATH=$DIR/bin:$PATH
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH

: '

Check the existence of executable files;

ls *.exe

If  you see all of the executable files including

geogrid.exe
metgrid.exe
ungrib.exe 

the installation is successfully compeleted.


#***********************************************************************************************************************************************
#The end of shell script
'
# Set the color variable
green='\033[0;32m'
# Clear the color after that
clear='\033[0m'
echo "${green}***Congratulations! You have successfully installed the WRF-Chem version 4.5 on your system***${clear}"

: '
After the installation set all environment variables in bashrc and activate it using the following commands;

vi ~/.bashrc

source ~/.bashrc

'
: '

References:

https://ruc.noaa.gov/wrf/wrf-chem/Users_guide.pdf

https://ruc.noaa.gov/wrf/wrf-chem/wrf_tutorial_exercises_v35/compiling_code.html

https://undhpc.gitlab.io/Tutorials/SpecificPrograms/WRF/README_INSTALL_3_8_1.html

https://ruc.noaa.gov/wrf/wrf-chem/FAQ.htm

https://wiki.harvard.edu/confluence/pages/viewpage.action?pageId=228526205

https://www2.acom.ucar.edu/wrf-chem

https://dreambooker.site/tags/wrf-chem/

https://github.com/HathewayWill

https://www.youtube.com/watch?v=m2FkdqPiJZ0

https://github.com/hectornav/

'
