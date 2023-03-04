@tool
extends Node

class_name NodeStateMachine

var class_state_machine : Script
var _state_machine : Object
var _current_state : StateAbstract

func _init() -> void:
	self.class_state_machine = preload(
			"res://addons/object_state_machine/state_machine.gd")
	self._state_machine = self.class_state_machine.new()

	if not (
		self._state_machine.has_method("is_class_state_machine") and \
			self._state_machine.is_class_state_machine()):
		queue_free()
		return

	# solo dejar habilitado process
	set_process(true)
	set_physics_process(false)
	set_physics_process_internal(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)

func get_stage_machine() -> Object:
	return self._state_machine

	# metodo publico
# metodos especiales, para detectar si es un estado o una maquina de estado
func is_class_state_machine() -> bool:
	return true

# metodo publico
# metodos especiales, para detectar si es un estado o una maquina de estado
func is_class_state() -> bool:
	return false

func _process(_delta : float) -> void:
	if not Engine.is_editor_hint():
		self._state_machine.confirm_transition()
