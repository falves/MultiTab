//
//  Cliente.h
//  MultiTab
//
//  Created by Felipe Alves on 11/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemDaMesa, Mesa;

@interface Cliente : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * parcial;
@property (nonatomic, retain) NSSet *itensCompartilhados;
@property (nonatomic, retain) NSSet *itensIndividuais;
@property (nonatomic, retain) Mesa *pertenceMesa;
@end

@interface Cliente (CoreDataGeneratedAccessors)

- (void)addItensCompartilhadosObject:(ItemDaMesa *)value;
- (void)removeItensCompartilhadosObject:(ItemDaMesa *)value;
- (void)addItensCompartilhados:(NSSet *)values;
- (void)removeItensCompartilhados:(NSSet *)values;

- (void)addItensIndividuaisObject:(ItemDaMesa *)value;
- (void)removeItensIndividuaisObject:(ItemDaMesa *)value;
- (void)addItensIndividuais:(NSSet *)values;
- (void)removeItensIndividuais:(NSSet *)values;

@end
