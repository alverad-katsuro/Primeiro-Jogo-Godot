extends CharacterBody2D

var _state_machine
var _is_attack = false

@export_category("Variables")

@export var _move_speed: float = 64.0
@export var _friction: float = 0.6
@export var _acceleration: float = 0.2
@export var _attack_weapon: Array = [1,5]

@export_category("Objects")
@export var _animation_tree: AnimationTree = null


func _ready():
	_animation_tree.active = true
	_state_machine = _animation_tree["parameters/playback"]


func _physics_process(_delta: float) -> void:
	_move()
	_attack()
	_animate()
	move_and_slide()


func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")
	)

	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction
		_animation_tree["parameters/attack/blend_position"] = _direction
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return

	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)


func _attack() -> void:
	if Input.is_action_just_pressed("attack"):
		set_physics_process(false);
		_is_attack = true;


func _animate() -> void:
	if _is_attack:
		_state_machine.travel("attack")
		return

	if velocity.length() > 10:
		_state_machine.travel("walk")
		return

	_state_machine.travel("idle")


func _on_animation_tree_animation_finished(anim_name) -> void:
	if (anim_name.contains("attack")):
		set_physics_process(true);
		_is_attack = false
	pass

func _on_attack_area_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("enemy"):
		_body.update_health(randi_range(_attack_weapon[0], _attack_weapon[1]));