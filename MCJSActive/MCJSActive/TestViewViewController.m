//
//  TestViewViewController.m
//  MCJSActive
//
//  Created by marco chen on 2016/12/2.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import "TestViewViewController.h"

@interface TestViewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation TestViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lblTitle.text = [NSString stringWithFormat:@"传过来的string值:%@\n传过来的integer值:%zd",self.dataString,self.dataInteger];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
