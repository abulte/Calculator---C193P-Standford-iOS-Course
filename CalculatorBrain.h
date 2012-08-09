//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Alexandre Bulté on 11/07/12.
//  Copyright (c) 2012 Bulte.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorBrain : NSObject

// Instance Methods
- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)operand;
- (double)performOperation:(NSString *)operation withVariables:(NSDictionary *)variables;
- (void)clearStack;

// Class Methods
// programmable feature
@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
