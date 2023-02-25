extends StateAbstract

var player : CharacterBody2D

func _enter() -> void:
	self.player = self.get_owner()

func _set_name() -> void:
	self._state_name = "Air"

func physics_process(delta : float) -> void:

	# aplicamos gravedad
	self.player.velocity.y += self.player.gravity * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		self.player.velocity.x = direction * self.player.SPEED
	else:
		self.player.velocity.x = move_toward(
								self.player.velocity.x, 0, self.player.SPEED)
	
	self.player.move_and_slide()

	if self.player.velocity.y > 0:
		self.transition_to(self.player.fall_state)
	
