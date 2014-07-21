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
    TileNode *tiles = [TileNode drawTilesWithFrame:self.frame];
    [self addChild:tiles];
    [self addCreep];
    //SKSpriteNode *upgrade = [SKSpriteNode spriteNodeWithImageNamed:@"upgrade"];
    //upgrade.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    //upgrade.yScale = 1.5;
    //upgrade.xScale = 1.5;
    //[self addChild:upgrade];
    TowerNode *turretOne = [TowerNode towerOfType:TowerOne withLevel:1];
    turretOne.position = CGPointMake(8, 8);
    
    [tiles addChild:turretOne ];

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
  for (UITouch *touch in touches) {
//    CGPoint position = [touch locationInNode:self];
//    NSLog(@"%@", NSStringFromCGPoint(position));
//    NSLog(@"%@", NSStringFromCGPoint([self tileCoordForPosition:position]));
  }
}


-(void) addCreep {
  CreepNode *creep = [CreepNode creepOfType:CreepOne];
  //creep.position = CGPointMake(-10, 125);
  creep.position = CGPointMake(60, 110);
  [self addChild:creep];
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
  //SKAction *followline = [SKAction followPath:path asOffset:NO orientToPath:YES duration:25.0];
  //[creep runAction:followline];
  //CreepNode *boss = [CreepNode creepOfType:CreepTwo];
  //boss.position = CGPointMake(200, 250);
  //[self addChild:boss];
}

@end
