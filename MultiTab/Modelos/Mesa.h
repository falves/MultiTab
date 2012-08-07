//
//  Mesa.h
//  MultiTab
//
//  Created by Felipe Alves on 07/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cliente, Item;

@interface Mesa : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSSet *clientesDaMesa;
@property (nonatomic, retain) NSSet *itensTotais;
@end

@interface Mesa (CoreDataGeneratedAccessors)

- (void)addClientesDaMesaObject:(Cliente *)value;
- (void)removeClientesDaMesaObject:(Cliente *)value;
- (void)addClientesDaMesa:(NSSet *)values;
- (void)removeClientesDaMesa:(NSSet *)values;

- (void)addItensTotaisObject:(Item *)value;
- (void)removeItensTotaisObject:(Item *)value;
- (void)addItensTotais:(NSSet *)values;
- (void)removeItensTotais:(NSSet *)values;

@end
