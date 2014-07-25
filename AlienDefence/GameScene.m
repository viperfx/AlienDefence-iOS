//
//  GameScene.m
//  AlienDefence
//
//  Created by Tharshan on 20/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import "GameScene.h"
#import "CreepNode.h"
#import "TileNode.h"
#import "TowerNode.h"
#import "Util.h"
@implementation GameScene

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"ship_dmg_low"];
    ship.position = CGPointMake(CGRectGetMaxX(self.frame)-ship.frame.size.width/2, CGRectGetMidY(self.frame));
    [self addChild:ship];
    
    //SKSpriteNode *panels = [SKSpriteNode spriteNodeWithImageNamed:@"hud"];
    //panels.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-30);
    //    tiles.anchorPoint = CGPointMake(0, 0);
    //[self addChild:panels];
    _tiles = [TileNode drawTilesWithFrame:self.frame];
    [self addChild:_tiles];
    self.physicsWorld.contactDelegate = self;
    self.towerBases = @[
                        [NSValue valueWithCGPoint:CGPointMake(40+(69/4),60+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(149*0.5+(69/4),60+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(218*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(285*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(354*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(423*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(492*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(561*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(580*0.5+(69/4),189*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(580*0.5+(69/4),258*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(580*0.5+(69/4),327*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(580*0.5+(69/4),396*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(580*0.5+(69/4),327*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(580*0.5+(69/4),464*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(513*0.5+(69/4),464*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(444*0.5+(69/4),464*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(375*0.5+(69/4),464*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(306*0.5+(69/4),464*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(237*0.5+(69/4),464*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(168*0.5+(69/4),464*0.5+(69/4))],
                        ];
    _waveData = @[
                  @{@"creepType": [NSNumber numberWithInteger:CreepOne], @"count": @10},
                  @{@"creepType": [NSNumber numberWithInteger:CreepTwo], @"count": @10}
                  ];
    _waveNumber = 0;
    SKAction *wait = [SKAction waitForDuration:30];
    SKAction *performSelector = [SKAction performSelector:@selector(addCreepWave) onTarget:self];
    SKAction *sequence = [SKAction sequence:@[performSelector, wait]];
    SKAction *repeat   = [SKAction repeatAction:sequence count:[_waveData count]];
    [self runAction:repeat];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, -10, 110);
    CGPathAddLineToPoint(path, NULL, 270, 110);
    CGPathAddLineToPoint(path, NULL, 270, 215);
    CGPathAddLineToPoint(path, NULL, 66, 215);
    CGPathAddLineToPoint(path, NULL, 68, 300);
    CGPathAddLineToPoint(path, NULL, 500, 300);
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = path;
    shape.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:0.2];
    shape.lineWidth = 1.0;
    [self addChild:shape];
    _followline = [SKAction followPath:path asOffset:NO orientToPath:YES duration:100];
    
    //SKSpriteNode *upgrade = [SKSpriteNode spriteNodeWithImageNamed:@"upgrade"];
    //upgrade.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    //upgrade.yScale = 1.5;
    //upgrade.xScale = 1.5;
    //[self addChild:upgrade];
    TowerNode *turretOne = [TowerNode towerOfType:TowerOne withLevel:1];
    TowerNode *turretTwo = [TowerNode towerOfType:TowerTwo withLevel:2];
    turretOne.position = [[self.towerBases objectAtIndex:0] CGPointValue];
    turretTwo.position = [[self.towerBases objectAtIndex:1] CGPointValue];
    _towers = [[NSMutableArray alloc] init];
    _creeps = [[NSMutableArray alloc] init];
    _towerBaseBounds = [[NSMutableArray alloc] init];
    [self.towers addObject:turretOne];
    [self.towers addObject:turretTwo];
    [self addChild:turretOne];
    [self addChild:turretTwo];
    _isTowerSelected = NO;
    NSArray *turretIconNames = @[@"turret-1-icon", @"turret-2-icon", @"turret-3-icon", @"turret-4-icon", @"turret-5-icon"];
    for (NSString *turretIconName in turretIconNames) {
      SKSpriteNode *turretIconSprite = [SKSpriteNode spriteNodeWithImageNamed:turretIconName];
      [turretIconSprite setName:@"movable"];
      [turretIconSprite setPosition:CGPointMake(CGRectGetMaxX(self.frame)-100-[turretIconNames indexOfObject:turretIconName]*40, 30)];
      [self addChild:turretIconSprite];
    }
    for (TowerNode *tower in _towers) {
        CGMutablePathRef circle = CGPathCreateMutable();
        CGPathAddArc(circle, NULL, tower.position.x, tower.position.y, 50, 0, 2*M_PI, true);
        CGPathCloseSubpath(circle);
        SKShapeNode *shape = [SKShapeNode node];
        shape.path = circle;
        shape.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:0.2];
        [self addChild:shape];
    }
    for (NSValue *base in _towerBases) {
      CGPoint basePoint = [base CGPointValue];
      CGRect baseRect = CGRectMake(basePoint.x, basePoint.y, 0, 0);
      CGRect expandedRect = CGRectInset(baseRect, -69/4, -69/4);
      [_towerBaseBounds addObject:[NSValue valueWithCGRect:expandedRect]];
    }
    
  }
  return self;
}
- (void) addCreepWave {
  NSDictionary *creepWave = [_waveData objectAtIndex:_waveNumber];
  SKAction *wait = [SKAction waitForDuration:2.5];
  SKAction *performSelector = [SKAction performSelector:@selector(addCreep) onTarget:self];
  SKAction *sequence = [SKAction sequence:@[performSelector, wait]];
  SKAction *repeat   = [SKAction repeatAction:sequence count:[[creepWave objectForKey:@"count"] intValue]];
  [self runAction:repeat];
  _waveNumber++;
  NSLog(@"creep wave added");
}

-(void) addCreep {
  NSDictionary *creepWave = [_waveData objectAtIndex:_waveNumber-1];
  SKSpriteNode *creep = [CreepNode creepOfType:(CreepType)[[creepWave objectForKey:@"creepType"] intValue]];
  creep.position = CGPointMake(-10, 125);
  [self addChild:creep];
  [_creeps addObject:creep];
  [creep runAction:_followline];
  NSLog(@"creep added");
}
- (void) didMoveToView:(SKView *)view {
  swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
  [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
  [view addGestureRecognizer:swipeRightGesture];
  
  swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
  [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
  [view addGestureRecognizer:swipeLeftGesture];
}
-(void)didBeginContact:(SKPhysicsContact *)contact {
  SKPhysicsBody* firstBody;
  SKPhysicsBody* secondBody;
  
  if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
  {
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
  }
  else
  {
    firstBody = contact.bodyB;
    secondBody = contact.bodyA;
  }
  NSLog(@"bodyA:%@ bodyB:%@",contact.bodyA.node.name, contact.bodyB.node.name);
  if (firstBody.categoryBitMask == CollisionMaskCreep && secondBody.categoryBitMask == CollisionMaskTower) {
    CreepNode *creep = (CreepNode*) firstBody.node;
    TowerNode *tower = (TowerNode*) secondBody.node;
    [tower pointToTargetAtPoint:creep.position];
  }else if (firstBody.categoryBitMask == CollisionMaskCreep && secondBody.categoryBitMask == CollisionMaskBullet) {
    NSLog(@"Creep Hit!");
  }
}
- (void) handleSwipeRight:(UISwipeGestureRecognizer*) recogniser {
  NSLog(@"Swipe Right");
}

- (void) handleSwipeLeft:(UISwipeGestureRecognizer*) recogniser {
  NSLog(@"Swipe Left");
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint positionInScene = [touch locationInNode:self];
  [self selectNodeForTouch:positionInScene];
  
}

- (void) selectNodeForTouch:(CGPoint)touchLocation {
  bool spotTaken = false;
  SKSpriteNode *touchedNode = (SKSpriteNode*)[self nodeAtPoint:touchLocation];
	if(![_selectedTower isEqual:touchedNode]) {

    if (_isTowerSelected) {
      for (TowerNode *tower in _towers) {
        CGRect touchFrame = CGRectInset(tower.frame, -9, -8);
        if (CGRectContainsPoint(touchFrame, touchLocation)) {
          NSLog(@"%@", tower);
          spotTaken = true;
        }
      }
      if (spotTaken) {
        [_selectedTower removeAllActions];
        [_selectedTower runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
        [_selectedTower setScale:1.0f];
        _isTowerSelected = NO;
      }else{
        for (NSValue *base in _towerBaseBounds) {
          CGRect baseRect = [base CGRectValue];
          if (CGRectContainsPoint(baseRect, touchLocation)) {
//            NSLog(@"%@", NSStringFromCGPoint(touchLocation));
//            NSLog(@"%@", NSStringFromCGRect(baseRect));
            TowerNode *turretPlaced = [TowerNode towerOfType:TowerOne withLevel:3];
            
            [turretPlaced setPosition:[[_towerBases objectAtIndex:[_towerBaseBounds indexOfObject:base]]CGPointValue]];
            [self addChild:turretPlaced];
            [_towers addObject:turretPlaced];
            _isTowerSelected = NO;
          }
        }
        
      }
    }
    
		[_selectedTower removeAllActions];
		[_selectedTower runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
    [_selectedTower setScale:1.0f];
		_selectedTower = touchedNode;
  
    
		if([[touchedNode name] isEqualToString:@"movable"]) {
      [_selectedTower setScale:1.5f];
      _isTowerSelected = YES;
			SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-6.0f) duration:0.1],
                                                [SKAction rotateByAngle:0.0 duration:0.1],
                                                [SKAction rotateByAngle:degToRad(6.0f) duration:0.1]]];
			[_selectedTower runAction:[SKAction repeatActionForever:sequence]];
		}
	}
}

- (void) update:(NSTimeInterval)currentTime {
  if (currentTime - self.timeOfLastMove < 0.2) return;
  [self gameLoop:currentTime];
}

- (void)gameLoop:(NSTimeInterval)currentTime {
//  for (TowerNode *tower in _towers) {
//    for (CreepNode *creep in _creeps) {
//      if ([self isCreepinRange:50 creep:creep.position tower:tower.position]) {
//        [tower pointToTargetAtPoint:creep.position];
//      }
//    }
//  }
//  self.timeOfLastMove = currentTime;
}

- (bool) isCreepinRange:(int) range creep:(CGPoint) creep tower:(CGPoint) tower {
  int rootDistance = sqrt(powf((tower.x-creep.x), 2)+powf((tower.y-creep.y), 2));
  if (rootDistance > range)
    return NO;
  return YES;
}


float degToRad(float degree) {
	return degree / 180.0f * M_PI;
}
@end
