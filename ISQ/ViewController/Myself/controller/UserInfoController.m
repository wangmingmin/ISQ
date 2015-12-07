//
//  UserInfoController.m
//  ISQ
//
//  Created by mac on 15-4-2.
//  Copyright (c) 2015年 cn.ai-shequ. All rights reserved.
//

#import "UserInfoController.h"
#import "UserInfoCell.h"
#import "ChangenfoConroller.h"
#import "AppDelegate.h"
#import "RequestPostUploadHelper.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "caneditCell.h"
#import "CannotEditCell.h"
#import "sexCell.h"
#import "signCell.h"

@interface UserInfoController (){
    UIImage *userPhotos;
    AppDelegate *userinfoDelegate;
    MBProgressHUD *HUD;
    EGOCache *theCahe;
    BOOL isChooseImg;
    NSString *theNowTime;
    BOOL isClick;
    NSString *value;
    UITextField *nicknameTextField;
    UIView *clickView;
    caneditCell *editCell;
    signCell *signcell;
    sexCell *sexChoosecell;
    NSDictionary *returnString;
}

@end

NSString *TMP_UPLOAD_IMG_PATH=@"";
@implementation UserInfoController
@synthesize InfoDetailTableview;


-(void)setMyPalce:(NSArray *)oldMyPalce{
    
    
    if (_myPalce!=oldMyPalce) {
        
        _myPalce=oldMyPalce;
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    isClick = NO;
    isChooseImg = NO;
    
    value = ([user_info objectForKey:userGender] ? [NSString stringWithFormat:@"%@",[user_info objectForKey:userGender]] :@"0");
    
    
    clickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    clickView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    [clickView addGestureRecognizer:tapGesture];
    [self.InfoDetailTableview addSubview:clickView];
    clickView.hidden = YES;
    //状态栏字体颜色
    [[ UIApplication sharedApplication ] setStatusBarStyle : UIStatusBarStyleDefault ];
    self.tabBarController.tabBar.hidden=YES;
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, 44, 44);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = item;
    
    userinfoDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    theCahe=[[EGOCache alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.InfoDetailTableview reloadData];
    
}

#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 120;
    }else if (indexPath.row==1){
        return 6;
    }    
    return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
         UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoCell1" forIndexPath:indexPath];
        if([user_info objectForKey:MYSELFHEADNAME]&&!isChooseImg){
            
            NSURL *imgUrl=[[NSURL alloc]initWithString:[user_info objectForKey:MYSELFHEADNAME]];
            [cell.userInfoImg setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"personalData"]];
            [cell.uploadPhoto addTarget:self action:@selector(uploadPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.userInfoImg.canClick=YES;

        }else if(isChooseImg){
            
            cell.userInfoImg.image = userPhotos;
            
        }else{
            
            cell.userInfoImg.image = [UIImage imageNamed:@"defuleImg"];
            
        }
        cell.layer.borderWidth=0.5f;
        cell.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        return cell;
        
    }else if (indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"intervalCell" forIndexPath:indexPath];
        
        cell.layer.borderWidth=0.5f;
        cell.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;

        return cell;
       
    }else if (indexPath.row == 2){
        
        editCell = [tableView dequeueReusableCellWithIdentifier:@"caneditCell" forIndexPath:indexPath];
        editCell.changeTextField.delegate = self;
        editCell.nameLabel.text = @"昵称";
        if ([user_info objectForKey:userNickname]) {
             editCell.changeTextField.text = [user_info objectForKey:userNickname];
            
        }else{
        
            editCell.changeTextField.text = @"输入昵称";
        }

        editCell.layer.borderWidth=0.5f;
        editCell.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;

        return editCell;
    
    }else if (indexPath.row == 4 || indexPath.row == 6){
        
        CannotEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cannoteditcell" forIndexPath:indexPath];
        if (indexPath.row == 4) {
            cell.nameLabel.text = @"手机号";
            if ([user_info objectForKey:userAccount]) {
                cell.detailLabel.text = [user_info objectForKey:userAccount];
            }
            
        }else if (indexPath.row == 6){
            cell.nameLabel.text = @"所在地址";
            if ([user_info objectForKey:saveCommunityName]) {
                
                cell.detailLabel.text = userinfoDelegate.theAddress;
            }else{
            
                cell.detailLabel.text = @"您还未选择所在社区";
            }
        }
        cell.layer.borderWidth=0.5f;
        cell.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        return cell;
        
    }else if (indexPath.row == 5){
        signcell = [tableView dequeueReusableCellWithIdentifier:@"signcell" forIndexPath:indexPath];
        signcell.nameLabel.text = @"签名";
        signcell.signTextfield.delegate=self;
        if ([user_info objectForKey:userIntro]) {
            
            signcell.signTextfield.text = [user_info objectForKey:userIntro];
        }else{
            signcell.signTextfield.placeholder = @"";
        }
        
       
        
        signcell.layer.borderWidth=0.5f;
        signcell.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        return signcell;
    }
    
    sexChoosecell = [tableView dequeueReusableCellWithIdentifier:@"sexcell"];
    if ([value isEqualToString:@"0"]) {
        sexChoosecell.manLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
        sexChoosecell.womanLabel.textColor = [UIColor blackColor];
        sexChoosecell.segmentControl.selectedSegmentIndex=0;
        
    }else if ([value isEqualToString:@"1"]){
    
        sexChoosecell.womanLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar_blue"]];
        sexChoosecell.manLabel.textColor = [UIColor blackColor];
        sexChoosecell.segmentControl.selectedSegmentIndex=1;
    }
    
    sexChoosecell.layer.borderWidth=0.5f;
    sexChoosecell.layer.borderColor=[[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    
    return sexChoosecell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [menu showInView:self.view];
    }
}

