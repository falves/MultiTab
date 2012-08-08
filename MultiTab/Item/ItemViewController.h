//
//  ItemViewController.h
//  MultiTab
//
//  Created by Felipe Alves on 08/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mesa.h"

@interface ItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Mesa * mesa;

@end
