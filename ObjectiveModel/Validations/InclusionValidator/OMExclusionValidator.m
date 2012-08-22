//
//  OMExclusionValidator.m
//  ObjectiveModel
//
//  Created by Michael R. Fleet on 8/22/12.
//  Copyright (c) 2012 Michael R. Fleet. All rights reserved.
//



#import "OMExclusionValidator.h"



@implementation OMExclusionValidator



- (instancetype)init
{
    if ( (self = [super init]) )
    {
        [self setMessage:@"is reserved"];
        [self setMode:OMMembershipValidationExclusion];
    }
    
    return self;
}



@end
