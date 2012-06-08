/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations/inclusion.rb
 * Ruby on Rails is Copyright © 2004-2012 David Heinemeier Hansson.
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



@interface OMActiveModel (InclusionValidation)



// Validates whether the value of the specified attribute is available in a
// particular enumerable object.
//
//   class Person < ActiveRecord::Base
//     validates_inclusion_of :gender, :in => %w( m f )
//     validates_inclusion_of :age, :in => a..z
//     validates_inclusion_of :format, :in => %w( jpg gif png ), :message => "extension %{value} is not included in the list"
//     validates_inclusion_of :states, :in => lambda{ |person| STATES[person.country] }
//   end
//
// Configuration options:
// * <tt>:message</tt> - Specifies a custom error message (default is: "is not
//   included in the list").

//     validates_inclusion_of :age, :in => 0..99
//+ (void)validatesInclusionOf:(NSObject *)properties withOptions:(NSDictionary *)options inSet:(NSCharacterSet *)set;


//     validates_inclusion_of :gender, :in => %w( m f )
+ (void)validatesInclusionOf:(NSObject *)properties withOptions:(NSDictionary *)options inArray:(NSArray *)array;

//     validates_inclusion_of :states, :in => lambda{ |person| STATES[person.country] }
//+ (void)validatesInclusionOf:(NSObject *)properties withOptions:(NSDictionary *)options usingBlock:;


@end
