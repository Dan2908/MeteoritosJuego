class_name Canon
extends Node2D

###########################################
#	VARIABLES
###########################################
export var proyectil:PackedScene = null
export var cadenciaDisparo:float = 0.8
export var velocidadProyectil:int = 400
export var ataqueProyectil:int = 1

onready var timerEnfriamiento:Timer = $TimerEnfriamiento
onready var audioPlayer:AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var estaFrio:bool = true
onready var estaDisparando:bool = false setget set_EstaDisparando

var puntosDisparo:Array = []
var puedeDisparar:bool = false setget set_PuedeDisparar

###########################################
#	MÉTODOS
###########################################
func AlmacenarPuntosDisparo():
	for node in get_children():
		if(node is Position2D):
			puntosDisparo.append(node)

func Disparar():
	estaFrio = false
	audioPlayer.play()
	timerEnfriamiento.start()
	for punto in puntosDisparo:
		var new_Proyectil:Proyectil = proyectil.instance()
		new_Proyectil.crear(
			punto.global_position,
			get_owner().rotation,
			velocidadProyectil,
			ataqueProyectil
		)
		Eventos.emit_signal("disparar", new_Proyectil)

func _ready():
	AlmacenarPuntosDisparo()
	timerEnfriamiento.wait_time = cadenciaDisparo

func _process(delta:float) -> void:
	if(estaFrio && estaDisparando):
		Disparar()

###########################################
#	SET GET
###########################################
func set_EstaDisparando(pDisparando: bool) -> void:
	estaDisparando = pDisparando

func set_PuedeDisparar(pValor:bool) -> void:
	puedeDisparar = pValor

###########################################
#	SEÑALES
###########################################
func _on_TimerEnfriamiento_timeout() -> void:
	estaFrio = true

