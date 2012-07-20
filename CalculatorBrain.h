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
- (double)performOperation:(NSString *)operation;
- (void)clearStack;

// Class Methods
@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

@end
