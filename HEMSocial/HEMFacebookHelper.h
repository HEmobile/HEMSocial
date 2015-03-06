//
//  HEMFacebookHelper.h
//  HEMSocial
//
//  Created by Marcilio Junior on 3/2/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyEmail;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyFirstName;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyGender;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyId;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyLastName;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyLink;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyLocale;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyName;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyTimezone;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyUpdatedTime;
FOUNDATION_EXPORT NSString * const HEMFacebookHelperKeyVerified;

typedef void(^HEMFacebookHelperSessionOpenBlockDef)(BOOL isSessionOpened, NSError* error);
typedef void(^HEMFacebookHelperSessionCloseBlockDef)(BOOL isSessionClosed, NSError* error);
typedef void(^HEMFacebookHelperMeWithPictureGraphAPIBlockDef)(NSDictionary *user, NSString *pictureURL, NSError *error);

@interface HEMFacebookHelper : NSObject

+ (instancetype)sharedInstance;
+ (void)initWithPermissions:(NSArray *)permissions;

- (BOOL)isSessionOpen;
- (void)closeSession:(HEMFacebookHelperSessionCloseBlockDef)completion;
- (void)openSession:(HEMFacebookHelperSessionOpenBlockDef)completion;
- (void)fetchMeWithPictureFromGraphAPI:(HEMFacebookHelperMeWithPictureGraphAPIBlockDef)completion;

@end
