//
//  SMPToolTip.m
//  SumUpUtilities
//
//  Created by Andras Kadar on 2/15/22.
//  Copyright © 2022 SumUp. All rights reserved.
//

#import "SMPToolTip.h"

#import "SMPMacroHelpers.h"

#define MAXDISPLAYCOUNT 2

static NSMutableArray *kISHCalledToolTips;
static BOOL kISHTooltipOnDisplay;
static CGFloat kISHTooltipDisplayDuration = 8.0;
static CGFloat kISHTooltipFadeInDuration = 0.5;
static CGFloat kISHTooltipFadeOutDuration = 0.5;
static SMPToolTip *kISHTooltipCurrentToolTip = nil;

@implementation SMPToolTip

@synthesize topImageView;
@synthesize bottomImageView;

+ (void)setDisplayDuration:(CGFloat)duration {
    kISHTooltipDisplayDuration = duration;
}

+ (void)setFadeInDuration:(CGFloat)duration {
    kISHTooltipFadeInDuration = duration;
}

+ (void)setFadeOutDuration:(CGFloat)duration {
    kISHTooltipFadeOutDuration = duration;
}

+ (BOOL)showInView:(UIView *)v withImage:(UIImage *)img {
    CGSize imgSize = [img size];

    return [SMPToolTip showInView:v topImage:img bottomImage:nil forKey:nil maxShows:HUGE_VAL onlyOncePerAppStart:NO withSize:CGSizeMake(imgSize.width + 10, imgSize.height + 10)];
}

+ (BOOL)showInView:(UIView *)v topImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage forKey:(NSString *)key {
    return [SMPToolTip showInView:v topImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage forKey:key maxShows:MAXDISPLAYCOUNT];
}

+ (BOOL)showInView:(UIView *)v topImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage forKey:(NSString *)key maxShows:(int)maxDisplay {
    return [SMPToolTip showInView:v topImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage forKey:key maxShows:maxDisplay onlyOncePerAppStart:YES];
}

+ (BOOL)showInView:(UIView *)v topImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage
            forKey:(NSString *)key maxShows:(int)maxDisplay onlyOncePerAppStart:(BOOL)onlyOncePerStart {
    return [SMPToolTip showInView:v topImage:topImage bottomImage:bottomImage forKey:key maxShows:maxDisplay onlyOncePerAppStart:onlyOncePerStart withSize:CGSizeZero];
}

+ (BOOL)showInView:(UIView*)v topImage:(UIImage*)topImage bottomImage:(UIImage*)bottomImage forKey:(NSString*)key maxShows:(int)maxDisplay onlyOncePerAppStart:(BOOL)onlyOncePerStart withSize:(CGSize)preferredSize {

    // OMLog(@"Tooltip for key %@ shown %u times",key,[[NSUserDefaults standardUserDefaults] integerForKey:key]);
#if TARGET_IPHONE_SIMULATOR
    if (key) {
        key = [NSString stringWithFormat:@"CBTOOLTIP_%@",key];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:key];
    }
