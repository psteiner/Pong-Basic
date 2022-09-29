extends Resource

class_name Math

static func pointConversion(pointA: float, originalStart: float, originalEnd: float, newStart: float, newEnd: float) -> float:
  var length = originalEnd - originalStart
  var newLength = newEnd - newStart
  
  return ((pointA - originalStart) * (newLength/length)) + newStart

static func vectorScaling(original: Vector2, scale: float) -> Vector2:
  var result: Vector2
  
  result.x = original.x * scale
  result.y = original.y * scale
  
  return result

static func vectorRotation(original: Vector2, degree: float) -> Vector2:
  var result: Vector2
  var radian: float = deg2rad(degree)
  var sine: float = sin(radian)
  var cosine: float = cos(radian)
  
  result.x = (original.x * cosine) - (original.y * sine)
  result.y = (original.x * sine) + (original.y * cosine)
  
  # cartesian graph system != Godot Game Engine Graph System
  # caller must convert result
  return result