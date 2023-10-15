extends CharacterBody2D

class_name  Slime

var _player_ref: Character = null

@export_category("Objects")

@export var _texture: Sprite2D = null

@export var _animation: AnimationPlayer = null


@export_category("Variables")

@export var _move_speed: float = 32.0

@export var _attack_weapon: Array = [1,5]
@export var _life: float = 100.0;


func _on_area_2d_body_entered_alert(_body: Node2D):
	if _body.is_in_group("character"):
		_player_ref = _body


func _on_area_2d_body_exited_alert(_body: Node2D):
	if _body.is_in_group("character"):
		_player_ref = null


func _physics_process(_delta: float) -> void:
	if _life <= 0:
		return
	_animate();
	if _player_ref != null:
		if _player_ref._life <= 0:
			velocity = Vector2.ZERO
			move_and_slide();
			return


		var _direction: Vector2 = global_position.direction_to(_player_ref.global_position);
		var _distance: float = global_position.distance_to(_player_ref.global_position);

		if _distance < 20:
			_player_ref.update_health(-randi_range(_attack_weapon[0], _attack_weapon[1]))
			_player_ref.global_position += _direction * 10



		velocity = _direction * _move_speed
		move_and_slide()


func _animate() -> void:
	if velocity.x > 0:
		_texture.flip_h = false
	else:
		_texture.flip_h = true

	if velocity != Vector2.ZERO:
		_animation.play("walk")
		return

	_animation.play("idle")

func update_health(valor: float) -> void:
	if _life <= 0:
		return
	else:	
		_life += valor;
		if _life <= 0:
			_animation.play("dead")
			return
