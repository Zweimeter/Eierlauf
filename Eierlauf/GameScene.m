//
//  GameScene.m
//  Eierlauf
//
//  Created by Sebastian Klotz on 07.04.15.
//  Copyright (c) 2015 Sebastian Klotz. All rights reserved.
//

#import "GameScene.h"
#import "SKTUtils.h"
#import "Crossworld.h"
#import "EnemyBubble.h"
#import "GameData.h"

float distanceBetweenPoints(CGPoint first, CGPoint second){
    return hypotf(second.x - first.x, second.y - first.y);
}

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
//    self.backgroundColor = [SKColor blueColor];
    
    self.amplify = 0.61;
    self.shakeFilter = 0.15;
    self.holeScale = 1;//0.3;
    
    self.penalty = 5;
    
    self.hasContact = NO;
    
    self.physicsWorld.contactDelegate = self;
    
    self.motionManager = [CMMotionManager new]; // Nice motion manager
    [self.motionManager startAccelerometerUpdates];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingHeading];
    [self initRegion];
    
    self.playground = [SKNode new];
    self.playground.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:self.playground];
    
    
    
    self.blackHole = [SKSpriteNode spriteNodeWithImageNamed:@"pinkHole.png"];
    self.blackHole.xScale = self.holeScale;
    self.blackHole.yScale = self.holeScale;
    
//    self.blackHole.colorBlendFactor = 1;
    
//    [self.playground addChild:self.blackHole];
    
    self.interface = [SKNode new];
    self.interface.zPosition = 10;
    self.interface.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:self.interface];
    
    
    
    
    self.bg = [SKSpriteNode spriteNodeWithImageNamed:@"world2BG5.png"];
    self.bg.zPosition = -10;
    [self.playground addChild:self.bg];
    
    
    self.crossworld = [Crossworld new];
    self.crossworld.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//    self.crossworld.zPosition = 5;
    [self addChild:self.crossworld];
    
//    self.enemyBubble = [EnemyBubble new];
//    //    //    [self.enemyBubble setHidden:YES];
//    self.enemyBubble.zPosition = -1;
//    [self.crossworld.maskNode addChild:self.enemyBubble.maskSection];
//    [self.crossworld addChild:self.enemyBubble];
    
    
    self.bubble = [SKSpriteNode spriteNodeWithImageNamed:@"babbels374.png"];
    //    self.bubble.xScale = 3;
    //    self.bubble.yScale = 3;
