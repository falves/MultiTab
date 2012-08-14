//
//  DetalhesDoItemViewController.h
//  MultiTab
//
//  Created by Felipe on 14/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDaMesa.h"
#import "Cliente.h"
#import "Mesa.h"

@interface DetalhesDoItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) ItemDaMesa * item;

@end
