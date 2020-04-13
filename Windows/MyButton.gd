extends Button

signal my_click(inst)



func _on_MyButton_button_up():
	emit_signal("my_click", self)
