extends Node2D

class_name Paddle

var _color: Color = Color.white
var _size: Vector2 = Vector2(10.0, 100.0)
var _padding: float = 10.0
var _speed: Vector2 = Vector2(0.0, 400.0) # only moves in y-axis
var _resetSpeed: Vector2 = _speed
var _halfHeight: float = _size.y/2.0

# handled by subclass
var _rect: Rect2
var _pos: Vector2
var _resetPos: Vector2
var _boundBox: BoundBox

var _maxMagnitude: float = 3.0
var _maxRotation: float = 75.0

func _draw() -> void:
  draw_rect(_rect, _color)

func getHalfHeight() -> float:
  return _halfHeight
  
func getRect() -> Rect2:
  return _rect
  
func resetPosition() -> void:
  _pos = _resetPos
  _rect = Rect2(_pos, _size)
  update()

func updatePosition() -> void:
  _pos.y = clamp(_pos.y, _boundBox.getPosition().y, _boundBox.getSize().y - _size.y)
  _rect = Rect2(_pos, _size)
  update()

# override in subclasses
func moveUp(_delta) -> void:
  assert(false, "Must override method moveUp()")
  
# override in subclasses
func moveDown(_delta) -> void:
  assert(false, "Must override method moveDown()")

func changeBallDirection(ball: Ball) -> void:
  var ballY = ball.getPosition().y
  var magnitude: float = Math.pointConversion(ballY, _pos.y, _pos.y + _size.y, _maxMagnitude, -_maxMagnitude)
  var degree: float = Math.pointConversion(ballY, _pos.y, _pos.y + _size.y, _maxRotation, -_maxRotation)
  
  magnitude = abs(magnitude) if abs(magnitude) >= 1.0 else 1.0
  
  ball.changeRotationAndDirection(degree)
  ball.changeMagnitude(magnitude)
