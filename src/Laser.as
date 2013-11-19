package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Jefferson Leard
	 */
	public class Laser extends FlxSprite
	{
		public var owner:FlxSprite;
		public var offset:FlxPoint;
		
		public var firingAngle:uint;
		
		public var group:FlxGroup;
		public var power:uint;
		
		
		
		
		public function Laser(owner:FlxSprite, offset:FlxPoint = new FlxPoint(0,0), power:uint = 8*6) 
		{
			this.owner = owner;
			this.power = power;
			group = new FlxGroup(power * 2);
			
			this.offset = offset;
			
			
			var i:int = 0;
			while (i < group.maxSize)
			{
				var tempBullet:LaserBullet = new LaserBullet(i);
				
				tempBullet.makeGraphic(2, 2);
				group.add(tempBullet);
				
				i++;
			}
		}
		
		public function fire(angle:uint)
		{
			var currentBullet:LaserBullet = group.getFirstAvailable();
			//make each bullet in the chain reduce its alpha by its proximity of point in the chain to max power, once zero no more chains added
			
		}
		
	}

}