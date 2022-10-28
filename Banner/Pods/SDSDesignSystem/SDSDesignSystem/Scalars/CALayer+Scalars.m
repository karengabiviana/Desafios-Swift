//
//  CALayer+Scalars.m
//  SDSDesignSystem
//
//  Created by Florian Schliep on 17.09.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "CALayer+Scalars.h"

@implementation CALayer (Scalars)

- (void)sds_applyCornerRadius:(SDSScalarType)scalar {
    [self sds_applyCornerRadius:scalar fromStyleSheet:[SDSStyleSheet global]];
}

- (void)sds_applyCornerRadius:(SDSScalarType)scalar fromStyleSheet:(SDSStyleSheet *)sheet {
    self.cornerRadius = [sheet scalarNormalValueForType:scalar];
}

- (void)sds_applyBorderWidth:(SDSScalarType)scalar {
    [self sds_applyBorderWidth:scalar fromStyleSheet:[SDSStyleSheet global]];
}

- (void)sds_applyBorderWidth:(SDSScalarType)scalar fromStyleSheet:(SDSStyleSheet *)sheet {
    self.borderWidth = [sheet scalarNormalValueForType:scalar];
}

@end
