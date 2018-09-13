# WorkForkernelPatch
This is the platform to do the ONL Linux patch

1. Reference
Applying Patches To The Linux Kernel
https://www.kernel.org/doc/html/v4.15/process/applying-patches.html


2. Kernel source at pubic
https://www.kernel.org/pub/linux/kernel/v4.x/

3. Based Information for ONL.
	3.1 Kernel source at the ONL folder:
	./OpenNetworkLinux/packages/base/amd64/kernels/kernel-4.14-lts-x86-64-all/builds/jessie/linux-4.14.49

	3.2. patch folder for specified kernerl.
	./OpenNetworkLinux/packages/base/any/kernels/4.14-lts/patches

	3.3 archives for kernel gar.zx source at ONL.
	./OpenNetworkLinux/packages/base/any/kernels/archives

4. How to use the script file to pull the specificed kernel source.
	a. 3.7.10-Kernel.sh
      => 1. This is the script file to pull the linux-3.7.10.tar.xz, utar the file to ./KERNEL/linux-3.7.10.
	b. 3.7.10-Kernel-patch.sh
      => 1. This is the script file to pull the linux-3.7.10.tar.xz, utar the file to ./KERNEL/linux-3.7.10-patches.
	     2. To add the patches form ./patches-gz/patches-3.7.10.tar.gz
    	
5. How to make the patches-4.14.49.tar.gz

5.1 Generate <file_name>.patch with diff
    
    a. make two folder a/ and b/, where b/ with the changes made from a/.	
    b. the command is 
	diff -Naur  a/ b/ >  ../0003-drivers-net-ethernet-broadcom-linux-4.16.18.patch
	diff -Naur  a/ b/ >  ../0003-drivers-net-ethernet-broadcom-tg3-linux-4.16.18.patch 
	diff -Naur  a/ b/ >  drivers-net-ethernet-broadcom-tg3-3.137k-version.patch                                         

5.2 Generate <file_name>.patch with git diff

   a. tar xvf linux-4.14.49.tar.xz
   b. cd linux-4.14.49
   c. git init
   d. git add .
   e. git commit -m "check in linux-4.14.49"
      ==>merge the code from linux-4.14.67 drivers/net/ethernet/broadcom/tg3.c

   f. To make patch from the last commit to the changes.
      git diff > ../003-jcyu.patch
      git diff > ../0003-drivers-net-ethernet-broadcom-linux-4.16.18.patch

5.3 The mode of the patch file should be "664" for onl, for example
    chmod 664 *
	
	  
6. How to patch from patch-file
 a. method-1
  $ cat 0001-drivers-i2c-muxes-pca954x-deselect-on-exit.patch | patch  –p0
  $ cat 0001-drivers-i2c-muxes-pca954x-deselect-on-exit.patch | patch  –p0
 
 b. method-2 
  $ patch -p1 < ../0001-drivers-i2c-muxes-pca954x-deselect-on-exit.patch
  $ patch -p1 < ../0002-driver-support-intel-igb-bcm5461S-phy.patch
