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



#import "OMActiveModel.h"
#import "OMValidator.h"



@interface OMActiveModel (Validation)



/*!
 * @brief Triggers validations and returns YES if any validation fails, else NO
 */
- (BOOL)isInvalid:(NSError **)errors;



/*!
 * @brief Triggers validations and returns YES if all validations pass, else NO
 */
- (BOOL)isValid:(NSError **)errors;



/*!
 * @brief Executes all validators defined for the model. See isValid.
 */
- (BOOL)validate:(NSError **)errors;



/*!
 * @param properties An NSString property name OR an NSArray of NSString property names
 * @param validators An NSArray containing one or more of the following:
 * "acceptance" => OMAcceptanceValidator
 * "confirmation" => OMConfirmationValidator
 * "exclusion" => OMMembershipValidator
 * "format" => OMFormatValidator
 * "inclusion" => OMMembershipValidator
 * "length" => OMLengthValidator
 * "numercality" => OMNumericalityValidator
 * "presence" => OMPresenceValidator
 * @param options A dictionary with one or more of the following keys/value pairs:
 */
+ (void)validates:(NSObject *)properties withValidators:(NSArray *)validators andOptions:(NSDictionary *)options;



+ (NSMutableDictionary *)validations;



@end