//    self.bubble.zPosition = 6;
    self.bubble.zPosition = 20;
    [self.crossworld addChild:self.bubble];
    
    self.babbels = [SKSpriteNode spriteNodeWithImageNamed:@"babbels374.png"];
    //    self.bubble.xScale = 3;
    //    self.bubble.yScale = 3;
    self.babbels.zPosition = 21;
    self.babbels.colorBlendFactor = 1;
    self.babbels.color = [SKColor whiteColor];
    [self.crossworld addChild:self.babbels];
    
    self.arrowBox = [SKNode new];
    self.arrowBox.zPosition = 10;
    [self.crossworld addChild:self.arrowBox];
    
    self.arrowMaskBox = [SKNode new];
    self.arrowMaskBox.zPosition = 10;
    [self.crossworld.maskNode addChild:self.arrowMaskBox];
    
    self.arrowMask = [SKSpriteNode spriteNodeWithImageNamed:@"equalTriangleCutMask.png"];
    self.arrowMask.position = CGPointMake(155, 0);
    [self.arrowMaskBox addChild:self.arrowMask];
    
    self.magnetArrow = [SKSpriteNode spriteNodeWithImageNamed:@"equalTriangleCut.png"];
    self.magnetArrow.position = CGPointMake(150, 0);
    self.magnetArrow.zPosition = 10;
    
    self.magnetArrow.physicsBody = [SKPhysicsBody bodyWithTexture:self.magnetArrow.texture size:self.magnetArrow.texture.size];
    self.magnetArrow.physicsBody.affectedByGravity = NO;
    self.magnetArrow.physicsBody.dynamic = YES;
    self.magnetArrow.physicsBody.categoryBitMask = ArrowCollisionType;
    self.magnetArrow.physicsBody.contactTestBitMask = BubbleCollisionType;
    self.magnetArrow.physicsBody.collisionBitMask = 0;
    
    [self.arrowBox addChild:self.magnetArrow];
    
    self.timerLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%.2f", self.combinedTime]];
    self.timerLabel.fontColor = [SKColor blackColor];
    self.timerLabel.fontSize = 80;
    self.timerLabel.position = CGPointMake(-400, 250);
    self.timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self.playground addChild:self.timerLabel];
    
    self.hits = 0;
    
    self.hitCounter = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%u", self.hits]];
    self.hitCounter.fontColor = [SKColor blackColor];
    self.hitCounter.fontSize = 80;
    self.hitCounter.position = CGPointMake(400, 250);
    self.hitCounter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [self.playground addChild:self.hitCounter];
    
    self.holeLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%.2f", self.holeScale]];
    self.holeLabel.fontColor = [SKColor darkGrayColor];
    self.holeLabel.position = CGPointMake(0, 0);
    [self.interface addChild:self.holeLabel];
    
    self.bubbleDown = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
    self.bubbleDown.zRotation = M_PI;
    self.bubbleDown.position = CGPointMake(-400, 0);
    [self.interface addChild:self.bubbleDown];
    
    self.bubbleUp = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
    self.bubbleUp.position = CGPointMake(400, 0);
    [self.interface addChild:self.bubbleUp];
    
    self.amplifyLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%.2f", self.amplify]];
    self.amplifyLabel.fontColor = [SKColor blackColor];
    self.amplifyLabel.position = CGPointMake(0, 300);
    [self.interface addChild:self.amplifyLabel];
    
    self.ampDown = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
    self.ampDown.zRotation = M_PI;
    self.ampDown.position = CGPointMake(-100, 310);
    [self.interface addChild:self.ampDown];
    
    self.ampUp = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
    self.ampUp.position = CGPointMake(100, 310);
    [self.interface addChild:self.ampUp];
    
    self.shakeFilterLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%.2f", self.shakeFilter]];
    self.shakeFilterLabel.fontColor = [SKColor blackColor];
    self.shakeFilterLabel.position = CGPointMake(0, -300);
    [self.interface addChild:self.shakeFilterLabel];
    
    self.shakeDown = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
    self.shakeDown.zRotation = M_PI;
    self.shakeDown.position = CGPointMake(-100, -290);
    [self.interface addChild:self.shakeDown];
    
    self.shakeUp = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
    self.shakeUp.position = CGPointMake(100, -290);
    [self.interface addChild:self.shakeUp];
    
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
    
    
    [self newEnemyBubble];
    
    [self.interface setHidden:YES];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSArray* nodes = [self nodesAtPoint:location];
        for (SKNode* node in nodes) {
            if (!self.interface.isHidden) {
                if ([node isEqual:self.ampDown]) {
                    self.amplify -= 0.01f;
                    [self updateAmpLabel];
                }
                else if ([node isEqual:self.ampUp]) {
                    self.amplify += 0.01f;
                    [self updateAmpLabel];
                }
                else if ([node isEqual:self.shakeDown]) {
                    self.shakeFilter -= 0.01f;
                    [self updateShakeLabel];
                }
                else if ([node isEqual:self.shakeUp]) {
                    self.shakeFilter += 0.01f;
                    [self updateShakeLabel];
                }
                else if ([node isEqual:self.bubbleDown]){
                    self.holeScale -= 0.01f;
                    [self updateHole];
                }
                else if ([node isEqual:self.bubbleUp]){
                    self.holeScale += 0.01f;
                    [self updateHole];
                }
            }
            if ([node isEqual:self.blackHole]) {
                if (self.interface.isHidden) {
                    [self.interface setHidden:NO];
                } else {
                    [self.interface setHidden:YES];
                }
            
            }
            if ([node isEqual:self.timerLabel] || [node isEqual:self.hitCounter]) {
                [self restartTimer];
                self.hits = 0;
                [self updateHitsLabel];
            }
        }
    }
}

-(void)updateAmpLabel {
    self.amplifyLabel.text = [NSString stringWithFormat:@"%.2f", self.amplify];
}

-(void)updateShakeLabel {
    self.shakeFilterLabel.text = [NSString stringWithFormat:@"%.2f", self.shakeFilter];
}

-(void)updateHole {
    self.blackHole.xScale = self.holeScale;
    self.blackHole.yScale = self.holeScale;
    self.holeLabel.text = [NSString stringWithFormat:@"%.2f", self.holeScale];
    
    self.crossworld.maskSection.xScale = self.holeScale;
    self.crossworld.maskSection.yScale = self.holeScale;
    self.crossworld.portalShadow.xScale = self.holeScale;
    self.crossworld.portalShadow.yScale = self.holeScale;
    
}

