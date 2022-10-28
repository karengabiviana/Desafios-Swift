//
//  UIView+NibLoading.m
//  SumUpUtilities
//
//  Created by Felix Lamouroux on 27.02.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import "UIView+NibLoading.h"

@implementation UIView (NibLoading)

+ (nullable instancetype)viewFromNibNamed:(NSString*)nibName {
    return [self viewFromNibNamed:nibName fromBundle:nil];
}

+ (nullable instancetype)viewFromNibNamed:(NSString*)nibName fromBundle:(nullable NSBundle *)bundle {
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    // Load the top-level objects from the custom XIB.
    NSArray *topLevelObjects = [bundle loadNibNamed:nibName owner:nil options:nil];
    
    UIView *v = nil;
    Class class = [self class];
    for(NSObject *candidate in topLevelObjects){
        if([candidate isKindOfClass:class]){
            v = (UIView*)candidate;
            break;
        }
    }
    return v;
}

+ (NSString *)smp_nibName {
    NSString *stringOfClass = NSStringFromClass([self class]);
    // Swift classes include the module name separated by a dot
    // for those we use the pathExtension.
    // For ObjC classes this is empty and we use the entire string instead.
    NSString *pathExtension = [stringOfClass pathExtension];
    return pathExtension.length ? pathExtension : stringOfClass;
}

+ (nullable instancetype)smp_viewFromNib {
    return [self viewFromNibNamed:[self smp_nibName]];
}

@end
