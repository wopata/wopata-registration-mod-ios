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
source 'git@github.com:wopata/wopata-tools.git'

platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'WopataLogin', '~> 0.6.0'
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

Drag the `GoogleService-Info.plist` file you just downloaded into the root of your Xcode project and add it to all targets.
 
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
import WopataLogin

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  
  WopataLogin.shared.configure(application: application, launchOptions: launchOptions)
  return true
}

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
  let srcApp = options[.sourceApplication] as? String
  let annotation = options[.annotation]
  return WopataLogin.shared.handle(url: url, application: app, sourceApplication: srcApp, annotation: annotation)
}

```

---

## Usage

Check out the provided demo app for an example on how you can use the component.

### Quick Start

```swift
import WopataLogin

class MyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        WopataLogin.shared.signedIn = { user in
          // send user data to server
        }
        WopataLogin.shared.signedUp = { user in
          // send user data to server
        }
        WopataLogin.shared.reset = { user in
          // send user data to server
        }
        present(WopataLogin.shared.mainController, animated: true)
    }

}
```

### Customization

You can customize most of the colors, fonts and backgrounds, using the `WopataLoginConfiguration` class

```swift
let config = WopataLogin.shared.config
config.landingBackgroundImage = UIImage(named: "background")

let brand = UIImageView(image: UIImage(named: "brand"))
brand.contentMode = .scaleAspectFit
brand.snp.makeConstraints { $0.width.equalTo(182) }
config.landingBrandView = brand

config.ctaBackgroundColor = UIColor.red
config.ctaFont = UIFont.boldSystemFont(ofSize: 15)

config.signinModes = [.facebook, .email]
config.facebookPermissions = ["public_profile"]

config.landingText = NSLocalizedString("landing_text", comment: "")

WopataLogin.shared.config = config
```

### Server errors

If your server is configured to return errors on sign-in/sign-up, you can forward them to the component.

```swift
WopataLogin.shared.addError(field: .facebook, message: "There was an error with your account, please contact the support.")
WopataLogin.shared.addError(field: .password, message: "The password is too short")
```
