extends StateAbstract

var player : KinematicBody2D

# se ejecuta cuando se entra al estado
func _enter() -> void:
	self.player = self.get_owner()

# se asigna un nombre al estado
func _set_name() -> void:
	self._state_name = "Air"

# condiciones de transicion entre estados
func _confirm_transition() -> void:
	if self.player.velocity.y > 0:
		self.transition_to(self.player.fall_state)
		return

# logica
func _physics_process(delta : float) -> void:
	# aplicamos gravedad
	self.player.velocity.y += self.player.GRAVITY * delta

	# Permitir moverse en el aire
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		self.player.velocity.x = direction * self.player.RUN_SPEED
	else:
		self.player.velocity.x = move_toward(
						self.player.velocity.x, 0, self.player.RUN_SPEED)

	# En godot v3 si no actualizamos la velocidad con el valor de
	# retorno de move_and_slide, evita la subida de las pendientes
	# y tampoco actualiza el valor de is_on_floor
	self.player.move_and_slide(
					self.player.velocity, Vector2.UP, true)
