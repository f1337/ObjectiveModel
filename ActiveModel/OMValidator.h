/*!
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



#import "OMActiveModel+OMValidator.h"



// typedef BOOL (^ OMValidatorConditionalBlock) (id);



@interface OMValidator : NSObject



/*!
 * If set to true, skips this validation if the attribute is blank (default is +false+).
 */
@property (assign) BOOL allowBlank;



/*!
 * If set to true, skips this validation if the attribute is +nil+ (default is +false+).
 */
@property (assign) BOOL allowNil;



/*! A custom error message (default is: "is invalid"). */
@property (nonatomic, copy) NSString *message;



/*!
 * TODO: make this private, or readonly? The validation options.
 */
@property (nonatomic, retain) NSDictionary *options;



/*!
 * TODO?: validateForUpdate, validateForInsert, validateForDelete
 * ~mrf: May provide value with CoreData implementations.
 *
 * See: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdValidation.html#//apple_ref/doc/uid/TP40004807-SW3
 *
 * @property (assign) BOOL validateForDelete;
 * @property (assign) BOOL validateForInsert;
 * @property (assign) BOOL validateForUpdate;
 */


/*!
 * TODO: shouldApplyValidationSelector
 *
 * Specifies a selector to call to determine if the validation should occur.
 *
 *   [model setShouldApplyValidationSelector:@selector(allowValidation)];
 *
 * The selector should return YES or NO.
 *
 * @property (assign) SEL shouldApplyValidationSelector;
 */



/*!
 * TODO: shouldApplyValidationBlock
 *
 * Specifies a block to call to determine if the validation should occur.
 *
 *   [model setShouldApplyValidationBlock:^(id)model
 *   {
 *      return ( [[model property] length] ? YES : NO );
 *   }];
 *
 * The selector should return YES or NO.
 *
 * @property (assign) OMValidatorConditionalBlock shouldApplyValidationBlock;
 */



/*!
 * TODO?: Specifies whether validation should be strict.
 * ~mrf: This seems like overkill for now.
 *
 * YES or NO. Specifies whether the validator should throw a runtime exception
 * if the validation fails, instead of raising a user-friendly error.
 *
 * @property (assign) BOOL strict;
 */


/*!
 * TODO?: Per ~mlj's feedback, add error title?
 * @property (copy) NSString *title;
 */



- (void)errorWithOriginalError:(NSError **)originalError
                         value:(NSObject *)value
                        forKey:(NSString *)inKey
                       message:(NSString *)message;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (BOOL)shouldSkipValidationForValue:(NSObject *)value;
- (BOOL)validateModel:(OMActiveModel *)model withValue:(NSObject *)value forKey:(NSString *)inKey error:(NSError **)outError;



@end
