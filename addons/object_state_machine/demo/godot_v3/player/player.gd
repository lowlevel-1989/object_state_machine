extends KinematicBody2D

export var GRAVITY   = 980.0       # (aceleración) pixel / segundos al cuadrado
export var RUN_SPEED = 300.0       # (velocidad)   pixel / segundos
export var JUMP_VELOCITY = -400.0  # (velocidad)   pixel / segundos

export var CLASS_IDLE_STATE : Script
export var CLASS_WALK_STATE : Script
export var CLASS_AIR_STATE  : Script
export var CLASS_JUMP_STATE : Script
export var CLASS_FALL_STATE : Script

onready var label_state : Label = $LabelState
onready var collision_shape : CollisionShape2D = $CollisionShape2D
onready var direction_debug : ColorRect = $DirectionDebug
onready var ray_direction   : Node2D    = $RayDirection
onready var ray_check_slope : RayCast2D = $RayDirection/RayCheckSlope

var idle_state : StateAbstract
var walk_state : StateAbstract
var air_state  : StateAbstract
var jump_state : StateAbstract
var fall_state : StateAbstract

var velocity : Vector2
var movement_state_machine : Object

# señal, recibe cuando se activa un cambio de estado
func _in_transition(
		_current_state: StateAbstract,
		next_state: StateAbstract) -> void:

	label_state.text = next_state.get_name()

# se asignan los estados en _ready, ya que se estan pasando por @export
func _ready():
	movement_state_machine = $NodeStateMachine.get_stage_machine()
	movement_state_machine.create("Movements SM")

	# Habilitar modo debug, descomentar linea de abajo
	# movement_state_machine.transition_debug_enable()

	idle_state = CLASS_IDLE_STATE.new()
	walk_state = CLASS_WALK_STATE.new()
	air_state  = CLASS_AIR_STATE. new()
	jump_state = CLASS_JUMP_STATE.new()
	fall_state = CLASS_FALL_STATE.new()

	# creamos los nuevos estados, para nuestra maquina de estado
	idle_state.create(self, movement_state_machine)
	walk_state.create(self, movement_state_machine)
	air_state. create(self, movement_state_machine)
	jump_state.create(self, movement_state_machine)
	fall_state.create(self, movement_state_machine)

	# asignamos el estado principal
	movement_state_machine.set_init_state(idle_state)
	movement_state_machine.connect("transitioned", self, "_in_transition")

# liberar recursos
func free() -> void:
	movement_state_machine.free()
	idle_state.free()
	walk_state.free()
	air_state. free()
	jump_state.free()
	fall_state.free()

	.free()

# Solo es para posicionar a donde esta mirando el jugador (debug)
func _update_direction_debug() -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	direction_debug.rect_position.x = -30 + ( direction * 20 )

# _input solo se activa cuando se presiona el boton
# cambiamos la direccion del ray
func _input(event) -> void:
	if event.get_action_strength("ui_right"):
		ray_direction.rotation = 0
	if event.get_action_strength("ui_left"):
		ray_direction.rotation = PI

func _physics_process(delta : float) -> void:
	movement_state_machine.physics_process(delta)
	_update_direction_debug()
