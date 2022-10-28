//
//  CUIButtonDropdown.m
//  CircuitUI
//
//  Created by Ivan Vasilev on 19.10.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "CUIButtonDropdown.h"
#import "CUIButton+Private.h"
#import "UIImage+CUILibrary.h"

@implementation CUIButtonDropdown

- (void)cui_commonInit {
    [super cui_commonInit];

    [self setupImage];
    [self invertContentLayoutDirection];
}

- (void)setupImage {
    UIImage *image = [UIImage.cui_chevron_down_24 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setImage:image forState:UIControlStateNormal];
}

- (void)updatePaddingForControlState:(UIControlState)controlState {
    [super updatePaddingForControlState:controlState];

    // We need to adjust the `contentEdgeInsets` to manually to fix the proportions of the button.
    // If we don't do that, it looks like the title and image are positioned too much on the side. (but in fact, they would be perfectly centred)
    // This is because the chevron itself doesn't take the whole width of the image (it is actually way smaller)
    CGFloat contentInsetLeft = self.contentEdgeInsets.left;
    CGFloat contentInsetRight = self.contentEdgeInsets.right;
    switch (self.effectiveUserInterfaceLayoutDirection) {
        case UIUserInterfaceLayoutDirectionLeftToRight: {
            CGFloat halfImageLeftInset = (self.imageEdgeInsets.left/2.0);
            // We don't adjust if contentInset will end up negative because a part of the image will be out of bounds
            if (contentInsetLeft + halfImageLeftInset > 0) {
                contentInsetLeft += halfImageLeftInset;
            }

            break;
        }
        case UIUserInterfaceLayoutDirectionRightToLeft: {
            CGFloat halfRightImageInset = (self.imageEdgeInsets.right/2.0);
            // We don't adjust if contentInset will end up negative because a part of the image will be out of bounds
            if (contentInsetRight + halfRightImageInset > 0) {
                contentInsetRight += halfRightImageInset;
            }

            break;
        }
    }

    self.contentEdgeInsets = UIEdgeInsetsMake(self.contentEdgeInsets.top, contentInsetLeft, self.contentEdgeInsets.bottom, contentInsetRight);
}

- (void)invertContentLayoutDirection {
    switch (self.effectiveUserInterfaceLayoutDirection) {
        case UIUserInterfaceLayoutDirectionLeftToRight:
            [self setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            break;
        case UIUserInterfaceLayoutDirectionRightToLeft:
            [self setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
            break;
    }
}

@end
