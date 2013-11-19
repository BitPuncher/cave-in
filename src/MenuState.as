package  
{
	import org.flixel.*;
	import org.flixel.FlxState;
	/**
	 * screen size is 320x240 (in usable pixels not actual reso)
	 * @author Jefferson Leard
	 */
	public class MenuState extends FlxState
	{
		private var title:FlxText;
		private var newGame:FlxButton;
		private var avatar:FlxSprite;
		private var background:FlxSprite;
		private var level:FlxTilemap;
		
		override public function create():void 
		{
			background = new FlxSprite(0, 0);
			background.makeGraphic(FlxG.width, FlxG.height, 0xff5e5e5e);
			add(background);
			
			level = new FlxTilemap();
			
		}
		
		override public function update():void 
		{
			
		}
		
	}

}