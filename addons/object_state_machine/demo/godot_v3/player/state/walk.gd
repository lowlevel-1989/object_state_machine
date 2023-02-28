extends StateAbstract

var player : KinematicBody2D

# se ejecuta cuando se entra al estado
func _enter() -> void:
	self.player = self.get_owner()

# se asigna un nombre al estado
func _set_name() -> void:
	self._state_name = "Walk"

# condiciones de transicion entre estados
func _confirm_transition() -> void:
	if not self.player.is_on_floor():
		self.transition_to(self.player.air_state)
		return

	if Input.is_action_just_pressed("ui_accept") and \
			self.player.is_on_floor():
		self.transition_to(self.player.jump_state)
		return

	if self.player.velocity.x == 0:
		self.transition_to(self.player.idle_state)
		return

# logica
func _physics_process(delta : float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		self.player.velocity.x = direction * self.player.RUN_SPEED
	else:
		self.player.velocity.x = move_toward(
								self.player.velocity.x, 0, self.player.RUN_SPEED)

  # Validar si estamos subiendo una colina
	if self.player.ray_check_slope.is_colliding():
		var n : Vector2 = self.player.ray_check_slope. \
									get_collision_normal()
		# fix godot v3, evitar que suba las colinas donde
		# el angulo es negativo. En godot v4 esto ya no pasa
		if rad2deg(acos(n.dot(Vector2.UP))) > 45:
			self.player.velocity.y = 0
			self.player.move_and_slide(
							self.player.velocity, Vector2.UP)
			return

	# En godot v3 si quieres que suba bien las pendientes, se debe
	# actualizar el valor de la velocidad con el valor de retorno
	# del metodo move_and_slide, esto incluye activar el is_on_floor
	self.player.velocity = self.player.move_and_slide(
					self.player.velocity, Vector2.UP, true)
