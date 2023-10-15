extends Area2D
class_name DoorComponent

var _player_ref: Character = null;

@export_category("Variables")
@export var _teleport_position: Vector2;


@export_category("Objects")
@export var _animation: AnimationPlayer = null

# # Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass


func _on_body_entered(_body: Node2D) -> void:
	if _body is Character:
		_player_ref = _body;
		_animation.play("open");
		
func __on_animation_player_animation_finished(_name: StringName) -> void:
	if _name == "open":
		print(_teleport_position);
		_player_ref.global_position = _teleport_position;
		_animation.play("close");
