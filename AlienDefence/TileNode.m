//
//  TileNode.m
//  AlienDefence
//
//  Created by Tharshan on 20/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import "TileNode.h"

@implementation TileNode
+(instancetype) drawTilesWithFrame:(CGRect)frame {
  TileNode *tiles = [self spriteNodeWithImageNamed:@"tiles"];
  tiles.position = CGPointMake(40+(tiles.size.width/2), 60+(tiles.size.height/2));
  tiles.name = @"tiles";
  return tiles;
}
@end
