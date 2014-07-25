//
//  TowerNode.h
//  AlienDefence
//
//  Created by Tharshan on 20/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, TowerType) {
  TowerOne = 1,
  TowerTwo = 2,
  TowerThree = 3,
};

@interface TowerNode : SKSpriteNode
+(instancetype) towerOfType:(TowerType)type withLevel:(NSInteger)level;
@property (retain, nonatomic) SKSpriteNode *target;
@end
@interface TowerNode ()

-(void) pointToTargetAtPoint:(CGPoint)target;
-(float) getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint;
-(void) shootAt:(SKSpriteNode*)creep;
@end