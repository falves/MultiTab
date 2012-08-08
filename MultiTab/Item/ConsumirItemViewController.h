//
//  ConsumirItemViewController.h
//  MultiTab
//
//  Created by Felipe Alves on 08/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Mesa.h"

@interface ConsumirItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic) Item * item;
@property (nonatomic) Mesa * mesa;

@end
