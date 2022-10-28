//
//  CUISemanticColor.h
//  CircuitUI
//
//  Created by Florian Schliep on 20.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

@import UIKit.UIColor;

NS_ASSUME_NONNULL_BEGIN

/**
 * This class is not meant to be instantiated. Instead, it provides a namespace to access semantically named UIColor objects using class properties.
 */
NS_SWIFT_NAME(SemanticColor)
@interface CUISemanticColor : NSObject

@property (nonatomic, readonly, class) UIColor *tintColor NS_SWIFT_NAME(tint);
@property (nonatomic, readonly, class) UIColor *bodyColor NS_SWIFT_NAME(body);
@property (nonatomic, readonly, class) UIColor *confirmColor NS_SWIFT_NAME(confirm);
@property (nonatomic, readonly, class) UIColor *notifyColor NS_SWIFT_NAME(notify);
@property (nonatomic, readonly, class) UIColor *alertColor NS_SWIFT_NAME(alert);
@property (nonatomic, readonly, class) UIColor *backgroundColor NS_SWIFT_NAME(background);
@property (nonatomic, readonly, class) UIColor *overlayColor NS_SWIFT_NAME(overlay);

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