-(void)update:(CFTimeInterval)currentTime {
    if (self.startTime == 0) {
        self.startTime = currentTime;
    }
    self.currentTime = currentTime;
    [self calcCollision];
    [self processMotion:currentTime];
//    if (CGRectIntersectsRect(self.enemyBubble.frame, self.magnetArrow.frame)) {
//        [self newEnemyBubble];
//    }
    [self updateTimerLabel];
}

-(void)didEvaluateActions {
    [self.crossworld didEvaluateActions];
}

-(void)restartTimer {
    self.startTime = self.currentTime;
}

-(void)updateTimerLabel {
    self.passedTime = self.currentTime - self.startTime;
    self.combinedTime = self.passedTime + (self.hits * self.penalty);
    self.timerLabel.text = [NSString stringWithFormat:@"%.1f", self.combinedTime];
}

-(void)updateHitsLabel {
    self.hitCounter.text = [NSString stringWithFormat:@"%u", self.hits];
}

-(void)processMotion:(CFTimeInterval)currentTime {
    CMAccelerometerData* accData = self.motionManager.accelerometerData;
//    CMGyroData* gyroData = self.motionManager.gyroData;
//    self.xAccel = accData.acceleration.x;
//    self.yAccel = accData.acceleration.y;
//    float zAccel = accData.acceleration.z;
    
    self.xAccel = accData.acceleration.x * self.shakeFilter + self.xAccel *(1.0f - self.shakeFilter);
    self.yAccel = accData.acceleration.y * self.shakeFilter + self.yAccel *(1.0f - self.shakeFilter);
    
    float xPos = 512*self.yAccel*self.amplify*1;
    float yPos = 512*self.xAccel*self.amplify*-1;
    
    // Winkel Babbels zur Mitte
    float angle = atan2f(yPos, xPos);// * (180/M_PI);
    
    // Radians 0...2Pi
    if (angle < 0) {
        angle = M_PI + (M_PI + angle);
    }
//    NSLog(@"Angle: %f", angle);
    
    // Maximaler X und Y Wert an bestimmter Stelle des Kreises
    float xMax = self.maxDistance * cosf(angle);
    float yMax = self.maxDistance * sinf(angle);
    
    if (fabsf(xPos) > fabsf(xMax)) {
//        xPos = xMax;
        xPos = xMax + (xPos - xMax)* 0.1;
        if (self.hasContact == false) {
            self.hits += 1;
            [self updateHitsLabel];
        }
        self.hasContact = true;
    } else {
        self.hasContact = false;
    }

    if (fabsf(yPos) > fabsf(yMax)) {
//        yPos = yMax;
        yPos = yMax + (yPos - yMax)* 0.1;
        if (self.hasContact == false) {
            self.hits += 1;
            [self updateHitsLabel];
        }
        self.hasContact = true;
    } else {
        self.hasContact = false;
    }

    
    
    self.bubble.position = CGPointMake(xPos, yPos);
    self.babbels.position = CGPointMake(xPos, yPos);
    
    
    if (self.hasContact) {
        float overlap = distanceBetweenPoints(self.bubble.position, self.blackHole.position) - self.maxDistance;
        
        self.babbels.xScale = 1 + overlap*0.025;
        self.babbels.yScale = 1 + overlap*0.025;
//        self.babbels.color = [SKColor lightGrayColor];
    } else {
        self.babbels.xScale = 1;
        self.babbels.yScale = 1;
//        self.babbels.color = [SKColor whiteColor];
    }
    
    
    
    
//    self.bubble.position = CGPointMake(self.bubble.position.x + self.yAccel*51, self.bubble.position.y - self.xAccel*51);
    
//    NSLog(@"x:%f", accData.acceleration.x);
//    NSLog(@"y:%f", accData.acceleration.y);
//    NSLog(@"gx:%f gy:%f", gyroData.rotationRate.x, gyroData.rotationRate.y);
//    NSLog(@"--------------------");
    
//    self.magneticDirection = self.locationManager.heading.magneticHeading;
    
    float magnetFilter = 0.2;
    
    if (fabsf(self.magneticDirection - self.locationManager.heading.magneticHeading) > 300) {
        self.magneticDirection = self.locationManager.heading.magneticHeading;
    }
    
    self.magneticDirection = self.locationManager.heading.magneticHeading * magnetFilter + self.magneticDirection *(1.0f - magnetFilter);
    
    self.arrowBox.zRotation = self.magneticDirection * M_PI / 180;
    self.arrowMaskBox.zRotation = self.magneticDirection * M_PI / 180;
//    self.bubble.zRotation = self.magneticDirection * M_PI / 180;
    
    
//    NSLog(@"M:%f", self.magneticDirection);
}

