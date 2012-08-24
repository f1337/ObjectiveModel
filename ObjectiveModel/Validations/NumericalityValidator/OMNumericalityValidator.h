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



#import "OMValidator.h"
#import "OMActiveModel+NumericalityValidation.h"
#import "NSNumber+ComparisonMethods.h"



@interface OMNumericalityValidator : OMValidator



/*!
 * Specifies the value must be an even number.
 */
@property (copy) NSNumber *even;



/*!
 * Specifies the value must be equal to the supplied value.
 * May be an NSNumber or an OMNumericalityValidatorNumberBlock.
 */
@property (nonatomic, copy) OMNumericalityValidatorNumberBlock equalToBlock;
@property (nonatomic, copy) NSNumber *equalToNumber;



/*!
 * Specifies the value must be greater than the supplied value.
 * May be an NSNumber or an OMNumericalityValidatorNumberBlock.
 */
@property (nonatomic, copy) OMNumericalityValidatorNumberBlock greaterThanBlock;
@property (nonatomic, copy) NSNumber *greaterThanNumber;



/*
 * Specifies the value must be greater than or equal the supplied value.
 * May be an NSNumber or an OMNumericalityValidatorNumberBlock.
 */
@property (nonatomic, copy) OMNumericalityValidatorNumberBlock greaterThanOrEqualToBlock;
@property (nonatomic, copy) NSNumber *greaterThanOrEqualToNumber;



/*!
 * Specifies whether the value has to be an integer, e.g. an integral value
 * (default is +false+).
 */
@property (copy) NSNumber *integer;



/*!
 * Specifies the value must be less than the supplied value.
 * May be an NSNumber or an OMNumericalityValidatorNumberBlock.
 */
@property (nonatomic, copy) OMNumericalityValidatorNumberBlock lessThanBlock;
@property (nonatomic, copy) NSNumber *lessThanNumber;



/*
 * Specifies the value must be less than or equal the supplied value.
 * May be an NSNumber or an OMNumericalityValidatorNumberBlock.
 */
@property (nonatomic, copy) OMNumericalityValidatorNumberBlock lessThanOrEqualToBlock;
@property (nonatomic, copy) NSNumber *lessThanOrEqualToNumber;



/*!
 * A custom error message (default is: "is not a number").
 */
- (NSString *)message;



/*
 * Specifies the value must be other than the supplied value.
 * May be an NSNumber or an OMNumericalityValidatorNumberBlock.
 */
@property (nonatomic, copy) OMNumericalityValidatorNumberBlock notEqualToBlock;
@property (nonatomic, copy) NSNumber *notEqualToNumber;



/*!
 * Specifies the value must be an odd number.
 */
@property (copy) NSNumber *odd;



@end
