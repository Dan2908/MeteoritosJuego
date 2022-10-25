extends Area2D

onready var padre:EnemigoDummy = get_parent()

func RecibirAtaque(pAtaque: Node2D) -> void:
	padre.RecibirAtaque(pAtaque)
