//
//  Crossworld.m
//  Eierlauf
//
//  Created by Olga Koschel on 23.04.15.
//  Copyright (c) 2015 Sebastian Klotz. All rights reserved.
//

#import "Crossworld.h"

@implementation Crossworld

-(id)init {
    self = [super init];
    if (self) {
        
        self.bg = [SKSpriteNode spriteNodeWithImageNamed:@"world1BG5.png"];
        [self addChild:self.bg];
        
        self.maskNode = [SKNode new];
        
        self.maskSection = [SKSpriteNode spriteNodeWithImageNamed:@"pinkHole.png"];
        //        self.maskSection.size = CGSizeMake(self.maskSection.size.width * scalingFactor, self.maskSection.size.height * scalingFactor);
        
        [self.maskNode addChild:self.maskSection];
        
//        self.portalShadow = [SKSpriteNode spriteNodeWithImageNamed:@"babbelsMaskShadow.png"];
//        [self addChild:self.portalShadow];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    
}

-(void)didEvaluateActions {
    
}

-(void)adjustShadowPos {
    self.portalShadow.position = self.maskSection.position;
}

@end
