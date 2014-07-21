//
//  CreepNode.m
//  AlienDefence
//
//  Created by Tharshan on 20/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import "CreepNode.h"

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
    creep = [self spriteNodeWithImageNamed:@"boss-1"];
    textures = @[[SKTexture textureWithImageNamed:@"boss-2"],
                 [SKTexture textureWithImageNamed:@"boss-3"],
                 [SKTexture textureWithImageNamed:@"boss-4"]];
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.2];
    [creep runAction:[SKAction repeatActionForever:animation]];
  }else{
    creep = [self spriteNodeWithImageNamed:@"boss"];
  }

  return creep;
}
@end
