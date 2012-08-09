//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Alexandre Bulté on 09/07/12.
//  Copyright (c) 2012 Bulte.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *history;
@property (weak, nonatomic) IBOutlet UILabel *variableValuesDisplay;

@end
