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
@property (atomic, strong) SKSpriteNode *target;
@property (nonatomic, strong) NSMutableArray *targets;
@property (nonatomic) int damage;
@end
@interface TowerNode ()

-(void) shootAtTarget:(SKSpriteNode*)target;
-(float) getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint;
-(void) damageEnemy:(SKSpriteNode*) enemy onKill:(void (^)()) killHandler;
-(void) debugDrawWithScene:(SKScene*) scene;
@end