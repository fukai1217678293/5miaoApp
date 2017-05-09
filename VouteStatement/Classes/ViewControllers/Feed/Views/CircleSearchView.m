//
//  CircleSearchView.m
//  VouteStatement
//
//  Created by 付凯 on 2017/4/29.
//  Copyright © 2017年 韫安. All rights reserved.
//

#import "CircleSearchView.h"
#import "LimitLengthTextField.h"
#import "QZSearchApiManager.h"
#import "PublishFeedReformer.h"
#import "QZSearchResultTableViewCell.h"

static NSString *const cellIdentifier = @"cellIdentifier";
@interface CircleSearchView ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,VTAPIManagerCallBackDelegate,VTAPIManagerParamSource>

@property (nonatomic,strong)LimitLengthTextField *searchTF;
@property (nonatomic,strong)UITableView *resultTableView;
@property (nonatomic,strong)UIView *searchHeaderView;
@property (nonatomic,strong)NSMutableArray <QZSearchResultModel *>*resultList;
@property (nonatomic,strong)QZSearchApiManager *searchApiManager;
@end

@implementation CircleSearchView
- (instancetype)initWithResultList:(NSArray *)resultList text:(NSString *)text{
    if (self = [super init]) {
        [self setup];
        self.resultList = [resultList mutableCopy];
        [self.resultTableView reloadData];
        if (text.length) {
            self.searchTF.text = text;
        }
    }
    return self;
}
- (instancetype)initWithText:(NSString *)text {
    if (self = [super init]) {
        [self setup];
        if (text.length) {
            self.searchTF.text = text;
        }
    }
    return self;
}
- (void)setup {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextDidChanged:) name:UITextFieldTextDidChangeNotification object:_searchTF];
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.searchHeaderView];
    [self.searchHeaderView addSubview:self.searchTF];
    [self insertSubview:self.resultTableView belowSubview:self.searchHeaderView];
    [self.searchTF becomeFirstResponder];
}
- (void)reloadTableViewWithDataSource:(NSArray *)dataSource {
    self.resultList = [dataSource mutableCopy];
    [self.resultTableView reloadData];
    if (!dataSource.count) {
        [self hidden];
    }
}
- (void)searchTextDidChanged:(NSNotification *)notic {
    if (notic.object == _searchTF) {
//        if (_searchTF.text.length) {
//            [self.searchApiManager loadData];
//        } else {
//            [self.searchApiManager cancelAllRequest];
//            [self.resultList removeAllObjects];
//            [self.resultTableView reloadData];
//            [self hiddenWithInput];
//        }
        
        if (self.textDidChangeHandle) {
            self.textDidChangeHandle(_searchTF.text);
        }
        if (!_searchTF.text.length) {
            [self hidden];
        }
    }
}
#pragma mark --VTAPIManagerParamSource
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    return @{@"q":_searchTF.text};
}
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    NSArray *resultArray = [manager fetchDataWithReformer:[PublishFeedReformer new]];
    if (!resultArray.count) {
        [self hiddenWithInput];
    }
    self.resultList = [resultArray mutableCopy];
    if (_resultTableView) {
        [_resultTableView reloadData];
    }
}
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    
}
- (void)hiddenWithModel:(QZSearchResultModel *)model {
    if (self.hiddenActionHandle) {
        self.hiddenActionHandle(model);
    }
    [self hidden];
}
- (void)hiddenWithInput{
    if (self.hiddenActionHandle) {
        QZSearchResultModel *model = [[QZSearchResultModel alloc] init];
        model.circle_name = _searchTF.text;
        model.hash_name = @"";
        self.hiddenActionHandle(model);
    }
    [self hidden];
}
- (void)hidden {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setHidden:YES];
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QZSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.dataModel = self.resultList[indexPath.row];
    return cell;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    _searchTF.text = self.resultList[indexPath.row].circle_name;
    if (self.searchViewDidSelectedCircleHandle) {
        self.searchViewDidSelectedCircleHandle(self.resultList[indexPath.row]);
    }
    [self hidden];
//    [self hiddenWithModel:self.resultList[indexPath.row]];
}
#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self hiddenWithInput];
    [self hidden];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    [self hiddenWithInput];
    return YES;
}
- (void)setText:(NSString *)text {
    _text = text;
    _searchTF.text = text;
    [_searchTF becomeFirstResponder];
}
#pragma mark -- getter
- (UIView *)searchHeaderView {
    if (!_searchHeaderView) {
        _searchHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 60)];
        _searchHeaderView.backgroundColor = [UIColor whiteColor];
        //add bottom shadow layer
        CALayer *layer = [_searchHeaderView layer];
        [layer setShadowColor:[[UIColor colorWithRed:225.0/255.0 green:226.0/255.0 blue:228.0/255.0 alpha:1] CGColor]];
        [layer setShadowOffset:CGSizeMake(0, 2)];
        [layer setShadowOpacity:1];
        [layer setShadowRadius:1.0f];
    }
    return _searchHeaderView;
}
- (LimitLengthTextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[LimitLengthTextField alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, 60)];
        _searchTF.backgroundColor = [UIColor whiteColor];
        
        _searchTF.textColor = [UIColor colorWithHexstring:@"333333"];
        _searchTF.font = [UIFont systemFontOfSize:15];
        _searchTF.borderStyle = UITextBorderStyleNone;
        _searchTF.delegate = self;
    }
    return _searchTF;
}
- (UITableView *)resultTableView {
    if (!_resultTableView) {
        CGRect tableFrame = CGRectMake(0, _searchHeaderView.bottom, SCREEN_WIDTH,SCREEN_HEIGHT -_searchHeaderView.bottom-64);
        _resultTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        _resultTableView.backgroundColor = [UIColor colorWithHexstring:@"f5f5f5"];
        _resultTableView.tableFooterView = [UIView new];
        _resultTableView.rowHeight = 60;
        _resultTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        [_resultTableView registerClass:[QZSearchResultTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _resultTableView;
}
- (QZSearchApiManager *)searchApiManager {
    if (!_searchApiManager) {
        _searchApiManager = [[QZSearchApiManager alloc] init];
        _searchApiManager.delegate = self;
        _searchApiManager.paramsourceDelegate = self;
    }
    return _searchApiManager;
}
- (NSMutableArray <QZSearchResultModel *> *)resultList {
    if (!_resultList) {
        _resultList = [NSMutableArray arrayWithCapacity:0];
    }
    return _resultList;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
