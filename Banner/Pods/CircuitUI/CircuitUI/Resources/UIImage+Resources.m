//
//  UIImage+Resources.m
//  CircuitUI
//
//  Created by Andras Kadar on 04.08.21.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import "UIImage+Resources+Private.h"

#import "CUIButton.h"
#import "NSBundle+Resources.h"

@implementation UIImage (Resources)

+ (UIImage *)cui_imageNamed:(NSString *)imageName {
    NSParameterAssert(imageName);
    UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle cui_resourceBundle] compatibleWithTraitCollection:nil];
    if (!image) {
        // In case of the example app, the resources bundle will not be present as it is created during the process of
        // installing a pod. We will need to just get the images from the root bundle.
        image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[CUIButton class]] compatibleWithTraitCollection:nil];
    }
    return image;
}

@end
