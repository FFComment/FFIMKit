//
//  EAMMessageListViewController.m
//  edu_anhui_messageKit
//
//  Created by yangjuanping on 2017/7/5.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "EAMMessageListViewController.h"
#import "EAMMessageListTableViewCell.h"
#import "EAMMesageChatVC.h"
//#import <FFIMKit/FFIMKit-umbrella.h>
#import "FFIMKit.h"

static const CGFloat kEAMTableCellHeight = 60.0;

@interface EAMMessageListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableChatList;
@property(nonatomic,strong)NSArray*     chatList;
@end

@implementation EAMMessageListViewController

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试";
    self.tableChatList.top = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *recipientMessageListCellIdentifier = @"recipientMessageListCellIdentifier";
    EAMMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recipientMessageListCellIdentifier];
    if (!cell) {
        cell = [[EAMMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recipientMessageListCellIdentifier];
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    EAMMessageListTableViewCell *cellListItem = (EAMMessageListTableViewCell *)cell;
    NSDictionary* item = [self.chatList objectAtIndex:indexPath.row];
    [cellListItem setItem:item];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 0.1)];
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 0.1)];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    EAMMesageChatVC* vc = [[EAMMesageChatVC alloc]initWithNibName:@"EAMMesageChatVC" bundle:[NSBundle bundleForClass:[self class]]];
    EAMMesageChatVC* vc = [[EAMMesageChatVC alloc]init];
    vc.title = @"聊天";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- setters and getters
-(UITableView*)tableChatList{
    if (!_tableChatList) {
        _tableChatList = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0, MAIN_WIDTH, MAIN_HEIGHT) style:UITableViewStyleGrouped];
        _tableChatList.rowHeight = kEAMTableCellHeight;
        _tableChatList.sectionHeaderHeight = 0.1;
        _tableChatList.sectionFooterHeight = 0.1;
        _tableChatList.delegate = self;
        _tableChatList.dataSource = self;
        [self.view addSubview:_tableChatList];
    }
    return _tableChatList;
}

@end
