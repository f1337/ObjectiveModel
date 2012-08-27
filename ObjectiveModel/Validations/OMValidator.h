/*
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */



#import "OMActiveModel+Validation.h"



typedef BOOL (^ OMValidatorConditionalBlock) (OMActiveModel *model);



/*!
A simple base class that can be used with OMActiveModel+Validation.

Any class that inherits from OMValidator must implement the validateModel:withValue:forKey:error: method.
To cause a validation error, the method must return NO. To raise a validation error with a message, use
`[self errorWithOriginalError:outError value:value forKey:inKey message:[self message]];`.

	@interface Person : OMActiveModel @end
	@implementation Person
	    + (void)initialize
	    {
        	[self validatesEach:@"name" withClass:[MyValidator class] andInitBlock:nil];
	    }
	@end

	@interface MyValidator : OMValidator @end
	@implementation MyValidator
		- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError
		{
			BOOL valid = ([value isBlank] ? NO : YES);

		    if ( ! valid )
		    {
		        [self errorWithOriginalError:outError value:value forKey:inKey message:[self message]];
		    }

		    return valid;
		}
	@end
*/
@interface OMValidator : NSObject



/*!
 * If YES, skips this validation if the attribute is blank (default is `NO`).
 */
@property (assign) BOOL allowBlank;



/*!
 * If YES, skips this validation if the attribute is `nil` (default is `NO`).
 */
@property (assign) BOOL allowNil;



/*! A custom error message (default is: "is invalid"). */
@property (nonatomic, copy) NSString *message;



/*
 * TODO?: validateForUpdate, validateForInsert, validateForDelete
 * see RoR's "ValidationContextTest"
 * ~mrf: May provide value with CoreData implementations.
 *
 * See: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdValidation.html#//apple_ref/doc/uid/TP40004807-SW3
 *
 * @property (assign) BOOL validateForDelete;
 * @property (assign) BOOL validateForInsert;
 * @property (assign) BOOL validateForUpdate;
 */



/*!
Specifies a block to call to determine if the validation should occur.
The block should return YES or NO.

    [self setShouldApplyValidationBlock:^(id)model
    {
       return ( [[model property] length] ? YES : NO );
    }];
*/
@property (copy) OMValidatorConditionalBlock shouldApplyValidationBlock;



/*
 * TODO? This seems like overkill for now (~mrf):
 *
 * YES or NO. Specifies whether the validator should throw a runtime exception
 * if the validation fails, instead of raising a user-friendly error.
 *
 * @property (assign) BOOL strict;
 */



/*
 * TODO?: Per ~mlj's feedback, add error title?
 * @property (copy) NSString *title;
 */



- (void)errorWithOriginalError:(NSError **)originalError
                         value:(NSObject *)value
                        forKey:(NSString *)inKey
                       message:(NSString *)message;
- (BOOL)shouldApplyValidationForModel:(OMActiveModel *)model;
- (BOOL)shouldSkipValidationForValue:(NSObject *)value;
- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError;



@end
