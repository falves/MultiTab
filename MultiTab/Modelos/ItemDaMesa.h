//
//  ItemDaMesa.h
//  MultiTab
//
//  Created by Felipe on 14/08/12.
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
@property (nonatomic, retain) NSSet *conssumidores;
@property (nonatomic, retain) Mesa *pertenceMesa;
@end

@interface ItemDaMesa (CoreDataGeneratedAccessors)

- (void)addConssumidoresObject:(Cliente *)value;
- (void)removeConssumidoresObject:(Cliente *)value;
- (void)addConssumidores:(NSSet *)values;
- (void)removeConssumidores:(NSSet *)values;

@end
