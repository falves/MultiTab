//
//  Cliente.h
//  MultiTab
//
//  Created by Mariana Meirelles on 8/7/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Mesa;

@interface Cliente : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * parcial;
@property (nonatomic, retain) NSSet *itensIndividuais;
@property (nonatomic, retain) NSSet *itensCompartilhados;
@property (nonatomic, retain) Mesa *mesa;
@end

@interface Cliente (CoreDataGeneratedAccessors)

- (void)addItensIndividuaisObject:(Item *)value;
- (void)removeItensIndividuaisObject:(Item *)value;
- (void)addItensIndividuais:(NSSet *)values;
- (void)removeItensIndividuais:(NSSet *)values;

- (void)addItensCompartilhadosObject:(Item *)value;
- (void)removeItensCompartilhadosObject:(Item *)value;
- (void)addItensCompartilhados:(NSSet *)values;
- (void)removeItensCompartilhados:(NSSet *)values;

@end
