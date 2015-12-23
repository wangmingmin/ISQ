//
//  ChekMyHelpController.m
//  ISQ
//
//  Created by mac on 15-6-13.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "ChekMyHelpController.h"
#import "LocalTableViewCell.h"

@interface ChekMyHelpController ()<UITableViewDataSource,UITableViewDelegate>{
    
    
    LocalTableViewCell *cell;
}

@end

@implementation ChekMyHelpController
@synthesize myHelpTableview;


-(void)setChekHelpData:(NSArray *)oldChekHelpData{
    
    if (_chekHelpData!=oldChekHelpData) {
        
        _chekHelpData=oldChekHelpData;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==3) {
        return 10;
    }else if(indexPath.row==5 ){
        
        
        return 270;
    }
    
    return 54;
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0||indexPath.row==1||indexPath.row==2||indexPath.row==4) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"sendHelpCell1" forIndexPath:indexPath];
        
        if (indexPath.row==0) {
            cell.sendHelplable1.text=@"我的姓名";
            cell.chekLable.text=_chekHelpData[0];

            
        }else if(indexPath.row==1){
            cell.sendHelplable1.text=@"联系方式";
            cell.chekLable.text=_chekHelpData[1];
            
            
            
        }else if(indexPath.row==2){
            cell.sendHelplable1.text=@"详细地址";
            cell.chekLable.text=_chekHelpData[2];
            
        }else if(indexPath.row==4){
            cell.sendHelplable1.text=@"受 理 人";
            cell.chekLable.text=_chekHelpData[3];
        }
       
        
    }
    else if(indexPath.row==5){
        cell=[tableView dequeueReusableCellWithIdentifier:@"sendHelpCell3" forIndexPath:indexPath];
        cell.sendHelplableDetail_tv.font = [UIFont systemFontOfSize:17];
        cell.sendHelplableDetail_tv.text=_chekHelpData[5];
    }
    
    else if (indexPath.row==3){
        cell=[tableView dequeueReusableCellWithIdentifier:@"sendHelpCell2" forIndexPath:indexPath];
    }
    
    if (indexPath.row==0||indexPath.row==2||indexPath.row==4) {
        cell.layer.borderColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.5f].CGColor;
        cell.layer.borderWidth=0.5f;
    }
    
    return cell;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back_bt:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
