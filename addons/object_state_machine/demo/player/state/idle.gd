extends StateAbstract

var player : CharacterBody2D

func _enter() -> void:
	self.player = self.get_owner()

func _set_name() -> void:
	self._state_name = "Idle"

func physics_process(_delta : float) -> void:	
	if not self.player.is_on_floor():
		self.transition_to(self.player.air_state)

	if Input.get_axis("ui_left", "ui_right"):
		self.transition_to(self.player.walk_state)
		
	if Input.is_action_just_pressed("ui_accept") and self.player.is_on_floor():
		self.transition_to(self.player.jump_state)
