extends Node2D

###########################################
#	VARIABLES
###########################################
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
	Eventos.connect("Disparar", self, "_on_Disparar")

func _ready():
	CrearColaProyectiles()
	Conectar()

###########################################
#	SEÑALES
###########################################
func _on_Disparar(pProyectil: Proyectil):
	proyectiles.add_child(pProyectil)
