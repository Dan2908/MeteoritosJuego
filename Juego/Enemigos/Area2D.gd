extends Area2D

onready var padre:EnemigoDummy = get_parent()

func RecibirAtaque(pAtaque: float) -> void:
	padre.RecibirAtaque(pAtaque)
