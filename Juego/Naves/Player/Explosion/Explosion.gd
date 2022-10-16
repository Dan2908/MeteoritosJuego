class_name Explosion
extends Node2D

onready var sonido:AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	sonido.play()
