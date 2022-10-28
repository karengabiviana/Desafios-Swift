//
//  CUILabelHeadline3.m
//  CircuitUI
//
//  Created by Florian Schliep on 22.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabelHeadline3.h"
#import "CUILabel+Private.h"

@implementation CUILabelHeadline3

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateHeadline3();
}

- (CGFloat)cui_lineSpacing {
    return 2;
}

@end
