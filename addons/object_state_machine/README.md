# Object State Machine

1. Install directly from Godot Asset Library

or

1. Download this respository, move `lowlevel-1989/object_state_machine` to your `{project_dir}`

2. Enable it from Project -> Settings -> Plugin

## Getting Started

### NodeStateMachine

- To create a state machine add the NodeStateMachine to the desired object as shown in the demo.

### Class

#### StateAbstract, abstract class that allows to define the different states

to define a new state you must create a class from the StateAbstract class and define its behavior.

##### Public methods
- void    StateAbstract::create(owner·:·Node,·state_machine·:·StateMachine)
- Node    StateAbstract::get_owner()
- void    StateAbstract::transition_to(state:·StateAbstract)
- String  StateAbstract::get_name()
- bool    StateAbstract::is_class_state_machine()
- bool    StateAbstract::is_class_state()

##### virtual methods
- void    StateAbstract::_enter()
- void    StateAbstract::_exit()
- void    StateAbstract::_input(event : InputEvent)
- void    StateAbstract::_process(delta : float)
- void    StateAbstract::_physics_process(delta : float)
- void    StateAbstract::_integrate_forces(state : Object)

##### private methods
- void    StateAbstract::_set_name()

#### StateMachine
in charge of administering the states.

##### signals
- transitioned(current : StateAbstract, next : StateAbstract)

##### Public methods
- void           StateMachine::create(name : String)
- void           StateMachine::set_init_state(state : StateAbstract)
- void           StateMachine::transition_debug_enable()
- void           StateMachine::transition_debug_disable()
- StateAbstract  StateMachine::get_current_state()
- StateAbstract  StateMachine::get_prev_state()
- void           StateMachine::transition_to()
- void           StateMachine::input()
- void           StateMachine::process(delta : float)
- void           StateMachine::physics_process(delta : float)
- void           StateMachine::integrate_forces(state : Object)
- void           StateMachine::is_class_state_machine()
- void           StateMachine::is_class_state()

### support Godot v3

file plugin.gd
```gdscript
# Seguir instrucciones para agregar soporte a godot v3
@tool  # <- Comentar   @tool para godot v3

# tool # <- Descomentar tool para godot v3

extends EditorPlugin

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	print("Object State Machine 0.6.0")


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
```
leave it this way
```gdscript
# Seguir instrucciones para agregar soporte a godot v3
# @tool  # <- Comentar   @tool para godot v3

tool # <- Descomentar tool para godot v3

extends EditorPlugin

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	print("Object State Machine 0.6.0")


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
```
