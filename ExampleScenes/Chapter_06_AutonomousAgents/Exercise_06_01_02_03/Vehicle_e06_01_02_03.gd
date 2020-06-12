extends Area2D

class_name Vehicle_e06_01

onready var viewport_size = get_viewport().get_visible_rect().size

var velocity : Vector2
var acceleration : Vector2

export var max_speed : float = 4
export var max_force : float = 0.1
export var size : float
var target: Vector2
var mass = 1
var polygon : PoolVector2Array
var color = Color(1,0,0,0.5)

func _init(_position:Vector2, _size:float):
	position = _position
	size = _size
	
func _ready():
	var collider = CollisionPolygon2D.new()
	var v1 = Vector2(-size,-size)
	var v2 = Vector2(size,0)
	var v3 = Vector2(-size,size)
	polygon = PoolVector2Array([v1,v2,v3])
	collider.set_polygon(polygon)
	add_child(collider)

func _process(delta):
	velocity += acceleration
	velocity = velocity.clamped(max_speed)
	position += velocity
	acceleration *= 0
	
	var theta = velocity.angle()
	rotation = theta
	
	check_edges()
	update()
	
func seek(_target:Vector2, delta):
	var desired = _target - position
	desired = desired.normalized()
	desired *= max_speed * delta * 100
	var steer: Vector2 = desired - velocity
	steer = steer.clamped(max_force)
	apply_force(steer)

func flee(_target:Vector2, delta):
	var desired = position - _target
	desired = desired.normalized()
	desired *= max_speed * delta * 100
	var steer: Vector2 = desired - velocity
	steer = steer.clamped(max_force)
	apply_force(steer)

func apply_force(force:Vector2):
	var f = force
	f /= mass
	acceleration += f
	
func check_edges():
	if position.x < 0:
		position.x += viewport_size.x
	elif position.x > viewport_size.x:
		position.x -= viewport_size.x
	elif position.y < 0:
		position.y += viewport_size.y
	elif position.y > viewport_size.y:
		position.y -= viewport_size.y

func _draw():
	draw_colored_polygon(polygon, color)
