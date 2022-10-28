//
//  SDSScalableFont+Private.h
//  SDSDesignSystem
//
//  Created by Felix Lamouroux on 16.10.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#ifndef SDSScalableFont_Private_h
#define SDSScalableFont_Private_h

#import "SDSScalableFont.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDSScalableFont()
@property (nonatomic, readwrite) __Font *baseFont;
@property (nonatomic, readwrite) NSString *documentation;
@end

NS_ASSUME_NONNULL_END

#endif /* SDSScalableFont_Private_h */
