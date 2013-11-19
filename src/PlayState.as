package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.ui.MouseCursor;
	import mx.core.BitmapAsset;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import org.flixel.system.FlxTile;
	/**
	 * ...
	 * @author Jefferson Leard
	 */
	public class PlayState extends FlxState
	{
		[Embed(source = "../lib/blockArt.png")] protected var BlockArt:Class;
		[Embed(source = "../lib/playerArt.png")] protected var PlayerArt:Class;
		[Embed(source = "../lib/coinArt.png")] protected var CoinArt:Class;
		
		public var tileWidth:int;
		public var tileHeight:int;
		public var player:FlxSprite;
		public var level:FlxTilemap;
		public var groundGroup:FlxGroup;
		public var primWeapon:FlxWeapon;
		public var primWeaponDamage:uint;
		public var secWeapon:FlxWeapon;
		public var secWeaponDamage:uint;
		public var cursor:Sprite;
		public var cursor2:MouseCursor;
		public var occupiedZone:uint; //used for measuring where the player is/was to assist in screen scrolling; 1 = top 2 rows, 2 = middle 10 rows, 3 = bottom 2 rows
		public var scoreText:FlxText;
		public var score:int;
		public var ceiling:int;
		public var ceilingTimer:FlxTimer;
		public var ceilingTimerBar:FlxBar;   //NYI
		public var currentCeilingSet:GroundBlockSet;
		public var stability:FlxSprite;
		public var stabilityBar:FlxBar;
		public var started:Boolean; //NYI
		public var pauseText:FlxText;
		
		public var coinGroup:FlxGroup;
		
		//game over variables
		public var gameOverTimer:FlxTimer;
		public var gameOverSprite:FlxSprite;
		public var gameOverText:FlxText;
		public var gameOverButton:FlxButton;
		public var gameOverGroup:FlxGroup;
		
		//debug timer
		private var debugTimer:FlxTimer;
		
		
		
		override public function create():void
		{
			//debug setup
			debugTimer = new FlxTimer;
			debugTimer.start(1, 1, debug);
			
			
			//basic variables
			tileHeight = 8;
			tileWidth = 8;
			FlxG.bgColor = 0xff111111;
			started = false;
			FlxG.paused = true;
			
			//score data
			score = 0;
			scoreText = new FlxText(172, 10, 80, "Score: ");
			scoreText.color = 0xffffffff;
			scoreText.alignment = "left";
			//end score data
			
			//level data
			var data:Array = new Array (
				1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
				0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
			
			level = new FlxTilemap();
			level.loadMap(FlxTilemap.arrayToCSV(data, 20), FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			//end level data
			
			
			
			
			
			
			//ground data
			
			/* New implementation of ground: DONE
			 * -ground group contains non-static groundBlockSet objects
			 * -they form a linked list
			 * -when a member object is completely turned to stone AND is also completely off screen, it is killed
			 * -once a member object is fully revealed on-screen, the group calls FlxGroup.recycle() to generate a new groundBlockSet
			 * --and initializes it, placing it at the end of the linked list
			 * 
			 */
			
			var tempBlockSet:GroundBlockSet;
			var arr:Array;
			groundGroup = new FlxGroup();
			
			for (var i:int = 0; i < 3; i++)
			{
				tempBlockSet = groundGroup.recycle(GroundBlockSet) as GroundBlockSet;
				if (i == 0)
				{
					arr = GroundBlockSet.randomize(level.widthInTiles - 4, 14, 2, 10);
				}
					else
				{
					arr = GroundBlockSet.randomize(level.widthInTiles - 4, 14, 2);
					tempBlockSet.previousSet = groundGroup.members[i - 1];
					tempBlockSet.previousSet.nextSet = tempBlockSet;
				}
				tempBlockSet.loadMap(FlxTilemap.arrayToCSV(arr, level.widthInTiles - 4), BlockArt, tileWidth, tileHeight);
				tempBlockSet.loadHealth();
				tempBlockSet.setTileProperties(1, FlxObject.ANY, brickBreak, Bullet, 6);
				tempBlockSet.maxVelocity.y = 300;
				tempBlockSet.acceleration.y = 0;
				
				tempBlockSet.x = (3 * tileWidth);
				tempBlockSet.y = ((groundGroup.countLiving() - 1) * tempBlockSet.height + tileHeight);
			}
			//end ground data
			
			
			//ceiling data
			ceiling = 0;
			currentCeilingSet = groundGroup.getFirstAlive() as GroundBlockSet;
			
			ceilingTimer = new FlxTimer();
			ceilingTimer.start(2, 1, ceilingTimerEnd);
			ceilingTimer.paused = true;
			//end ceiling data
			
			//stability data
			stability = new FlxSprite(0, 0);
			stability.visible = false;
			stabilityBar = new FlxBar(scoreText.x, scoreText.y + 15, FlxBar.FILL_LEFT_TO_RIGHT, 30, 10, stability, "health", 1, 100, false);
			//end stability data
			
			
			//player data
			player = new FlxSprite(8, 16);
			player.loadGraphic(PlayerArt, false, true);
			player.facing = FlxObject.RIGHT;
			//player.makeGraphic(7, 7, 0xff0800ff);
			player.maxVelocity.x = 100;
			player.maxVelocity.y = 300;
			player.acceleration.y = 150;
			player.drag.x = player.maxVelocity.x * 5;
			occupiedZone = 1;
			//end player data
			
			//coin data
			coinGroup = new FlxGroup(30);
			for (i = 0; i < coinGroup.maxSize; i++)
			{
				var tempCoin:Pickup = new Pickup("coin");
				tempCoin.loadGraphic(CoinArt);
				tempCoin.kill();
				coinGroup.add(tempCoin);
			}
			//end coin data
			
			
			//Weapon data
			primWeapon = new FlxWeapon("digger", player, "x", "y");
			primWeapon.makePixelBullet(30, 2, 2, 0xffffffff, 4, 4);
			primWeapon.setBulletLifeSpan(1000);
			primWeapon.setFireRate(250);
			primWeapon.setBulletSpeed(32);
			primWeaponDamage = 1;
			
			secWeapon = new FlxWeapon("bomb", player, "x", "y");
			secWeapon.makePixelBullet(10, 4, 4, 0xffffff00, 4, 4);
			secWeapon.setBulletLifeSpan(0);
			secWeapon.setFireRate(5000);
			secWeapon.setBulletSpeed(24);
			secWeaponDamage = 3;
			//end Weapon data
			
			//Cursor Data
			FlxG.mouse.show();
			
			pauseText = new FlxText(level.width / 2 -25, level.height / 2, 60, "Paused (P)");
			pauseText.alignment = "center";
			
			
			//gameOver variables
			gameOverSprite = new FlxSprite();
			gameOverSprite.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			gameOverSprite.alpha = 0;
			//gameOverSprite.kill();
			
			gameOverText = new FlxText(FlxG.width / 2 - 5, FlxG.height / 2, 100, "game over :\\");
			gameOverButton = new FlxButton(FlxG.width / 2 - 10, FlxG.height / 2 + 30, "retry", retry);
			gameOverGroup = new FlxGroup();
			gameOverGroup.add(gameOverText);
			gameOverGroup.add(gameOverButton); //gameOverGroup gets added later when the player dies
			
			gameOverTimer = new FlxTimer();
			//end gameOver variables
			
			//all the adds
			add(scoreText);
			add(groundGroup);
			add(level);
			add(stability);
			add(stabilityBar);
			add(player);
			add(primWeapon.group);
			add(secWeapon.group);
			add(coinGroup);
			add(pauseText);
			add(gameOverSprite);
			//end adds
			
		}
		
		override public function update():void 
		{	
			if (!player.alive)
			{
				if(!gameOverTimer.finished)
					gameOverSprite.alpha = gameOverTimer.progress * .75;
				//return;
			}
			else
			{
				
			}
			
			
			if (FlxG.keys.justPressed("P"))
			{
				FlxG.paused = !FlxG.paused;
			}
			
			
			if (FlxG.paused)
			{
				pauseText.visible = true;
				ceilingTimer.paused = true;
				return;
			}
			else
			{
				pauseText.visible = false;
				if (started)
					ceilingTimer.paused = false;
			}
			
			//for use in a bunch of for loops. jerks.
			var i:int;
			
			//determines when to flag the game's start so the ceiling can start falling
			if (!started && player.x > level.x + tileWidth * 3)
			{
				started = true;
			}
			
			//player input
			player.acceleration.x = 0;
			if (FlxG.keys.A)
				player.acceleration.x = -player.maxVelocity.x * 3;
			if (FlxG.keys.D)
				player.acceleration.x = player.maxVelocity.x * 3;
			if (FlxG.keys.W && player.isTouching(FlxObject.FLOOR))
				player.velocity.y = -player.maxVelocity.y / 4;
			if (FlxG.mouse.pressed())
			{
				if (FlxG.keys.SHIFT)
					secWeapon.fireAtMouse();
				else
					primWeapon.fireAtMouse();
			}
			
			super.update();
			
			//player facing
			if (player.x < FlxG.mouse.screenX)
				player.facing = FlxObject.RIGHT;
			else if (player.x > FlxG.mouse.screenX)
				player.facing = FlxObject.LEFT;
				
			
			//occupiedZone changes and stage reactions (scrolling)
			if (player.y > player.height * (level.heightInTiles * 1 / 4) && occupiedZone == 1)
			{
				occupiedZone = 2;
			}
			
			if (player.y <= player.height * (level.heightInTiles * 1 / 4) && occupiedZone == 2)
			{
				occupiedZone = 1;
			}
			
			if (player.y > player.height * (level.heightInTiles * 3 / 4) && occupiedZone == 2)
			{
				for (i = 0; i < groundGroup.length; i++)
				{
					groundGroup.members[i].velocity.y = player.velocity.y * -1;
					groundGroup.members[i].acceleration.y  = player.acceleration.y * -1;
				}
				
				player.velocity.y = 0;
				player.acceleration.y = 0;
				
				occupiedZone = 3;
			}
			
			if (player.y <= player.height * (level.heightInTiles * 1 / 3) && occupiedZone == 3)
			{
				player.acceleration.y = groundGroup.members[0].acceleration.y * -1;
				player.velocity.y = groundGroup.members[0].velocity.y * -1;
				
				for (i = 0; i < groundGroup.length; i++)
				{
					groundGroup.members[i].acceleration.y = 0;
					groundGroup.members[i].velocity.y = 0;
				}
				
				occupiedZone = 2;
			}
			
			//groundBlock recycling
			
			var tempSet:GroundBlockSet;
			tempSet = groundGroup.getFirstAlive() as GroundBlockSet;
			tempSet = tempSet.lastSet();
			
			if (tempSet.y + tempSet.height < FlxG.height)
			{
				var newBlockSet:GroundBlockSet = groundGroup.recycle(GroundBlockSet) as GroundBlockSet;
				var arr:Array = GroundBlockSet.randomize(level.widthInTiles - 4, 14, 2);
				
				newBlockSet.loadMap(FlxTilemap.arrayToCSV(arr, level.widthInTiles - 4), BlockArt, tileWidth, tileHeight);
				newBlockSet.loadHealth();
				newBlockSet.setTileProperties(1, FlxObject.ANY, brickBreak, Bullet, 6);
				newBlockSet.maxVelocity.y = tempSet.maxVelocity.y;
				newBlockSet.velocity.y = tempSet.velocity.y;
				newBlockSet.acceleration.y = tempSet.acceleration.y;
				
				newBlockSet.x = (tempSet.x);
				newBlockSet.y = (tempSet.y + tempSet.height);
				
				newBlockSet.previousSet = tempSet;
				tempSet.nextSet = newBlockSet;
				
				newBlockSet.revive();
			}
			
			tempSet = tempSet.firstSet();
			
			while (!tempSet.onScreen() && tempSet != currentCeilingSet)
			{
				tempSet = tempSet.nextSet;
				tempSet.previousSet.kill();
			}
			
			//collision
			
			FlxG.collide(primWeapon.group, groundGroup);
			FlxG.collide(secWeapon.group, groundGroup);
			FlxG.collide(player, groundGroup);
			FlxG.collide(coinGroup, groundGroup);
			FlxG.collide(coinGroup, level);
			FlxG.collide(player, coinGroup, collectCoin);
			FlxG.collide(groundGroup);
			FlxG.collide(groundGroup, level);
			FlxG.collide(level, player);
			//FlxG.collide(ceiling, groundGroup);
			
			
			//Ceiling Falling is now being handled by a private function call ceilingTimerEnd(timer:FlxTimer) on expiration of timer.
			
			scoreText.text = "Score: ".concat(score.toString());
			
		}
		
		/**
		 * 
		 * @param	brick
		 * @param	bullet
		 */
		private function brickBreak(brick:FlxTile, bullet:FlxObject):void
		{
			var tempBullet:Bullet = bullet as (Bullet);
			
			bullet.kill();
			var map:GroundBlockSet = GroundBlockSet(brick.tilemap);
			var tileBroken:Number = map.hurtTile(brick, primWeaponDamage);
			score += 50 * tileBroken;
			stability.health += tileBroken * 5;
			if (tileBroken > 0)
			{
				var amount:Number = Math.random() * 100;
				if (amount > 90)
				{
					Pickup.spawn(brick.x, brick.y, coinGroup);
					Pickup.spawn(brick.x, brick.y, coinGroup);
					Pickup.spawn(brick.x, brick.y, coinGroup);
				}
				else if (amount > 80)
				{
					Pickup.spawn(brick.x, brick.y, coinGroup);
					Pickup.spawn(brick.x, brick.y, coinGroup);
				}
				else if (amount > 70)
				{
					Pickup.spawn(brick.x, brick.y, coinGroup);
				}
				//else //test use
				//{
					//Pickup.spawn(brick.x, brick.y, coinGroup);
				//}
			}
		}
		
		/**
		 * 
		 * @param	timer
		 */
		private function gameOver(timer:FlxTimer):void
		{
			add(gameOverGroup);
		}
		
		/**
		 * 
		 * @param	timer
		 */
		private function ceilingTimerEnd(timer:FlxTimer):void
		{
			var i:int;
			
			ceilingTimer.stop();
			
			stability.health = FlxU.bound(stability.health - 5, 1, 100);
			
			for (i = 0; i < currentCeilingSet.widthInTiles; i++)
			{
				currentCeilingSet.setTile(i, ceiling, 7);
			}
			
			ceiling++;
			
			if (ceiling >= currentCeilingSet.heightInTiles)
			{
				ceiling -= currentCeilingSet.heightInTiles;
				if (currentCeilingSet.nextSet == null)   					//THIS should end the timer resets if ceiling reaches the last viable row of ground
					return;
				else
					currentCeilingSet = currentCeilingSet.nextSet;  
			}
			
			if (player.alive && player.y < currentCeilingSet.y + ceiling * tileHeight)
			{
				player.kill();
				gameOverTimer.start(3, 1, gameOver);
				timer.start(.2, 1, ceilingTimerEnd);
			}
			else if (player.alive)
				timer.start(5 * (1 - stability.health / 100), 1, ceilingTimerEnd);
			else
			{
				timer.start(.2, 1, ceilingTimerEnd)
			}
		}
		
		/**
		 * 
		 */
		private function retry():void
		{
			FlxG.switchState(new PlayState());
		}
		
		/**
		 * A function that prints certain variable values to the console every 1 second.
		 * Used for debugging.
		 * @param	timer The debug timer. Function resets the timer each time it expires.
		 */
		private function debug(timer:FlxTimer):void
		{
			timer.stop();
			
			//trace("Count Living: " + groundGroup.countLiving());
			//trace("Ceiling: " + ceiling);
			
			//trace("gameOverSprite.alpha: " + gameOverSprite.alpha);
			//trace("sprite var " + gameOverSprite.visible)
			timer.start(1, 1, debug);
		}
		
		private function collectCoin(player:FlxObject, pickup:FlxObject):void
		{
			pickup.kill();
			score += 1;
		}
	}

}