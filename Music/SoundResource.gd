extends Resource

class_name SoundResource

const START_AT_ZERO: float = 0.0

func createSound(soundFile: Resource, audioStreamNode: NodePath, 
  length: float, isLoop := false) -> Animation:
  var sound: Animation = Animation.new()
  var trackIndex: int = sound.add_track(Animation.TYPE_AUDIO)
  
  sound.set_length(length)
  sound.set_loop(isLoop)
  
  sound.track_set_path(trackIndex, audioStreamNode)
  sound.audio_track_insert_key(trackIndex, START_AT_ZERO, soundFile)
  
  return sound
