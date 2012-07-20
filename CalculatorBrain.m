//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Alexandre Bulté on 11/07/12.
//  Copyright (c) 2012 Bulte.net. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operands;
@end

@implementation CalculatorBrain

@synthesize operands = _operands;

- (NSMutableArray *)operands
{
    if (!_operands) {
        _operands = [[NSMutableArray alloc] init ];
    }
    return _operands;
}

- (double)popOperand
{
    NSNumber *lastOperand = [self.operands lastObject];
    if (lastOperand) [self.operands removeLastObject];
    return [lastOperand doubleValue];
}

- (void)pushOperand:(double)operand
{
    [self.operands addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"/"]) {
        double secondOperand = [self popOperand];
        if (secondOperand) result = [self popOperand] / secondOperand;
    } else if ([operation isEqualToString:@"-"]) {
        double secondOperand = [self popOperand];
        result = [self popOperand] - secondOperand;
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
    } else if ([operation isEqualToString:@"Pi"]) {
        result = 3.14116;
    }

    [self pushOperand:result];
    
    return result;
}

- (void)clearStack
{
    self.operands = nil;
}


@end
