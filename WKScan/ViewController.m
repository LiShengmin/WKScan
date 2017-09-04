//
//  ViewController.m
//  WKScan
//
//  Created by 李盛民 on 2017/8/31.
//  Copyright © 2017年 李盛民. All rights reserved.
//

#import "ViewController.h"
#import "ScanManager.h"

@interface ViewController () <UITableViewDataSource>
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
    [_scanManager getScanDeviceWithDLNA:^(DeviceEntity *device) {
        [self.dataSource addObject:device];
        [self.tableView reloadData];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)beginBtnAction:(UIButton *)sender {
    [_scanManager statrScan];

    
}
- (IBAction)clearBtnAction:(id)sender {
    [_dataSource removeAllObjects];
    [_scanManager stopScan];
    [_scanManager statrScan];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = _dataSource[indexPath.row].name;
    return cell;
}
@end
