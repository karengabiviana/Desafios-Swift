//
//  ISHDevice.h
//
//  Created by Hagi on 04/03/15.
//  Copyright (c) 2015 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPDevice: UIDevice

/**
 *   The summary can be appended to support emails from customers and
 *   is localized.
 *
 *   @note The summary requires you to bundle localized strings for
 *   the following keys:
 *
 *   sumup_support_email_title_locale
 *   sumup_support_email_title_device
 *   sumup_support_email_title_system
 *   sumup_support_email_title_disk_space
 */
+ (nonnull NSString *)supportSummary NS_REQUIRES_SUPER;

/**
 *   Formatted and localized description of the used/free disk space.
 */
+ (nonnull NSString *)diskSpaceStatus;

@end
