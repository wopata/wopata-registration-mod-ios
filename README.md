WopataLogin is a social/native sign-signup module for iOS

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)

## Requirements

- iOS 8.0+ / Mac OS X 10.11+ / tvOS 9.0+
- Xcode 8.0+
- Swift 3.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate WopataLogin into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'WopataLogin', '~> 1.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```

---

## Configuration

### Create your Facebook application

Create or select your Facebook application on [facebook for developpers](https://developers.facebook.com/docs/facebook-login/ios).
Note the Facebook App ID for your application.

### Generate a Google configuration file

The configuration file provides service-specific information for your application. You have to generate it from the [Google Developer Console](https://developers.google.com/mobile/add?platform=ios&cntapi=signin&cnturl=https:%2F%2Fdevelopers.google.com%2Fidentity%2Fsign-in%2Fios%2Fsign-in%3Fconfigured%3Dtrue&cntlbl=Continue%20Adding%20Sign-In).

### Add the configuration file to your project

Drag the `GoogleService-Info.plist file you just downloaded into the root of your Xcode project and add it to all targets.
 
### Configure your Info.plist

In the `GoogleService-Info.plist` file, locate the `REVERSED_CLIENT_ID` key and note its value.

1. Locate the `Info.plist` file in your xcode project.
2. Right click on the file and select "Open As Source Code"
3. Paste the following xml inside the `<dict>...</dict>` tags
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbxxxxxxxxxxxxxxx</string>
    </array>
  </dict>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>THE VALUE YOU NOTED EARLIER</string>
    </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>xxxxxxxxxxxxxxx</string>
<key>FacebookDisplayName</key>
<string>XXXXXXXXXX</string>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fb-messenger-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
```

### Connect your AppDelegate

In order to redirect to your application after login, Facebook and Goog need to connect your AppDelegate.
Add the following code to your AppDelegate.swift file.

```swift
//  AppDelegate.swift
import FBSDKCoreKit
import GoogleSignIn
import Google

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

  var configureError: NSError?
  GGLContext.sharedInstance().configureWithError(&configureError)
  assert(configureError == nil, "Error configuring Google services: \(configureError!)")

  return true
}

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
  let srcApp = options[.sourceApplication] as? String
  let annotation = options[.annotation]
  if FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: srcApp, annotation: annotation) {
    return true
  }

  if GIDSignIn.sharedInstance().handle(url, sourceApplication: srcApp, annotation: annotation) {
      return true
  }

  return true
}

```

---

## Usage
