//
//  CUISingleLineTextFieldAccessoryConfiguration.h
//  CircuitUI
//
//  Created by Marcel Voß on 17.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_CLOSED_ENUM(NSInteger, CUISingleLineTextFieldAccessoryPosition) {
    CUISingleLineTextFieldAccessoryPositionLeading,
    CUISingleLineTextFieldAccessoryPositionTrailing
} NS_SWIFT_NAME(SingleLineTextFieldAccessoryPosition);

/// An object that is used to configure a text field's accessory, as well as its position within the text field.
NS_SWIFT_NAME(SingleLineTextFieldAccessoryConfiguration)
@interface CUISingleLineTextFieldAccessoryConfiguration: NSObject

@property (nonatomic, readonly) UIView *accessoryView;

/// Defines whether the accessory respects semantic content directions. The default is YES.
/// @Note When this property is set to NO, the `position` can be interpreted as left and right rather than leading and trailing.
@property (nonatomic, readonly) BOOL respectSemanticContentDirection;

/// Defines how the accessory should be placed inside the text field.
/// @Note The effect of this property depends on `respectSemanticContentDirection`. Please refer to its documentation too.
@property (nonatomic, readonly) CUISingleLineTextFieldAccessoryPosition position;

- (instancetype)initWithAccessoryView:(UIView *)accessoryView position:(CUISingleLineTextFieldAccessoryPosition)position;
- (instancetype)initWithAccessoryView:(UIView *)accessoryView position:(CUISingleLineTextFieldAccessoryPosition)position respectSemanticContentDirection:(BOOL)respectSemanticContentDirection NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToAccessoryConfiguration:(CUISingleLineTextFieldAccessoryConfiguration *)accessoryConfiguration;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
