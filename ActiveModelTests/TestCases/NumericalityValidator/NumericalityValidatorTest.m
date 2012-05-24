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
#import "OMNumericalityValidator.h"
#import "Topic.h"



@interface NumericalityValidatorTest (Private)



- (void)assertValuesAreInvalid:(NSArray *)values withErrorMessage:(NSString *)message;
- (void)assertValuesAreValid:(NSArray *)values;



@end



@implementation NumericalityValidatorTest



#pragma mark - SETUP/TEARDOWN



- (void)tearDown
{
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
                              [NSNumber numberWithFloat:0.0],
                              [NSNumber numberWithFloat:10.0],
                              [NSNumber numberWithFloat:10.5],
                              [NSNumber numberWithFloat:-10.5],
                              [NSNumber numberWithFloat:-0.0001], nil];
    
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
    [self assertValuesAreInvalid:[self null] withErrorMessage:nil];
    [self assertValuesAreInvalid:[self blankStrings] withErrorMessage:nil];
    [self assertValuesAreInvalid:[self junkStrings] withErrorMessage:nil];

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
    [self assertValuesAreInvalid:[self blankStrings] withErrorMessage:nil];
    [self assertValuesAreInvalid:[self junkStrings] withErrorMessage:nil];

    // valid!(NIL + FLOATS + INTEGERS + BIGDECIMAL + INFINITY)
    [self assertValuesAreValid:[self null]];
    [self assertValuesAreValid:[self floats]];
    [self assertValuesAreValid:[self integers]];
    [self assertValuesAreValid:[self bigDecimals]];
    [self assertValuesAreValid:[self infinity]];
}



- (void)testValidatesNumericalityOfWithIntegerOnly
{
    // Topic.validates_numericality_of :approved, :only_integer => true
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"integer", nil]];

    // invalid!(NIL + BLANK + JUNK + FLOATS + BIGDECIMAL + INFINITY)
    [self assertValuesAreInvalid:[self null] withErrorMessage:@"must be an integer"];
    [self assertValuesAreInvalid:[self blankStrings] withErrorMessage:@"must be an integer"];
    [self assertValuesAreInvalid:[self junkStrings] withErrorMessage:@"must be an integer"];
    [self assertValuesAreInvalid:[self floats] withErrorMessage:@"must be an integer"];
    [self assertValuesAreInvalid:[self bigDecimals] withErrorMessage:@"must be an integer"];
    [self assertValuesAreInvalid:[self infinity] withErrorMessage:@"must be an integer"];

    // valid!(INTEGERS)
    [self assertValuesAreValid:[self integers]];
}



- (void)testValidatesNumericalityOfWithIntegerOnlyAndNilAllowed
{
    // Topic.validates_numericality_of :approved, :only_integer => true, :allow_nil => true
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], @"allowNil",
                                    [NSNumber numberWithBool:YES], @"integer",
                                    nil]];

    // invalid!(JUNK + BLANK + FLOATS + BIGDECIMAL + INFINITY)
    [self assertValuesAreInvalid:[self blankStrings] withErrorMessage:@"must be an integer"];
    [self assertValuesAreInvalid:[self junkStrings] withErrorMessage:@"must be an integer"];
    [self assertValuesAreInvalid:[self floats] withErrorMessage:@"must be an integer"];
    [self assertValuesAreInvalid:[self bigDecimals] withErrorMessage:@"must be an integer"];
    [self assertValuesAreInvalid:[self infinity] withErrorMessage:@"must be an integer"];

    // valid!(NIL + INTEGERS)
    [self assertValuesAreValid:[self null]];
    [self assertValuesAreValid:[self integers]];
}



- (void)testValidatesNumericalityWithGreaterThan
{
    // Topic.validates_numericality_of :approved, :greater_than => 10
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:10], @"greaterThan",
                                    nil]];

    // invalid!([-10, 10], 'must be greater than 10')
    [self assertValuesAreInvalid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-10], [NSNumber numberWithInt:10], nil]
                withErrorMessage:@"must be greater than 10"];

    // valid!([11])
    [self assertValuesAreValid:[NSArray arrayWithObject:[NSNumber numberWithInt:11]]];
}



- (void)testValidatesNumericalityWithGreaterThanOrEqual
{
    // Topic.validates_numericality_of :approved, :greater_than_or_equal_to => 10
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:10], @"greaterThanOrEqualTo",
                                    nil]];

    // invalid!([-9, 9], 'must be greater than or equal to 10')
    [self assertValuesAreInvalid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-9], [NSNumber numberWithInt:9], nil]
                withErrorMessage:@"must be greater than or equal to 10"];

    // valid!([10])
    [self assertValuesAreValid:[NSArray arrayWithObject:[NSNumber numberWithInt:10]]];
}



