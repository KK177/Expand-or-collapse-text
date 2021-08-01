//
//  ViewController.m
//  LongLabelShowTestTab
//
//  Created by iiik- on 2021/7/30.
//

#import "ViewController.h"
#import <SDAutoLayout.h>
#import "YTableViewCell.h"
#import "model.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *dataArr;

@end

@implementation ViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 70;//这句必须写上值可以为自己估算的cell的高
        [_tableView registerClass:[YTableViewCell class] forCellReuseIdentifier:@"YTabCellID"];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数据源
    [self initDataSource];
    
    //初始化tableView
    [self initTab];
}

- (void)initDataSource {
    for (int i=0; i < 2; i++) {
        model *mol = [[model alloc]init];
        mol.title = @"在iOS的开发过程中，我们在进行文本展示的功能实现时，经常会遇到文本过长的情况，如果我们使用的是UITableView，那么文本在Cell中展示时如果全部展示完全的话，那么可能出现整屏只能展示一个Cell的情况。此时我们需要对多行文本进行分割，在前部分的末尾加上“展开/全文”的按钮，用户在点击此按钮后，Cell再展开进行全部文";
        mol.isOpen = NO;
        [self.dataArr addObject:mol];
    }
    model *mol = [[model alloc]init];
    mol.title = @"在iOS的开发过程中，我们在进行文本展示的功能实现时，经常会遇到文本过长的情况";
    mol.isOpen = NO;
    [self.dataArr addObject:mol];
}
- (void)initTab {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 60)
    .bottomEqualToView(self.view);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTabCellID"];
    model *mol = self.dataArr[indexPath.row];
    [cell initMol:mol];
    __weak typeof(self)weakself = self;
    cell.blk = ^ {
        model *mol = weakself.dataArr[indexPath.row];
        mol.isOpen = !mol.isOpen;
        [weakself.dataArr replaceObjectAtIndex:indexPath.row withObject:mol];
        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[weakself.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"1");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.frame.size.width tableView:tableView];
}

@end
