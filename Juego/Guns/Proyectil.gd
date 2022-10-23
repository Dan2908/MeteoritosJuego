class_name Proyectil
extends Area2D

###########################################
#	VARIABLES
###########################################
var velocidad:Vector2 = Vector2.ZERO
var ataque:int

###########################################
#	MÉTODOS
###########################################
func Crear(pPosicion: Vector2, pDireccion: float, pVelocidad: float, pAtaque: float) -> void:
	position = pPosicion
	rotation = pDireccion
	velocidad = Vector2(pVelocidad, 0).rotated(pDireccion)
	ataque = pAtaque

func Atacar(pEntidad: CollisionObject2D):
	if(pEntidad.has_method("RecibirAtaque")):
		pEntidad.RecibirAtaque(ataque)
	queue_free()

func _physics_process(delta: float) -> void:
	position += velocidad * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Proyectil_area_entered(area: Area2D):
	Atacar(area)

func _on_Proyectil_body_entered(body: Node):
	Atacar(body) # Replace with function body.
