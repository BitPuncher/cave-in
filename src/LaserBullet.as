package  
{
	
	import org.flixel.*;
	/**
	 * ...
	 * @author Jefferson Leard
	 */
	public class LaserBullet extends FlxSprite
	{
		
		public var bulletId:uint;
		public var nextBullet:LaserBullet;
		public var prevBullet:LaserBullet;
		
		
		public function LaserBullet(id:uint)
		{
			bulletId = id;
			nextBullet = null;
			prevBullet = null;
			this.kill();
		}
		
		override public function update():void
		{
			
		}
		
		//returns first bullet in the laser chain, ie. the one at the origin of the beam
		public function firstBullet():LaserBullet
		{
			var firstBullet:LaserBullet = this;
			while (firstBullet.prevBullet != null)
			{
				firstBullet = firstBullet.prevBullet;
			}
			return firstBullet;
		}
		
		//returns last bullet in the laser chain, ie. the one at the target
		public function lastBullet():LaserBullet
		{
			var lastBullet:LaserBullet = this;
			while (lastBullet.nextBullet != null)
			{
				lastBullet = lastBullet.prevBullet;
			}
			return lastBullet;
		}
		
		override public function kill()
		{
			super.kill();
			nextBullet = null;
			prevBullet = null;
			alpha = 1;
		}
		
	}

}