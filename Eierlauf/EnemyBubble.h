//
//  EnemyBubble.h
//  Eierlauf
//
//  Created by Sebastian Klotz on 21.04.15.
//  Copyright (c) 2015 Sebastian Klotz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EnemyBubble : SKNode

// Kommt in die Crossworld.maskNode
@property (nonatomic) SKSpriteNode* maskSection;

// Kommt in die normale Crossworld
@property (nonatomic) SKSpriteNode* maskShadow;
@property (nonatomic) SKSpriteNode* bubble;

@end
