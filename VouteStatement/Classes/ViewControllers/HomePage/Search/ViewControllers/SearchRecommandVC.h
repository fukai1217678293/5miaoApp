//
//  SearchRecommandVC.h
//  VouteStatement
//
//  Created by 付凯 on 2017/3/7.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^DidSelectItemHandle)(NSString *title);

@interface SearchRecommandVC : BaseViewController

@property (nonatomic,strong)UITableView         *tableView;

@property (nonatomic,copy)DidSelectItemHandle selectedRowHandle;

@property (nonatomic,strong)UIViewController    *presentationViewController;

- (void)tableViewReloadDataWithSource:(NSArray *)results;


@end
