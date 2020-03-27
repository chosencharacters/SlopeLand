package;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.ProjectLayerData;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.LevelData;

/**
 * ...
 * @author 
 */
class FlxOgmo3LoaderExt extends FlxOgmo3Loader 
{

	public function new(projectData:String, levelData:String) 
	{
		super(projectData, levelData);
		
	}
	
	public function loadTilemapExt(tileGraphic:Dynamic, tileLayer:String = "tiles"):FlxTilemapExt
	{
		var tilemap = new FlxTilemapExt();
		var layer = getTileLayer(level, tileLayer);
		var tileset = getTilesetData(project, layer.tileset);
		
		switch (layer.arrayMode)
		{
			case 0:
				//-1 tends to crash FlxTilemapExt so...
				for (tile in 0...layer.data.length)
					if (layer.data[tile] == -1)
						layer.data[tile] = 0;
				tilemap.loadMapFromArray(layer.data, layer.gridCellsX, layer.gridCellsY, tileGraphic, tileset.tileWidth, tileset.tileHeight);
			case 1:
				for (r in 0...layer.data2D.length)
					for (c in 0...layer.data2D[r].length)
						if (layer.data2D[r][c] == -1)
							layer.data2D[r][c] = 0;
				tilemap.loadMapFrom2DArray(layer.data2D, tileGraphic, tileset.tileWidth, tileset.tileHeight);
		}
		return tilemap;
	}
	
	/**
	 * Get Tile Layer data matching a given name
	 */
	static function getTileLayer(data:LevelData, name:String):TileLayer
	{
		for (layer in data.layers)
			if (layer.name == name)
				return cast layer;
		return null;
	}
	
	/**
	 * Get matching Tileset data from a given name
	 */
	static function getTilesetData(data:ProjectData, name:String):ProjectTilesetData
	{
		for (tileset in data.tilesets)
			if (tileset.label == name)
				return tileset;
		return null;
	}
	
}