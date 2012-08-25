ObjectiveModel
==============

An ActiveModel implementation for Objective-C.


INSTALLATION
------------

ObjectiveModel is packaged as a static library. Standard TL;DR for using a static library in an Xcode project goes here.



Examples
--------


### OMAcceptanceValidator

Encapsulates the pattern of validating the acceptance of a terms of
service check box, "enter initials to accept", or similar agreement.

	@implementation Person
	    + (void)initialize
	    {
	        [self validatesAcceptanceOf:@"termsOfService" withInitBlock:nil];
	        [self validatesAcceptanceOf:@"EULA" withInitBlock:^(OMValidator *validator)
	        {
	            OMAcceptanceValidator *acceptanceValidator = (OMAcceptanceValidator *)validator;
	            [acceptanceValidator setAccept:@"I agree."];
	            [acceptanceValidator setMessage:@"must be abided"];
	        }];
	    }
	@end



### OMBlockValidator

Validates each attribute against the provided block.

    @implementation Person
        + (void)initialize
        {
            [self validatesEach:[NSArray arrayWithObjects:@"firstName", @"lastName", nil]
                      withBlock:^BOOL(OMBlockValidator *validator, OMActiveModel *model, NSObject *value)
            {
                NSString *stringValue = [value description];
                if ( [stringValue hasPrefix:@"z"] )
                {
                    [validator setMessage:@"starts with z."];
                    return NO;
                }
                else
                {
                    return YES;
                }
            }];
        }
    @end





License
-------

ObjectiveModel is released under the MIT license ([www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)).