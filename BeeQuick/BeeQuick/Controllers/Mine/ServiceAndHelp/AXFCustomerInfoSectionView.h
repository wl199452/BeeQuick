//
//  CustomerInfoSectionView.h
//  GDSASYS
//
//  Created by windzhou on 15/3/30.
//  Copyright (c) 2015年 Smart-Array. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomerInfoSectionViewDelegate;

@interface AXFCustomerInfoSectionView : UIView

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *managerNameLabel;
@property(nonatomic,strong)UILabel *departmentLabel;
@property(nonatomic,strong)UILabel *addressLabel;

@property (assign, nonatomic) BOOL isOpen;
@property (nonatomic, assign) id <CustomerInfoSectionViewDelegate> delegate;
@property (nonatomic, assign) NSInteger section;
@property (strong, nonatomic) UIImageView *arrow;

-(void)toggleOpen:(id)sender;
-(void)toggleOpenWithUserAction:(BOOL)userAction;
- (void)initWithNameLabel:(NSString*)name ManagerNameLabel:(NSString*)managerName DepartmentLabel:(NSString*)department AddressLabel:(NSString*)address section:(NSInteger)sectionNumber delegate:(id <CustomerInfoSectionViewDelegate>)delegate;
@end

@protocol CustomerInfoSectionViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(AXFCustomerInfoSectionView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(AXFCustomerInfoSectionView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end
