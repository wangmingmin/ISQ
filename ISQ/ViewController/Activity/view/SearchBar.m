//
//  SearchBar.m
//  WonderfulDrama
//
//  Created by iOS on 14/11/21.
//  Copyright (c) 2014年 Vincent. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.placeholder = @"请输入活动关键字";
        self.contentMode = UIViewContentModeCenter;
        self.tintColor = [UIColor grayColor];
        self.barStyle = UIBarStyleDefault;
    }
    return self;
}

+ (instancetype) shareSearchBar{
    static SearchBar *_searchBar=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _searchBar = [[self alloc] init];
        _searchBar.frame = CGRectMake(-60, 0, 280, 38);
    });
    return _searchBar;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    if ([searchBar.text isEqualToString:@""] || searchBar.text == nil) {
       
    }
    if (self.searchBlock) {
        self.searchBlock(searchBar.text);
    }
    [self resignFirstResponder];
}

@end
