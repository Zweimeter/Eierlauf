//
//  Crossworld.h
//  Eierlauf
//
//  Created by Olga Koschel on 23.04.15.
//  Copyright (c) 2015 Sebastian Klotz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Crossworld : SKCropNode

@property (nonatomic) SKNode* maskWorld;
@property (nonatomic) SKSpriteNode* bg;
@property (nonatomic) SKSpriteNode* maskSection;
@property (nonatomic) SKSpriteNode* portalShadow;

-(void)update:(CFTimeInterval)currentTime;
-(void)didEvaluateActions;
-(void)adjustShadowPos;

@end
