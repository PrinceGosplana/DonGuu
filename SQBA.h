//
//  SQBA.h
//  SQBA
//
//  Created by x2 on 8/24/13.
//  Copyright 2013 5craft. All rights reserved.
//
//  version 0.3.2

/*
 * Those frameworks have to be linked to your application binary for SQBA to work properly.
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <zlib.h>
#import <Security/Security.h>


@interface SQBA : NSObject

/*!
 *  @brief Starts a SQBA session for the project with developer's @c apiKey.
 *
 *  This method serves as the entry point to SQBA. It must be called in the scope 
 *  of @c applicationDidFinishLaunching before any other SQBA invocations.
 *
 * @code
 *  - (void)applicationDidFinishLaunching:(UIApplication *)application
 {
     [SQBA startWithApiKey:@"YOUR_API_KEY_HERE"];
 // ....
 }
 * @endcode
 *
 * @param apiKey The API key for this developer.
 */

+ (void)startWithApiKey:(NSString *)apiKey;


/*!
 *  @brief Processes URLs passed to applications.
 *
 *  This method processes app URLs for internal SQBA data. It must be called in the scope
 *  of @c application:openUrl or @c application:handleOpenURL (deprecated) to enable 
 *  SQBA-Testers functionality.
 *
 * @code
 *  - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
     [SQBA processOpenURL:url];
     return YES;
 }
 * @endcode
 *
 * @param url URL passed to application:openURL: method
 */

+ (void)processOpenURL:(NSURL *)url;//required for testers' interface

@end



@interface SQBA(Files)

/*!
 *  @brief Returns path to SQBA-versioned resource or nil if not found.
 *
 *  This method will return full path to SQBA-versioned file for current version and user group.
 *  Will return nil if the group file is not exists or was not downloaded yet.
 *
 * @code
 *  - (void)updateGiftCardImage
 {
     NSString * imagePath = [SQBA pathToResourceNamed:@"giftCard-1.png"];
     if (imagePath) self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
 }
 * @endcode
 *
 * @param filename name of SQBA-versioned resource file.
 *
 * @return full path to SQBA-versioned resource or @c nil if resource was not found.
 */

+ (NSString *)pathToResourceNamed:(NSString *)filename;


/*!
 *  @brief Returns path to SQBA-versioned resource. Tries to find it in app bundle if not found. If still not found returns nil.
 *
 *  This method will return full path to SQBA-versioned file for current version and user group.
 *  If the group file is not exists or was not downloaded yet SQBA will try to find it in bundle resources
 *  and return path to file in app bundle if found. Otherwise will return nil.
 *
 * @code
 *  - (void)updateGiftCardImage
 {
     NSString * imagePath = [SQBA pathToBundledResourceNamed:@"giftCard-2.png"];
     if (imagePath) self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
 }
 * @endcode
 *
 * @param filename name of SQBA-versioned resource file.
 *
 * @return full path to SQBA-versioned resource. Full path to resource in app bundle if not found. Or @c nil if resource was not found in app bundle.
 */

+ (NSString *)pathToBundledResourceNamed:(NSString *)filename;


/*!
 *  @brief Returns path to SQBA-versioned resource. Tries to find it in app bundle if not found. If still not found returns nil.
 *
 *  This method will return full path to SQBA-versioned file for current version and user group.
 *  Will return @c placeholder if the group file is not exists or was not downloaded yet.
 *
 * @code
 *  - (void)updateGiftCardImage
 {
     NSString * placeholderPath = [NSBundle.mainBundle pathForResource:@"placeholder" ofType:@"png"];
     NSString * imagePath = [SQBA pathToResourceNamed:@"giftCard-3.png" placeholder:placeholderPath];
     self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
 }
 * @endcode
 *
 * @param filename name of SQBA-versioned resource file.
 *
 * @return full path to SQBA-versioned resource. or @c placeholder if resource was not found.
 */

+ (NSString *)pathToResourceNamed:(NSString *)filename placeholder:(NSString *)placeholder;

@end




@interface SQBA(Events)

/*!
 *  @brief Saves successfull in-app purchase.
 *
 *  This method saves successfull in-app purchases. It have to be called on successfully processed
 *  in-app purchases to enable main SQBA functionality.
 *
 * @code
 *  - (void)inAppProcessedSuccessfully:(NSDictionary *)inAppInfo
 {
     CGFloat usdEquivalent = [inAppInfo[@"usdPrice"] floatValue];
     [SQBA saveEventPaymentWithUSDAmount:usdEquivalent];
 }
 * @endcode
 *
 * @param usdAmount dollar equvalent of money spent on
 */

+ (void)saveEventInAppPurchaseWithUSDAmount:(CGFloat)usdAmount;


extern NSString * const kSQBASocialNetworkFacebook;
extern NSString * const kSQBASocialNetworkGameCenter;
extern NSString * const kSQBASocialNetworkTwitter;
extern NSString * const kSQBASocialNetworkVK;

/*!
 *  @brief Saves login event for social networks.
 *
 *  This method saves successfull login event for social networks. It have to be called on successfull social
 *  network login to enable main SQBA functionality.
 *
 *  @note Please use supplied constants for social networks. If you can't find a network among constants feel free to use own network specifier.
 *
 * @code
 *  - (void)facebookDidLogin:(NSString *)facebookId
 {
     [SQBA saveEventSocialConnectToNetwork:kSQBASocialNetworkFacebook withSocialId:facebookId];
 }
 * @endcode
 *
 * @param socialNetwork social network that logged the user in.
 * @param socialId (optional) user identifier in social network
 */

