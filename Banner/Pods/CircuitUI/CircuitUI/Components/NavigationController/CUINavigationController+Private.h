//
//  CUINavigationController+Private.h
//  SDSDesignSystem
//
//  Created by Illia Lukisha on 16/11/2021.
//  Copyright © 2021 SumUp. All rights reserved.
//

#import <CircuitUI/CUINavigationController.h>

NS_ASSUME_NONNULL_BEGIN

@interface CUINavigationController ()

@property (nullable, nonatomic) id <UINavigationControllerDelegate> interceptingDelegate;

@end

NS_ASSUME_NONNULL_END
