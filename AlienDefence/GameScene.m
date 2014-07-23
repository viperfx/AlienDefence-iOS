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
    [self addCreep];
    
    self.towerBases = @[
                        [NSValue valueWithCGPoint:CGPointMake(40+(69/4),60+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(149*0.5+(69/4),60+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(218*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(285*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(354*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(423*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(492*0.5+(69/4),120*0.5+(69/4))],
                        [NSValue valueWithCGPoint:CGPointMake(561*0.5+(69/4),120*0.5+(69/4))]];
    
    //SKSpriteNode *upgrade = [SKSpriteNode spriteNodeWithImageNamed:@"upgrade"];
    //upgrade.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    //upgrade.yScale = 1.5;
    //upgrade.xScale = 1.5;
    //[self addChild:upgrade];
    TowerNode *turretOne = [TowerNode towerOfType:TowerOne withLevel:1];
    TowerNode *turretTwo = [TowerNode towerOfType:TowerTwo withLevel:2];
    turretOne.position = [[self.towerBases objectAtIndex:0] CGPointValue];
    turretTwo.position = [[self.towerBases objectAtIndex:1] CGPointValue];
    self.towers = [[NSMutableArray alloc] init];
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
      CGRect touchFrame = CGRectInset(tower.frame, -9, -8);
      CGPathRef path = CGPathCreateWithRect(touchFrame,NULL);
      SKShapeNode *shape = [SKShapeNode node];
      shape.path = path;
      shape.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:0.2];
      [self addChild:shape];
    }
    for (NSValue *base in _towerBases) {
      CGPoint basePoint = [base CGPointValue];
      CGRect baseRect = CGRectMake(basePoint.x, basePoint.y, 0, 0);
      CGRect expandedRect = CGRectInset(baseRect, -69/4, -69/4);
      [_towerBaseBounds addObject:[NSValue valueWithCGRect:expandedRect]];
//      CGPathRef path = CGPathCreateWithRect(expandedRect,NULL);
//      SKShapeNode *shape = [SKShapeNode node];
//      shape.path = path;
//      shape.strokeColor = [SKColor colorWithRed:0 green:1.0 blue:0 alpha:0.2];
//      shape.userInteractionEnabled = false;
//      [self addChild:shape];
    }
  }
  return self;
}

- (void) didMoveToView:(SKView *)view {
  swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
  [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
  [view addGestureRecognizer:swipeRightGesture];
  
  swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
  [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
  [view addGestureRecognizer:swipeLeftGesture];
}

- (void) handleSwipeRight:(UISwipeGestureRecognizer*) recogniser {
  NSLog(@"Swipe Right");
}

- (void) handleSwipeLeft:(UISwipeGestureRecognizer*) recogniser {
  NSLog(@"Swipe Left");
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//  for (UITouch *touch in touches) {
//    CGPoint position = [touch locationInNode:self];
//    NSLog(@"%@", NSStringFromCGPoint(position));
//    NSLog(@"%@", NSStringFromCGPoint([self tileCoordForPosition:position]));
//  }
  UITouch *touch = [touches anyObject];
  CGPoint positionInScene = [touch locationInNode:self];
//  NSLog(@"%@", NSStringFromCGPoint(positionInScene));
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
            NSLog(@"%@", NSStringFromCGPoint(touchLocation));
            NSLog(@"%@", NSStringFromCGRect(baseRect));
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

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//  UITouch *touch = [touches anyObject];
//  CGPoint positionInScene = [touch locationInNode:self];
//  CGPoint previousPosition = [touch previousLocationInNode:self];
//  if ([[_selectedTower name] isEqualToString:@"movable"]) {
//    [_selectedTower setPosition:positionInScene];
//  }
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//  UITouch *touch = [touches anyObject];
//  CGPoint previousPosition = [touch previousLocationInNode:self];
//  TowerNode *turretPlaced = [TowerNode towerOfType:TowerOne withLevel:3];
//  [turretPlaced setPosition:[_selectedTower position]];
//  [_selectedTower setPosition:previousPosition];
//  [self addChild:turretPlaced];
//}

- (void) update:(NSTimeInterval)currentTime {
  if (currentTime - self.timeOfLastMove < 0.5) return;
  [self gameLoop:currentTime];
}

- (void)gameLoop:(NSTimeInterval)currentTime {
  CGPoint position = [self.scene convertPoint:self.creep.position toNode:self.scene];
  //NSLog(@"%@", NSStringFromCGPoint(position));
  for (TowerNode *tower in self.towers) {
    //NSLog(@"%@", NSStringFromCGPoint(position));
    [tower pointToTargetAtPoint:position];
  }
  self.timeOfLastMove = currentTime;
}

-(void) addCreep {
  self.creep = [CreepNode creepOfType:CreepOne];
  self.creep.position = CGPointMake(-10, 125);
//  self.creep.position = CGPointMake(60, 110);
  [self addChild:self.creep];
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
  SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:YES duration:100];
  [self.creep runAction:followline];
  //CreepNode *boss = [CreepNode creepOfType:CreepTwo];
  //boss.position = CGPointMake(200, 250);
  //[self addChild:boss];
}
float degToRad(float degree) {
	return degree / 180.0f * M_PI;
}
@end
