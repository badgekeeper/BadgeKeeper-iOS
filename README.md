# BadgeKeeper
BadgeKeeper service lightweight client library.

## Adding BadgeKeeper to your project

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add BadgeKeeper to your project.

1. Add a pod entry for BadgeKeeper to your Podfile `pod 'BadgeKeeper'`
2. Install the pod(s) by running `pod install`.
3. Include BadgeKeeper wherever you need it with `#import "BadgeKeeper.h"`.

### How to use

#### Setup project
```
[BadgeKeeper instance].projectId = <ProjectId from admin panel>;
```
#### Setup user
```
[BadgeKeeper instance].userId = <Your client id>;
```
#### Setup loading icons flag
```
[BadgeKeeper instance].shouldLoadIcons = YES / NO;
```

#### Subscribe to response for post and increment requests
```
[[NSNotificationCenter defaultCenter]
                            addObserver:self
                            selector:@selector(clientDidSendValues:)
                            name:kBKNotificationDidPostPreparedValues
                            object:nil];
```
or
```
[[NSNotificationCenter defaultCenter]
                            addObserver:self
                            selector:@selector(clientDidSendValues:)
                            name:kBKNotificationDidIncrementPreparedValues
                            object:nil];
```
After that you can catch notification results
```
- (void)clientDidSendValues:(NSNotification *)notification {
    NSArray *achievements = notification.userInfo[kBKNotificationKeyResponseObject];
}
```
where achievements is array of BKUnlockedUserAchievement objects.

#### Subscribe to response for getting achievements by project
```
[[NSNotificationCenter defaultCenter]
                            addObserver:self
                            selector:@selector(clientDidReceiveProjectAchievements:)
                            name:kBKNotificationDidReceiveProjectAchievements
                            object:nil];
```
and handler method
```
- (void)clientDidReceiveProjectAchievements:(NSNotification *)notification {
    NSArray *achievements = notification.userInfo[kBKNotificationKeyResponseObject];
}
```
where achievements is array of BKProjectAchievement objects.

#### Subscribe to response for getting achievements by user
```
[[NSNotificationCenter defaultCenter]
                            addObserver:self
                            selector:@selector(clientDidReceiveUserAchievements:)
                            name:kBKNotificationDidReceiveUserAchievements
                            object:nil];
```
and handler method
```
- (void)clientDidReceiveUserAchievements:(NSNotification *)notification {
    NSArray *achievements = notification.userInfo[kBKNotificationKeyResponseObject];
}
```
where achievements is array of BKUserAchievement objects.

#### Post variable
```
[[BadgeKeeper instance] preparePostValue:100 forKey:@"Variable"];
[[BadgeKeeper instance] postPreparedValues];
```
#### Increment variable
```
[[BadgeKeeper instance] prepareIncrementValue:20 forKey:@"Variable"];
[[BadgeKeeper instance] incrementPreparedValues];
```

### Error handling
To handle error response from Badge Keeper service you should use notifications.
```
[[NSNotificationCenter defaultCenter]
                            addObserver:self
                            selector:@selector(clientDidReceiveErrorProjectAchievements:)
                            name:kBKNotificationFailedReceiveProjectAchievements
                            object:nil];
```
to handle error response for getting achievements by project

```
[[NSNotificationCenter defaultCenter]
                            addObserver:self
                            selector:@selector(clientDidReceiveErrorUserAchievements:)
                            name:kBKNotificationFailedReceiveUserAchievements
                            object:nil];
```
to handle error response for getting achievements by user

```
[[NSNotificationCenter defaultCenter]
                            addObserver:self
                            selector:@selector(clientDidReceiveErrorPostPreparedValues:)
                            name:kBKNotificationFailedPostPreparedValues
                            object:nil];
```
to handle error response for posting variables

```
[[NSNotificationCenter defaultCenter]
                            addObserver:self
                            selector:@selector(clientDidReceiveErrorIncrementPreparedValues:)
                            name:kBKNotificationFailedIncrementPreparedValues
                            object:nil];
```
to handle error response for increment variables

Example how to work with error notification
```
- (void)clientDidReceiveErrorUserAchievements:(NSNotification *)notification {
    NSError *error = notification.userInfo[kBKNotificationKeyErrorObject];
    NSString *text = [NSString stringWithFormat:@"Code: %ld, Message: %@",
                      (unsigned long)error.code, error.localizedDescription];
}
```

## License

MIT. See `LICENSE` for details.
