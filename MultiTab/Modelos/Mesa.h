//
//  Mesa.h
//  MultiTab
//
//  Created by Mariana Meirelles on 8/7/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cliente, Item;

@interface Mesa : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSSet *itensTotais;
@property (nonatomic, retain) NSSet *clientes;
@end

@interface Mesa (CoreDataGeneratedAccessors)

- (void)addItensTotaisObject:(Item *)value;
- (void)removeItensTotaisObject:(Item *)value;
- (void)addItensTotais:(NSSet *)values;
- (void)removeItensTotais:(NSSet *)values;

- (void)addClientesObject:(Cliente *)value;
- (void)removeClientesObject:(Cliente *)value;
- (void)addClientes:(NSSet *)values;
- (void)removeClientes:(NSSet *)values;

@end
