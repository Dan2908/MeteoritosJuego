class_name MotorSFX
extends AudioStreamPlayer2D

onready var tween:Tween = $Tween

const maxPitch: float = 1.0
const minPitch: float = 0.1
const maxVolumen: int = -5
const minVolumen: int = -20

var escalaObjetivo: float = minPitch
var volumenObjetivo: int = minVolumen

func Acelerar(pEnReversa: bool):
	tween.stop_all()
	if(pEnReversa):
		escalaObjetivo = minPitch
		volumenObjetivo = minVolumen
	else:
		escalaObjetivo = maxPitch
		volumenObjetivo = maxVolumen
	tween.interpolate_property(self, "pitch_scale", pitch_scale, escalaObjetivo, 1.0, Tween.TRANS_LINEAR)
	tween.interpolate_property(self, "volume_db", volume_db, volumenObjetivo, 1.0, Tween.TRANS_LINEAR)
	tween.start()

func _ready():
	pass
