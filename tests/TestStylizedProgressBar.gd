extends CenterContainer

@onready var progress_bar 		:= $VBoxContainer/StylizedProgressBar
@onready var button_decrease 	:= $VBoxContainer/HBoxContainer/Decrease
@onready var button_increase 	:= $VBoxContainer/HBoxContainer/Increase
@onready var set_value 			:= $VBoxContainer/GridContainer/SetValue
@onready var set_max_value 		:= $VBoxContainer/GridContainer/SetMaxValue


func _ready() -> void:
	button_increase.pressed.connect(_increase)
	button_decrease.pressed.connect(_decrease)
	set_value.value_changed.connect(_set_value)
	set_max_value.value_changed.connect(_set_max_value)
	
	set_value.set_value(progress_bar.get_value())
	set_max_value.set_value(progress_bar.get_max_value())


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
