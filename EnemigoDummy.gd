class_name EnemigoDummy
extends Node2D

onready var canon:Canon = $Canon
 
var hitPoints:float = 10.0

func RecibirAtaque(pAtaque: float) -> void:
	hitPoints -= pAtaque
	if(hitPoints <= 0):
		queue_free()

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if(body is Player):
		body.Destruir()

func _process(delta):
	canon.set_EstaDisparando(true)
