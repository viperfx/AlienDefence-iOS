//
//  CreepNode.h
//  AlienDefence
//
//  Created by Tharshan on 20/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, CreepType) {
  CreepOne = 0,
  CreepTwo = 1,
  CreepThree = 3,
};

@interface CreepNode : SKSpriteNode
+(instancetype) creepOfType:(CreepType)type;
@property (nonatomic) int health;
@end
