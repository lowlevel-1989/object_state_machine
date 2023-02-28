extends StateAbstract

var player : KinematicBody2D

# se ejecuta cuando se entra al estado
func _enter() -> void:
	self.player = self.get_owner()

# se asigna un nombre al estado
func _set_name() -> void:
	self._state_name = "Jump"

# logica
func _physics_process(_delta : float) -> void:

	# aplicamos el salto
	self.player.velocity.y = self.player.JUMP_VELOCITY

	self.player.velocity = self.player.move_and_slide(
					self.player.velocity, Vector2.UP, true)

	self.transition_to(self.player.air_state)
