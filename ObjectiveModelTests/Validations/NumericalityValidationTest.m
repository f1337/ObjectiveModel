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



#import "NumericalityValidationTest.h"
#import "Topic.h"
#import <ObjectiveModel/Validations.h>



@implementation NumericalityValidationTest



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
    [Topic validatesNumericalityOf:@"approved" withBlock:nil];

    // invalid!(NIL + BLANK + JUNK)
    OMAssertValuesAreInvalid(([self null]), @"");
    OMAssertValuesAreInvalid(([self blankStrings]), @"");
    OMAssertValuesAreInvalid(([self junkStrings]), @"");

    // valid!(FLOATS + INTEGERS + BIGDECIMAL + INFINITY)
    OMAssertValuesAreValid([self floats]);
    OMAssertValuesAreValid([self integers]);
    OMAssertValuesAreValid([self bigDecimals]);
    OMAssertValuesAreValid([self infinity]);
}



- (void)testValidatesNumericalityOfWithNilAllowed
{
    // Topic.validates_numericality_of :approved, :allow_nil => true
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         [validator setAllowNil:YES];
     }];

    // invalid!(JUNK + BLANK)
    OMAssertValuesAreInvalid(([self blankStrings]), @"");
    OMAssertValuesAreInvalid(([self junkStrings]), @"");

    // valid!(NIL + FLOATS + INTEGERS + BIGDECIMAL + INFINITY)
    OMAssertValuesAreValid([self null]);
    OMAssertValuesAreValid([self floats]);
    OMAssertValuesAreValid([self integers]);
    OMAssertValuesAreValid([self bigDecimals]);
    OMAssertValuesAreValid([self infinity]);
}



- (void)testValidatesNumericalityOfWithIntegerOnly
{
    // Topic.validates_numericality_of :approved, :only_integer => true
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setInteger:[NSNumber numberWithBool:YES]];
     }];

    // invalid!(NIL + BLANK + JUNK + FLOATS + BIGDECIMAL + INFINITY)
    OMAssertValuesAreInvalid(([self null]), @"must be an integer");
    OMAssertValuesAreInvalid(([self blankStrings]), @"must be an integer");
    OMAssertValuesAreInvalid(([self junkStrings]), @"must be an integer");
    OMAssertValuesAreInvalid(([self floats]), @"must be an integer");
    OMAssertValuesAreInvalid(([self bigDecimals]), @"must be an integer");
    OMAssertValuesAreInvalid(([self infinity]), @"must be an integer");

    // valid!(INTEGERS)
    OMAssertValuesAreValid([self integers]);
}



- (void)testValidatesNumericalityOfWithIntegerOnlyAndNilAllowed
{
    // Topic.validates_numericality_of :approved, :only_integer => true, :allow_nil => true
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         [validator setAllowNil:YES];
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setInteger:[NSNumber numberWithBool:YES]];
     }];

    // invalid!(JUNK + BLANK + FLOATS + BIGDECIMAL + INFINITY)
    OMAssertValuesAreInvalid(([self blankStrings]), @"must be an integer");
    OMAssertValuesAreInvalid(([self junkStrings]), @"must be an integer");
    OMAssertValuesAreInvalid(([self floats]), @"must be an integer");
    OMAssertValuesAreInvalid(([self bigDecimals]), @"must be an integer");
    OMAssertValuesAreInvalid(([self infinity]), @"must be an integer");

    // valid!(NIL + INTEGERS)
    OMAssertValuesAreValid([self null]);
    OMAssertValuesAreValid([self integers]);
}



- (void)testValidatesNumericalityWithGreaterThan
{
    // Topic.validates_numericality_of :approved, :greater_than => 10
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setGreaterThan:[NSNumber numberWithInt:10]];
     }];

    // invalid!([-10, 10], 'must be greater than 10')
    OMAssertValuesAreInvalid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-10], [NSNumber numberWithInt:10], nil]), @"must be greater than 10");

    // valid!([11])
    OMAssertValuesAreValid([NSArray arrayWithObject:[NSNumber numberWithInt:11]]);
}



