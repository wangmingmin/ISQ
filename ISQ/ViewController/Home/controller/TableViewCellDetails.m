//
//  TableViewCellDetails.m
//  chuanwanList
//
//  Created by 123 on 16/3/11.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "TableViewCellDetails.h"
#import <CoreText/CTStringAttributes.h>

@interface TableViewCellDetails ()
@property (weak, nonatomic) IBOutlet UILabel *detailsNews;
@end

@implementation TableViewCellDetails

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDetailsMessage:(NSString *)detailsMessage
{
    self.detailsNews.text = [NSString stringWithFormat:@"%@",detailsMessage];

    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.detailsNews.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [paragraphStyle1 setFirstLineHeadIndent:30];
    
    long number = 2.0f;//字间隔
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString1 addAttribute:(id)kCTKernAttributeName value:(__bridge id _Nonnull)(num) range:NSMakeRange(0,[attributedString1 length])];
    CFRelease(num);
    
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.detailsNews.text length])];
    [self.detailsNews setAttributedText:attributedString1];
    [self.detailsNews sizeToFit];

}
@end
