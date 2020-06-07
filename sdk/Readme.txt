Welcome to the Adobe� Lightroom� Classic 8.0 Software Development Kit
(Build: "201910171147-f2855d44")
_____________________________________________________________________________

This file contains the latest information for the Adobe Lightroom SDK (8.0 Release).
The information applies to Adobe Lightroom Classic and includes the following sections:

1. Introduction
2. SDK content overview
3. Development environment
4. Sample plug-ins
5. Running the plug-ins
6. Adobe Add-ons

**********************************************
1. Introduction
**********************************************

The SDK provides information and examples for the scripting interface to Adobe
Lightroom Classic. The SDK defines a scripting interface for the Lua language.

A number of new features have been added in the 8.0 SDK release. Please see the API
Reference for more information about each of the namespaces:

1.	LrApplicationView:
  	Support added for jumping to reference view in LrApplicationView.showView()
		LrApplicationView.showView( "develop_reference_horiz" ) or
		LrApplicationView.showView( "develop_reference_vert" )
   	to go to L/R or T/B reference view from either the develop or the library module.

2. 	LrCatalog:
   	- There is a change in catalog:findPhotoByPath() API signature.
   	  The API now takes an optional boolean(true/false) parameter which indicates whether
   	  the user wants to do case-sensitive or case-insensitive search.
   	  eg: catalog:findPhotoByPath(path,true) indicates case-sensitive search for path.
	- New filter "edit" added for filtering edited and non-edited images. Users can get the
	  value of the current library view filter using catalog:getCurrentViewFilter(), and the
	  resulting table returned will have additional field "edit"

3. 	LrDevelopController:
   	- Support added for setting tone curve from SDK.
   	- Support added to set localized Blacks and Whites.

4. 	LrStringUtils:
	Optional parameter has been added to the LrStringUtils.compareStrings() API, which gives the
	user flexibility as to whether they want the numbers in the string to be treated as numbers or
	normal string characters.


Key Bug Fixes:

1. 	Localised Blacks and Whites option has been added to LrDevelopController.
2.	LrStringUtils.compareStrings() API would always treat numbers in string as numbers. This
	has been enhanced, where the user decides whether to treat digits of numbers as normal
	string characters of convert them to numbers before comparison
3.	Docs have been updated to correct a number of issues.

**********************************************
2. SDK content overview
**********************************************

The SDK contents include the following:

- <sdkInstall>/Manual/Lightroom SDK Guide.pdf:
	Describes the SDK and how to extend the functionality of
	Adobe Lightroom Classic.

- <sdkInstall>/API Reference/:
	The Scripting API reference in HTML format. Start at index.html.

- <sdkInstall>/Sample Plugins:
	Sample plug-ins and demonstration code (see section 4).

**********************************************
3. Development environment
**********************************************

You can use any text editor to write your Lua scripts, and you can
use the LrLogger namespace to write debugging information to a console.
See the section on "Debugging your Plug-in" in the Lightroom SDK Guide.

**********************************************
4. Sample Plugins
**********************************************

The SDK provides the following samples:

- <sdkInstall>/Sample Plugins/flickr.lrdevplugin/:
	Sample plug-in that demonstrates creating a plug-in which allows
	images to be directly exported to a Flickr account.

- <sdkInstall>/Sample Plugins/ftp_upload.lrdevplugin/:
	Sample plug-in that demonstrates how to export images to an FTP server.

- <sdkInstall>/Sample Plugins/helloworld.lrdevplugin/:
	Sample code that accompanies the Getting Started section of the
	Lightroom SDK Guide.

  <sdkInstall>/Sample Plugins/custommetadatasample.lrdevplugin/:
	Sample code that accompanies the custommetadatasample plug-in that
	demonstrates custom metadata.

- <sdkInstall>/Sample Plugins/metaexportfilter.lrdevplugin/:
	Sample code that demonstrates using the metadata stored in a file
	to filter the files exported via the export dialog.

- <sdkInstall>/Sample Plugins/websample.lrwebengine/:
	Sample code that creates a new style of web gallery template
	using the Web SDK.

**********************************************
5. Running the plug-ins
**********************************************

To run the sample code, load the plug-ins using the Plug-in Manager
available within Lightroom. See the Lightroom SDK Guide for more information.

*********************************************************
6. Adobe Add-ons
*********************************************************

To learn more about Adobe Add-ons, point your browser to:

  https://creative.adobe.com/addons

_____________________________________________________________________________

Copyright 2018 Adobe Systems Incorporated. All rights reserved.

Adobe, Lightroom, and Photoshop are registered trademarks or trademarks of
Adobe Systems Incorporated in the United States and/or other countries.
Windows is either a registered trademark or a trademark of Microsoft Corporation
in the United States and/or other countries. Macintosh is a trademark of
Apple Computer, Inc., registered in the United States and  other countries.

_____________________________________________________________________________
