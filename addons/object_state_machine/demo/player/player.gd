extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@export var CLASS_IDLE_STATE : Script
@export var CLASS_WALK_STATE : Script
@export var CLASS_AIR_STATE  : Script
@export var CLASS_JUMP_STATE : Script
@export var CLASS_FALL_STATE : Script

@onready var label_state : Label = $LabelState
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var direction_debug : ColorRect = $DirectionDebug

var idle_state : StateAbstract
var walk_state : StateAbstract
var air_state  : StateAbstract
var jump_state : StateAbstract
var fall_state : StateAbstract

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var movement_state_machine : StateMachine

# se inicializa la maquina de estados en _init
func _init():
	movement_state_machine = StateMachine.new("Movements SM")
	
	# Habilitar modo debug, descomentar linea de abajo
	#movement_state_machine.transition_debug_enable()
	

# terminar de anotar aqui :3
func _in_transition(
		_current_state: StateAbstract,
		next_state: StateAbstract) -> void:
	
	label_state.text = next_state.get_name()

# se asignan los estados en _ready, ya que se estan pasando por @export
func _ready():
	idle_state = CLASS_IDLE_STATE.new(self, movement_state_machine)
	walk_state = CLASS_WALK_STATE.new(self, movement_state_machine)
	air_state  = CLASS_AIR_STATE. new(self, movement_state_machine)
	jump_state = CLASS_JUMP_STATE.new(self, movement_state_machine)
	fall_state = CLASS_FALL_STATE.new(self, movement_state_machine)
	
	movement_state_machine.set_init_state(idle_state)
	movement_state_machine.connect("transitioned", _in_transition)

func free():
	# liberar recursos
	movement_state_machine.free()
	idle_state.free()
	walk_state.free()
	air_state. free()
	jump_state.free()
	fall_state.free()

	super()

# Solo es para posicionar a donde esta mirando el jugador (debug)
func _update_direction_debug() -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	direction_debug.position.x = -30 + ( direction * 20 )

func _physics_process(delta):
	movement_state_machine.physics_process(delta)
	
	_update_direction_debug()
