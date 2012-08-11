//
//  ItemDaMesa.h
//  MultiTab
//
//  Created by Felipe Alves on 11/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cliente, Mesa;

@interface ItemDaMesa : NSManagedObject

@property (nonatomic, retain) NSString * idDaMesa;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * preco;
@property (nonatomic, retain) NSNumber * quantosConsumiram;
@property (nonatomic, retain) NSSet *clienteCompartilhado;
@property (nonatomic, retain) Cliente *clienteIndividual;
@property (nonatomic, retain) Mesa *pertenceMesa;
@end

@interface ItemDaMesa (CoreDataGeneratedAccessors)

- (void)addClienteCompartilhadoObject:(Cliente *)value;
- (void)removeClienteCompartilhadoObject:(Cliente *)value;
- (void)addClienteCompartilhado:(NSSet *)values;
- (void)removeClienteCompartilhado:(NSSet *)values;

@end
