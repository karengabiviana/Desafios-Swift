//
//  CUILabelHeadline4.m
//  CircuitUI
//
//  Created by Florian Schliep on 22.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabelHeadline4.h"
#import "CUILabel+Private.h"

@implementation CUILabelHeadline4

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateHeadline4();
}

- (CGFloat)cui_lineSpacing {
    return 3;
}

@end
