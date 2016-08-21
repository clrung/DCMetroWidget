# DC Metro Widget [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/clrung/DCMetroWidget/master/LICENSE) [![platforms](https://img.shields.io/badge/platform-macOS-lightgrey.svg)]()

<p align="center">
<a href="http://appstore.com/mac/dcmetro"><img src="https://www.mapdiva.com/wp-content/uploads/2011/01/Mac_App_Store_Badge_US_UK1.png" width="400" height="200" alt="Available on the Mac App Store"/></a>
</p>

A Today extension for macOS' Notification Center that tracks DC Metro arrival times.

<p align="center">
<img src="http://i.imgur.com/K9iXRGF.png" width="320" height="403" alt="Screenshot"/></a>
</p>

## Requirements
* macOS 10.11+
 * There is currently an [open issue for Yosemite (10.10) support](https://github.com/clrung/DCMetroWidget/issues/15).  I am working on it!

## Installation
This project uses [CocoaPods](https://cocoapods.org).  You know what to do:

```bash
$ pod install
```

### WMATA API Key
The extension will not fetch information from WMATA's API without an API key.  You can setup a free account and get a key [here](https://developer.wmata.com/).  Replace [WMATA\_KEY\_GOES\_HERE] in [TodayViewController.swift](https://github.com/clrung/DCMetroWidget/blob/master/DCMetroWidget/TodayViewController.swift) with your key.

## Dependencies
* [WMATAFetcher](https://cocoapods.org/pods/WMATAFetcher)
* [Crashlytics](https://cocoapods.org/pods/Crashlytics)