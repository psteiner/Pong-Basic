extends Resource

class_name Math

static func pointConversion(pointA: float, originalStart: float, originalEnd: float, newStart: float, newEnd: float) -> float:
  var length = originalEnd - originalStart
  var newLength = newEnd - newStart
  
  return ((pointA - originalStart) * (newLength/length)) + newStart

static func vectorScaling(original: Vector2, scale: float) -> Vector2:
  var result: Vector2 = Vector2(0.0,0.0)
  
  result.x = original.x * scale
  result.y = original.y * scale
  
  return result

static func vectorRotation(original: Vector2, degree: float) -> Vector2:
  var result: Vector2 = Vector2(0.0,0.0)
  var radian: float = deg2rad(degree)
  var sine: float = sin(radian)
  var cosine: float = cos(radian)
  
  result.x = (original.x * cosine) - (original.y * sine)
  result.y = (original.x * sine) + (original.y * cosine)
  
  # cartesian graph system != Godot Game Engine Graph System
  # caller must convert result
  return result


static func primitiveNormalDistributionRandom() -> float:
  var iterate: int = 6
  var result: float = 0.0
  
  randomize()
  for i in iterate:
    result += randf() 
    
  print(result / float(iterate))
    
  return result / float(iterate)
