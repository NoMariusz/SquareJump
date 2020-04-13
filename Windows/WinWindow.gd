extends Node2D

var menu = preload("res://Windows/MainWindow.tscn")


func _on_Button_button_up():
	get_tree().change_scene_to(menu)
