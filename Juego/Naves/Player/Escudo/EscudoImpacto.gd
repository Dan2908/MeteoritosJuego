class_name ImpactoEscudo
extends Sprite

onready var animation:AnimationPlayer = $Animacion

func _ready():
	animation.play("impacto")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

