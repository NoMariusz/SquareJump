extends Area2D

signal checkpoint_entered(body, checpoint)


func _on_Checkpoint_body_entered(body):
	self.emit_signal("checkpoint_entered", body, self)
