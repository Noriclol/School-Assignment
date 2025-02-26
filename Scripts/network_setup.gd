extends Control

var player = load("res://Scenes/Player.tscn")
var tank = load("res://Scenes/tank.tscn")

@onready var multiplayer_config_ui = %Multiplayer_Config
@onready var server_ip_adress = %Server_IP_Adress
@onready var device_ip_adress = %Device_IP_Adress

@onready var player_id : Label = %Player_Id
@onready var game_hud = %GameHud

@onready var server_hud = %ServerHud

@onready var start_btn = %Start_Btn


#@onready var multiplayer_spawner = %MultiplayerSpawner
@onready var spawned_scenes = %SpawnedScenes

var players : Array[Player] = []


func _ready() -> void:
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)
	start_btn.pressed.connect(on_start_btn_pressed)
	device_ip_adress.text = Network.ip_adress


func _on_create_server_pressed() -> void:
	multiplayer_config_ui.hide()
	Network.create_server()
	_instance_player(multiplayer.get_unique_id())
	game_hud.show()
	if multiplayer.is_server():
		server_hud.show()
	player_id.text = "Player_" + str(multiplayer.get_unique_id())


func _on_join_server_pressed() -> void:
	if server_ip_adress.text != "":
		multiplayer_config_ui.hide()
		Network.ip_adress = server_ip_adress.text
		Network.create_client()
		game_hud.show()
		game_hud.show()
		player_id.text = "Player_" + str(multiplayer.get_unique_id())
		return


func on_start_btn_pressed() -> void:
	server_hud.hide()

	# for id in multiplayer.get_peers():
	# 	_player.spawn_local_tank.rpc_id(id)

	if !multiplayer.is_server(): return

	for _player in players:
		_instance_tank(_player.get_multiplayer_authority())
		#_player.spawn_local_tank.rpc_id(_player.get_multiplayer_authority())


func _player_connected(id) -> void:
	print("Player " + str(id) + " connected!")
	_instance_player(id)
	


func _player_disconnected(id) -> void:
	print("Player " + str(id) + " disconnected!")
	if spawned_scenes.has_node("Player_" + str(id)):
		spawned_scenes.get_node("Player_" + str(id)).queue_free()


func _connected_to_server() -> void:
	await get_tree().create_timer(0.01).timeout
	_instance_player(multiplayer.get_unique_id())
	print("Connected to server")


func _instance_player(id: int) -> Player:
	if multiplayer.is_server():
		print("Server | Player ", id, " spawned")
	else:
		print("Client | Player ", id, " spawned")
	var player_instance = Global.instance_node_at_location(player, spawned_scenes, Vector2.ZERO)
	player_instance.name = "Player_" + str(id)
	player_instance.set_multiplayer_authority(id)
	#player_instance.spawn_local_tank()
	if !players.has(player_instance):
		players.append(player_instance)

	return player_instance


func _instance_tank(id: int) -> void:
	if multiplayer.is_server():
		print("Server | Spawned a tank for player ", id, " spawned")
	else:
		print("Client | Spawned a tank for player ", id, " spawned")
	var random_offset = Vector2(randf_range(-500, 500), randf_range(-500, 500)) 
	var new_tank = Global.instance_node_at_location(tank, spawned_scenes,  random_offset)
	#new_tank.tank_fired.connect(on_tank_fired)
	#player_tank.set_multiplayer_authority(self.get_multiplayer_authority())
	new_tank.name = "Player_Tank_" + str(id)
	new_tank.player_name.text = new_tank.name
