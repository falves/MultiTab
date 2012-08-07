//
//  Item.h
//  MultiTab
//
//  Created by Mariana Meirelles on 8/7/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cliente, Mesa;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * preco;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) Cliente *clienteIndividual;
@property (nonatomic, retain) Cliente *clientesCompartilhados;
@property (nonatomic, retain) Mesa *mesa;

@end
