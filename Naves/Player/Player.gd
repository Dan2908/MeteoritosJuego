class_name Player
extends RigidBody2D

###########################################
#	VARIABLES
###########################################
export var potenciaMotor:int = 20
export var potenciaRotacion:int = 280

onready var canon:Canon = $Canon

var empuje:Vector2 = Vector2.ZERO
var dirRotacion:int = 0

###########################################
#	MÉTODOS
###########################################

# Lee las acciones del jugador (teclas) y modifica las fuerzas requeridas
func PlayerInput() -> void:
	empuje = Vector2.ZERO
	if(Input.is_action_pressed("mover_adelante")):
		empuje.x = potenciaMotor
	elif(Input.is_action_pressed("mover_atras")):
		empuje.x = -potenciaMotor

	dirRotacion = 0
	if(Input.is_action_pressed("rotar_horario")):
		dirRotacion += 1
	elif(Input.is_action_pressed("rotar_antihorario")):
		dirRotacion -= 1

	if(Input.is_action_pressed("disparar")):
		canon.set_EstaDisparando(true)
	else:
		canon.set_EstaDisparando(false)

# Como physic_process() para RigidBody2D. Aplica cambios en los vectores de fuerzas
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dirRotacion * potenciaRotacion)

# Procesos a ejecutar en cada repetición del Loop principal
func _process(delta: float) -> void:
	PlayerInput()
