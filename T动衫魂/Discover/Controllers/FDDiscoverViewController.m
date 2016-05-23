//
//  FDDiscoverViewController.m
//  T动衫魂
//
//  Created by asus on 16/5/21.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import "FDDiscoverViewController.h"
#import "FDDiscoverViewCell.h"
#import "FDDiscoverModel.h"
#import "FDAddDiscoverViewController.h"
#import "FDHomeNetworkTool.h"




#define kParamIdStart   @"idstart"
#define kParamIdEnd     @"idend"
#define kStepData       30

@interface FDDiscoverViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

/**
 *  数据源，每个都是FDDiscoverModel
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  当前的IDstart
 */
@property (nonatomic, assign) NSInteger idStartNow;

/**
 *  当前的IDend
 */
@property (nonatomic, assign) NSInteger idEndNow;

@end

@implementation FDDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupViews];
    
    [self dropDownLoadMoreDiscovers];
}

- (void)setupNav
{
    self.navigationItem.title = @"买家秀";
    
    
    //添加买家秀按钮
    UIButton *rightBarBtn = [[UIButton alloc] init];
    rightBarBtn.frame = CGRectMake(0, 0, 23, 23);
    
    [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"Fav_Note_ToolBar_Camera_HL"] forState:UIControlStateNormal];
    [rightBarBtn addTarget:self action:@selector(addDiscoverClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

- (void)setupViews
{
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    
    _tableView.rowHeight = [UIScreen mainScreen].bounds.size.width*4/3;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[FDDiscoverViewCell class] forCellReuseIdentifier:kcellID];
    
    //添加约束
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //添加下拉刷新控件
    __weak typeof(self) _weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_weakSelf dropDownLoadMoreDiscovers];
    }];
    
    /**
     *  添加上拉刷新
     */
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [_weakSelf dropUpLoadMoreDiscovers];
    }];

}


/**
 *  下拉刷新最新数据
 */
- (void)dropDownLoadMoreDiscovers
{
    //封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kParamIdStart] = @1;
    params[kParamIdEnd] = [NSString stringWithFormat:@"%d", kStepData];

    //复位idstart和idend,
    self.idStartNow = kStepData;
    self.idEndNow = kStepData+kStepData;
    FDLog(@"%@", params);
    
    __weak typeof(self) _weakSelf = self;
    [FDHomeNetworkTool getDiscoversRequires:params dropUp:NO success:^(NSArray *results) {
        [_weakSelf.dataSource removeAllObjects];
        [_weakSelf.tableView reloadData];
        [_weakSelf addMoreRowForTableView:results dropUp:NO];
    } failure:^(NSArray *results) {
        
    }];
    
    [self.tableView.mj_header endRefreshing];
}

/**
 *  上拉加载更多旧数据
 */
- (void)dropUpLoadMoreDiscovers
{
    //封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.idStartNow = self.idStartNow!=0 ? self.idStartNow:1;
    self.idEndNow = self.idEndNow!=0 ? self.idEndNow:kStepData;
    params[kParamIdStart] = [NSString stringWithFormat:@"%ld", self.idStartNow];
    params[kParamIdEnd] = [NSString stringWithFormat:@"%ld", self.idEndNow];
    
    FDLog(@"%@", params);
    __weak typeof(self) _weakSelf = self;
    [FDHomeNetworkTool getDiscoversRequires:params dropUp:YES success:^(NSArray *results) {
        //获取成功，idStartNow和idEndNow增加
        _weakSelf.idStartNow += kStepData;
        _weakSelf.idEndNow += kStepData;
        [_weakSelf addMoreRowForTableView:results dropUp:YES];
    } failure:^(NSArray *results) {
        //没有获取到数据，idStartNow和idEndNow不变
    }];
    
    [self.tableView.mj_footer endRefreshing];
}

/**
 *  添加新的数据到tableview显示
 *
 *  @param array     数据
 *  @param direction YES 上拉，NO，下拉
 */
- (void)addMoreRowForTableView:(NSArray *)array dropUp:(BOOL)direction
{
    __weak typeof(self) _weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *indexRows = [[NSMutableArray alloc] init];
        
//            [insertRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//        for (NSObject *model in array) {
        for (int i=0; i<array.count; i++) {
            
            NSObject *model = array[i];
            if (direction) {  //上拉
                [_weakSelf.dataSource addObject:model];
            } else {//下拉
                [_weakSelf.dataSource insertObject:model atIndex:0];
            }
            
            FDLog(@"下面的i可能有错%ld", [_weakSelf.dataSource indexOfObject:model]);
            [indexRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [_weakSelf.tableView beginUpdates];
            //添加数据
        [_weakSelf.tableView insertRowsAtIndexPaths:indexRows withRowAnimation:UITableViewRowAnimationFade];
        
        [_weakSelf.tableView endUpdates];
    });
}


#pragma mark - uitableviewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDDiscoverModel *model = self.dataSource[indexPath.row];
    
    FDDiscoverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellID forIndexPath:indexPath];
        
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


/**
 *  懒加载
 *
 *  @return datasource
 */
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

/**
 *  发布自己的秀
 */
- (void)addDiscoverClick
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"发布自己的买家秀" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [sheet showInView:self.view];
    });
    
   
}


/**
 *  打开相册,或则相机
 *  yes  打开相册，  no 打开相机
 */
- (void)openAlbum:(BOOL)Album
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;   //系统自带的编辑框

    if (Album) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
    }

    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //打开相机
            [self openAlbum:NO];
            break;
            
        case 1:
            //打开相册
            [self openAlbum:YES];
            break;
            
            
        default:
            break;
    }
}


#pragma mark - UIImagePickerController delegate
//选择了图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    image = [image imageWithSize:CGSizeMake(320, 480) equal:NO];
    
    FDAddDiscoverViewController *vc = [[FDAddDiscoverViewController alloc] init];
 
    vc.hidesBottomBarWhenPushed = YES;
    vc.image = [image imageWithSize:CGSizeMake(960, 1280) equal:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
