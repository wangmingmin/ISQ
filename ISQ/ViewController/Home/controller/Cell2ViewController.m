//
//  Cell2ViewController.m
//  ISQ
//
//  Created by mac on 15-3-18.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "Cell2ViewController.h"

@interface Cell2ViewController ()

@end

@implementation Cell2ViewController
@synthesize label;
#pragma mark - Managing the detail item

-(void)setDetailItem:(id)newDetailItem{
    if (_detailItem!=newDetailItem) {
        _detailItem=newDetailItem;
        
        _theData=[self.detailItem description];
//        [self configureView];
    }
    
    
}

//-(void)configureView{
//    
//    
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.text=_theData;
    // Do any additional setup after loading the view.
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
