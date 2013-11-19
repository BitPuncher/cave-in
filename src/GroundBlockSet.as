package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.system.FlxTile;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GroundBlockSet extends FlxTilemap
	{
		
		public var tileHealth:Array;
		public var previousSet:GroundBlockSet;
		public var nextSet:GroundBlockSet;
		
		
		public function GroundBlockSet() 
		{
			super();
		}
		
		
		//must be called after initialization in order for blocks to break
		public function loadHealth():void
		{
			tileHealth = new Array();
			var arr:Array = getData();
			for (var i:int = 0; i < arr.length; i++)
			{
				tileHealth.push((arr[i] * (arr[i] / 3)) as Number);
			}
		}
		
		
		//Takes a FlxTile object that will allow the GroundBlockSet to find the corresponding tile and allocate its damage, returns a score value, if any, of the damage done
		public function hurtTile(Tile:FlxTile, damage:int):int
		{
			var toughness:Number = Math.ceil(Tile.index / 3);
			
			tileHealth[Tile.mapIndex] -= damage;
			
			var newTileValue:uint = Math.ceil(tileHealth[Tile.mapIndex] / toughness);
			
			if (newTileValue < getTileByIndex(Tile.mapIndex))
			{
				if (newTileValue % 3 == 0)
				{
					setTileByIndex(Tile.mapIndex, 0);
					return toughness;
				}
				else
				{
					setTileByIndex(Tile.mapIndex, newTileValue);
				}
			}
			return 0;
		}
		
		override public function update():void
		{
			
		}
		
		//Returns a randomized array map for the GroundBlockSet with the given width and height,
		//optionally specifies the range of used tile variance and how many empty rows staring at the top (default zero rows)
		public static function randomize(width:uint, height:uint, tiles:uint = 2, depth:uint = 0):Array
		{
			var arr:Array = [];
			for (var i:int = 0; i < width * height; i++)
			{
				if (i < width * depth)
					arr.push(0);
				else
				{
					arr.push(Math.ceil(Math.random() * (tiles)) * 3);
				}
			}
			
			return arr;
		}
		
		//returns the first GroundBlockSet in the chain, from any member set, by recursing along @previousSet
		//and returning self if @previousSet is null
		public function firstSet():GroundBlockSet
		{
			if (previousSet == null)
				return this;
			else
				return previousSet.firstSet();
		}
		
		//returns the last GroundBlockSet in the chain, from any member set, by recursing along @nextSet
		//and returning self if @nextSet is null
		public function lastSet():GroundBlockSet
		{
			if (nextSet == null)
				return this;
			else
				return nextSet.lastSet();
		}
		
		override public function kill():void
		{
			if (previousSet != null)
				previousSet.nextSet = nextSet;
			if (nextSet != null)
				nextSet.previousSet = previousSet;
			previousSet = null;
			nextSet = null;
			
			super.kill();
		}
		
		
	}

}