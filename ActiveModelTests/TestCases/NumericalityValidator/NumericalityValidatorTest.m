/*!
 * Copyright © 2011-2012 Michael R. Fleet (github.com/f1337)
 *
 * Portions of this software were transliterated from Ruby on Rails.
 * https://github.com/rails/rails/blob/master/activemodel/test/cases/validations/numericality_validation_test.rb
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



#import "NumericalityValidatorTest.h"
#import "OMActiveModel+OMNumericalityValidator.h"
#import "Topic.h"



@interface NumericalityValidatorTest (Private)



- (void)assertValuesAreInvalid:(NSArray *)values;
- (void)assertValuesAreValid:(NSArray *)values;



@end



@implementation NumericalityValidatorTest



#pragma mark - SETUP/TEARDOWN



- (void)setUp
{
    [super setUp];

    [Person validatesNumericalityOf:[NSArray arrayWithObjects:@"two", @"three", @"ratio", nil]
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:1.1], @"greaterThan",
                                   [NSNumber numberWithInt:0], @"greaterThanOrEqualTo",
                                   [NSNumber numberWithInt:16], @"lessThan",
                                   [NSNumber numberWithInt:20.50], @"lessThanOrEqualTo",
                                   [NSNumber numberWithInt:25], @"notEqualTo",
                                   nil]];
    
    // test even integer contraints
    [Person validatesNumericalityOf:@"two"
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:2], @"equalTo",
                                   [NSNumber numberWithBool:YES], @"even",
                                   [NSNumber numberWithInt:2], @"greaterThanOrEqualTo",
                                   [NSNumber numberWithBool:YES], @"integer",
                                   [NSNumber numberWithInt:2], @"lessThanOrEqualTo",
                                   nil]];
    
    // test odd integer contraints & allowNil
    [Person validatesNumericalityOf:@"three"
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:3], @"equalTo",
                                   [NSNumber numberWithInt:3], @"greaterThanOrEqualTo",
                                   [NSNumber numberWithBool:YES], @"integer",
                                   [NSNumber numberWithInt:3], @"lessThanOrEqualTo",
                                   [NSNumber numberWithBool:YES], @"odd",
                                   nil]];
    
    // test float <=> integer constraints
    [Person validatesNumericalityOf:@"ratio"
                      withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:15.25], @"equalTo",
                                   [NSNumber numberWithFloat:15.25], @"greaterThanOrEqualTo",
                                   [NSNumber numberWithFloat:15.25], @"lessThanOrEqualTo",
                                   nil]];

    model = [[Person alloc] init];
}



- (void)tearDown
{
    [model release];
    [Person removeAllValidations];
    [Topic removeAllValidations];
    [super tearDown];
}



#pragma mark - TRANSLITERATED RoR TEST DATA



//NIL = [nil]
- (NSArray *)null
{
    return [NSArray arrayWithObject:[NSNull null]];
}



//BLANK = ["", " ", " \t \r \n"]
- (NSArray *)blankStrings
{
    return [NSArray arrayWithObjects:@"", @" ", @" \t \r \n", nil];
}



//BIGDECIMAL_STRINGS = %w(12345678901234567890.1234567890) # 30 significant digits
//BIGDECIMAL = BIGDECIMAL_STRINGS.collect! { |bd| BigDecimal.new(bd) }
- (NSArray *)bigDecimals
{
    return [@"12345678901234567890.1234567890" componentsSeparatedByString:@" "];
}



//FLOAT_STRINGS = %w(0.0 +0.0 -0.0 10.0 10.5 -10.5 -0.0001 -090.1 90.1e1 -90.1e5 -90.1e-5 90e-5)
//FLOATS = [0.0, 10.0, 10.5, -10.5, -0.0001] + FLOAT_STRINGS
- (NSArray *)floats
{
    NSMutableArray *floats = [NSMutableArray arrayWithObjects:
                              [NSNumber numberWithInt:0.0],
                              [NSNumber numberWithInt:10.0],
                              [NSNumber numberWithInt:10.5],
                              [NSNumber numberWithInt:-10.5],
                              [NSNumber numberWithInt:-0.0001], nil];
    
    // NSNumberFormatter doesn't play nicely with multiple positivePrefixes
    // (none versus plus sign). Validating w/o preceding plus sign.
    // NSNumberFormatter doesn't like to juggle standard and scientific notation.
    // Validating w/o scientific notation.
    [floats addObjectsFromArray:[@"0.0 -0.0 10.0 10.5 -10.5 -0.0001 -090.1" componentsSeparatedByString:@" "]];
    
    return floats;
}



// INFINITY = [1.0/0.0]
- (NSArray *)infinity
{
    return [NSArray arrayWithObject:[NSNumber numberWithFloat:INFINITY]];
}



//INTEGER_STRINGS = %w(0 +0 -0 10 +10 -10 0090 -090)
//INTEGERS = [0, 10, -10] + INTEGER_STRINGS
- (NSArray *)integers
{
    NSMutableArray *integers = [NSMutableArray arrayWithObjects:
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:10],
                                [NSNumber numberWithInt:-10], nil];
    
    // NSNumberFormatter doesn't play nicely with multiple positivePrefixes
    // (none versus plus sign). Validating w/o preceding plus sign.
    [integers addObjectsFromArray:[@"0 -0 10 -10 0090 -090" componentsSeparatedByString:@" "]];
    
    return integers;
}



//JUNK = ["not a number", "42 not a number", "0xdeadbeef", "0xinvalidhex", "0Xdeadbeef", "00-1", "--3", "+-3", "+3-1", "-+019.0", "12.12.13.12", "123\nnot a number"]
- (NSArray *)junkStrings
{
    return [NSArray arrayWithObjects:
            @"not a number",
            @"42 not a number",
            @"0xdeadbeef",
            @"0xinvalidhex",
            @"0Xdeadbeef",
            @"00-1",
            @"--3",
            @"+-3",
            @"+3-1",
            @"-+019.0",
            @"12.12.13.12",
            @"123\nnot a number",
            nil];
}



#pragma mark - TRANSLITERATED RoR TESTS



- (void)testDefaultValidatesNumericalityOf
{
    // Topic.validates_numericality_of :approved
    [Topic validatesNumericalityOf:@"approved" withOptions:nil];

    // invalid!(NIL + BLANK + JUNK)
    [self assertValuesAreInvalid:[self null]];
    [self assertValuesAreInvalid:[self blankStrings]];
    [self assertValuesAreInvalid:[self junkStrings]];

    // valid!(FLOATS + INTEGERS + BIGDECIMAL + INFINITY)
    [self assertValuesAreValid:[self floats]];
    [self assertValuesAreValid:[self integers]];
    [self assertValuesAreValid:[self bigDecimals]];
    [self assertValuesAreValid:[self infinity]];
}



- (void)testValidatesNumericalityOfWithNilAllowed
{
    // Topic.validates_numericality_of :approved, :allow_nil => true
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"allowNil", nil]];

    // invalid!(JUNK + BLANK)
    [self assertValuesAreInvalid:[self blankStrings]];
    [self assertValuesAreInvalid:[self junkStrings]];

    // valid!(NIL + FLOATS + INTEGERS + BIGDECIMAL + INFINITY)
    [self assertValuesAreValid:[self null]];
    [self assertValuesAreValid:[self floats]];
    [self assertValuesAreValid:[self integers]];
    [self assertValuesAreValid:[self bigDecimals]];
    [self assertValuesAreValid:[self infinity]];
}



#pragma mark - TESTS



- (void)testAnUnsetOrNilValueForTwoShouldBeInvalid
{
    [self assertPropertyIsInvalid:@"two" forModel:model withErrorMessage:@"is not a valid number"];
}



- (void)testIfTwoEquals0ItShouldBeInvalid
{
    [model setTwo:[NSNumber numberWithInt:0]];
    [self assertPropertyIsInvalid:@"two" forModel:model withErrorMessage:@"is not a valid number"];
}



- (void)testIfTwoEquals2ItShouldBeValid
{
    [model setTwo:[NSNumber numberWithInt:2]];
    [self assertPropertyIsValid:@"two" forModel:model];
}



- (void)testIfTwoEquals15ItShouldBeInvalid
{
    [model setTwo:[NSNumber numberWithInt:15]];
    [self assertPropertyIsInvalid:@"two" forModel:model withErrorMessage:@"is not a valid number"];
}



- (void)testIfThreeEquals1ItShouldBeInvalid
{
    [model setThree:[NSNumber numberWithInt:1]];
    [self assertPropertyIsInvalid:@"three" forModel:model withErrorMessage:@"is not a valid number"];
}



- (void)testIfThreeEquals3ItShouldBeValid
{
    [model setThree:[NSNumber numberWithInt:3]];
    [self assertPropertyIsValid:@"three" forModel:model];
}



- (void)testIfThreeEquals15ItShouldBeInvalid
{
    [model setThree:[NSNumber numberWithInt:15]];
    [self assertPropertyIsInvalid:@"three" forModel:model withErrorMessage:@"is not a valid number"];
}



#pragma mark - PRIVATE



// def invalid!(values, error = nil)
- (void)assertValuesAreInvalid:(NSArray *)values
{
    // with_each_topic_approved_value(values) do |topic, value|
    // topic = Topic.new(:title => "numeric test", :content => "whatever")
    Topic *topic = [[Topic alloc] init];
    [topic setTitle:@"numeric test"];
    [topic setContent:@"whatever"];

    // values.each do |value|
    for (id value in values)
    {
        // topic.approved = value
        [topic setApproved:value];
        NSLog(@"invalid expected topic: %@, approved: %@, value: %@", topic, [topic approved], value);
        // assert topic.invalid?, "#{value.inspect} not rejected as a number"
        // assert topic.errors[:approved].any?, "FAILED for #{value.inspect}"
        // assert_equal error, topic.errors[:approved].first if error
        [self assertModelIsInvalid:topic withErrorMessage:@"is not a valid number" forKeys:[NSArray arrayWithObject:@"approved"]];
    }
}



// def invalid!(values, error = nil)
- (void)assertValuesAreValid:(NSArray *)values
{
    // with_each_topic_approved_value(values) do |topic, value|
    // topic = Topic.new(:title => "numeric test", :content => "whatever")
    Topic *topic = [[Topic alloc] init];
    [topic setTitle:@"numeric test"];
    [topic setContent:@"whatever"];
    
    // values.each do |value|
    for (id value in values)
    {
        // topic.approved = value
        [topic setApproved:value];
        NSLog(@"valid expected topic: %@, approved: %@, value: %@", topic, [topic approved], value);
        // assert topic.valid?, "#{value.inspect} not accepted as a number"
        [self assertModelIsValid:topic];
    }
}

//def with_each_topic_approved_value(values)
//topic = Topic.new(:title => "numeric test", :content => "whatever")
//values.each do |value|
//topic.approved = value
//yield topic, value
//end
//end


@end
