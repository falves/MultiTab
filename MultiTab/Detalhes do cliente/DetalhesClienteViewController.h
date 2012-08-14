//
//  DetalhesClienteViewController.h
//  MultiTab
//
//  Created by Mariana Meirelles on 8/14/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mesa.h"
#import "Cliente.h"
#import "ItemDaMesa.h"

@interface DetalhesClienteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) Cliente * cliente;

@end
