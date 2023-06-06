extends CenterContainer

@onready var progress_bar 		:= $VBoxContainer/HBoxContainer/StylizedProgressBar
@onready var button_decrease 	:= $VBoxContainer/HBoxContainer/Decrease
@onready var button_increase 	:= $VBoxContainer/HBoxContainer/Increase
@onready var set_value 			:= $VBoxContainer/GridContainer/SetValue
@onready var set_max_value 		:= $VBoxContainer/GridContainer/SetMaxValue
@onready var set_separation 	:= $VBoxContainer/GridContainer/SetSeparation
@onready var set_fill_size		:= $VBoxContainer/GridContainer/SetFillSize
@onready var color_picker		:= $VBoxContainer/GridContainer/ColorPickerButton
@onready var resize				:= $VBoxContainer/GridContainer/OptionButton


func _ready() -> void:
	button_increase.pressed.connect(_increase)
	button_decrease.pressed.connect(_decrease)
	set_value.value_changed.connect(_set_value)
	set_max_value.value_changed.connect(_set_max_value)
	set_separation.value_changed.connect(_set_separation)
	set_fill_size.value_changed.connect(_set_fill_size)
	color_picker.color_changed.connect(_set_color)
	resize.item_selected.connect(_set_auto_resize)
	color_picker.set_pick_color(progress_bar.get_color())
	set_value.set_value(progress_bar.get_value())
	set_max_value.set_value(progress_bar.get_max_value())
	set_fill_size.set_value(progress_bar.get_fill_size().x)


func _decrease() -> void:
	progress_bar.decrement()
	set_value.set_value(progress_bar.get_value())


func _increase() -> void:
	progress_bar.increment()
	set_value.set_value(progress_bar.get_value())


func _set_value(input: float) -> void:
	progress_bar.set_value(int(input))


func _set_max_value(input: float) -> void:
	set_value.set_max(int(input))
	progress_bar.set_max_value(int(input))


func _set_separation(value: int) -> void:
	progress_bar.set_separation(value)


func _set_color(color: Color) -> void:
	progress_bar.set_color(color)


func _set_fill_size(value: float) -> void:
	var fill_size = progress_bar.get_fill_size()
	fill_size.x = value
	progress_bar.set_fill_size(fill_size)


func _set_auto_resize(index: int) -> void:
	var text = resize.get_item_text(index)
	match text:
		"None":			progress_bar.set_auto_resize(progress_bar.AutoResize.NONE);		return
		"Fill":			progress_bar.set_auto_resize(progress_bar.AutoResize.FILL);		return
		"Container":	progress_bar.set_auto_resize(progress_bar.AutoResize.CONTAINER);	return
