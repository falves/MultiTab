//
//  Mesa.h
//  MultiTab
//
//  Created by Felipe Alves on 11/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cliente, ItemDaMesa;

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

- (void)addItensTotaisObject:(ItemDaMesa *)value;
- (void)removeItensTotaisObject:(ItemDaMesa *)value;
- (void)addItensTotais:(NSSet *)values;
- (void)removeItensTotais:(NSSet *)values;

@end
