extends Area2D

# przerób na własny model akceleracji gdzie będzie słownik z danymi na którym będą przechowywane informację o ruchu dla danych obiektów
# ruch oprzyj o funkcję kwadratową

var Player = preload("res://Characters/player.tscn").instance()
var bodies_on = []

func _physics_process(delta):
	for body in self.bodies_on:
		body.jump_stream_on(500)
	

func _on_Area2D_body_entered(body):
	if body.get_class() == Player.get_class():
		bodies_on.append(body)
		body.on_jump_stream = true


func _on_Area2D_body_exited(body):
	if body.get_class() == Player.get_class():
		bodies_on.remove(bodies_on.find(body))
		body.on_jump_stream = false
