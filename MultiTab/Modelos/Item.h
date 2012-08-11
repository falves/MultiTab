//
//  Item.h
//  MultiTab
//
//  Created by Felipe Alves on 11/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cliente, Mesa;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * preco;
@property (nonatomic, retain) NSNumber * quantosConsumiram;
@property (nonatomic, retain) NSSet *clienteIndividual;
@property (nonatomic, retain) NSSet *clientesCompartilhados;
@property (nonatomic, retain) Mesa *pertenceMesa;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addClienteIndividualObject:(Cliente *)value;
- (void)removeClienteIndividualObject:(Cliente *)value;
- (void)addClienteIndividual:(NSSet *)values;
- (void)removeClienteIndividual:(NSSet *)values;

- (void)addClientesCompartilhadosObject:(Cliente *)value;
- (void)removeClientesCompartilhadosObject:(Cliente *)value;
- (void)addClientesCompartilhados:(NSSet *)values;
- (void)removeClientesCompartilhados:(NSSet *)values;

@end
