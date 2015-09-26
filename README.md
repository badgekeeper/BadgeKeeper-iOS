# BadgeKeeper
BadgeKeeper service lightweight client library.

## Adding BadgeKeeper to your project

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add BadgeKeeper to your project.

1. Add a pod entry for BadgeKeeper to your Podfile `pod 'BadgeKeeper'`
2. Install the pod(s) by running `pod install`.
3. Include BadgeKeeper wherever you need it with `#import "BadgeKeeper.h"`.

### How to use

1. Setup project
[BadgeKeeper instance].projectId = "ProjectId from admin panel";
2. Setup user
[BadgeKeeper instance].userId = "Your client id";
3. Subscribe to completed achievements
    [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                selector:@selector(clientDidSendValues:)
                                name:kBKNotificationDidPostPreparedValues
                                object:nil];
or
    [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                selector:@selector(clientDidSendValues:)
                                name:kBKNotificationDidIncrementPreparedValues
                                object:nil];
4. Catch notification
- (void)clientDidSendValues:(NSNotification *)notification {
    NSArray *value = notification.userInfo[kBKNotificationKeyResponseObject];
}
5. Post variable
[[BadgeKeeper instance] prepareValue:100 forKey:@"Variable"];
[[BadgeKeeper instance] postPreparedValues];
6. Increment variable
[[BadgeKeeper instance] prepareValue:20 forKey:@"Variable"];
[[BadgeKeeper instance] incrementPreparedValues];

## License

MIT. See `LICENSE` for details.
