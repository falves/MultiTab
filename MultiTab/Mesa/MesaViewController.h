//
//  MesaViewController.h
//  MultiTab
//
//  Created by Mariana Meirelles on 8/7/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Mesa.h"

@interface MesaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, assign) BOOL novaMesa;
@property (nonatomic, strong) NSString * nomeDaMesa;
@property (nonatomic, strong) Mesa * mesa;

@end
