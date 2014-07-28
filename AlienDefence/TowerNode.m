//
//  TowerNode.m
//  AlienDefence
//
//  Created by Tharshan on 20/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import "TowerNode.h"
#import "CreepNode.h"
#import "Util.h"

@implementation BulletNode

+(instancetype)bulletOfType:(int)type withColor:(UIColor *)color {
  BulletNode *bullet;
  bullet = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"bullet_%d", type]];
  bullet.color = color;
  bullet.colorBlendFactor = 0.8;
  bullet.name = @"bullet";
  bullet.anchorPoint = CGPointMake(0.5, 0.5);
  bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
  bullet.physicsBody.dynamic = NO;
  bullet.physicsBody.categoryBitMask = CollisionMaskBullet;
  bullet.physicsBody.contactTestBitMask = CollisionMaskCreep;
  bullet.physicsBody.collisionBitMask = 0;
  bullet.zPosition = 0;
  return bullet;
}

@end

@implementation TowerNode
+(instancetype) towerOfType:(TowerType)type withLevel:(NSInteger)level{
  TowerNode *tower;
  tower = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"turret-%d-%d",type, level]];
  tower.anchorPoint = CGPointMake(0.5, 0.5);
  tower.name = @"tower";
  tower.level = level;
  tower.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
  tower.physicsBody.dynamic = YES;
  tower.physicsBody.affectedByGravity = NO;
  tower.physicsBody.categoryBitMask = CollisionMaskTower;
  tower.physicsBody.contactTestBitMask = CollisionMaskCreep;
  tower.physicsBody.collisionBitMask = 0;
  tower.zPosition = 1;
  tower.targets = [[NSMutableArray alloc] init];
  if (type == TowerOne) {
    tower.damage = 10;
    tower.bulletType = 2;
    tower.bulletColor = [UIColor blueColor];
  }else if (type == TowerTwo) {
    tower.damage = 20;
    tower.bulletType = 3;
    tower.bulletColor = [UIColor greenColor];
  }else if (type == TowerThree) {
    tower.damage = 15;
    tower.bulletType = 4;
    tower.bulletColor = [UIColor redColor];
  }else if (type == TowerFour) {
    tower.damage = 20;
    tower.bulletType = 5;
    tower.bulletColor = [UIColor orangeColor];
  }
  return tower;
}

-(void) shootAtTarget:(SKSpriteNode*)target {
  float angle = [self getRotationWithPoint:self.position endPoint:target.position];
  SKSpriteNode *bullet = [BulletNode bulletOfType:_bulletType withColor:_bulletColor];
  bullet.zRotation = angle;
  [self runAction:[SKAction rotateToAngle:angle duration:0] completion:^{
    [self addChild:bullet];
    CGPoint creepPoint = [self convertPoint:target.position fromNode:self.parent];
    SKAction *move = [SKAction moveTo:creepPoint duration:0.5];
    [bullet runAction:move completion:^{
      [bullet removeFromParent];
    }];
  }];

}
-(void) debugDrawWithScene:(SKScene *)scene {
  CGMutablePathRef circle = CGPathCreateMutable();
  CGPathAddArc(circle, NULL, self.position.x, self.position.y, 50, 0, 2*M_PI, true);
  CGPathCloseSubpath(circle);
  SKShapeNode *shape = [SKShapeNode node];
  shape.path = circle;
  shape.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:0.2];
  [scene addChild:shape];
}
-(void) damageEnemy:(CreepNode*) enemy onKill:(void (^)()) killHandler {
  enemy.health = enemy.health - self.damage;
  if (enemy.health <= 0) {
    [enemy removeFromParent];
    //NSLog(@"Creep killed");
    killHandler();
  }
}
- (float)getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint {
  CGPoint originPoint = CGPointMake(epoint.x - spoint.x, epoint.y - spoint.y); // get origin point to origin by subtracting end from start
  float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
  return bearingRadians;
}
@end
