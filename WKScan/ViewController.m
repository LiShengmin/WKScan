//
//  ViewController.m
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import "ViewController.h"
#import "ScanManager.h"

@interface ViewController () <UITableViewDataSource, ScanDeviceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@property (nonatomic, strong) NSMutableArray<DeviceEntity *> * dataSource;

@property (nonatomic, strong) ScanManager *scanManager;
//@property (nonatomic, strong)

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    _tableView.dataSource =self;
    
    _scanManager = [ScanManager manager];
    _scanManager.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)beginBtnAction:(UIButton *)sender {
    [_scanManager statrScan];
}
- (IBAction)clearBtnAction:(id)sender {
    [_scanManager stopScan];
    [_dataSource removeAllObjects];
    [_tableView reloadData];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 50)];
    NSString * title = [NSString stringWithFormat:@"%@", _dataSource[indexPath.row].name];
    label.text = title;
    [cell addSubview:label];

    UILabel * ipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 375, 50)];
    ipLabel.text = _dataSource[indexPath.row].ip;
    [cell addSubview:ipLabel];
    return cell;
}

#pragma mark- ScanDeviceDelegate
- (void)scanManager:(ScanManager *)manager upDateWithAllDevice:(NSArray<DeviceEntity *> *)devices {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:devices];
    [self.tableView reloadData];
}
@end
