WopataLogin is a social/native sign-signup module for iOS

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

## Usage

### Facebook configuration

#### Create your Facebook application

Create or select your Facebook application on [facebook for developpers](https://developers.facebook.com/docs/facebook-login/ios).
Note the Facebook App ID for your application.
 
#### Configure your Info.plist

1. Locate the `Info.plist` file in your xcode project.
2. Right click on the file and select "Open As Source Code"
3. Paste the following xml inside the `<dict>...</dict>` tags
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
  <key>CFBundleURLSchemes</key>
  <array>
    <string>fbxxxxxxxxxxxxxxx</string>
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

#### Connect your AppDelegate

In order to redirect to your application after login, Facebook needs to connect your AppDelegate.
Add the following code to your AppDelegate.swift file.

```swift
//  AppDelegate.swift
import FBSDKCoreKit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

  return true
}

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
  let srcApp = options[.sourceApplication] as? String
  let annotation = options[.annotation]
  if FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: srcApp, annotation: annotation) {
    return true
  }

  return true
}

```


