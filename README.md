# Badge Keeper

Badge Keeper iOS library will help add achievement system to your app easily.

More information you can find here: [Badge Keeper official site](https://badgekeeper.net)

Test your project from web browser here: [Badge Keeper Api](https://api.badgekeeper.net/swagger/ui/index)

[![Build Status](https://travis-ci.org/badgekeeper/BadgeKeeper-iOS.svg?branch=master)](https://travis-ci.org/badgekeeper/BadgeKeeper-iOS)
[![Version](https://img.shields.io/cocoapods/v/BadgeKeeper.svg)](http://cocoadocs.org/docsets/BadgeKeeper)
[![Platform](https://img.shields.io/cocoapods/p/BadgeKeeper.svg)](http://cocoadocs.org/docsets/BadgeKeeper)
[![License](https://img.shields.io/cocoapods/l/BadgeKeeper.svg)](http://cocoadocs.org/docsets/BadgeKeeper)

## Getting Started

To integrate Badge Keeper library into your iOS project, install with [CocoaPods](http://cocoapods.org)
```
platform :ios, '7.0'
pod 'BadgeKeeper'
```

## Usage

### Import header

```objc
#import <BadgeKeeper/BadgeKeeper.h>
```

### Basic Initialization

```objc
[BadgeKeeper instance].projectId       = @"Project Id from admin panel";
[BadgeKeeper instance].userId          = @"Your client id";
[BadgeKeeper instance].shouldLoadIcons = YES; // default is NO
```

That's all settings that need to be configured.

### Callbacks

There are four callbacks that we will use to receive results from Badge Keeper service:

```
// 1 - Returns array of BKAchievement elements
typedef void (^BKAchievementsResponseCallback)(NSArray *achievements);

// 2 - Returns array of BKUserAchievement elements
typedef void (^BKUserAchievementsResponseCallback)(NSArray *achievements);

// 3 - Returns array of BKUnlockedAchievement elements
typedef void (^BKAchievementsUnlockedCallback)(NSArray *achievements);

// 4 - Returns error code and error message if something goes wrong
typedef void (^BKFailureResponseCallback)(int code, NSString *message);
```

### Get project achievements (no userId required)

```objc
[[BadgeKeeper instance]
	getProjectAchievementsWithSuccess:^(NSArray *achievements) {
		// Returns array of BKAchievement elements
	}
	withFailure:^(int code, NSString *message) {
		// Returns error code and error message if something goes wrong
	}];
```

### Get user achievements

```objc
[[BadgeKeeper instance]
	getUserAchievementsWithSuccess:^(NSArray *achievements) {
		// Returns array of BKUserAchievement elements
	}
	withFailure:^(int code, NSString *message) {
		// Returns error code and error message if something goes wrong
	}];
```

### Post user variables and validate completed achievements

```objc
[[BadgeKeeper instance] preparePostValue:0 forKey:@"key"];
[[BadgeKeeper instance]
	postPreparedValuesWithSuccess:^(NSArray *achievements) {
       // Returns array of BKUnlockedAchievement elements
    }
	withFailure:^(int code, NSString *message) {
		// Returns error code and error message if something goes wrong
	}];
```

### Increment user variables and validate completed achievements

```objc
[[BadgeKeeper instance] prepareIncrementValue:1 forKey:@"key"];
[[BadgeKeeper instance]
	incrementPreparedValuesWithSuccess:^(NSArray *achievements) {
       // Returns array of BKUnlockedAchievement elements
    }
	withFailure:^(int code, NSString *message) {
		// Returns error code and error message if something goes wrong
	}];
```

### Attention
```objc
// Requests will be processed in separated thread!
// Use this when works with UI inside callback method.
dispatch_sync(dispatch_get_main_queue(), ^{
    // Put your UI logic here
});
```
	

## Requirements

* Xcode 6.0 or later.
* iOS 7 or later.

## License

	Copyright 2015 Badge Keeper

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

    	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.