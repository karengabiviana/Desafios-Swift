//
//  UIView+NibLoading.h
//  SumUpUtilities
//
//  Created by Felix Lamouroux on 27.02.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (NibLoading)
+ (nullable instancetype)viewFromNibNamed:(NSString*)nibName;
+ (nullable instancetype)viewFromNibNamed:(NSString*)nibName fromBundle:(nullable NSBundle *)bundle;

/// Convenience property to retrieve the nib name for classes that have an xib file of the same name.
@property (class, readonly) NSString *smp_nibName NS_SWIFT_NAME(nibName);

/// Convenience method to load view from an xib file of the same name.
+ (nullable instancetype)smp_viewFromNib NS_SWIFT_NAME(viewFromNib());
@end

NS_ASSUME_NONNULL_END
