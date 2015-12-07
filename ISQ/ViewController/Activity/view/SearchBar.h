//
//  SearchBar.h
//  WonderfulDrama
//
//  Created by iOS on 14/11/21.
//  Copyright (c) 2014年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^searchBlock)(NSString *text);

@interface SearchBar : UISearchBar <UISearchBarDelegate>

@property (nonatomic, strong)searchBlock searchBlock;

+ (instancetype) shareSearchBar;

@end
