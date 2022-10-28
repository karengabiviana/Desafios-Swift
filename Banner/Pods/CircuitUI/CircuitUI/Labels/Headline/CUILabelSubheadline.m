//
//  CUILabelSubheadline.m
//  CircuitUI
//
//  Created by Florian Schliep on 22.01.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUILabelSubheadline.h"
#import "CUILabel+Private.h"

@implementation CUILabelSubheadline

- (SDSTextStyleConfiguration *)createTextStyleConfiguration {
    return CUITextStyleCreateSubheadline();
}

- (CUILabelCase)textCase {
    return CUILabelCaseUppercase;
}

- (CGFloat)cui_lineSpacing {
    return 3;
}

@end
