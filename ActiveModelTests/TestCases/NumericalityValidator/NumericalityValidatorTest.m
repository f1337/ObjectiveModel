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



- (void)testValidatesNumericalityOfWithIntegerOnly
{
    // Topic.validates_numericality_of :approved, :only_integer => true
    [Topic validatesNumericalityOf:@"approved"
                       withOptions:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"integer", nil]];

    // invalid!(NIL + BLANK + JUNK + FLOATS + BIGDECIMAL + INFINITY)
    [self assertValuesAreInvalid:[self null]];
    [self assertValuesAreInvalid:[self blankStrings]];
    [self assertValuesAreInvalid:[self junkStrings]];
    [self assertValuesAreInvalid:[self floats]];
    [self assertValuesAreInvalid:[self bigDecimals]];
    [self assertValuesAreInvalid:[self infinity]];

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
    [self assertValuesAreInvalid:[self blankStrings]];
    [self assertValuesAreInvalid:[self junkStrings]];
    [self assertValuesAreInvalid:[self floats]];
    [self assertValuesAreInvalid:[self bigDecimals]];
    [self assertValuesAreInvalid:[self infinity]];

    // valid!(NIL + INTEGERS)
    [self assertValuesAreValid:[self null]];
    [self assertValuesAreValid:[self integers]];
}
 
/*
 def test_validates_numericality_with_greater_than
 Topic.validates_numericality_of :approved, :greater_than => 10
 
 invalid!([-10, 10], 'must be greater than 10')
 valid!([11])
 end
 
 def test_validates_numericality_with_greater_than_or_equal
 Topic.validates_numericality_of :approved, :greater_than_or_equal_to => 10
 
 invalid!([-9, 9], 'must be greater than or equal to 10')
 valid!([10])
 end
 
 def test_validates_numericality_with_equal_to
 Topic.validates_numericality_of :approved, :equal_to => 10
 
 invalid!([-10, 11] + INFINITY, 'must be equal to 10')
 valid!([10])
 end
 
 def test_validates_numericality_with_less_than
 Topic.validates_numericality_of :approved, :less_than => 10
 
 invalid!([10], 'must be less than 10')
 valid!([-9, 9])
 end
 
 def test_validates_numericality_with_less_than_or_equal_to
 Topic.validates_numericality_of :approved, :less_than_or_equal_to => 10
 
 invalid!([11], 'must be less than or equal to 10')
 valid!([-10, 10])
 end
 
 def test_validates_numericality_with_odd
 Topic.validates_numericality_of :approved, :odd => true
 
 invalid!([-2, 2], 'must be odd')
 valid!([-1, 1])
 end
 
 def test_validates_numericality_with_even
 Topic.validates_numericality_of :approved, :even => true
 
 invalid!([-1, 1], 'must be even')
 valid!([-2, 2])
 end
 
 def test_validates_numericality_with_greater_than_less_than_and_even
 Topic.validates_numericality_of :approved, :greater_than => 1, :less_than => 4, :even => true
 
 invalid!([1, 3, 4])
 valid!([2])
 end
 
 def test_validates_numericality_with_other_than
 Topic.validates_numericality_of :approved, :other_than => 0
 
 invalid!([0, 0.0])
 valid!([-1, 42])
 end
 
 def test_validates_numericality_with_proc
 Topic.send(:define_method, :min_approved, lambda { 5 })
 Topic.validates_numericality_of :approved, :greater_than_or_equal_to => Proc.new {|topic| topic.min_approved }
 
 invalid!([3, 4])
 valid!([5, 6])
 Topic.send(:remove_method, :min_approved)
 end
 
 def test_validates_numericality_with_symbol
 Topic.send(:define_method, :max_approved, lambda { 5 })
 Topic.validates_numericality_of :approved, :less_than_or_equal_to => :max_approved
 
 invalid!([6])
 valid!([4, 5])
 Topic.send(:remove_method, :max_approved)
 end
 
 def test_validates_numericality_with_numeric_message
 Topic.validates_numericality_of :approved, :less_than => 4, :message => "smaller than %{count}"
 topic = Topic.new("title" => "numeric test", "approved" => 10)
 
 assert !topic.valid?
 assert_equal ["smaller than 4"], topic.errors[:approved]
 
 Topic.validates_numericality_of :approved, :greater_than => 4, :message => "greater than %{count}"
 topic = Topic.new("title" => "numeric test", "approved" => 1)
 
 assert !topic.valid?
 assert_equal ["greater than 4"], topic.errors[:approved]
 end
 
 def test_validates_numericality_of_for_ruby_class
 Person.validates_numericality_of :karma, :allow_nil => false
 
 p = Person.new
 p.karma = "Pix"
 assert p.invalid?
 
 assert_equal ["is not a number"], p.errors[:karma]
 
 p.karma = "1234"
 assert p.valid?
 ensure
 Person.reset_callbacks(:validate)
 end
 
 def test_validates_numericality_with_invalid_args
 assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :greater_than_or_equal_to => "foo" }
 assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :less_than_or_equal_to => "foo" }
 assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :greater_than => "foo" }
 assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :less_than => "foo" }
 assert_raise(ArgumentError){ Topic.validates_numericality_of :approved, :equal_to => "foo" }
 end
 
 */
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
//        NSLog(@"expecting invalid topic: %@, approved: %@, value: %@", topic, [topic approved], value);
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
//        NSLog(@"expecting valid topic: %@, approved: %@, value: %@", topic, [topic approved], value);
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
