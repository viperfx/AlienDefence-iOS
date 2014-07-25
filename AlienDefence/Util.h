//
//  Util.h
//  AlienDefence
//
//  Created by Tharshan on 25/07/2014.
//  Copyright (c) 2014 Tharshan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(uint32_t, CollisionMask) {
  CollisionMaskCreep = 1 << 0,    //0000
  CollisionMaskTower = 1 << 1,    //0010
  CollisionMaskBullet = 1 << 2,   //0100
};

@interface Util : NSObject

@end
