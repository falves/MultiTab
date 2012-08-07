//
//  Cliente.h
//  MultiTab
//
//  Created by Felipe Alves on 07/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Mesa;

@interface Cliente : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * parcial;
@property (nonatomic, retain) NSSet *itensCompartilhados;
@property (nonatomic, retain) NSSet *itensIndividuais;
@property (nonatomic, retain) Mesa *pertenceMesa;
@end

@interface Cliente (CoreDataGeneratedAccessors)

- (void)addItensCompartilhadosObject:(Item *)value;
- (void)removeItensCompartilhadosObject:(Item *)value;
- (void)addItensCompartilhados:(NSSet *)values;
- (void)removeItensCompartilhados:(NSSet *)values;

- (void)addItensIndividuaisObject:(Item *)value;
- (void)removeItensIndividuaisObject:(Item *)value;
- (void)addItensIndividuais:(NSSet *)values;
- (void)removeItensIndividuais:(NSSet *)values;

@end
