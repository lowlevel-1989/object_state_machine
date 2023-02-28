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
