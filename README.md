# Flagstaff

[![Version](https://img.shields.io/cocoapods/v/Flagstaff.svg?style=flat)](http://cocoapods.org/pods/Flagstaff)
[![License](https://img.shields.io/cocoapods/l/Flagstaff.svg?style=flat)](http://cocoapods.org/pods/Flagstaff)
[![Platform](https://img.shields.io/cocoapods/p/Flagstaff.svg?style=flat)](http://cocoapods.org/pods/Flagstaff)

Flagstaff is a simple feature flagging framework built in Objective-C.

## Installation

Flagstaff is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Flagstaff', '~> 0.1'
```

## Using Flagstaff

First, you need remote flags to use. Flags must follow the [flagstaff v1 schema](https://github.com/NickEntin/flagstaff-ios/wiki/Flagstaff-Schema). For development purposes, the simplest way to do this is to upload `json` files to a server and use a url format similar to the following:

```Objective-C
FSFlagManager *flagManager = [[FSFlagManager alloc] initWithURLFormat:@"https://example.com/flags/{flag}.json"];

// Check if a flag is enabled
if ([flagManager enableFeatureForKey:@"flag_name"]) {
    // The flag is enabled
} else {
    // The flag is disabled
}

// Get custom parameters for key
NSDictionary *parameters = [flagManager parametersForKey:@"flag_name"];
NSInteger parameterValue = [[parameters objectForKey:@"param_name"] integerValue];
```

## Author

Nick Entin, nick@entin.io

## License

Flagstaff is available under the MIT license. See the LICENSE file for more info.

## Contributing

See a bug or have a feature you'd like added? Submit an issue or pull request. Contributions are welcome and appreciated!
