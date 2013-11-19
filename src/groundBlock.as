package  
{
	import flash.utils.Dictionary;
	import org.flixel.*;
	/**
	 * ...
	 * @author ...
	 */
	public class groundBlock extends FlxSprite
	{
		public var location:FlxPoint;
		public var size:uint;
		public var toughness:uint;
		public static var colors:Dictionary = new Dictionary();
		colors[1] = 0xff6C7A4D;
		colors[2] = 0xff4D627A;
		
		public function groundBlock(x:int, y:int, toughness:uint, size:uint) 
		{
			location = new FlxPoint(x, y);
			this.size = size;
			this.toughness = toughness;
			super(location.x * size, location.y * size);
			this.makeGraphic(size, size, colors[toughness]);
			immovable = true;
			trace(this.y);
			
		}
		
		override public function update():void 
		{
			if (y < location.y * size)
			{
				velocity.y = 50;
			}
			else if (y > location.y * size)
			{
				y = location.y * size;
				velocity.y = 0;
			}
			else
			{
				velocity.y = 0;
			}
				super.update();
		}
		
		
	}

}