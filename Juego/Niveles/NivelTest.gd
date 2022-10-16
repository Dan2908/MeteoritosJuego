extends Node2D

###########################################
#	VARIABLES
###########################################
export var explosion:PackedScene = null
onready var proyectiles:Node

###########################################
#	MÉTODOS
###########################################

# Crear un nodo para contener y descartar los proyectiles disparados del jugador
func CrearColaProyectiles():
	proyectiles = Node.new()
	proyectiles.name = "Proyectiles"
	add_child(proyectiles)

# Conectar con hub
func Conectar():
	Eventos.connect("disparar", self, "_on_disparar")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")

func _ready():
	CrearColaProyectiles()
	Conectar()

###########################################
#	SEÑALES
###########################################
func _on_disparar(pProyectil: Proyectil):
	proyectiles.add_child(pProyectil)

func _on_nave_destruida(posicion: Vector2):
	var new_explosion: Node2D = explosion.instance()
	new_explosion.global_position = posicion
	add_child(new_explosion)
