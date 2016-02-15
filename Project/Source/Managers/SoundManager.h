//
//  SoundManager.h
//  AKSound
//
//  Created by Andrii Kurshyn on 1/17/16.
//  Copyright © 2016 Andrii Kurshyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
Constant used by NSError to differentiate between "domains" of error codes, serving as a
discriminator for error codes that originate SoundManager.
*/
FOUNDATION_EXPORT NSString* const kSoundManagerErrorDomain;

/**
 SoundManager-related Error Codes
 Constants used by NSError to indicate errors in the SoundManager domain.
 */
typedef NS_ENUM (NSInteger, SMError)
{
    kSMError_Unknown = -1,
    
    // File System
    kSMError_NoSuchFile = 10,
};


@interface SoundManager : NSObject

/**
 Use this method to obtain the shared instance of this class.  There should only be one instance of this class.
 */
+ (SoundManager *) sharedInstance;

/**
 Immediately play system sound clip by path
 
 @param path The string path to file.
 @param completion The completion block that will be called when completed ply, succes or failure.
 */
- (void)playSoundByPath:(NSString *)path completion:(nullable void (^)(NSError* __nullable error))completion;

/**
 Immediately play sound clip by path and choose type sound
 
 @param path The string path to file.
 @param isSound YES if you what play audi like system sound, NO if you what play audi like system alert with vibration.
 @param completion The completion block that will be called when completed ply, succes or failure.
 */
- (void)playByPath:(NSString *)path isSound:(BOOL)isSound completion:(nullable void (^)(NSError* __nullable error))completion;

NS_ASSUME_NONNULL_END

@end
