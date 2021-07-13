#!/bin/bash

cd src
octave --eval "bringONSASmFilesToONSAS_docs('~/work/codigos/onsas/ONSAS.m_repo/')"
cd ..

# make documention
julia docs/make.jl $1

# preview build
if [ $1 = pdf ]
then
  evince docs/build/ONSAS.m.pdf
elif [ $1 = html ]
then
  epiphany docs/build/index.html
fi
