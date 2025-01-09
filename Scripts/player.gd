extends Node2D
class_name Player


@onready var camera : Camera2D = %Camera2D
@export var team = 0

@export var player_tank : Tank = null

var tank = load("res://Scenes/tank.tscn")



func _physics_process(_delta: float) -> void:
    handle_input()
    if !is_multiplayer_authority(): return
    if Input.is_action_just_pressed("Turret | Fire"):
        print("player: ", self.multiplayer.get_unique_id(), " fired the gun")

    

func handle_input():
    if !player_tank: return
    if !is_multiplayer_authority(): return
    camera.global_position = player_tank.global_position
    var tank_thrust = Input.get_axis("Tank | Forward", "Tank | Backward")
    var tank_rotation = Input.get_axis("Tank | RotateLeft", "Tank | RotateRight")
    var turret_rotation = Input.get_axis("Turret | RotateLeft", "Turret | RotateRight")
    var turret_fire = Input.is_action_just_pressed("Turret | Fire")

    if tank_thrust != 0:
        player_tank.move_tank(tank_thrust)

    if tank_rotation != 0:
        player_tank.rotate_tank(tank_rotation)

    if turret_rotation != 0:
        player_tank.rotate_turret(turret_rotation)
    
    if turret_fire:
        player_tank.fire_gun()
        turret_fire = false




@rpc("any_peer", "call_local", "reliable")
func spawn_local_tank():

    if player_tank: return

    if multiplayer.is_server():
        print("Server | Player ", self.get_multiplayer_authority(), " spawned a local tank")
    else:
        print("Client | Player ", self.get_multiplayer_authority(), " spawned a local tank")

    var random_offset = Vector2(randf_range(-500, 500), randf_range(-500, 500)) 
    player_tank = Global.instance_node_at_location(tank, get_parent(),  random_offset)
    player_tank.set_multiplayer_authority(self.get_multiplayer_authority())
    player_tank.name = "Player_Tank_" + str(self.get_multiplayer_authority())
    if !multiplayer.is_server():
        spawn_tank.rpc(player_tank.global_transform, self.get_multiplayer_authority())

@rpc("any_peer", "call_remote", "reliable")
func spawn_tank(transform : Transform2D, id : int) -> void:
    if is_multiplayer_authority(): return
    #print("Player ", id, " spawned the tank")

    player_tank = Global.instance_node_at_location(tank, get_parent(), transform.origin)
    player_tank.set_multiplayer_authority(id)
    player_tank.name = "Player_Tank_" + str(id)
