//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Alexandre Bulté on 11/07/12.
//  Copyright (c) 2012 Bulte.net. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

/*** Getters ***/

- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init ];
    }
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

/*** Class methods ***/

+ (NSString *)descriptionOfProgram:(id)program
{
    //TODO
    NSString *description = @"TODO";
    return description;

}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"/"]) {
            double secondOperand = [self popOperandOffProgramStack:stack];
            if (secondOperand) result = [self popOperandOffProgramStack:stack] / secondOperand;
        } else if ([operation isEqualToString:@"-"]) {
            double secondOperand = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - secondOperand;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"Pi"]) {
            result = 3.14116;
        }
    }
    
    return result;
}


+ (double)runProgram:(id)program;
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}


/*** Instance methods ***/

- (double)popOperand
{
    NSNumber *lastOperand = [self.programStack lastObject];
    if (lastOperand) [self.programStack removeLastObject];
    return [lastOperand doubleValue];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}


- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

- (void)clearStack
{
    self.programStack = nil;
}


@end
