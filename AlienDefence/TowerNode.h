//
//  TowerNode.h
//  AlienDefence
//
//  Created by Tharshan on 20/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, TowerType) {
  TowerOne = 0,
  TowerTwo = 1,
  TowerThree = 3,
};



@interface TowerNode : SKSpriteNode
+(instancetype) towerOfType:(TowerType)type withLevel:(NSInteger)level;

@end
