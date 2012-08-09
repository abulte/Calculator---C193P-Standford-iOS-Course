//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Alexandre Bulté on 09/07/12.
//  Copyright (c) 2012 Bulte.net. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsEnteringANumber;
@property (nonatomic) BOOL hasEnteredDot;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsEnteringANumber = _userIsEnteringANumber;
@synthesize hasEnteredDot = _hasEnteredDot;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (NSDictionary *)testVariableValues
{
    if(!_testVariableValues) _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2], @"x", [NSNumber numberWithInt:5], @"y", [NSNumber numberWithInt:7], @"y", [NSNumber numberWithInt:19], @"foo",nil];
    
    return _testVariableValues;
}

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsEnteringANumber) {
        if (![sender.currentTitle isEqualToString:@"."] || !self.hasEnteredDot) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    } else {
        self.display.text = digit;
        self.userIsEnteringANumber = YES;
    }
    if ([sender.currentTitle isEqualToString:@"."]) {
        self.hasEnteredDot = YES;
    }
}

- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushVariable:sender.currentTitle];
    self.userIsEnteringANumber = NO;
    self.hasEnteredDot = NO;
    self.history.text = [CalculatorBrain descriptionOfProgram:[[self brain] program]];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsEnteringANumber = NO;
    self.hasEnteredDot = NO;
    self.history.text = [CalculatorBrain descriptionOfProgram:[[self brain] program]];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsEnteringANumber){
        [self enterPressed];
    }
    double result = [self.brain performOperation:sender.currentTitle withVariables:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.history.text = [CalculatorBrain descriptionOfProgram:[[self brain] program]];
}

- (IBAction)clearPressed {
    // vider la stack
    [self.brain clearStack];
    // vider l'affichage
    self.display.text = @"0";
    // vider l'historique
    self.history.text = @"";
    // reset states
    self.userIsEnteringANumber = NO;
    self.hasEnteredDot = NO;
}

@end
