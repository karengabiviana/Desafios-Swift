//
//  SDSStatefulColor.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 08.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSStatefulColor_h
#define SDSStatefulColor_h

#import "SDSStatefulObject.h"
#import "SDSDesignPlatform.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(StatefulColorUsage)
typedef NSString *SDSStatefulColorUsage NS_STRING_ENUM;

/// Usage to describe the foreground color (usually the text color).
extern SDSStatefulColorUsage const SDSStatefulColorUsageForeground;
/// Usage to describe the background color (usually a UIView's backgroundColor).
extern SDSStatefulColorUsage const SDSStatefulColorUsageBackground;
/// Usage to describe the border color (usually applied to a CALayer borderColor).
extern SDSStatefulColorUsage const SDSStatefulColorUsageBorder;
/// Usage to describe the color of a tinted image
/// (useful e.g. to provide an color for images that differs from the foreground color).
extern SDSStatefulColorUsage const SDSStatefulColorUsageImage;
/// Usage to describe the tint color (usually a UIView's tintColor).
extern SDSStatefulColorUsage const SDSStatefulColorUsageTint;

/**
 *   Class providing multiple colors for different control states
 *   (normal, highlighted, disabled).
 */
NS_SWIFT_NAME(StatefulColor)
@interface SDSStatefulColor : SDSStatefulObject<__Color *>
/// Usage can be used to identify where a stateful color should be used when provided through a SDSStatefulColorSet.
@property (nonatomic, readonly, nullable) SDSStatefulColorUsage usage;

#if TARGET_OS_IOS
/**
 *   Retrieve the appropriate value for the given control state and attempts to invert it
 *   if explicit values were provided to allow inversion.
 *
 *   @param controlState The control state for which a value should be provided.
 *   @param inverted If YES the inverted color will be returned.
 *   @return The value associated with the given control state.
 */
- (UIColor *)valueForState:(UIControlState)controlState inverted:(BOOL)inverted;
#endif

@end

/**
 *   Color sets desribe multiple `SDSStatefulColor` for different usages (such as background or foreground).
 *   Each `SDSStatefulColor` provides colors for different UIControlStates
 *   (such as normal, highlighted, and disabled).
 */
NS_SWIFT_NAME(StatefulColorSet)
@interface SDSStatefulColorSet : NSObject
@property (nonatomic, readonly) NSArray<SDSStatefulColor *> *colors;
@property (nonatomic, readonly) NSString *documentation;

/**
 *   @param usage The usage key to look up.
 *   @return A color set applicable to the provided usage or the first one if non match.
 */
- (SDSStatefulColor *)colorForUsage:(SDSStatefulColorUsage)usage NS_SWIFT_NAME(color(for:));

/**
 *   @param usage The usage key to look up.
 *   @return A color set applicable to the provided usage or nil if non match.
 */
- (nullable SDSStatefulColor *)strictColorForUsage:(SDSStatefulColorUsage)usage NS_SWIFT_NAME(strictColor(for:));

@end

NS_ASSUME_NONNULL_END

#endif
