extends Node2D

var focused := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var poly: Array = $Walls/Line2D.points
	poly.append(poly[0])
	$Walls/CollisionPolygon2D.polygon = poly
	$Walls/Polygon2D.polygon = poly
	$CanvasLayer/LightOccluder2D.occluder.polygon = poly
	
	$CanvasLayer/FlickerOverlay.show()
	$CanvasLayer/FlashlightColor.show()
	$CanvasLayer/Tiling.show()
	$CanvasLayer/CanvasModulate.color = Color(0,0,0)

func _process(delta: float) -> void:
	$CanvasLayer/PointLight2D.position = $Player.global_position
	$CanvasLayer/PointLight2D.rotation = $Player.rot
