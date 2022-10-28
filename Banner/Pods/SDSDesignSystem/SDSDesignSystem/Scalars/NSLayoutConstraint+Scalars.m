//
//  NSLayoutConstraint+Scalars.m
//  SDSDesignSystem
//
//  Created by Florian Schliep on 22.06.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "NSLayoutConstraint+Scalars.h"

@implementation NSLayoutConstraint (Scalars)

+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier scalar:(SDSScalarType)scalar {
    return [self constraintWithItem:view1
                          attribute:attr1
                          relatedBy:relation
                             toItem:view2
                          attribute:attr2
                         multiplier:multiplier
                             scalar:scalar
                         styleSheet:[SDSStyleSheet global]];
}

+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier scalar:(SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    return [self constraintWithItem:view1
                          attribute:attr1
                          relatedBy:relation
                             toItem:view2
                          attribute:attr2
                         multiplier:multiplier
                           constant:[sheet scalarForType:scalar].normal.doubleValue];
}

- (void)applyScalar:(SDSScalarType)scalar {
    [self applyScalar:scalar styleSheet:[SDSStyleSheet global]];
}

- (void)applyScalar:(SDSScalarType)scalar styleSheet:(SDSStyleSheet *)sheet {
    self.constant = [sheet scalarForType:scalar].normal.doubleValue;
}

@end
