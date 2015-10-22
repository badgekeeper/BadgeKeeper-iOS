//
//  BKAchievementViewController.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "BKAchievementViewController.h"
#import "BadgeKeeper.h"

@interface BKAchievementViewController () {
    
}

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UIButton    *postVariablesButton;
@property (weak, nonatomic) IBOutlet UIButton    *incrementVariablesButton;
@property (weak, nonatomic) IBOutlet UIButton    *getUserAchievementsButton;
@property (weak, nonatomic) IBOutlet UIButton    *getProjectAchievementsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UITextView *responseTextView;

#pragma mark - Actions
- (IBAction)postButtonClick:(UIButton *)sender;
- (IBAction)incrementButtonClick:(UIButton *)sender;

#pragma mark - Utils
- (void)setLoading:(BOOL)isLoading;

@end


@implementation BKAchievementViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BadgeKeeper Sample";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Actions

- (IBAction)postButtonClick:(UIButton *)sender {
    if ([self isLoginValid]) {
        [self setLoading:YES];
        [self.responseTextView setText:@""];
        
        static NSInteger posts = 0;
        posts++;
        
        [BadgeKeeper instance].userId = self.loginTextField.text;
        [[BadgeKeeper instance] preparePostValue:posts forKey:@"x"];
        
        BKFailureResponseCallback failure = ^(int code, NSString *message) {
            [self didReceiveErrorWithCode:code andMessage:message];
        };
        
        BKAchievementsUnlockedCallback success = ^(NSArray *achievements) {
            [self didReceiveSuccessUnlockedAchievements:achievements];
        };
        
        [[BadgeKeeper instance] postPreparedValuesWithSuccess:success
                                                  withFailure:failure];
    }
}

- (IBAction)incrementButtonClick:(UIButton *)sender {
    if ([self isLoginValid]) {
        [self setLoading:YES];
        [self.responseTextView setText:@""];

        static NSInteger increments = 0;
        increments++;
        
        BKFailureResponseCallback failure = ^(int code, NSString *message) {
            [self didReceiveErrorWithCode:code andMessage:message];
        };
        
        BKAchievementsUnlockedCallback success = ^(NSArray *achievements) {
            [self didReceiveSuccessUnlockedAchievements:achievements];
        };
        
        [BadgeKeeper instance].userId = self.loginTextField.text;
        [[BadgeKeeper instance] prepareIncrementValue:increments forKey:@"x"];
        [[BadgeKeeper instance] incrementPreparedValuesWithSuccess:success
                                                       withFailure:failure];
    }
}

- (IBAction)getUserAchievementsClick:(UIButton *)sender {
    if ([self isLoginValid]) {
        [self setLoading:YES];
        [self.responseTextView setText:@""];
        
        BKFailureResponseCallback failure = ^(int code, NSString *message) {
            [self didReceiveErrorWithCode:code andMessage:message];
        };
        
        BKUserAchievementsResponseCallback success = ^(NSArray *achievements) {
            [self didReceiveSuccessUserAchievements:achievements];
        };
        
        [BadgeKeeper instance].userId = self.loginTextField.text;
        [[BadgeKeeper instance] getUserAchievementsWithSuccess:success withFailure:failure];
    }
}

- (IBAction)getProjectAchievementsClick:(UIButton *)sender {

    [self setLoading:YES];
    [self.responseTextView setText:@""];
        
    BKFailureResponseCallback failure = ^(int code, NSString *message) {
        [self didReceiveErrorWithCode:code andMessage:message];
    };
        
    BKAchievementsResponseCallback success = ^(NSArray *achievements) {
        [self didReceiveSuccessProjectAchievements:achievements];
    };
        
    [[BadgeKeeper instance] getProjectAchievementsWithSuccess:success withFailure:failure];
}

- (BOOL)isLoginValid {
    NSString *login = self.loginTextField.text;
    if (login.length == 0) {
        [self showAlertWithMessage:@"You should specify your User ID first!"];
        return NO;
    }
    
    return YES;
}


#pragma mark - Utils

- (void)setLoading:(BOOL)isLoading {
    if (isLoading) {
        self.loginTextField.enabled = NO;
        self.postVariablesButton.enabled = NO;
        self.incrementVariablesButton.enabled = NO;
        self.getProjectAchievementsButton.enabled = NO;
        self.getUserAchievementsButton.enabled = NO;
        [self.activityIndicatorView startAnimating];
    }
    else {
        self.loginTextField.enabled = YES;
        self.postVariablesButton.enabled = YES;
        self.incrementVariablesButton.enabled = YES;
        self.getProjectAchievementsButton.enabled = YES;
        self.getUserAchievementsButton.enabled = YES;
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)didReceiveSuccessProjectAchievements:(NSArray *)achievements {
    NSString *text = [NSString stringWithFormat:@"Achievements: ["];
    
    for (BKAchievement *achievement in achievements) {
        NSString *atext = [NSString stringWithFormat:@"{ \"Title\": \"%@\", \"Description\": \"%@\" }", achievement.displayName, achievement.desc];
        
        if ([achievements lastObject] != achievement) {
            atext = [atext stringByAppendingString:@", "];
        }
        text = [text stringByAppendingString:atext];
    }
    text = [text stringByAppendingString:@"]"];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.responseTextView setText:text];
        [self setLoading:NO];
    });
}

- (void)didReceiveSuccessUserAchievements:(NSArray *)achievements {
    NSString *text = [NSString stringWithFormat:@"Achievements: ["];
    
    for (BKUserAchievement *achievement in achievements) {
        NSString *atext = [NSString stringWithFormat:@"{ \"Title\": \"%@\", \"Description\": \"%@\", \"IsUnlocked\":\"%@\" }", achievement.displayName, achievement.desc, (achievement.isUnlocked ? @"YES" : @"NO")];
        
        if ([achievements lastObject] != achievement) {
            atext = [atext stringByAppendingString:@", "];
        }
        text = [text stringByAppendingString:atext];
    }
    text = [text stringByAppendingString:@"]"];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.responseTextView setText:text];
        [self setLoading:NO];
    });
}

- (void)didReceiveSuccessUnlockedAchievements:(NSArray *)achievements {
    NSString *text = [NSString stringWithFormat:@"Achievements: ["];
    
    for (BKUnlockedAchievement *achievement in achievements) {
        NSString *atext = [NSString stringWithFormat:@"{ \"Title\": \"%@\", \"Description\": \"%@\", \"IsUnlocked\":\"%@\", \"Rewards\": [", achievement.displayName, achievement.desc, (achievement.isUnlocked ? @"YES" : @"NO")];
        
        for (BKReward *reward in achievement.rewards) {
            NSString *rtext = [NSString stringWithFormat:@"{ \"Name\": \"%@\", \"Value\": %f }", reward.name, reward.value];
            if ([achievement.rewards lastObject] != reward) {
                rtext = [rtext stringByAppendingString:@", "];
            }
            atext = [atext stringByAppendingString:rtext];
        }
        atext = [atext stringByAppendingString:@"] }"];
        
        if ([achievements lastObject] != achievement) {
            atext = [atext stringByAppendingString:@", "];
        }
        text = [text stringByAppendingString:atext];
    }
    text = [text stringByAppendingString:@"]"];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.responseTextView setText:text];
        [self setLoading:NO];
    });
}

- (void)didReceiveErrorWithCode:(int)code andMessage:(NSString *)message {
    NSString *text = [NSString stringWithFormat:@"Error: [\"Code\": %ld, \"Message\": \"%@\"", (unsigned long)code, message];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.responseTextView setText:text];
        [self setLoading:NO];
    });
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
