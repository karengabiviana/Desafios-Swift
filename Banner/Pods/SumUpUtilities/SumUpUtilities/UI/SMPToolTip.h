//
//  SMPToolTip.h
//  SumUpUtilities
//
//  Created by Andras Kadar on 2/15/22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

/*! @class SMPToolTip
 @abstract Provides UI elements to display a tooltip. */
@interface SMPToolTip : UIView {
    UIImageView *topImageView;
    UIImageView *bottomImageView;
}
@property (readonly) UIImageView *topImageView;
@property (readonly) UIImageView *bottomImageView;

+ (void)setDisplayDuration:(CGFloat)duration;
+ (void)setFadeInDuration:(CGFloat)duration;
+ (void)setFadeOutDuration:(CGFloat)duration;

+ (BOOL)showInView:(UIView*)v withImage:(UIImage *)image;
+ (BOOL)showInView:(UIView*)v topImage:(UIImage*)topImage bottomImage:(UIImage*)bottomImage forKey:(NSString*)key maxShows:(int)max;
+ (BOOL)showInView:(UIView*)v topImage:(UIImage*)topImage bottomImage:(UIImage*)bottomImage forKey:(NSString*)key;
+ (BOOL)showInView:(UIView*)v topImage:(UIImage*)topImage bottomImage:(UIImage*)bottomImage forKey:(NSString*)key maxShows:(int)maxDisplay onlyOncePerAppStart:(BOOL)onlyOncePerStart;


+ (void)resetRuntimeCounter;

+ (void)hideCurrentToolTip;

- (void)hide;
@end

