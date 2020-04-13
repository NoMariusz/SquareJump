extends Node2D

var lvldata
var btn_model = preload("res://Windows/MyButton.tscn")


func _ready():
	load_lvl_data()
	make_btns()

func _on_ButtonMenu_button_up():
	var mainmenu = load("res://Windows/MainWindow.tscn")
	get_tree().change_scene_to(mainmenu)


func load_lvl_data():
	var file = File.new()
	file.open("res://Managment/GameInfo.json", file.READ)
	
	var text = file.get_as_text()
	lvldata = parse_json(text)
	
	file.close()

func make_btns():
	var i = 0
	print("making btns")
	for name in lvldata["Levels"]:
		i += 1
		var btn = btn_model.instance()
		btn.text = "Level " + str(i)
		btn.set_size(Vector2(300, 600))
		btn.editor_description = name
		btn.connect("my_click", self, "btn_down")
		$VBoxContainer/CenterContainer/GridContainer.add_child(btn)

func btn_down(btn):
	change_actual_lvl(btn.editor_description)
	get_tree().change_scene_to(load("res://World/LevelManager.tscn"))

func change_actual_lvl(name):
	lvldata["ActualLevel"] = name
	
	var file = File.new()
	file.open("res://Managment/GameInfo.json", File.WRITE)
	file.store_line(to_json(lvldata))
	file.close()
