

# NRLoginManager

[![Version](https://img.shields.io/cocoapods/v/NRLoginManager.svg?style=flat)](http://cocoapods.org/pods/NRLoginManager)
[![License](https://img.shields.io/cocoapods/l/NRLoginManager.svg?style=flat)](http://cocoapods.org/pods/NRLoginManager)
[![Platform](https://img.shields.io/cocoapods/p/NRLoginManager.svg?style=flat)](http://cocoapods.org/pods/NRLoginManager)
![ScreenShot](https://cdn.rawgit.com/naveenrana1309/NRLoginManager/master/Example/sample.png "Screeshot")





## Introduction

NRLoginManager: This library provides makes your login work easy by integrating the facebook and google login with one line of code.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Xcode 9+ , Swift 4 , iOS 10 and above

## Installation

NRLoginManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NRLoginManager"
```

## Usage

# Facebook Login
```
@IBAction func facebookButtonPressed(_ sender: UIButton) {
NRLoginManager.shared.login(type: .facebook) { (user, error) in
if error == nil {
self.welcomeLabel.text = user!.name
print(user!)
}
}
}

```

# Google Login

```
@IBAction func googleButtonPressed(_ sender: UIButton) {
NRLoginManager.shared.clientID = "YOUR GOOGLE CLIENT ID" https://developers.google.com/identity/sign-in/ios/start-integrating
NRLoginManager.shared.login(type: .google) { (user, error) in
if error == nil {
self.welcomeLabel.text = user!.name
print(user!)
}

}
}


```

# Plist Keys
You have to update the plist with your social ids.
```
<key>CFBundleURLTypes</key>
<array>
<dict>
<key>CFBundleTypeRole</key>
<string>Editor</string>
<key>CFBundleURLSchemes</key>
<array>
<string>fbYOURFBID</string>
</array>
</dict>
<dict>
<key>CFBundleTypeRole</key>
<string>Editor</string>
<key>CFBundleURLSchemes</key>
<array>
<string>Add google client id here</string>
</array>
</dict>


</array>
<key>CFBundleVersion</key>
<string>1</string>
<key>FacebookAppID</key>
<string>YOURFBID</string>
<key>FacebookDisplayName</key>
<string>NRLoginManager</string>

<key>LSApplicationQueriesSchemes</key>
<array>
<string>fbapi</string>
<string>fb-messenger-api</string>
<string>fbauth2</string>
<string>fbshareextension</string>
<string>comgooglemaps</string>
</array>

```

# Setup Appdelegate

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
// Override point for customization after application launch.
NRLoginManager.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
return true
}

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
return NRLoginManager.shared.application(app, open: url, options: options)
}


```

## Contributing

Contributions are always welcome! :)

1. Fork it ( http://github.com/naveenrana1309/NRLoginManager/fork )
2. Create your feature branch ('git checkout -b my-new-feature')
3. Commit your changes ('git commit -am 'Add some feature')
4. Push to the branch ('git push origin my-new-feature')
5. Create new Pull Request

## Compatibility

Xcode 9+ , Swift 4 , iOS 10 and above

## Author

Naveen Rana. [See Profile](https://www.linkedin.com/in/naveenrana1309)

Email: 
naveenrana1309@gmail.com. 

Check out [Facebook Profile](https://www.facebook.com/naveen.rana.146) for detail.

## License

NRLoginManager is available under the MIT license. See the LICENSE file for more info.
