class_name Player
extends RigidBody2D

enum ESTADOS {SPAWN, VIVO, MUERTO, INVENCIBLE}

###########################################
#	VARIABLES
###########################################
export var potenciaMotor:int = 20
export var potenciaRotacion:int = 200
export var estelaMaxima:int = 150
export var hitPoints:float = 15.0

onready var canon:Canon = $Canon
onready var rayoLaser:RayoLaser = $LaserBeam2D
onready var estela:Estela = $EstelaDeImpulso/Estela
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var animacion:AnimationPlayer = $AnimationPlayer
onready var motorSFX:MotorSFX = $Motor
onready var impactoSFX:AudioStreamPlayer = $ImpactoSFX
onready var escudo:EscudoPlayer = $Escudo

var dirRotacion:int = 0
var empuje:Vector2 = Vector2.ZERO
var estado:int = ESTADOS.SPAWN setget set_Estado
var escudoActivo:bool = false
###########################################
#	MÉTODOS
###########################################

# Lee las acciones del jugador (teclas) y modifica las fuerzas requeridas
func PlayerInput() -> void:
	if( not _EstaInputActivo()):
		return

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

	if(Input.is_action_just_pressed("activar_escudo")):
		escudoActivo = !escudoActivo
		escudo.Actualizar(escudoActivo)

func Destruir() -> void:
	_ActualizarEstado(ESTADOS.MUERTO)

func RecibirAtaque(pAtaque: Node2D) -> void:
	impactoSFX.play()
	hitPoints = hitPoints - pAtaque.ataque
	if(hitPoints < 0):
		Destruir()

func _ActualizarEstado(pValor: int) -> void:
	match pValor:
		ESTADOS.SPAWN:
			colisionador.set_deferred("disabled", true)
			canon.set_PuedeDisparar(false)
			animacion.play("spawn")
		ESTADOS.VIVO:
			colisionador.set_deferred("disabled", false)
			canon.set_PuedeDisparar(true)
		ESTADOS.MUERTO:
			colisionador.set_deferred("disabled", true)
			canon.set_PuedeDisparar(false)
			Eventos.emit_signal("nave_destruida", position)
			queue_free()
		ESTADOS.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		_:
			printerr("[ERROR] ", pValor, " no es un estado")
			return
	set_Estado(pValor)

func _EstaInputActivo() -> bool:
	return not (estado in [ESTADOS.MUERTO, ESTADOS.SPAWN])

# Como physic_process() para RigidBody2D. Aplica cambios en los vectores de fuerzas
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dirRotacion * potenciaRotacion)

# Procesos a ejecutar en cada repetición del Loop principal
func _process(delta: float) -> void:
	PlayerInput()

func _unhandled_input(event) -> void:
	if(not _EstaInputActivo()):
		return

	# Laser
	if(event.is_action_pressed("disparo_secundario")):
		rayoLaser.set_is_casting(true)
	elif(event.is_action_released("disparo_secundario")):
		rayoLaser.set_is_casting(false)
	# Mover
	if(event.is_action_released("mover_adelante") or event.is_action_released("mover_atras")):
		motorSFX.Acelerar(true)
	elif(event.is_action_pressed("mover_adelante")):
		estela.set_max_points(estelaMaxima)
		motorSFX.Acelerar(false)
	elif(event.is_action_pressed("mover_atras")):
		estela.set_max_points(0)
		motorSFX.Acelerar(false)

func _ready() -> void:
	_ActualizarEstado(ESTADOS.SPAWN)
	escudo.Actualizar(escudoActivo)
	motorSFX.play()
###########################################
#	SET GET
###########################################
func set_Estado(pValor: int) -> void:
	estado = pValor

###########################################
#	SEÑALES
###########################################
func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "spawn"):
		_ActualizarEstado(ESTADOS.VIVO)
