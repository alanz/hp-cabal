## -*- docker-image-name: "hp-cabal" -*-
#Build with
#  docker build -t hp-cabal .
#Test with
#  docker run -i -t -v $PWD:/root/work hp-cabal /bin/bash

FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN echo "2015-05-11"
RUN apt-get update

RUN apt-get install -y wget

RUN cd /root/ && wget "https://www.haskell.org/ghc/dist/7.10.1/ghc-7.10.1-x86_64-unknown-linux-deb7.tar.bz2"
RUN cd /root/ && wget "https://www.haskell.org/cabal/release/cabal-install-1.22.4.0/cabal-install-1.22.4.0.tar.gz"

RUN apt-get install -y git
RUN apt-get install -y vim emacs
RUN apt-get install -y fakeroot
RUN apt-get install -y make build-essential
RUN apt-get install -y libgmp10 zlib1g-dev libgmp-dev cpphs


RUN cd /root/ && tar -xf ghc-7.10.1-x86_64-unknown-linux-deb7.tar.bz2
RUN cd /root/ghc-7.10.1 && ./configure && make install

RUN cd /root/ && tar -xf cabal-install-1.22.4.0.tar.gz
RUN cd /root/cabal-install-1.22.4.0 && ./bootstrap.sh
RUN rm -fr ~/.ghc

ENV PATH /.cabal/bin:/root/.cabal/bin:$PATH

# -------- preinstall the current dependencies, as constrained by stackage LTS
RUN echo "Updating 2015-06-03"
RUN cabal update

COPY cabal.config .
RUN cabal install alex happy
RUN apt-get install -y libgl1-mesa-dev libglu1-mesa-dev
RUN apt-get install -y freeglut3 freeglut3-dev
RUN apt-get install -y libgtk2.0-dev
RUN apt-get install -y libpango1.0-dev
RUN apt-get install -y libcairo2-dev
RUN apt-get install -y libglib2.0-dev

# -----------------------------------------------------------------------------

COPY hp-cabal.cabal .
COPY Setup.hs       .
COPY src            .

RUN cabal install --dependencies-only

RUN cabal install gtk2hs-buildtools
RUN cabal install threadscope
RUN cabal install profiteur
RUN cabal install parallel
RUN cabal install monad-par
# RUN cabal install ghc-vis
# RUN cabal install ghc-events-analyze --allow-newer


# -------- mount the command line directory here
WORKDIR /root/work

