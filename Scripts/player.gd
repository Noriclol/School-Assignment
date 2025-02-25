extends Node2D
class_name Player


@onready var camera : Camera2D = %Camera2D
@export var team = 0

@export var player_tank : Tank = null

var bullet = load("res://Scenes/bullet.tscn")


func on_tank_fired(bullet_spawn : Node2D) -> void:
	print("player: ", self.get_multiplayer_authority(), " fired his gun")
	#spawn_local_bullet(get_multiplayer_authority())


func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return

	handle_input(delta)
	update_camera()


func update_camera() -> void:
	if !player_tank: return
	camera.make_current()
	camera.global_position = player_tank.global_position


func handle_input(delta: float):
	if !player_tank: return
	var handle = player_tank.player_name.get_parent() as Node2D
	handle.global_rotation = 0

	var tank_thrust = Input.get_axis("Tank | Forward", "Tank | Backward")
	var tank_rotation = Input.get_axis("Tank | RotateLeft", "Tank | RotateRight")
	var turret_rotation = Input.get_axis("Turret | RotateLeft", "Turret | RotateRight")
	var turret_fire = Input.is_action_just_pressed("Turret | Fire")

	if tank_thrust != 0:
		player_tank.move_tank(tank_thrust, delta)

	if tank_rotation != 0:
		player_tank.rotate_tank(tank_rotation, delta)

	if turret_rotation != 0:
		player_tank.rotate_turret(turret_rotation)
	
	if turret_fire:
		player_tank.fire_gun()
		turret_fire = false




# @rpc("any_peer", "call_local", "reliable")
# func spawn_local_tank():

# 	if player_tank: return

# 	if multiplayer.is_server():
# 		print("Server | Player ", self.get_multiplayer_authority(), " spawned a local tank")
# 	else:
# 		print("Client | Player ", self.get_multiplayer_authority(), " spawned a local tank")

# 	var random_offset = Vector2(randf_range(-500, 500), randf_range(-500, 500)) 
# 	player_tank = Global.instance_node_at_location(tank, get_parent(),  random_offset)

# 	player_tank.tank_fired.connect(on_tank_fired)


# 	#player_tank.set_multiplayer_authority(self.get_multiplayer_authority())
# 	player_tank.name = "Player_Tank_" + str(self.get_multiplayer_authority())
# 	player_tank.player_name.text = player_tank.name
# 	#if !multiplayer.is_server():
# 		#spawn_tank.rpc(player_tank.global_transform, self.get_multiplayer_authority())

# @rpc("any_peer", "call_remote", "reliable")
# func spawn_tank(transform : Transform2D, id : int) -> void:
# 	if is_multiplayer_authority(): return
# 	#print("Player ", id, " spawned the tank")
	
# 	player_tank = Global.instance_node_at_location(tank, get_parent(), transform.origin)
# 	#player_tank.set_multiplayer_authority(id)
# 	player_tank.name = "Player_Tank_" + str(id)
# 	player_tank.player_name.text = player_tank.name

# @rpc("any_peer", "call_local", "reliable")
# func spawn_local_bullet(id : int) -> void:
# 	var bullet_instance = Global.instance_node_at_location(bullet, get_parent(), player_tank.bullet_spawn.global_position) as RigidBody2D
# 	bullet_instance.set_multiplayer_authority(1)
# 	bullet_instance.apply_impulse(Vector2.UP.rotated(player_tank.turret.global_rotation) * player_tank.data.bullet_speed)
# 	if !multiplayer.is_server():
# 		spawn_bullet.rpc()

		


# @rpc("authority", "call_remote", "reliable")
# func spawn_bullet() -> void:
# 	var bullet_instance = Global.instance_node_at_location(bullet, get_parent(), player_tank.bullet_spawn.global_position) as RigidBody2D
# 	bullet_instance.set_multiplayer_authority(1)
# 	if multiplayer.is_server():
# 		bullet_instance.apply_impulse(Vector2.UP.rotated(player_tank.turret.global_rotation) * player_tank.data.bullet_speed)
