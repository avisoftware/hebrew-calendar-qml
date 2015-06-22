#hebrew-calendar-qml
![GitHub release](https://img.shields.io/github/tag/avi-software/hebrew-calendar-qml.svg?style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/avi-software/hebrew-calendar-qml.svg?style=flat-square)
![GitHub issues](https://img.shields.io/github/issues/avi-software/hebrew-calendar-qml.svg?style=flat-square)
![GitHub license](https://img.shields.io/github/license/avi-software/hebrew-calendar-qml.svg?style=flat-square)

<img src =https://myapps.developer.ubuntu.com/site_media/appmedia/2015/06/drawing2.png height="128" width="128"><icon>  

##Description
hebrew-calendar-qml, It is an Hebrew calendar for Ubuntu Phone.  
The calendar includes Hebrew dates, holidays, times, Parshiot Hashavua, and more.

It is written QML and C++ by QT.

##Dependencies
`libhdate1`  
	_Note: click packages not support on dependencies, so i have to ship the libhdate.so with the package._
####build-depend:  
`libhdate-dev`  
##Compiling click package
####Prepare
* First you should install `ubuntu sdk` package, [see here](https://developer.ubuntu.com/en/start/ubuntu-sdk/installing-the-sdk/).
* Create build target like [this](https://developer.ubuntu.com/en/apps/sdk/tutorials/click-targets-and-device-kits/).  

#### Install dependencies
* Go to __Tool__ > __Option__
* Select __Ubuntu__ and the __Click__ tab.
* Click __Maintain__ for the click build target you wish to install the package.
* On the terminal window type `apt-get install libhdate-dev:<arch>`  
*(replace `<arch>` with the build target architecture)*

#### Open The project
* Go to __File__ > __Open__
* Select the `CMakeLists.txt` file from the root of the project directory.
* Open the project against your build target.
* check in the __General Messages__ tab, if you get errors.

#### Create click package
* Go to __Publish__ tab.
* Click on __Build and Validate click package__ .

#####*Packaging note:*
*If you want to create multiarch click package [read this](http://www.theorangenotebook.com/2014/12/creating-mutli-arch-click-packages.html).*
##Screenshots
![screen shot](https://myapps.developer.ubuntu.com/site_media/appmedia/2015/06/screenshot0.png)
![screen shot1](https://myapps.developer.ubuntu.com/site_media/appmedia/2015/06/screenshot1.png)
