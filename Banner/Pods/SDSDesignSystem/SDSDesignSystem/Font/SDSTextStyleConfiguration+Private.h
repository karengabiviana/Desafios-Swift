//
//  SDSTextStyleConfiguration+Private.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 01.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSTextStyleConfiguration_Private_h
#define SDSTextStyleConfiguration_Private_h

#import "SDSTextStyleConfiguration.h"

@class SDSScalableFont;

NS_ASSUME_NONNULL_BEGIN

@interface SDSTextStyleConfiguration ()

/**
 *   The baseFont as described in a stylesheet. Clients should use
 *   scaledFont.
 */
@property (nonatomic) SDSScalableFont *baseFont;

#if TARGET_OS_IOS

/**
 *   Setting this property overrides the system's preferred content size category.
 *
 *   Default is the system's preferred content size category. Setting it does not
 *   trigger any notification: You either post the notification on behalf of the
 *   app delegate or manually reload views with fonts.
 */
@property (class, nonatomic) UIContentSizeCategory contentSizeCategory;

#endif /* TARGET_OS_IOS */

@end

NS_ASSUME_NONNULL_END

#endif
