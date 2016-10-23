# Description

Ad Hoc this is a program that allows you to make a portable application from the typical application. A portable application is a program that runs from any directory and it does not leave any traces of its work in the operating system.

Ad Hoc makes a portable application in the PAF (PortableApps.com Format). PAF is one of the approaches to creating a portable software. (An another way is an application virtualization). PAF software is a typical application with the settings located in the separate directory. All actions with app are managed by the special launcher or launchers.

# Structure

Ad Hoc contains:

-programs for collecting information about the application;
-programs for preparing and configuring portable application;
-program for creating launchers for selected executable files;
-program for packaging portable application into the archive.

The basic directory layout of each portable app consists of a main directory, PortApp which contains three directories: App, Data and Source:

…\PortApp\App
…\PortApp\Data
…\PortApp\Source
…\PortApp\AppLauncher.portable.exe
…\PortApp\SetLnch.ini

For more details about structure and about this project see Readme.rtf (in Russian).

# License

See License / Лицензия.txt
