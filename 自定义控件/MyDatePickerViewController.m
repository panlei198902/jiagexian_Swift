//
//  MyDatePickerViewController.m
//  Test2
//
//  Created by tonyguan on 13-1-25.
//  Copyright (c) 2013年 eorient. All rights reserved.
//

#import "MyDatePickerViewController.h"

@interface MyDatePickerViewController ()

@end

@implementation MyDatePickerViewController

- (id)init
{
    
    NSBundle* resourcesBundle = [NSBundle bundleForClass:[MyDatePickerViewController class]];
    self = [super initWithNibName:@"MyDatePickerViewController" bundle:resourcesBundle];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) showInView:(UIView*)superview
{
    if (!self.view.superview) {
        [superview addSubview:self.view];
    }
    
    self.view.center =  CGPointMake(self.view.center.x, 900);
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, superview.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.3
                          delay:0.3
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.view.center =  CGPointMake(superview.center.x,superview.frame.size.height - self.view.frame.size.height/2);
                         
                     } completion:nil];
}

-(void) hideInView
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.view.center =  CGPointMake(self.view.center.x, 900);
                         
                     } completion:nil];
}

- (IBAction)done:(id)sender {
    [self hideInView];
    [self.delegate myPickDateViewControllerDidFinish:self andSelectedDate:_datePickerView.date];
}

- (IBAction)cancel:(id)sender {
    [self hideInView];
}

@end
