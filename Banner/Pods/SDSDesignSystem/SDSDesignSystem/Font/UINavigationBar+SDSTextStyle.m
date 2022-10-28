//
//  UINavigationBar+SDSTextStyle.m
//  SDSDesignSystem
//
//  Created by Evgeniy Nazarov on 18.02.19.
//  Copyright © 2019 SumUp. All rights reserved.
//

#import "UINavigationBar+SDSTextStyle.h"
#import "SDSScalableFont.h"
#import "SDSTextStyleConfiguration+Private.h"

@implementation UINavigationBar (SDSTextStyle)

- (void)sds_applyTitleTextStyle:(SDSTextStyle)style {
    [self sds_applyTitleTextStyle:style invertedColor:NO];
}

- (void)sds_applyTitleTextStyle:(SDSTextStyle)style invertedColor:(BOOL)inverted {
    SDSTextStyleConfiguration *configuration = [SDSStyleSheet.global configurationForTextStyle:style];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    attributes[NSForegroundColorAttributeName] = [configuration.textColor valueForState:UIControlStateNormal inverted:inverted];
    attributes[NSFontAttributeName] = configuration.baseFont.baseFont;
    self.titleTextAttributes = attributes.copy;
}

@end
