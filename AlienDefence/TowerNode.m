//
//  TowerNode.m
//  AlienDefence
//
//  Created by Tharshan on 20/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import "TowerNode.h"

@implementation TowerNode
+(instancetype) towerOfType:(TowerType)type withLevel:(NSInteger)level{
  TowerNode *tower;
  if (type == TowerOne) {
      tower = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"turret-1-%d", level]];
      tower.anchorPoint = CGPointMake(0, 0);
  }
  return tower;
}
@end
