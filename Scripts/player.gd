extends Node2D
class_name Player


@onready var camera : Camera2D = %Camera2D
@export var team = 0
var player_tank : Tank = null




func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("Turret | Fire"):
        if !is_multiplayer_authority(): return
        
        print("Player[" + str(get_multiplayer_authority()) + "] Firing")
    pass
    #handle_input()

    

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



# @rpc("any_peer", "call_local", "reliable")
# func _spawn_tank() -> void:
#     #print("Spawning tank")
#     if not is_multiplayer_authority(): return
#     print("Player ", self.multiplayer.get_unique_id(), " spawned the tank")
#     var spawnpoint = get_tree().get_nodes_in_group("Spawn_Blue")[0]
#     #var random_offset = Vector2(randf_range(-500, 500), randf_range(-500, 500)) 
#     player_tank = Global.instance_node_at_location(tank, get_parent(), spawnpoint.global_position)
#     player_tank.set_multiplayer_authority(1)
#     player_tank.name = "Player_Tank_" + str(self.multiplayer.get_unique_id())
