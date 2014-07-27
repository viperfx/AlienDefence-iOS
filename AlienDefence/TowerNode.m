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
@implementation TowerNode
+(instancetype) towerOfType:(TowerType)type withLevel:(NSInteger)level{
  TowerNode *tower;
  tower = [self spriteNodeWithImageNamed:[NSString stringWithFormat:@"turret-%d-%d",type, level]];
  tower.anchorPoint = CGPointMake(0.5, 0.5);
  tower.name = @"tower";
  tower.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
  tower.physicsBody.dynamic = YES;
  tower.physicsBody.affectedByGravity = NO;
  tower.physicsBody.categoryBitMask = CollisionMaskTower;
  tower.physicsBody.contactTestBitMask = CollisionMaskCreep;
  tower.physicsBody.collisionBitMask = 0;
  tower.damage = 10;
  tower.zPosition = 1;
  return tower;
}
-(void) pointToTargetAtPoint:(SKSpriteNode*)target {
  if (self.zRotation < 0) {
    self.zRotation = self.zRotation + M_PI * 2;
  }
  float angle = [self getRotationWithPoint:self.position endPoint:target.position];
  
//  self.zRotation = angle;
  SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet_2"];
//  bullet.position = CGPointMake(self.position.x, self.position.y);
  bullet.color = [SKColor greenColor];
  bullet.colorBlendFactor = 0.7;
//  bullet.alpha = 0.4;
  bullet.name = @"bullet";
  bullet.anchorPoint = CGPointMake(0.5, 0.5);
  bullet.zRotation = angle;
  bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
  bullet.physicsBody.dynamic = NO;
  bullet.physicsBody.categoryBitMask = CollisionMaskBullet;
  bullet.physicsBody.contactTestBitMask = CollisionMaskCreep;
  bullet.physicsBody.collisionBitMask = 0;
  bullet.zPosition = 0;
  [self runAction:[SKAction rotateToAngle:angle duration:0] completion:^{
    [self addChild:bullet];
    CGPoint creepPoint = [self convertPoint:target.position fromNode:self.parent];
    SKAction *move = [SKAction moveTo:creepPoint duration:0.5];
    [bullet runAction:move completion:^{
      [bullet removeFromParent];
    }];
  }];

}
-(void) damageEnemy:(CreepNode*) enemy onKill:(void (^)()) killHandler {
  enemy.health = enemy.health - self.damage;
  if (enemy.health <= 0) {
    [enemy removeFromParent];
    self.target = nil;
    NSLog(@"Creep killed");
    killHandler();
  }
}
- (float)getRotationWithPoint:(CGPoint)spoint endPoint:(CGPoint)epoint {
  CGPoint originPoint = CGPointMake(epoint.x - spoint.x, epoint.y - spoint.y); // get origin point to origin by subtracting end from start
  float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
  return bearingRadians;
}
@end
