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

+ (BOOL)isOperation:(NSString *)string;
+ (BOOL)isSingleOperandOperation:(NSString *)string;
+ (BOOL)isDoubleOperandOperation:(NSString *)string;
+ (BOOL)isNoOperandOperation:(NSString *)string;
+ (NSString *)descriptionOfTopOfStack:(id)stack;

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

+ (BOOL)isOperation:(NSString *)string
{
    if ([CalculatorBrain isSingleOperandOperation:string] || 
        [CalculatorBrain isDoubleOperandOperation:string] ||
        [CalculatorBrain isNoOperandOperation:string])
        return TRUE;
    else return FALSE;
}

+ (BOOL)isNoOperandOperation:(NSString *)string
{
    NSArray *operations = [[NSArray alloc] initWithObjects:@"Pi", @"cos", @"sin", nil];
    
    if ([operations containsObject:string]) return TRUE;
    else return FALSE;
}

+ (BOOL)isSingleOperandOperation:(NSString *)string
{
    NSArray *operations = [[NSArray alloc] initWithObjects:@"sqrt", @"cos", @"sin", nil];
    
    if ([operations containsObject:string]) return TRUE;
    else return FALSE;
}

+ (BOOL)isDoubleOperandOperation:(NSString *)string;
{
    NSArray *operations = [[NSArray alloc] initWithObjects:@"+", @"-", @"/",@"*", nil];
    
    if ([operations containsObject:string]) return TRUE;
    else return FALSE;    
}

/*** Class methods ***/

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

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        // iterate through stack and replace variables by their values
        for (id programElement in program) {
            // is a number, just build the stack
            if ([programElement isKindOfClass:[NSValue class]]) {
                [stack addObject:programElement];
            }
            else if ([programElement isKindOfClass:[NSString class]]) {
                // ignore operations strings
                if (![CalculatorBrain isOperation:programElement]) {
                    NSValue *variableValue = [variableValues valueForKey:programElement];
                    if (!variableValue) variableValue = 0;
                    [stack addObject:variableValue];
                }
                else {
                    [stack addObject:programElement];
                }
            }
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program;
{
    NSDictionary *variableValues;
    NSLog(@"Variables : %@", [CalculatorBrain variablesUsedInProgram:program]);
    NSLog(@"Description : %@",[CalculatorBrain descriptionOfProgram:program]);
    return [self runProgram:program usingVariableValues:variableValues];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        for (id programElement in program) {
            if ([programElement isKindOfClass:[NSString class]]) {
                if (![CalculatorBrain isOperation:programElement]) {
                    [variables addObject:programElement];
                }
            }
        }
    }
    //return [[NSSet alloc] initWithSet:variables];
    if ([variables count] > 0) return [variables copy];
    else return nil;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString  *topDescription = @"";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSString class]]) {
        if ([CalculatorBrain isSingleOperandOperation:topOfStack]) {
            NSString *lastValue = [CalculatorBrain descriptionOfTopOfStack:stack];
            topDescription = [NSString stringWithFormat:@"%@(%@)", topOfStack, lastValue];
        }
        else if ([CalculatorBrain isDoubleOperandOperation:topOfStack]) {
            NSString *lastValue = [CalculatorBrain descriptionOfTopOfStack:stack];
            NSString *beforeLastValue = [CalculatorBrain descriptionOfTopOfStack:stack];
            topDescription = [NSString stringWithFormat:@"(%@ %@ %@)", beforeLastValue, topOfStack, lastValue];            
        }
        else if ([CalculatorBrain isNoOperandOperation:topOfStack]) {
            topDescription = topOfStack;
        }
    }
    // return value as string
    else if ([topOfStack isKindOfClass:[NSNumber class]]){
        topDescription = [NSString stringWithFormat:@"%@", topOfStack];
    }
    return topDescription;
}


// displays (3 + 3) * 5

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString *description = [[NSString alloc] init];
    NSMutableArray *stack = [program mutableCopy];
    description = [CalculatorBrain descriptionOfTopOfStack:stack];
    // remove extra ( )
    description = [description stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    description = [description stringByReplacingCharactersInRange:NSMakeRange([description length]-1, 1) withString:@""];
    return description;
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
