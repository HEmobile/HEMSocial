//
//  HEMFacebookHelper.h
//  HEMSocial
//
//  Created by Marcilio Junior on 3/2/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Facebook-iOS-SDK/FacebookSDK/FacebookSDK.h>

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

typedef void(^HEMFacebookHelperSuccessBlockDef)(BOOL success, NSError* error);
typedef void(^HEMFacebookHelperMeWithPictureGraphAPIBlockDef)(NSDictionary *user, NSString *pictureURL, NSError *error);

@interface HEMFacebookHelper : NSObject

+ (instancetype)sharedInstance;

/**
 *  Define the arary with permissions used by the app.
 *
 *  @param permissions NSArray with the permissions.
 */
+ (void)initWithPermissions:(NSArray *)permissions;

/**
 *  Check if has an session opened. If the session state is FBSessionStateCreatedTokenLoaded, the active session is re-opened.
 *
 *  @return Boolean indicating if the session is opened.
 */
- (BOOL)isSessionOpen;

/**
 *  Close the active session and clear token information.
 *
 *  @param completion success: Boolean indicating if the session was closed.
 *                      error: NSError instance with any error that can occur when closing the active session.
 */
- (void)closeSession:(HEMFacebookHelperSuccessBlockDef)completion;

/**
 *  Open an session with the permissions defined on +initWithPermission: method.
 *
 *  @param completion success: Boolean indicating if the session was opened.
 *                      error: NSError instance with any error that can occur when opening an active session.
 */
- (void)openSession:(HEMFacebookHelperSuccessBlockDef)completion;

/**
 *  Fetch the information of the logged user.
 *
 *  @param completion user: User information based on the permissions defined in +initWithPermissions: method.
 *              pictureURL: URL of the user's profile photo.
 *                   error: NSError instance with any error that can occur fetching the user information.
 */
- (void)fetchMeWithPictureFromGraphAPI:(HEMFacebookHelperMeWithPictureGraphAPIBlockDef)completion;

@end