- (void)testValidatesNumericalityWithGreaterThanOrEqual
{
    // Topic.validates_numericality_of :approved, :greater_than_or_equal_to => 10
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setGreaterThanOrEqualToNumber:[NSNumber numberWithInt:10]];
     }];

    // invalid!([-9, 9], 'must be greater than or equal to 10')
    OMAssertValuesAreInvalid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-9], [NSNumber numberWithInt:9], nil]), @"must be greater than or equal to 10");

    // valid!([10])
    OMAssertValuesAreValid([NSArray arrayWithObject:[NSNumber numberWithInt:10]]);
}



-(void)testValidatesNumericalityWithEqualTo
{
    // Topic.validates_numericality_of :approved, :equal_to => 10
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setEqualTo:[NSNumber numberWithInt:10]];
     }];

    // invalid!([-10, 11] + INFINITY, 'must be equal to 10')
    OMAssertValuesAreInvalid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-10], [NSNumber numberWithInt:11], nil]), @"must be equal to 10");
    OMAssertValuesAreInvalid(([self infinity]), @"must be equal to 10");

    // valid!([10])
    OMAssertValuesAreValid([NSArray arrayWithObject:[NSNumber numberWithInt:10]]);
}



- (void)testValidatesNumericalityWithLessThan
{
    // Topic.validates_numericality_of :approved, :less_than => 10
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setLessThan:[NSNumber numberWithInt:10]];
     }];
    
    // invalid!([10], 'must be less than 10')
    OMAssertValuesAreInvalid(([NSArray arrayWithObject:[NSNumber numberWithInt:10]]), @"must be less than 10");

    // valid!([-9, 9])
    OMAssertValuesAreValid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-9], [NSNumber numberWithInt:9], nil]));
}



- (void)testValidatesNumericalityWithLessThanOrEqualTo
{
    // Topic.validates_numericality_of :approved, :less_than_or_equal_to => 10
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setLessThanOrEqualTo:[NSNumber numberWithInt:10]];
     }];
    
    // invalid!([11], 'must be less than or equal to 10')
    OMAssertValuesAreInvalid(([NSArray arrayWithObject:[NSNumber numberWithInt:11]]), @"must be less than or equal to 10");
    
    // valid!([-10, 10])
    OMAssertValuesAreValid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-10], [NSNumber numberWithInt:10], nil]));
}



- (void)testValidatesNumericalityWithOdd
{
    // Topic.validates_numericality_of :approved, :odd => true
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setOdd:[NSNumber numberWithBool:YES]];
     }];
    
    // invalid!([-2, 2], 'must be odd')
    OMAssertValuesAreInvalid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-2], [NSNumber numberWithInt:2], nil]), @"must be odd");
    
    // valid!([-1, 1])
    OMAssertValuesAreValid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:1], nil]));
}



- (void)testValidatesNumericalityWithEven
{
    // Topic.validates_numericality_of :approved, :even => true
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setEven:[NSNumber numberWithBool:YES]];
     }];
    
    // invalid!([-1, 1], 'must be even')
    OMAssertValuesAreInvalid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:1], nil]), @"must be even");

    // valid!([-2, 2])
    OMAssertValuesAreValid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-2], [NSNumber numberWithInt:2], nil]));
}



- (void)testValidatesNumericalityWithGreaterThanLessThanAndEven
{
    // Topic.validates_numericality_of :approved, :greater_than => 1, :less_than => 4, :even => true
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setGreaterThan:[NSNumber numberWithInt:1]];
         [myValidator setLessThan:[NSNumber numberWithInt:4]];
         [myValidator setEven:[NSNumber numberWithBool:YES]];
     }];
    
    // invalid!([1, 3, 4])
    OMAssertValuesAreInvalid(([NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], nil]), @"");
    
    // valid!([2])
    OMAssertValuesAreValid(([NSArray arrayWithObject:[NSNumber numberWithInt:2]]));
}



