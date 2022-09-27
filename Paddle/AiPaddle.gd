extends Paddle

class_name AiPaddle

const _CHASE_BUFFER: float = 15.0

func _init(box: BoundBox) -> void:
  _boundBox = box
  _pos = Vector2(_boundBox.getSize().x -(_padding + _size.x), _boundBox.getHalfHeight() - _halfHeight)
  _resetPos = _pos
  _rect = Rect2(_pos, _size)

func checkMovement(delta: float, ballPos: Vector2):
  if ballPos.y <= (_pos.y + _halfHeight) - _CHASE_BUFFER:
    moveUp(delta)
    updatePosition()
  elif ballPos.y >= (_pos.y + _halfHeight) + _CHASE_BUFFER:
    moveDown(delta)
    updatePosition()
    
    
func moveUp(delta: float) -> void:
  # y += -400 * 0.1666
  # y += -6.667
  # move up ~7 pixels
  _pos.y -= _speed.y * delta

func moveDown(delta: float) -> void:
  _pos.y += _speed.y * delta
