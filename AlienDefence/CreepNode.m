//
//  CreepNode.m
//  AlienDefence
//
//  Created by Tharshan on 20/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import "CreepNode.h"
#import "Util.h"
@implementation CreepNode
+(instancetype) creepOfType:(CreepType)type {
  CreepNode *creep;
  NSArray *textures;
  
  if (type == CreepOne) {
    creep = [self spriteNodeWithImageNamed:@"creep_1r_1"];
    textures = @[[SKTexture textureWithImageNamed:@"creep_1r_2"],
                 [SKTexture textureWithImageNamed:@"creep_1r_3"],
                 [SKTexture textureWithImageNamed:@"creep_1r_4"],
                 [SKTexture textureWithImageNamed:@"creep_1r_5"],
                 [SKTexture textureWithImageNamed:@"creep_1r_6"]];
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.2];
    [creep runAction:[SKAction repeatActionForever:animation]];
  }else if (type == CreepTwo) {
    creep = [self spriteNodeWithImageNamed:@"creep_2b_1"];
    textures = @[[SKTexture textureWithImageNamed:@"creep_2b_2"],
                 [SKTexture textureWithImageNamed:@"creep_2b_3"],
                 [SKTexture textureWithImageNamed:@"creep_2b_4"]];
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.2];
    [creep runAction:[SKAction repeatActionForever:animation]];
  }else{
    creep = [self spriteNodeWithImageNamed:@"boss"];
  }
  creep.name = @"creep";
  creep.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:creep.frame.size];
  creep.physicsBody.dynamic = YES;
  creep.physicsBody.affectedByGravity = NO;
  creep.physicsBody.categoryBitMask = CollisionMaskCreep;
  creep.physicsBody.contactTestBitMask = CollisionMaskTower;
  creep.physicsBody.collisionBitMask = 0;
  return creep;
}
@end