#pragma mark - saveData 昵称

- (void)changeHttpClink:(NSString*)str{

    
    [self showHudInView:self.view hint:@"正在处理..."];
    
    //用户信息缓存器
    NSString *http=[requestTheCodeURL stringByAppendingString:@"changeproperty"];
    NSDictionary *arry=@{@"phone":[user_info objectForKey:userAccount],@"pnum":@"1",@"pv":str};
    [ISQHttpTool getHttp:http contentType:nil params:arry success:^(id resposeObject) {
        
        returnString = [NSJSONSerialization JSONObjectWithData:resposeObject options:NSJapaneseEUCStringEncoding  error:nil];
        NSInteger numIndexSelect = sexChoosecell.segmentControl.selectedSegmentIndex;
        [self changeSexHttpClink:[NSString stringWithFormat:@"%ld",(long)numIndexSelect]];
        
    } failure:^(NSError *erro) {
       
        [self hideHud];
        [self warning2:@"保存失败，请检查您当前网络!"];
        
    }];
}

#pragma mark - saveData 性别

- (void)changeSexHttpClink:(NSString*)str{
    
    //用户信息缓存器
    NSString *http=[requestTheCodeURL stringByAppendingString:@"changeproperty"];
    NSDictionary *arry=@{@"phone":[user_info objectForKey:userAccount],@"pnum":@"5",@"pv":str};
    [ISQHttpTool getHttp:http contentType:nil params:arry success:^(id resposeObject) {
        
        returnString = [NSJSONSerialization JSONObjectWithData:resposeObject options:NSJapaneseEUCStringEncoding  error:nil];
        
       
        //签名
        [self changeSignatureHttpClink:signcell.signTextfield.text];
        
        
        
    } failure:^(NSError *erro) {
        [self hideHud];
        [self warning2:@"性别、签名修改失败！"];
        
    }];
}

#pragma mark - saveData 签名

- (void)changeSignatureHttpClink:(NSString*)str{
    
    //用户信息缓存器
    NSString *http=[requestTheCodeURL stringByAppendingString:@"changeproperty"];
    NSDictionary *arry=@{@"phone":[user_info objectForKey:userAccount],@"pnum":@"4",@"pv":str};
    [ISQHttpTool getHttp:http contentType:nil params:arry success:^(id resposeObject) {
        
        returnString = [NSJSONSerialization JSONObjectWithData:resposeObject options:NSJapaneseEUCStringEncoding  error:nil];
                
        //更改一次信息，重新获取一次
        AppDelegate *delget=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delget ToObtainInfo:@""];
        [self hideHud];
        
    } failure:^(NSError *erro) {
        [self hideHud];
        [self warning2:@"签名修改失败！"];
        
    }];
}


