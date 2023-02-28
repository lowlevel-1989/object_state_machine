extends StateAbstract

var player : KinematicBody2D

# se ejecuta cuando se entra al estado
func _enter() -> void:
	self.player = self.get_owner()

# se asigna un nombre al estado
func _set_name() -> void:
	self._state_name = "Idle"

# condiciones de transicion entre estados
func _confirm_transition() -> void:
	if not self.player.is_on_floor():
		self.transition_to(self.player.air_state)
		return

	if Input.get_axis("ui_left", "ui_right"):
		self.transition_to(self.player.walk_state)
		return

	if Input.is_action_just_pressed("ui_accept") and \
			self.player.is_on_floor():
		self.transition_to(self.player.jump_state)
		return
