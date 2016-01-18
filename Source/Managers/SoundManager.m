//
//  SoundManager.m
//  AKSound
//
//  Created by Andrii Kurshyn on 1/17/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

#import "SoundManager.h"
#include <AudioToolbox/AudioToolbox.h>

#define BLOCK_IF_EXISTS(completion, error) { if (completion != nil) completion(error); }

NSString* const kSoundManagerErrorDomain = @"SoundManagerErrorDomain";

@implementation SoundManager

#pragma mark - Life Cycle

+ (SoundManager *)sharedInstance {
    static SoundManager* sharedSoundManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
            sharedSoundManager = [SoundManager new];
    });
    return sharedSoundManager;
}

#pragma mark - Public Methods

- (void)playSoundByPath:(NSString *)path completion:(void (^)(NSError* error))completion {
    [self playByPath:path isSound:YES completion:completion];
}

- (void)playByPath:(NSString *)path isSound:(BOOL)isSound completion:(void (^)(NSError* error))completion {
    [self playByURL:[[NSURL alloc] initFileURLWithPath:path] isSound:isSound completion:completion];
}

#pragma mark - Private Methods

- (void)playByURL:(NSURL *)URLSound isSound:(BOOL)isSound completion:(void (^)(NSError* error))completion {
    OSStatus status;
    SystemSoundID soundID = [self createSoundIDByURL:URLSound status:&status];
    
    if (status != 0) {
        [self disposeSystemSoundID:soundID];
        dispatch_async(dispatch_get_main_queue(), ^{
            BLOCK_IF_EXISTS(completion, [self createErrorWithCode:kSMError_NoSuchFile])
        });
        return;
    }
    
    [self playSoundID:soundID isSound:isSound completion:^{
        [self disposeSystemSoundID:soundID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BLOCK_IF_EXISTS(completion, nil)
        });
    }];
}

- (SystemSoundID)createSoundIDByURL:(NSURL *)URL status:(OSStatus *)status {
    SystemSoundID soundID;
    OSStatus stat = AudioServicesCreateSystemSoundID((__bridge CFURLRef) URL, &soundID);
    if (status != NULL) {
        *status = stat;
    }
    return soundID;
}

- (void)disposeSystemSoundID:(SystemSoundID)soundID {
    AudioServicesDisposeSystemSoundID(soundID);
}

- (void)playSoundID:(SystemSoundID)soundID isSound:(BOOL)isSound completion:(void (^)())completion {
    
    if (isSound == YES) {
        AudioServicesPlaySystemSoundWithCompletion(soundID, completion);
    } else {
        AudioServicesPlayAlertSoundWithCompletion(soundID, completion);
    }
}

- (NSError *)createErrorWithCode:(SMError)code {

    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];

    switch (code) {
        case kSMError_NoSuchFile:
            userInfo[NSLocalizedDescriptionKey] = @"File don't found.";
            break;
        default:
            userInfo[NSLocalizedDescriptionKey] = @"Unknow error";
            break;
    }
    
    return [NSError errorWithDomain:kSoundManagerErrorDomain
                               code:code
                           userInfo:userInfo];
}


@end
