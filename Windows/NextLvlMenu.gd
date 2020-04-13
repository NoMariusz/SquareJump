extends Node2D

var lvl
var menu

func _ready():
	menu = load("res://Windows/MainWindow.tscn")
	lvl = load("res://World/LevelManager.tscn")

func _on_ButtonLvl_button_up():
	get_tree().change_scene_to(lvl)


func _on_ButtonMenu_button_up():
	get_tree().change_scene_to(menu)
