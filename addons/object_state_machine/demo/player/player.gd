"""
DOC: Player Movement State Machine

States:
- IDLE *
- WALK
- JUMP
- AIR
- FALL

Transitions:
- IDLE  -> WALK  : When moving
- WALK  -> IDLE  : When stopping
- IDLE  -> JUMP  : When jumping
- WALK  -> JUMP  : When jumping
- JUMP  -> AIR   : When ascending
- AIR   -> FALL  : When descending
- FALL  -> IDLE  : When landing
"""

extends CharacterBody2D

@export var GRAVITY   = 980.0       # (aceleración) pixel / segundos al cuadrado
@export var RUN_SPEED = 300.0       # (velocidad)   pixel / segundos
@export var JUMP_VELOCITY = -400.0  # (velocidad)   pixel / segundos

@export var CLASS_STATE_IDLE : Script
@export var CLASS_STATE_WALK : Script
@export var CLASS_STATE_AIR  : Script
@export var CLASS_STATE_JUMP : Script
@export var CLASS_STATE_FALL : Script

@onready var label_state : Label = $LabelState
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var direction_debug : ColorRect = $DirectionDebug

var state_idle : StateAbstract
var state_walk : StateAbstract
var state_air  : StateAbstract
var state_jump : StateAbstract
var state_fall : StateAbstract

var state_machine : Object

# señal, recibe cuando se activa un cambio de estado
func _in_transition(
		_current_state: StateAbstract,
		next_state: StateAbstract) -> void:

	label_state.text = next_state.get_name()

# se asignan los estados en _ready, ya que se estan pasando por @export
func _ready() -> void:
	state_machine = $NodeStateMachine.get_stage_machine()
	state_machine.create("Movements SM")

	# Habilitar modo debug, descomentar linea de abajo
	# movement_state_machine.transition_debug_enable()

	state_idle = CLASS_STATE_IDLE.new()
	state_walk = CLASS_STATE_WALK.new()
	state_air  = CLASS_STATE_AIR. new()
	state_jump = CLASS_STATE_JUMP.new()
	state_fall = CLASS_STATE_FALL.new()

	# creamos los nuevos estados, para nuestra maquina de estado
	state_idle.create(self, state_machine)
	state_walk.create(self, state_machine)
	state_air. create(self, state_machine)
	state_jump.create(self, state_machine)
	state_fall.create(self, state_machine)

	# asignamos el estado principal
	state_machine.set_init_state(state_idle)
	state_machine.connect("transitioned", _in_transition)

# liberar recursos
func free() -> void:
	state_machine.free()
	state_idle.free()
	state_walk.free()
	state_air. free()
	state_jump.free()
	state_fall.free()

	super()

# Solo es para posicionar a donde esta mirando el jugador (debug)
func _update_direction_debug() -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	direction_debug.position.x = -30 + ( direction * 20 )

func _physics_process(delta : float) -> void:
	state_machine.physics_process(delta)
	_update_direction_debug()
