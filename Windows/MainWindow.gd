extends Node2D
var lvl = load("res://World/LevelManager.tscn")

func _ready():
	pass

func _on_Button_button_up():
	get_tree().change_scene_to(self.lvl)

func _on_ButtonExit_button_up():
	get_tree().quit()

func _on_ButtonLevels_button_up():
	var lvlmenu = preload("res://Windows/LevelsMenu.tscn")
	get_tree().change_scene_to(lvlmenu)
