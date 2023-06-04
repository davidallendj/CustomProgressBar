extends PanelContainer

@onready var fill 		:= %Fill
@onready var container 	:= %Container
@export var max_value	:= 10

enum fill_direction{
	LEFT_TO_RIGHT,
	RIGHT_TO_LEFT,
	TOP_TO_BOTTOM,
	BOTTOM_TO_TOP
}

var direction = fill_direction.LEFT_TO_RIGHT


func _ready() -> void:
	auto_resize_container()


func increment(value: int = 1) -> void:
	var current_value: int 		= get_value()
	var new_value 				= clamp(value, current_value, max_value);
	var container_size: Vector2 = container.get_size()
	var fill_size: float 		= floor(max_value / container_size.x) 
	for i in range(current_value, current_value+value, 1):
		if current_value+value > max_value:
			break
		var f = fill.duplicate()
		container.add_child(f)
		f.set_visible(true)


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


func get_value() -> int:
	return container.get_child_count()


func get_max_value() -> int:
	return max_value


func get_percent() -> float:
	return (get_value() / max_value) * 100


func set_value(value: int) -> void:
	value = clamp(value, 0, max_value)
	clear()
	for i in max_value:
		if i <= value-1:
			var f = fill.duplicate()
			container.add_child(f)
			f.set_visible(true)
		else:
			var f = container.get_child(i)
			container.remove_child(f)


func set_max_value(value: int) -> void:
	max_value = value
	auto_resize_container()


func set_color(color: Color) -> void:
	for i in get_value():
		container.get_child(i).set_color(color)


func set_value_color(index: int, color: Color) -> void:
	index = clamp(index, 0, get_value())
	container.get_child(index).set_color(color)


func set_fill_size(value: Vector2) -> void:
	var current_value: int = get_value()
	for i in get_value():
		var f = container.get_child(i)
		f.set_size(value)


func set_container_size(value: int) -> void:
	var fill_size = fill.get_size()
	container.set_size(Vector2(value*fill_size.x, fill_size.y))


func is_horizontal() -> bool:
	return \
	direction == fill_direction.LEFT_TO_RIGHT or \
	direction == fill_direction.RIGHT_TO_LEFT


func is_vertial() -> bool:
	return !is_horizontal()


func auto_resize_container() -> void:
	var separation 	= container.get("theme_override_constants/separation")
	var fill_size 	= fill.get_custom_minimum_size()
	var final_size	= Vector2()
	if is_horizontal():
		final_size.x	= max_value * (fill_size.x + separation)
	else:
		final_size.y 	= max_value * (fill_size.x +separation)
	container.set_custom_minimum_size(final_size)
	container.set_size(final_size)
