//
//  AdicionarClienteViewController.h
//  MultiTab
//
//  Created by Felipe on 14/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cliente.h"
#import "Mesa.h"
#import "ItemDaMesa.h"

@interface AdicionarClienteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) ItemDaMesa * item;
@property (nonatomic) Mesa * mesa;

@end
