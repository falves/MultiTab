//
//  Cliente.h
//  MultiTab
//
//  Created by Felipe on 14/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemDaMesa, Mesa;

@interface Cliente : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * parcial;
@property (nonatomic, retain) NSSet *itens;
@property (nonatomic, retain) Mesa *pertenceMesa;
@end

@interface Cliente (CoreDataGeneratedAccessors)

- (void)addItensObject:(ItemDaMesa *)value;
- (void)removeItensObject:(ItemDaMesa *)value;
- (void)addItens:(NSSet *)values;
- (void)removeItens:(NSSet *)values;

@end