- (void)testValidatesNumericalityWithIsNotEqualTo
{
    // Topic.validates_numericality_of :approved, :other_than => 0
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setNotEqualTo:[NSNumber numberWithInt:0]];
     }];
    
    // invalid!([0, 0.0])
    OMAssertValuesAreInvalid(([NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithDouble:0.0], nil]), @"must not be equal to 0");
    
    // valid!([-1, 42])
    OMAssertValuesAreValid(([NSArray arrayWithObjects:[NSNumber numberWithInt:-1], [NSNumber numberWithInt:42], nil]));
}



- (void)testValidatesNumericalityWithBlock
{
    // Topic.send(:define_method, :min_approved, lambda { 5 })
    OMNumericalityValidatorNumberBlock block = ^NSNumber *(id topic)
    {
        return [NSNumber numberWithInt:5];
    };

    // Topic.validates_numericality_of :approved, :greater_than_or_equal_to => Proc.new {|topic| topic.min_approved }
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setGreaterThanOrEqualToBlock:block];
     }];

    // invalid!([3, 4])
    OMAssertValuesAreInvalid(([NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithDouble:4], nil]), @"must be greater than or equal to 5");

    // valid!([5, 6])
    OMAssertValuesAreValid(([NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:6], nil]));
}



- (void)testValidatesNumericalityWithMethodInBlock
{
    // Topic.send(:define_method, :max_approved, lambda { 5 })
    // Topic.validates_numericality_of :approved, :less_than_or_equal_to => :max_approved
    OMNumericalityValidatorNumberBlock block = ^NSNumber *(id topic)
    {
        return [topic maxApproved];
    };
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setLessThanOrEqualTo:block];
     }];
    
    // invalid!([6])
    OMAssertValuesAreInvalid(([NSArray arrayWithObject:[NSNumber numberWithInt:6]]), @"");
    
    // valid!([4, 5])
    OMAssertValuesAreValid(([NSArray arrayWithObjects:[NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil]));
}



- (void)testValidatesNumericalityWithNumericMessage
{
    // Topic.validates_numericality_of :approved, :less_than => 4, :message => "smaller than %{count}"
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setLessThan:[NSNumber numberWithInt:4]];
         [myValidator setMessage:@"smaller than %{count}"];
     }];

    // topic = Topic.new("title" => "numeric test", "approved" => 10)
    Topic *topic = [[Topic alloc] init];
    [topic setTitle:@"numeric test"];
    [topic setApproved:[NSNumber numberWithInt:10]];
    
    // assert !topic.valid?
    // assert_equal ["smaller than 4"], topic.errors[:approved]
    OMAssertModelIsInvalid(topic, @"smaller than 4", [NSArray arrayWithObject:@"approved"]);
    [topic release];
    

    // Topic.validates_numericality_of :approved, :greater_than => 4, :message => "greater than %{count}"
    [Topic validatesNumericalityOf:@"approved" withBlock:^void (OMValidator *validator)
     {
         OMNumericalityValidator *myValidator = (OMNumericalityValidator *)validator;
         [myValidator setGreaterThan:[NSNumber numberWithInt:4]];
         [myValidator setMessage:@"bigger than %{count}"];
     }];
    
    // topic = Topic.new("title" => "numeric test", "approved" => 1)
    topic = [[Topic alloc] init];
    [topic setTitle:@"numeric test"];
    [topic setApproved:[NSNumber numberWithInt:1]];

    // assert !topic.valid?
    // assert_equal ["greater than 4"], topic.errors[:approved]
    OMAssertModelIsInvalid(topic, @"bigger than 4", [NSArray arrayWithObject:@"approved"]);
    [topic release];
}



@end
