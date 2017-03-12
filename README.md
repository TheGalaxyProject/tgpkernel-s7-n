# TGPKernel S7

![TGPKernel Logo](https://github.com/TheGalaxyProject/tgpkernel-s7-n/blob/build/build/logo.png?raw=true)

A Custom Kernel for Samsung Galaxy S7 / S7 Edge.

The main purpose of this Kernel is to have a stock-like Kernel that runs on S7 and S7 Edge
variants, but capable of running S7 Edge and Ported Firmwares.


Currently supporting S7 / S8 Port / NFE and N8 Port ROMS.


* XDA S7 Forum: http://forum.xda-developers.com/showthread.php?t=3462897
* XDA S7 Edge Forum: http://forum.xda-developers.com/showthread.php?t=3501571
* Grifo Development Forum: https://forum.grifodev.ch/thread/66


Compiled using my own built custom toolchain

* URL: https://github.com/djb77/aarch64-cortex_a53-linux-gnueabi

## How to use
Adjust the toolchain path in build.sh and Makefile to match the path on your system. 

Run build.sh with the following options, doesn't matter what order keep and silent are in.

- **./build.sh** will build TGPKernel
- **./build.sh keep** will build TGPKernel and also copy the .img files to the output folder
- **./build.sh silent** will build TGPKernel but only display warning and errors in the log
- **./build.sh 0** will clear the workspace
- **./build.sh 00** will clear CCACHE

When finished, the new files and logs will be created in the output directory.

If Java is installed, the .zip file will be signed.


## Credit and Thanks to the following:
- [Samsung Open Source Release Center](http://opensource.samsung.com) for the Source code
- [The Linux Kernel Archive](https://www.kernel.org) for the Linux Patches
- @osm0sis for [Android Image Kitchen](https://github.com/osm0sis/Android-Image-Kitchen/tree/AIK-Linux) and [anykernel2](https://github.com/osm0sis/AnyKernel2)
- @Tkkg1994 for all his help and numerous code samples from his source
- @Wootever for the PWM Flicker-free Fix
- @Chainfire for the Deep Sleep Fix from SuperSU
- @morogoku for MTweaks and lots of help and commits
- @farovitus for lots of help and Spectrum Profiles
- @arter97, @lyapota, @kylothow, @jesec and others for their commits