-(void)testValidatesNumericalityWithEqualTo
{
    // Topic.validates_numericality_of :approved, :equal_to => 10
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:10], @"equalTo",
                                    nil]];

    // invalid!([-10, 11] + INFINITY, 'must be equal to 10')
    [self assertValuesAreInvalid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-10], [NSNumber numberWithInt:11], nil]
                withErrorMessage:@"must be equal to 10"];
    [self assertValuesAreInvalid:[self infinity]
                withErrorMessage:@"must be equal to 10"];

    // valid!([10])
    [self assertValuesAreValid:[NSArray arrayWithObject:[NSNumber numberWithInt:10]]];
}



- (void)testValidatesNumericalityWithLessThan
{
    // Topic.validates_numericality_of :approved, :less_than => 10
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:10], @"lessThan",
                                    nil]];
    
    // invalid!([10], 'must be less than 10')
    [self assertValuesAreInvalid:[NSArray arrayWithObject:[NSNumber numberWithInt:10]]
                withErrorMessage:@"must be less than 10"];

    // valid!([-9, 9])
    [self assertValuesAreValid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-9], [NSNumber numberWithInt:9], nil]];
}



- (void)testValidatesNumericalityWithLessThanOrEqualTo
{
    // Topic.validates_numericality_of :approved, :less_than_or_equal_to => 10
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:10], @"lessThanOrEqualTo",
                                    nil]];
    
    // invalid!([11], 'must be less than or equal to 10')
    [self assertValuesAreInvalid:[NSArray arrayWithObject:[NSNumber numberWithInt:11]]
                withErrorMessage:@"must be less than or equal to 10"];
    
    // valid!([-10, 10])
    [self assertValuesAreValid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-10], [NSNumber numberWithInt:10], nil]];
}



- (void)testValidatesNumericalityWithOdd
{
    // Topic.validates_numericality_of :approved, :odd => true
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], @"odd",
                                    nil]];
    
    // invalid!([-2, 2], 'must be odd')
    [self assertValuesAreInvalid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-2], [NSNumber numberWithInt:2], nil]
                withErrorMessage:@"must be odd"];
    
    // valid!([-1, 1])
    [self assertValuesAreValid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:1], nil]];
}



- (void)testValidatesNumericalityWithEven
{
    // Topic.validates_numericality_of :approved, :even => true
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], @"even",
                                    nil]];
    
    // invalid!([-1, 1], 'must be even')
    [self assertValuesAreInvalid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:1], nil]
                withErrorMessage:@"must be even"];

    // valid!([-2, 2])
    [self assertValuesAreValid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-2], [NSNumber numberWithInt:2], nil]];
}



- (void)testValidatesNumericalityWithGreaterThanLessThanAndEven
{
    // Topic.validates_numericality_of :approved, :greater_than => 1, :less_than => 4, :even => true
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:1], @"greaterThan",
                                    [NSNumber numberWithInt:4], @"lessThan",
                                    [NSNumber numberWithBool:YES], @"even",
                                    nil]];
    
    // invalid!([1, 3, 4])
    [self assertValuesAreInvalid:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], nil]
                withErrorMessage:nil];
    
    // valid!([2])
    [self assertValuesAreValid:[NSArray arrayWithObject:[NSNumber numberWithInt:2]]];
}



- (void)testValidatesNumericalityWithIsNotEqualTo
{
    // Topic.validates_numericality_of :approved, :other_than => 0
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:0], @"notEqualTo",
                                    nil]];
    
    // invalid!([0, 0.0])
    [self assertValuesAreInvalid:[NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithDouble:0.0], nil]
                withErrorMessage:@"must not be equal to 0"];
    
    // valid!([-1, 42])
    [self assertValuesAreValid:[NSArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:42], nil]];
}



- (void)testValidatesNumericalityWithBlock
{
    // Topic.send(:define_method, :min_approved, lambda { 5 })
    id block = ^NSNumber *(id topic)
    {
        return [NSNumber numberWithInt:5];
    };

    // Topic.validates_numericality_of :approved, :greater_than_or_equal_to => Proc.new {|topic| topic.min_approved }
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    block, @"greaterThanOrEqualTo",
                                    nil]];

    // invalid!([3, 4])
    [self assertValuesAreInvalid:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:4], nil]
                withErrorMessage:@"must be greater than or equal to 5"];

    // valid!([5, 6])
    [self assertValuesAreValid:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:6], nil]];
}



