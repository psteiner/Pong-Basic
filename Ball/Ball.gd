extends Node2D

class_name Ball

var _color: Color = Color.white
var _radius: float = 10.0
var _pos: Vector2
var _resetPos: Vector2
var _speed: Vector2
var _resetSpeed: Vector2

func _init(startPos: Vector2, speed := 400.0):
  _pos = startPos
  _resetPos = startPos
  _speed = Vector2(abs(speed), 0.0)
  _resetSpeed = _speed
  
func _draw() -> void:
  draw_circle(_pos, _radius, _color)

func moveBall(delta: float) -> void:
  _pos += _speed * delta
  update()

func resetBall(playerServe: bool) -> void:
  _pos = _resetPos
  _speed = _resetSpeed if playerServe else -_resetSpeed
  update()

func inverseYSpeed() -> void:
  _speed.y = -_speed.y
  
func inverseXSpeed() -> void:
  _speed = Vector2(-_speed.x, rand_range(-400.0,400.0))
        
func getPosition() -> Vector2:
  return _pos

func getTopPoint() -> Vector2:
  return Vector2(_pos.x, _pos.y - _radius)

func getBottomPoint() -> Vector2:
  return Vector2(_pos.x, _pos.y + _radius)
  
func isMovingLeft() -> bool:
  return _speed.x <= 0.0

func isMovingRight() -> bool:
  return _speed.x >= 0.0
  
func isMovingUp() -> bool:
  return _speed.y <= 0.0

func isMovingDown() -> bool:
  return _speed.y >= 0.0
