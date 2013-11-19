package  
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Jefferson Leard
	 */
	public class Pickup extends FlxSprite 
	{
		[Embed(source = "../lib/coinArt.png")] protected var CoinArt:Class;
		public var type:String;
		public var ttlTimer:FlxTimer;
		public var ttl:uint;
		//public var id:uint;
		
		public function Pickup(type:String="coin") 
		{
			super();
			if (type == "coin")
			{
				type = "coin"
				//this.id = id;
				acceleration.y = 100;
				maxVelocity.y = 90;
				maxVelocity.x = 90;
				elasticity = .5;
				drag.x = maxVelocity.x * 3;
				drag.y = maxVelocity.y * 3;
				ttl = 7;
				ttlTimer = new FlxTimer();
				ttlTimer.start(ttl, 1);
			}
		}
		
		/**
		 * Adds kill switch when Time to Live is up, as well as flicker warning when almost dead.
		 */
		override public function update():void
		{
			super.update();
			if (ttlTimer.finished)
			{
				kill();
			}
			else if (!flickering && ttlTimer.progress > .75)
			{
				this.flicker(ttlTimer.timeLeft);
			}
		}
		
		/**
		 * Adds Time to Live Timer maintenance.
		 */
		override public function revive():void
		{
			super.revive();
			ttlTimer.start(ttl, 1);
		}
		
		/**
		 * Adds Time to Live Timer maintenance.
		 */
		override public function kill():void
		{
			super.kill();
			ttlTimer.stop();
		}
		
		/**
		 * Static function that allows you to create a pickup from a group
		 * or from scratch and give it an x, y category. On second thought, the
		 * constructor handles the second case, so maybe I should just leave
		 * that to that. But maybe I won't, since this function has x and y
		 * velocity presets.
		 * @param	x	The x coordinate to spawn the pickup at.
		 * @param	y	Thy y coordinate to spawn the pickup at.
		 * @param	group	If passed a group, it will select the first Available
		 * 					from the group to spawn.
		 * @return	Returns the spawned Pickup object.
		 */
		public static function spawn(x:int, y:int, group:FlxGroup = null):Pickup
		{
			var pickup:Pickup;
			
			if (group)
			{
				pickup = group.getFirstAvailable() as (Pickup);
				pickup.revive();
				pickup.x = x;
				pickup.y = y;
				pickup.velocity.x = (Math.random() * 150) - 75;
				pickup.velocity.y = Math.random() * -100;
			}
			else
			{
				pickup = new Pickup();
				pickup.x = x;
				pickup.y = y;
				pickup.velocity.x = (Math.random() * 150) - 75;
				pickup.velocity.y = (Math.random() * -50) - 50;
			}
			return pickup;
		}
	}

}