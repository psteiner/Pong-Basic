extends AnimationPlayer

class_name BackgroundManager

var sounds: SoundResource = SoundResource.new()
onready var backgroundPlayer: NodePath = get_parent().get_path()
var backgroundFile: Resource = preload("res://Music/BackgroundMusic.wav")
var backgroundMusicName: String = "BackgroundMusic"
var backgroundLength: float = backgroundFile.get_length()


func _ready() -> void:
  self.name = "BackgroundManager"
  self.add_animation(backgroundMusicName, 
  sounds.createSound(backgroundFile,backgroundPlayer, backgroundLength, true))
  self.play(backgroundMusicName)