#endif

    if(kISHCalledToolTips == nil) {
        kISHCalledToolTips = [[NSMutableArray alloc] initWithCapacity:0];
    }

    BOOL hasBeenShownThisAppStart = NO;

    if (key && [kISHCalledToolTips containsObject:key] ) {
        hasBeenShownThisAppStart = YES;
    }

    BOOL shownToOften = NO;
    if (key) {
        NSInteger timesShown = [[NSUserDefaults standardUserDefaults] integerForKey:key];
        shownToOften = timesShown > maxDisplay;
    }

    if(shownToOften || (hasBeenShownThisAppStart && onlyOncePerStart) || kISHTooltipOnDisplay) {
        return NO;
    }

    kISHTooltipOnDisplay = YES;
    CGSize size = preferredSize;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(250,150+topImage.size.height+bottomImage.size.height);
    }

    UIView *addToView = v;
    if (!addToView) {
        // add to main window
        addToView = [[UIApplication sharedApplication] keyWindow];
    }
    SMPToolTip *tooltip = [[SMPToolTip alloc] initWithFrame:CGRectMake((addToView.bounds.size.width-size.width)/2, (addToView.bounds.size.height-size.height)/2, size.width,size.height)];

    tooltip.topImageView.image = [topImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    tooltip.bottomImageView.image = [bottomImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [addToView addSubview:tooltip];

    [UIView animateWithDuration:kISHTooltipFadeInDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [tooltip setHidden:NO];
    } completion:NULL];

    [tooltip performSelector:@selector(hide) withObject:nil afterDelay:kISHTooltipDisplayDuration];

    NSInteger counter = 0;

    if (key && !hasBeenShownThisAppStart) {
        // increase persistent counter only once per appStart
        counter = [[NSUserDefaults standardUserDefaults] integerForKey:key];
        counter++;
        [[NSUserDefaults standardUserDefaults] setInteger:counter forKey:key];
        [kISHCalledToolTips addObject:[NSString stringWithString:key]];
    }
    kISHTooltipCurrentToolTip = tooltip; // is retained by superview

    return YES;
}

+ (void)resetRuntimeCounter {
    kISHCalledToolTips = nil;
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])){

        [self.layer setMasksToBounds:YES];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectInset(self.bounds, -10, -10)];
        [self addSubview:toolbar];

        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 8.0;
        self.hidden = YES;
        self.userInteractionEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;

        topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        topImageView.contentMode = UIViewContentModeCenter;
        topImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:topImageView];

        bottomImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        bottomImageView.contentMode = UIViewContentModeCenter;
        bottomImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:bottomImageView];

        [bottomImageView setTintColor:[UIColor blackColor]];
        [topImageView setTintColor:[UIColor blackColor]];

        CGFloat viewerOffset = 15;

        UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        [interpolationHorizontal setMinimumRelativeValue:@(-viewerOffset)];
        [interpolationHorizontal setMaximumRelativeValue:@(viewerOffset)];

        UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        [interpolationVertical setMinimumRelativeValue:@(-viewerOffset)];
        [interpolationVertical setMaximumRelativeValue:@(viewerOffset)];

        UIView *someView = self;
        [someView addMotionEffect:interpolationHorizontal];
        [someView addMotionEffect:interpolationVertical];

    }

    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)hide {
    if (![self superview]) {
        return;
    }

    SMPBlockWeakSelf weakSelf = self;

    [self resetCurrentToolTipPointer];
    [UIView animateWithDuration:kISHTooltipFadeOutDuration delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [weakSelf setHidden:YES];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];


    kISHTooltipOnDisplay = NO;
}

- (void)removeFromSuperview {
    [self resetCurrentToolTipPointer];
    [super removeFromSuperview];
}

- (void)resetCurrentToolTipPointer {
    if (self == kISHTooltipCurrentToolTip) {
        // in case we did not set the current tooltip to nil, do so now
        // only do so if this is the current one!
        kISHTooltipCurrentToolTip = nil;
    }
}

+ (void)hideCurrentToolTip {
    if (![kISHTooltipCurrentToolTip isKindOfClass:[SMPToolTip class]]) {
        kISHTooltipCurrentToolTip = nil;
        return;
    }

    [kISHTooltipCurrentToolTip hide];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat topImageHeight = topImageView.image?topImageView.image.size.height:0.0;
    CGFloat topMargin = topImageView.image?5.0:0.0;
    CGFloat bottomImageHeight = bottomImageView.image?bottomImageView.image.size.height:0.0;

    topImageView.hidden = topImageView.image==nil;
    bottomImageView.hidden = bottomImageView.image==nil;

    topImageView.frame = CGRectMake(0, topMargin, self.frame.size.width, topImageHeight);
    bottomImageView.frame = CGRectMake(0, topImageHeight+2.0*topMargin, self.frame.size.width, bottomImageHeight);
}

- (void)dealloc {
    [self resetCurrentToolTipPointer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