//保存
- (void)saveAction:(UIButton *)sender{

    [self changeHttpClink:editCell.changeTextField.text];
}


#pragma mark - click

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        [self snapImage];
        
    }else if(buttonIndex==1){
        
        [self pickImage];
    }
}


- (void)resignKeyboard:(UIGestureRecognizer *)sender{

    [self.InfoDetailTableview endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
}


- (void)uploadPhotoAction:(UIButton *)sender{

    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];

}

#pragma mark - 键盘通知

- (void)showKeyboard:(NSNotification *)notification{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    clickView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    if (width < 375) {
        
        self.InfoDetailTableview.frame = CGRectMake(0, -140, UISCREENWIDTH, UISCREENHEIGHT);
    }
    
     [UIView commitAnimations];
}


- (void)hideKeyboard:(NSNotification *)notificaiton{

    clickView.hidden = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    self.InfoDetailTableview.frame = CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT);
    [UIView commitAnimations];

}


//拍照
- (void) snapImage{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未发现相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
    }
    
}

//从相册里找
- (void) pickImage{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:picker animated:YES completion:^{
        }];
    }
}


//完成拍照
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    //获取当前时间
    [self getCurrentTime];
    
    isChooseImg=YES;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImg=[self imageWithImageSimple:image scaledToSize:CGSizeMake(150, 150)];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [self saveImage:newImg WithName:[NSString stringWithFormat:@"%@%@%@",[user_info objectForKey:userIsqCode],theNowTime,@".jpg"]];
    
    [self onPostData];
}

//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"取消拍照");
}

-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    userPhotos=tempImage;
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    TMP_UPLOAD_IMG_PATH=fullPathToFile;
    [imageData writeToFile:fullPathToFile atomically:NO];

    [self.InfoDetailTableview reloadData];
}

//上传头像
-(void)onPostData{
    NSMutableDictionary *dir=[NSMutableDictionary dictionaryWithCapacity:7];
    NSString *url=[NSString stringWithFormat:@"%@?name=%@%@",upLoadMyImg,[user_info objectForKey:userIsqCode],theNowTime];

    if([TMP_UPLOAD_IMG_PATH isEqualToString:@""]){
        [RequestPostUploadHelper postRequestWithURL:url postParems:dir picFilePath:nil picFileName:nil];
    }else{
        
        NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
        [RequestPostUploadHelper postRequestWithURL:url postParems:dir picFilePath:TMP_UPLOAD_IMG_PATH picFileName:[nameAry objectAtIndex:[nameAry count]-1]];
        
        if ([[RequestPostUploadHelper postRequestWithURL:url postParems:dir picFilePath:TMP_UPLOAD_IMG_PATH picFileName:[nameAry objectAtIndex:[nameAry count]-1]] isEqualToString:@"YES"]) {
            
            //保存头像地址，用于发送消息时附带
            [user_info setObject:[NSString stringWithFormat:@"http://web.app.wisq.cn:8080/avatar/%@%@%@",[user_info objectForKey:userIsqCode],theNowTime,@".jpg"] forKey:MYSELFHEADNAME];
           
            [self warning2:@"上传成功！"];
            
        }
    }
}

- (IBAction)myInfoBack_bt:(id)sender {
    //状态栏字体颜色
    [[ UIApplication sharedApplication ] setStatusBarStyle : UIStatusBarStyleLightContent ];

    self.tabBarController.tabBar.hidden=NO;
    UIImage *image = [UIImage imageNamed:@"topBar_blue.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES ];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)warning2:(NSString *)warString2{
    
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode=MBProgressHUDModeText;
    
    HUD.labelText =[NSString stringWithFormat:@"%@",warString2];
    HUD.margin = 8.f;
    HUD.removeFromSuperViewOnHide = YES;
    
    [HUD hide:YES afterDelay:1.5];
    
    
}


-(void)getCurrentTime{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
     NSDate *datenow = [NSDate date];
    
    theNowTime = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

}



@end
