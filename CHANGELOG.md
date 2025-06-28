# Changelog

## [1.0.0a] - 2025-06-28

### Removed
- Graphical state machine for the reference model
- Separation between Godot v3 and Godot v4 folders
- Godot v3 demo (escenas, scripts, imágenes)

### Changed
- Unified Godot v3 and Godot v4 support into a single codebase (edit `plugin.gd` to switch version)
- Improved documentation (`README.md`, internal usage)
- Demo restructured: shared player and states folder for both versions
- Added example of state documentation in the CharacterBody2D demo
- Cleaned up unused demo and screenshot files

## [0.7.2] - 2023-03-10

### Changed
- Fix Version plugin

## [0.7.1] - 2023-03-10

### Added
- Debug Comming Soon

### Changed
- Fix remote debug

## [0.7.0] - 2023-03-04

### Added
- Graphical state machine for the reference model

### Changed
- KinematicBody2D platform demo for Godot v3 (update)
- CharacterBody2D platform demo for Godot v4 (update)

## [0.6.1] - 2023-02-28

### Changed
- KinematicBody2D platform demo for Godot v3 (update)
- CharacterBody2D platform demo for Godot v4 (update)

## [0.6.0] - 2023-02-28

### Added

- LICENSE
- README.md
- support Godot v3
- KinematicBody2D platform demo for Godot v3
- CharacterBody2D platform demo for Godot v4
- new node   -> node_state_machine
- new method -> void StateAbstract::confirm_transition()
- new method -> void StateAbstract::create(name : String)
- new method -> void StateMachine::create(name : String)

### Changed
- plugin.gd -> commend for support godot v3, default support v4