-(void)calcCollision {
    self.maxDistance = (self.blackHole.size.width - self.bubble.size.width)/2;
//
////    NSLog(@"hole: %f  %f", self.maxDistance, distanceBetweenPoints(self.bubble.position, self.blackHole.position));
//    
//    if (distanceBetweenPoints(self.bubble.position, self.blackHole.position) > self.maxDistance) {
//        self.blackHole.color = [SKColor redColor];
//        self.bubble.texture = [SKTexture textureWithImageNamed:@"babbelsPressed374.png"];
//        self.hasContact = YES;
//    } else {
//        self.blackHole.color = [SKColor blackColor];
//        self.bubble.texture = [SKTexture textureWithImageNamed:@"babbels374.png"];
//        self.hasContact = NO;
//    }
    
    
// TEST TEST

    if (self.hasContact) {
//        self.blackHole.color = [SKColor redColor];
        self.babbels.texture = [SKTexture textureWithImageNamed:@"babbelsPressed374.png"];
    }
    else {
//        self.blackHole.color = [SKColor blackColor];
        self.babbels.texture = [SKTexture textureWithImageNamed:@"babbels374.png"];
    }
}

-(void)newEnemyBubble {
    
    self.enemyBubble.bubble.physicsBody = nil;
    
    [self.enemyBubble removeAllActions];
    [self.enemyBubble.bubble removeAllActions];
    [self.enemyBubble.maskSection removeAllActions];
    
    [self.enemyBubble removeAllChildren];
    [self.enemyBubble removeFromParent];
    [self.enemyBubble.maskSection removeFromParent];
    
    self.enemyBubble.bubble = nil;
    self.enemyBubble = nil;
    
    self.enemyBubble = [EnemyBubble new];
    //    [self.enemyBubble setHidden:YES];
    self.enemyBubble.zPosition = -1;
    [self.crossworld.maskNode addChild:self.enemyBubble.maskSection];
    [self.crossworld addChild:self.enemyBubble];

//    [self.enemyBubble removeAllActions];
//    [self.enemyBubble.bubble removeFromParent];
//    [self.enemyBubble addChild:self.enemyBubble.bubble];
//    [self.enemyBubble.maskSection removeAllActions];
    // Punkt auf einem 600px großen Kreis
    int randAngle = RandomFloatRange(0, M_PI*2);
    float randX = 600 * cosf(randAngle);
    float randY = 600 * sinf(randAngle);
    
    [self.enemyBubble setPosition:CGPointMake(randX, randY)];
//    self.enemyBubble.bubble.position = CGPointZero;
    [self.enemyBubble.maskSection setPosition:CGPointMake(randX, randY)];
//    self.enemyBubble.zPosition = -1;
    
    
    SKAction* moveToCenter = [SKAction moveTo:CGPointZero duration:7];
    [self.enemyBubble runAction:moveToCenter completion:^{
        [self newEnemyBubble];
    }];
    [self.enemyBubble.maskSection runAction:moveToCenter completion:^{
//        [self newEnemyBubble];
    }];
}

//-------------------------
// iBeacon
//-------------------------
#pragma mark iBeacon geshizzle

-(void)initRegion {
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Eierlauf"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    //    NSLog(@"Beacon: %@", beacon);
    
    if (beacon.proximity == CLProximityUnknown) {
        //        self.backgroundColor = [SKColor lightGrayColor];
    }
    else if (beacon.proximity == CLProximityFar) {
        self.backgroundColor = [SKColor redColor];
    }
    else if (beacon.proximity == CLProximityNear) {
        self.backgroundColor = [SKColor orangeColor];
    }
    else if (beacon.proximity == CLProximityImmediate) {
        self.backgroundColor = [SKColor greenColor];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == ArrowCollisionType && secondBody.categoryBitMask == BubbleCollisionType) {
        NSLog(@"HIT");
//        Character* character = (Character *)firstBody.node;
//        SKSpriteNode* collBod = (SKSpriteNode *)secondBody.node;
//        Item* item = (Item *)[collBod.userData objectForKey:@"owner"];
//        [self collectCrystal:item];
//        [item collect];
        [self newEnemyBubble];
    }
}

@end
