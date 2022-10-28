//
//  CTAButton.h
//  SDSDesignSystem
//
//  Created by Eduardo Domene on 15.12.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButton.h"
#import "CUIButtonVariant.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTAButton : CUIButton

@property (nonatomic) CUIButtonSize size;

- (instancetype)initWithSize:(CUIButtonSize)size NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithTitle:(NSString *)title size:(CUIButtonSize)size NS_DESIGNATED_INITIALIZER;
- (void)setTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
