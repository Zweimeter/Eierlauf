//
//  GameScene.h
//  Eierlauf
//

//  Copyright (c) 2015 Sebastian Klotz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
@class Crossworld;
@class EnemyBubble;

float distanceBetweenPoints(CGPoint first, CGPoint second);

@interface GameScene : SKScene <CLLocationManagerDelegate, SKPhysicsContactDelegate>

@property (nonatomic) CFTimeInterval currentTime;

@property (nonatomic) SKNode* gameContent;
@property (nonatomic) SKNode* interface;
@property (nonatomic) SKNode* playground;
@property (nonatomic) SKSpriteNode* blackHole;
@property (nonatomic) SKSpriteNode* bg;

@property (nonatomic) Crossworld* crossworld;

@property (nonatomic) CMMotionManager* motionManager;
@property (nonatomic) CMAccelerometerData* accelerometerData;
@property (nonatomic) CMAttitude* attitude;
@property (nonatomic) CMAttitude* refFrame;

@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) CLLocationDirection magneticDirection;

@property (nonatomic) SKLabelNode* amplifyLabel;
@property (nonatomic) SKSpriteNode* ampDown;
@property (nonatomic) SKSpriteNode* ampUp;

@property (nonatomic) SKLabelNode* shakeFilterLabel;
@property (nonatomic) SKSpriteNode* shakeDown;
@property (nonatomic) SKSpriteNode* shakeUp;

@property (nonatomic) float amplify;
@property (nonatomic) float shakeFilter;
@property (nonatomic) float xAccel;
@property (nonatomic) float yAccel;

@property (nonatomic) SKNode* arrowBox;
@property (nonatomic) SKNode* arrowMaskBox;
@property (nonatomic) SKSpriteNode* arrowMask;
@property (nonatomic) SKSpriteNode* magnetArrow;

@property (nonatomic) EnemyBubble* enemyBubble;
//@property (nonatomic) BOOL enemyV

@property (nonatomic) SKSpriteNode* babbels;
@property (nonatomic) SKSpriteNode* bubble;
@property (nonatomic) BOOL hasContact;
@property (nonatomic) float maxDistance;

@property (nonatomic) SKLabelNode* holeLabel;
@property (nonatomic) SKSpriteNode* bubbleDown;
@property (nonatomic) SKSpriteNode* bubbleUp;
@property (nonatomic) float holeScale;

@property (nonatomic) CLBeaconRegion *beaconRegion;

@property (nonatomic) SKLabelNode* timerLabel;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) CFTimeInterval passedTime;
@property (nonatomic) float penalty;
@property (nonatomic) CFTimeInterval combinedTime;

@property (nonatomic) SKLabelNode* hitCounter;
@property (nonatomic) int hits;

@end