- (void)testValidatesNumericalityWithSelector
{
    // Topic.send(:define_method, :max_approved, lambda { 5 })
    // Topic.validates_numericality_of :approved, :less_than_or_equal_to => :max_approved
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSValue valueWithBytes:&@selector(maxApproved) objCType:@encode(SEL)], @"lessThanOrEqualTo",
                                    nil]];
    
    // invalid!([6])
    [self assertValuesAreInvalid:[NSArray arrayWithObject:[NSNumber numberWithInt:6]] withErrorMessage:nil];
    
    // valid!([4, 5])
    [self assertValuesAreValid:[NSArray arrayWithObjects:[NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil]];
}



- (void)testValidatesNumericalityWithNumericMessage
{
    // Topic.validates_numericality_of :approved, :less_than => 4, :message => "smaller than %{count}"
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:4], @"lessThan",
                                    @"smaller than %{count}", @"message",
                                    nil]];

    // topic = Topic.new("title" => "numeric test", "approved" => 10)
    Topic *topic = [[Topic alloc] init];
    [topic setTitle:@"numeric test"];
    [topic setApproved:[NSNumber numberWithInt:10]];
    
    // assert !topic.valid?
    // assert_equal ["smaller than 4"], topic.errors[:approved]
    [self assertModelIsInvalid:topic withErrorMessage:@"smaller than 4" forKeys:[NSArray arrayWithObject:@"approved"]];
    [topic release];
    

    // Topic.validates_numericality_of :approved, :greater_than => 4, :message => "greater than %{count}"
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:4], @"greaterThan",
                                    @"bigger than %{count}", @"message",
                                    nil]];
    
    // topic = Topic.new("title" => "numeric test", "approved" => 1)
    topic = [[Topic alloc] init];
    [topic setTitle:@"numeric test"];
    [topic setApproved:[NSNumber numberWithInt:1]];

    // assert !topic.valid?
    // assert_equal ["greater than 4"], topic.errors[:approved]
    [self assertModelIsInvalid:topic withErrorMessage:@"bigger than 4" forKeys:[NSArray arrayWithObject:@"approved"]];
    [topic release];
}



- (void)testValidatesNumericalityWithInvalidArgs
{
    // assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :greater_than_or_equal_to => "foo" }
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"foo", @"greaterThanOrEqualTo", nil];
    STAssertThrowsSpecificNamed([Topic validatesNumericalityOf:@"approved" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");

    // assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :less_than_or_equal_to => "foo" }
    options = [NSDictionary dictionaryWithObjectsAndKeys:@"foo", @"lessThanOrEqualTo", nil];
    STAssertThrowsSpecificNamed([Topic validatesNumericalityOf:@"approved" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");

    // assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :greater_than => "foo" }
    options = [NSDictionary dictionaryWithObjectsAndKeys:@"foo", @"greaterThan", nil];
    STAssertThrowsSpecificNamed([Topic validatesNumericalityOf:@"approved" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");
    
    // assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :less_than => "foo" }
    options = [NSDictionary dictionaryWithObjectsAndKeys:@"foo", @"lessThan", nil];
    STAssertThrowsSpecificNamed([Topic validatesNumericalityOf:@"approved" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");
    
    // assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :equal_to => "foo" }
    options = [NSDictionary dictionaryWithObjectsAndKeys:@"foo", @"equalTo", nil];
    STAssertThrowsSpecificNamed([Topic validatesNumericalityOf:@"approved" withOptions:options], NSException, NSInvalidArgumentException, @"An NSInvalidArgumentException should have been raised, but was not.");
}



#pragma mark - PRIVATE



// def invalid!(values, error = nil)
- (void)assertValuesAreInvalid:(NSArray *)values withErrorMessage:(NSString *)message
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
        // assert topic.invalid?, "#{value.inspect} not rejected as a number"
        // assert topic.errors[:approved].any?, "FAILED for #{value.inspect}"
        // assert_equal error, topic.errors[:approved].first if error
        [self assertModelIsInvalid:topic withErrorMessage:message forKeys:[NSArray arrayWithObject:@"approved"]];
    }

    [topic release];
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
        // assert topic.valid?, "#{value.inspect} not accepted as a number"
        [self assertModelIsValid:topic];
    }

    [topic release];
}

//def with_each_topic_approved_value(values)
//topic = Topic.new(:title => "numeric test", :content => "whatever")
//values.each do |value|
//topic.approved = value
//yield topic, value
//end
//end


@end
