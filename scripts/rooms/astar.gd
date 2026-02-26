extends TileMapLayer

var astar = AStarGrid2D.new()

func _ready():
	var tilemap_size = get_used_rect().end - get_used_rect().position
	var map_rect = Rect2i(Vector2i.ZERO, tilemap_size)
	
	var tile_size = get_tile_set().tile_size
	astar.region = map_rect
	# continue https://www.youtube.com/watch?v=OMrDS0zlr-k at 2:40
	
