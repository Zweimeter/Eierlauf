//
//  GameData.h
//  Eierlauf
//
//  Created by Sebastian Klotz on 28.04.15.
//  Copyright (c) 2015 Sebastian Klotz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(uint32_t, CollisionType){
    ArrowCollisionType           = 0x1 << 0,
    BubbleCollisionType             = 0x1 << 1
};

@interface GameData : NSObject

@end
