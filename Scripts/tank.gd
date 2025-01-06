extends RigidBody2D
class_name Tank






var data : TankData = ResourceLoader.load("res://Resources/Sherman.tres")
@onready var hull : Sprite2D = %Hull_Sprite
@onready var turret : Sprite2D = %Turret_Sprite



func _ready() -> void:
	mass = data.tank_weight


func move_tank(_tank_thrust : float):
	if not is_multiplayer_authority(): return
	# Move the tank
	var thrust = Vector2.DOWN.rotated(rotation) * data.tank_thrust_force * _tank_thrust
	#print("player: ", multiplayer.get_unique_id(), " moved the tank")
	#print("thrust: ", thrust)
	apply_central_force(thrust)


func rotate_tank(_tank_rotation : float):
	if not is_multiplayer_authority(): return
	#print("player: ", multiplayer.get_unique_id(), " rotated the tank")
	# Rotate the tank
	apply_torque(data.tank_rotation_force * _tank_rotation)
	##angular_velocity = tank_data.tank_rotation_speed * get_parent().input.tank_rotation


func rotate_turret(_turret_rotation : float):
	if not is_multiplayer_authority(): return
	#print("player: ", multiplayer.get_unique_id(), " rotated the turret")
	# Rotate the turret
	turret.rotation += data.turret_rotation_speed * _turret_rotation


func fire_gun():
	# Fire the gun
	if not is_multiplayer_authority(): return
	#print("player: ", multiplayer.get_unique_id(), " fired the gun")
	
	# var bullet = tank_data.bullet_instance.instantiate() as RigidBody2D
	# get_parent().call_deferred("add_child",bullet)
	# bullet.global_position = bullet_spawn.global_position
	# bullet.global_rotation = bullet_spawn.global_rotation
	# bullet.linear_velocity = Vector2.UP.rotated(bullet.global_rotation) * tank_data.bullet_speed
	# turret_fire_anim.play("Fire")

