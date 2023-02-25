extends StateAbstract

var player : CharacterBody2D

func _enter() -> void:
	self.player = self.get_owner()

func _set_name() -> void:
	self._state_name = "Jump"

func physics_process(_delta : float) -> void:
	
	# aplicamos el salto
	self.player.velocity.y = self.player.JUMP_VELOCITY

	self.player.move_and_slide()
	
	self.transition_to(self.player.air_state)
