extends Node

var json_path = "res://Managment/GameInfo.json"
var lvl
var player_checkpoint
var LvlList
var dangerList = []
var data

var is_return_button = false
var ReturnButton

var LavaBall = load("res://World/Elements/LavaBall.tscn").instance()


func _ready():
	load_lvl()
	player_checkpoint = $Map/StartPosition.position + $Map.position
	move_player_to_last_checkpoint()
	connect_checkpoints()
	load_dangers()
	config_return_btn()

# return btn
func _input(event):
	if event.is_action_released("ui_cancel"):
		if is_return_button:
			is_return_button = false
			$Player/ParallaxBackground.remove_child(ReturnButton)
		else:
			is_return_button = true
			$Player/ParallaxBackground.add_child(ReturnButton)

func config_return_btn():
	ReturnButton = $Player/ParallaxBackground/ReturnButton
	print(ReturnButton)
	$Player/ParallaxBackground.remove_child(ReturnButton)
	
	

# checkpoints
func connect_checkpoints():
	for child in $Map/Checkpoints.get_children():
		child.connect("checkpoint_entered", self, "_player_reach_checkpoint")
	$Map/EndPortal.connect("body_entered", self, "_player_reach_end")
	
func _player_reach_checkpoint(body, checkpoint):
	if body == $Player:
		checkpoint.get_node("Particles2D").process_material = checkpoint.get_node("Particles2D").process_material.duplicate()
		checkpoint.get_node("Particles2D").process_material.color = Color(0.16, 0.87, 0.17, 1)
		self.player_checkpoint  = checkpoint.get_node("Position2D").position + checkpoint.position + $Map.position
	
func move_player_to_last_checkpoint():
	$Player.position = player_checkpoint

# falls
func _on_FallChecker_body_entered(body):
	if body == $Player:
		move_player_to_last_checkpoint()
	else:
		body.queue_free()

# died
func _player_died():
	self.move_player_to_last_checkpoint()

# end
func _player_reach_end(body):
	if body == $Player:
		body.hit_ground()
		call_deferred("load_new_level")

func load_new_level():
	print("You won")
	var level_now = data["ActualLevel"]
	self.modify_json()
	self.save_json()
	self.remove_child($Map)
	if level_now == data["Levels"][len(data["Levels"])-1]:
		var winmenu = preload("res://Windows/WinWindow.tscn")
		get_tree().change_scene_to(winmenu)
	else:
		var lvlmenu = preload("res://Windows/NextLvlMenu.tscn")
		get_tree().change_scene_to(lvlmenu)

func modify_json():
	var lvlIndex = data["Levels"].find(data["ActualLevel"])
	if lvlIndex + 1 == len(data["Levels"]):
		data["ActualLevel"] = data["Levels"][0]
	else:
		data["ActualLevel"] = data["Levels"][lvlIndex +1]
	
	
#load Game
func load_lvl():
	load_config()
	self.add_child(lvl.instance())

func load_config():
	var file = File.new()
	file.open(json_path, file.READ)
	
	var text = file.get_as_text()
	data = parse_json(text)
	
	file.close()
	
	lvl = load(data["ActualLevel"])
	LvlList = data["Levels"]

#load dangers
func load_dangers():
	dangerList = []
	for danger in $Map/Dangers.get_children():
		dangerList.append(danger)
	connect_dangers()
		
func connect_dangers():
	for danger in self.dangerList:
		danger.connect("body_entered", self, "_body_entered_danger")

func _body_entered_danger(body):
	if body.get_class() == $Player.get_class():
		body.hit_ground()
		_player_died()
	elif body != $Map/TileMap and body.get_class() != LavaBall.get_class():
		body.queue_free()

#json
func save_json():
	var file = File.new()
	file.open(json_path, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	
	

func _on_ReturnButton_button_up():
	var mainmenu = preload("res://Windows/MainWindow.tscn")
	get_tree().change_scene_to(mainmenu)
