@tool
extends PanelContainer

@onready var fill 			:= %Fill
@onready var container 		:= %Container

@export var value			:= 0: 	get = get_value, set = set_value
@export var max_value		:= 10: 	set = set_max_value
@export var separation		:= 4: 	get = get_separation, set = set_separation
@export var fill_size		:= Vector2(8, 0)
@export var fill_direction 	:= FillDirection.LEFT_TO_RIGHT
@export var fill_color		:= Color.YELLOW
@export var auto_resize 	:= AutoResize.CONTAINER


enum FillDirection {
	LEFT_TO_RIGHT,
	RIGHT_TO_LEFT,
	TOP_TO_BOTTOM,
	BOTTOM_TO_TOP
}

enum AutoResize {
	NONE,
	FILL,
	CONTAINER
}


func _ready() -> void:
	_auto_resize(auto_resize)


func increment(value: int = 1) -> void:
	var current_value: int 		= get_value()
	var new_value 				= clamp(value, current_value, max_value);
	var container_size: Vector2 = container.get_size()
	for i in range(current_value, current_value+value, 1):
		if current_value+value > max_value:
			break
		var f = fill.duplicate()
		container.add_child(f)
		f.set_visible(true)
		f.set_color(fill_color)
		f.set_custom_minimum_size(fill_size)


func decrement(value: int = 1) -> void:
	var current_value: int 	= get_value()
	var new_value 			= clamp(value, 0, current_value)
	for i in range(current_value, current_value-value, -1):
		var f = container.get_child(i-1)
		container.remove_child(f)


func clear() -> void:
	var current_value: int = get_value()
	for i in range(0, current_value, 1):
		var f = container.get_child(0)
		container.remove_child(f)


func get_percent() -> float:
	return (get_value() / max_value) * 100


func get_value() -> int:
	return container.get_child_count()


func get_max_value() -> int:
	return max_value


func get_value_color(index: int) -> Color:
	index = clamp(index, 0, get_value())
	return container.get_child(index).get_color()


func get_fill_size() -> Vector2:
	return fill_size


func get_color() -> Color:
	return fill_color


func get_separation() -> int:
	return container.get("theme_override_constants/separation")


func set_percent(value: float) -> void:
	set_value(floor(value * max_value))


func set_value(value: int) -> void:
	value = clamp(value, 0, max_value)
	clear()
	for i in max_value:
		if i <= value-1:
			var f = fill.duplicate()
			container.add_child(f)
			f.set_visible(true)
			f.set_color(fill_color)
			f.set_custom_minimum_size(fill_size)


func set_max_value(value: int) -> void:
	max_value = value
	_auto_resize()


func set_color(fill_color: Color) -> void:
	self.fill_color = fill_color
	for i in get_value():
		container.get_child(i).set_color(self.fill_color)


func set_separation(value: int) -> void:
	container.set("theme_override_constants/separation", value)


func set_value_color(index: int, fill_color: Color) -> void:
	index = clamp(index, 0, get_value())
	container.get_child(index).set_color(fill_color)


func set_fill_size(value: Vector2) -> void:
	fill_size = value
	for i in get_value():
		var f = container.get_child(i)
		f.set_custom_minimum_size(fill_size)


func set_container_size(value: int) -> void:
	container.set_size(Vector2(value*fill_size.x, fill_size.y))


func set_auto_resize(type: AutoResize) -> void:
	auto_resize = type


func is_horizontal() -> bool:
	return \
	fill_direction == FillDirection.LEFT_TO_RIGHT or \
	fill_direction == FillDirection.RIGHT_TO_LEFT


func is_vertial() -> bool:
	return !is_horizontal()


func _auto_resize(v = auto_resize) -> void:
	match v:
		AutoResize.NONE: 									return
		AutoResize.FILL: 		_auto_resize_fill(); 		return
		AutoResize.CONTAINER: 	_auto_resize_container(); 	return


func _auto_resize_container() -> void:
	print("_auto_resize_container()")
	var separation 	= get_separation()
#	var fill_size 	= fill.get_custom_minimum_size()
	var final_size	= get_size()
	if is_horizontal():
		final_size.x = max_value * (fill_size.x + separation)
	else:
		final_size.y = max_value * (fill_size.x +separation)
	container.set_custom_minimum_size(final_size)
	container.set_size(final_size)


func _auto_resize_fill() -> void:
	print("_auto_resize_fill()")
	var container_size 	= container.get_size()
	var separation 		= get_separation()
	var x 				= floor((container_size.x / max_value) - separation) 
	var y				= container_size.y
	set_fill_size(Vector2(x, y))
	
