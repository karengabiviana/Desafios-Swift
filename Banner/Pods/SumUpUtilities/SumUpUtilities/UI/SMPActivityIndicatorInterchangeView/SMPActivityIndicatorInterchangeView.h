//
//  SMPActivityIndicatorInterchangeView.h
//
//  Created by Florian Schliep on 01.10.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  An enum describing how the content in the view should be laid out
 */
NS_SWIFT_NAME(ActivityIndicatorInterchangeViewContentMode)
typedef NS_ENUM(NSUInteger, SMPActivityIndicatorInterchangeViewContentMode) {
    /// Centers the content view in the activity view while maintaining its original size
    SMPActivityIndicatorInterchangeViewContentModeCenter,
    /// Scales the content view to fill the activity view
    SMPActivityIndicatorInterchangeViewContentModeFill
};

/**
 *  A wrapper view that can interchange its content view with an activity indicator.
 */
NS_SWIFT_NAME(ActivityIndicatorInterchangeView)
@interface SMPActivityIndicatorInterchangeView<__covariant ContentType: UIView *> : UIView

@property (nullable, nonatomic) ContentType contentView;
/**
 *  Content layout mode of the content view. Defaults to
 *  SMPActivityIndicatorInterchangeViewContentModeCenter.
 */
@property (nonatomic) SMPActivityIndicatorInterchangeViewContentMode contentMode;

/**
 *  Color of the activity indicator.
 */
@property (nullable, nonatomic) UIColor *activityIndicatorColor;

- (instancetype)initWithContentView:(nullable ContentType)contentView NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

/**
 *  Hides the content view and start loading.
 *  Does nothing if loading already started.
 */
- (void)startLoading;

/**
 *  Shows the content view and stops loading.
 *  Does nothing if loading hasn't been started already.
 */
- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
