//
//  TestViewViewController.m
//  MCJSActive
//
//  Created by marco chen on 2016/12/2.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lblTitle.text = [NSString stringWithFormat:@"传过来的string值:%@\n传过来的integer值:%zd",self.dataString,self.dataInteger];

}
- (IBAction)buttonOnClickBack:(id)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
