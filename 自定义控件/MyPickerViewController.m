//
//  MyPickerViewController.m
//  JiaGeXian4iPhone
//
//  Created by tonyguan on 13-1-25.
//  Copyright (c) 2013年 eorient. All rights reserved.
//

#import "MyPickerViewController.h"

@interface MyPickerViewController ()

@end

@implementation MyPickerViewController

- (id)init
{
    NSBundle* resourcesBundle = [NSBundle bundleForClass:[MyPickerViewController class]];
    self = [super initWithNibName:@"MyPickerViewController" bundle:resourcesBundle];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pickerData = [NSArray arrayWithObjects:
                     @"价格不限",
                     @"￥0-->￥1000 元/天",
                     @"￥1000-->￥2000 元/天",
                     @"￥2000-->￥3000 元/天",
                     @"￥3000-->￥5000 元/天", nil];    
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
    int selectedIndex = [_picker selectedRowInComponent:0];
    [self.delegate myPickViewClose: [_pickerData objectAtIndex:selectedIndex ]];
}

- (IBAction)cancel:(id)sender {
    [self hideInView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark 实现协议UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [_pickerData objectAtIndex:row];
}


#pragma mark 实现协议UIPickerViewDataSource方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
        numberOfRowsInComponent:(NSInteger)component {
	return [_pickerData count];
}




@end
