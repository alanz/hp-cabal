Installs haskell-platform 2015.2.0.0 on Debian
----------------------------------------------

This cabal file captures the packages and constraints from
`hp2015_2_0_0` in 
https://github.com/haskell/haskell-platform/blob/pre-release/hptool/src/Releases2015.hs

It is tested with GHC 7.10.1

Either build the docker file, or use it as a template to see what Debian
packages are required, and then

    cabal install --dependencies-only







