//
//  EnemyBubble.m
//  Eierlauf
//
//  Created by Sebastian Klotz on 21.04.15.
//  Copyright (c) 2015 Sebastian Klotz. All rights reserved.
//

#import "EnemyBubble.h"
#import "GameData.h"

@implementation EnemyBubble

-(id)init {
    self = [super init];
    if (self) {
        self.maskSection = [SKSpriteNode spriteNodeWithImageNamed:@"bubbleMask.png"];
        
//        self.maskShadow = [SKSpriteNode spriteNodeWithImageNamed:@"bubbleMaskShadow.png"];
//        [self addChild:self.maskShadow];
        
        self.bubble = [SKSpriteNode spriteNodeWithImageNamed:@"bubbleWhiteGrey.png"];
        
        self.bubble.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bubble.size.width/2];
        self.bubble.physicsBody.affectedByGravity = NO;
        self.bubble.physicsBody.dynamic = YES;
        self.bubble.physicsBody.categoryBitMask = BubbleCollisionType;
        self.bubble.physicsBody.contactTestBitMask = ArrowCollisionType;
        self.bubble.physicsBody.collisionBitMask = 0;
        [self addChild: self.bubble];
    }
    return self;
}

@end