+ (void)saveEventSocialConnectToNetwork:(NSString *)socialNetwork withSocialId:(NSString *)socialId;


/*!
 *  @brief Saves successfull post event for social networks.
 *
 *  This method saves successfull post (like posting on the wall, posting to photo album or other social activity) 
 *  event for social networks. It have to be called on successfull post to enable main SQBA functionality.
 *
 *  @note Please use supplied constants for social networks. If you can't find a network among constants feel free to use own network specifier.
 *
 * @code
 *  - (void)facebookDidPosted:(NSString *)postId
 {
     [SQBA saveEventSocialPostToNetwork:kSQBASocialNetworkFacebook withPostId:postId];
 }
 * @endcode
 *
 * @param socialNetwork social network that logged the user in.
 * @param postId (optional) created post identifier in social network
 */

+ (void)saveEventSocialPostToNetwork:(NSString *)socialNetwork withPostId:(NSString *)postId;


/*!
 *  @brief Saves custom app states or statistics.
 *
 *  This method saves custom app data to use it in user group filters. Those parameters can
 *  be one of two types:
 *   - NSNumber * - those will be treated as integers.
 *   - NSString * - thise will be treated as strings.
 *
 * @code
 *  - (void)buyNextShip //saving current user ships on purchasing new one
 {
    Ship * newShip = ...;//purchase process
    
    if (newShip) [SQBA saveEventAppSpecificWithDictionary:@{ @"ship": newShip.caption }];
 }
 * @endcode
 *
 * @param socialNetwork social network that logged the user in.
 * @param postId (optional) created post identifier in social network
 */

+ (void)saveEventAppSpecificWithDictionary:(NSDictionary *)eventInfo;

@end




@interface SQBA(Codes)

/*!
 *  @brief Generates a new code with @c dictionary linked to the code.
 *
 *  This will create a unique code for user with linked NSDictionary @c codeDictionary. Block
 *  @c onSuccess will be executed when code creation completes. Generated code can be used
 *  only one time by each App user. Passing @c NO as @c multiuser makes code available only
 *  to first redeemer.
 *
 *  @note Code creator cannot use own codes.
 *
 * @code
 *  - (IBAction)doGenerateCode:(id)sender
 {
     [SQBA createCodeForDictionary:@{ @"money": @(1000) } multiuser:YES onSuccess:^(NSString * code) {
         self.codeLabel.text = code;
     } onError: ^(NSError * error) {
         NSLog(@"Error generating code: %@", error);
     }];
 }
 * @endcode
 *
 * @param codeDictionary An @c NSDictionary object that will be linked to generated code.
 * @param multiuser If @c YES is passed here than the code can be used one time by multiple users. Otherwise only the first user will be able to use generated code.
 * @param onSuccess This block will be called if the code generates successfully. Generated code will be passed as @c code
 * @param onError This block will be called if something went wrong during the code generation. Error reason will be passed as @c error.
 */

+ (void)createCodeForDictionary:(NSDictionary *)codeDictionary multiuser:(BOOL)multiuser onSuccess:(void (^)(NSString * code))onSuccess onError:(void (^)(NSError * error))onError;


/*!
 *  @brief Redeems an existing code.
 *
 *  This will try to redeem a code created by another user (or developer). Block @c onSuccess 
 *  will be executed on successfull redemption passing %c codeDictionary used during code
 *  creation. Otherwise @c onError block will be called.
 *
 *  @note Code creator cannot use own codes.
 *
 * @code
 *  - (IBAction)doRedeemCode:(id)sender
 {
     NSString * code = self.codeTextField.text;
 
     [SQBA redeemCode:code onSuccess:^(NSDictionary * codeDictionary) {
         int money = [codeDictionary[@"money"] intValue];
         [[ShopManager sharedInstance] giveMoney:money];
     } onError: ^(NSError * error) {
         NSLog(@"Error redeeming code: %@", error);
     }];
 }
 * @endcode
 *
 * @param code Code generated by another user (or developer).
 * @param onSuccess This block will be called if the code redeems successfully. %c NSDictionary used in code generation will be passed here as @c codeDictionary.
 * @param onError This block will be called if something went wrong during code redemption. Error reason will be passed as @c error.
 */

+ (void)redeemCode:(NSString *)code onSuccess:(void (^)(NSDictionary * codeDictionary))onSuccess onError:(void (^)(NSError * error))onError;

@end




@interface SQBA(Pushes)

/*!
 *  @brief Saves token for remote push-notifications.
 *
 *  This will save push token. This method must be called to enable SQBA-Pushes functionality.
 *  It is better call this method from %c application:didRegisterForRemoteNotificationsWithDeviceToken: .
 *
 * @code
 *  - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
 {
     [SQBA setPushToken:deviceToken];
 }
 * @endcode
 *
 * @param token Received @c deviceToken for remote push-notifications.
 */

+ (void)setPushToken:(NSData *)token;


/*!
 *  @brief Processes received push-notification.
 *
 *  This will process received push-notification for internal SQBA data. This method must be called 
 *  to enable SQBA-Pushes functionality.
 *  It is better call this method from %c application:didReceiveRemoteNotification: .
 *
 * @code
 *  - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
 {
     [SQBA processRemoteNotification:userInfo];
 }
 * @endcode
 *
 * @param notificationUserInfo Received @c userInfo from push-notification.
 */

+ (void)processRemoteNotification:(NSDictionary *)notificationUserInfo;

@end

