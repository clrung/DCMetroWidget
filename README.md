# DC Metro Widget

<p align="center">
<a href="http://appstore.com/mac/dcmetro"><img src="https://www.mapdiva.com/wp-content/uploads/2011/01/Mac_App_Store_Badge_US_UK1.png" width="400" height="200" alt="Available on the Mac App Store"/></a>
</p>

A Today extension for macOS' Notification Center that tracks DC Metro arrival times.

<p align="center">
<img src="http://i.imgur.com/K9iXRGF.png" width="320" height="403" alt="Screenshot"/></a>
</p>

## Installation
This project uses [CocoaPods](http://cocoapods.org).  You know what to do:

	pod install

### WMATA API Key
The extension will not fetch information from WMATA's API without an API key.  You can setup a free account and get a key [here](https://developer.wmata.com/).  Replace [WMATA\_KEY\_GOES\_HERE] in [WMATAFetcher.swift](https://github.com/clrung/DCMetroWidget/blob/master/DCMetroWidget/WMATAFetcher.swift) with your key.