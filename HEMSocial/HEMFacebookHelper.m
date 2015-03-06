//
//  HEMFacebookHelper.m
//  HEMSocial
//
//  Created by Marcilio Junior on 3/2/15.
//  Copyright (c) 2015 HE:mobile. All rights reserved.
//

#import "HEMFacebookHelper.h"

NSString * const HEMFacebookHelperKeyEmail          = @"email";
NSString * const HEMFacebookHelperKeyFirstName      = @"first_name";
NSString * const HEMFacebookHelperKeyGender         = @"gender";
NSString * const HEMFacebookHelperKeyId             = @"id";
NSString * const HEMFacebookHelperKeyLastName       = @"last_name";
NSString * const HEMFacebookHelperKeyLink           = @"link";
NSString * const HEMFacebookHelperKeyLocale         = @"locale";
NSString * const HEMFacebookHelperKeyName           = @"name";
NSString * const HEMFacebookHelperKeyTimezone       = @"timezone";
NSString * const HEMFacebookHelperKeyUpdatedTime    = @"updated_time";
NSString * const HEMFacebookHelperKeyVerified       = @"verified";

@interface HEMFacebookHelper ()

@property (nonatomic) NSArray *permissions;

@end

@implementation HEMFacebookHelper

+ (instancetype)sharedInstance
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

+ (void)initWithPermissions:(NSArray *)permissions
{
    [HEMFacebookHelper sharedInstance].permissions = permissions;
}

- (BOOL)isSessionOpen
{
    if (!FBSession.activeSession.isOpen) {
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                FBSession.activeSession = session;
            }];
        }
    }
    
    return FBSession.activeSession.isOpen;
}

- (void)closeSession:(HEMFacebookHelperSessionCloseBlockDef)completion
{
    if (FBSession.activeSession.isOpen) {
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession setActiveSession:nil];
    }
    
    completion(YES, nil);
}

- (void)openSession:(HEMFacebookHelperSessionOpenBlockDef)completion
{
    [FBSession openActiveSessionWithReadPermissions:self.permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        
        if (state == FBSessionStateOpen) {
            completion(!error, error);
        }
        else if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
            completion(NO, error);
        }
        
    }];
}

- (void)fetchMeWithPictureFromGraphAPI:(HEMFacebookHelperMeWithPictureGraphAPIBlockDef)completion
{
    if (![self isSessionOpen]) {
        NSError *error = [NSError errorWithDomain:@"br.com.hemobile.facebookhelper.error.session" code:-1 userInfo:@{(NSString *)kCFErrorDescriptionKey: @"Session closed"}];
        completion(nil, nil, error);
        
        return;
    }
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, FBGraphObject *result, NSError *error) {
        
        if (!error) {
            NSDictionary *params = @{@"redirect": @"false", @"height": @"200", @"width": @"200", @"type": @"normal"};
            [FBRequestConnection startWithGraphPath:@"/me/picture" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id picureResult, NSError *pictureError) {
                
                completion(result, picureResult[@"data"][@"url"], error);
                
            }];
        }
        else {
            // TODO:
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
            
            completion(nil, nil, error);
        }
        
    }];
}





// Handle errors
//- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
//{
//    // If the session was opened successfully
//    if (!error && state == FBSessionStateOpen) {
//        // Show the user the logged-in UI
//        if (self.sessionOpenHandler) {
//            self.sessionOpenHandler(YES, error);
//        }
//        
//        return;
//    }
//    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
//        // Show the user the logged-out UI
//        if (self.sessionCloseHandler) {
//            self.sessionCloseHandler(NO, error);
//        }
//    }
//    
//    // Handle errors
//    if (error) {
//        NSLog(@"Error");
//        NSString *alertText;
//        NSString *alertTitle;
//        
//        // If the error requires people using an app to make an action outside of the app in order to recover
//        if ([FBErrorUtility shouldNotifyUserForError:error] == YES) {
//            alertTitle = @"Something went wrong";
//            alertText = [FBErrorUtility userMessageForError:error];
//        }
//        else {
//            
//            // If the user cancelled login, do nothing
//            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
//                NSLog(@"User cancelled login");
//                
//                // Handle session closures that happen outside of the app
//            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
//                alertTitle = @"Session Error";
//                alertText = @"Your current session is no longer valid. Please log in again.";
//                
//                // Here we will handle all other errors with a generic error message.
//                // We recommend you check our Handling Errors guide for more information
//                // https://developers.facebook.com/docs/ios/errors/
//            }
//            else {
//                //Get more error information from the error
//                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
//                
//                // Show the user an error message
//                alertTitle = @"Something went wrong";
//                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
//            }
//        }
//        // Clear this token
//        [FBSession.activeSession closeAndClearTokenInformation];
//        
//        // Show the user the logged-out UI
//    }
//}

@end
