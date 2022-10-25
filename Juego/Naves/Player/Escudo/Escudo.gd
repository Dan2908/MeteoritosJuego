class_name EscudoPlayer
extends Area2D

onready var animacion:AnimationPlayer = $Animacion
onready var impactSprite:Sprite = $ShieldEffect
onready var circleShape:CircleShape2D = $CollisionShape2D.get_shape()

var impacto:PackedScene = preload("res://Juego/Naves/Player/Escudo/EscudoImpacto.tscn")

const PI_15 = PI*1.5

func RecibirAtaque(pAtaque: Node2D) -> void:
	var newImpacto: ImpactoEscudo = impacto.instance()
	var angulo:float = global_position.angle_to_point(pAtaque.global_position) + PI_15 - get_global_rotation()
	newImpacto.set_global_rotation(angulo)
	add_child(newImpacto)

func Actualizar(pEstado: bool) -> void:
	if(pEstado):
		_Activar()
	else:
		_Desactivar()

func _ready():
	pass

func _Activar() -> void:
	animacion.play("aparecer")

func _Desactivar() -> void:
	animacion.play_backwards("aparecer")

