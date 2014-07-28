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
  TowerFour = 4,
  TowerFive = 5
};

@interface TowerNode : SKSpriteNode
+(instancetype) towerOfType:(TowerType)type withLevel:(NSInteger)level;

@property (nonatomic, strong) NSMutableArray *targets;
@property (nonatomic) int damage;
@property (nonatomic) int level;
@property (nonatomic) int bulletType;
@property (nonatomic, strong) UIColor *bulletColor;
@property (nonatomic, strong) SKSpriteNode *bullet;
@end
@interface TowerNode ()

-(void) shootAtTarget:(SKSpriteNode*)target;
-(float) getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint;
-(void) damageEnemy:(SKSpriteNode*) enemy onKill:(void (^)()) killHandler;
-(void) debugDrawWithScene:(SKScene*) scene;
@end

@interface BulletNode : SKSpriteNode
+(instancetype) bulletOfType:(int) type withColor:(UIColor*) color;

@end