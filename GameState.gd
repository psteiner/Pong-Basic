extends Node2D

# sound maker
var backgroundStream: AudioStreamPlayer = AudioStreamPlayer.new()
var backgroundManager: BackgroundManager = BackgroundManager.new()

var soundStream: AudioStreamPlayer = AudioStreamPlayer.new()
var soundManager: SoundManager = SoundManager.new()

# states
enum GAME_STATE {MENU, SERVE, PLAY}
var isPlayerServe: bool = true

# scoring
var playerScore: int = 0
var aiScore: int = 0
var _SCORE_HEIGHT_PADDING: float = 50.0

# current state
var currentGameState = GAME_STATE.MENU
onready var screen: Rect2 = get_tree().get_root().get_visible_rect()
onready var screenBox: BoundBox = BoundBox.new(screen)

onready var ball: Ball = Ball.new(screenBox.getCenter())
onready var playerPaddle: PlayerPaddle = PlayerPaddle.new(screenBox)
onready var aiPaddle: AiPaddle = AiPaddle.new(screenBox)
onready var instructionText: Text = Text.new(
  "Start a game by pressing the space bar", 
  Vector2(screenBox.getSize().x / 2.0, 0.0))
  
onready var playerScoreText: Text = Text.new(
  playerScore as String,
  Vector2(screenBox.getSize().x/4.0, _SCORE_HEIGHT_PADDING)
 )
onready var aiScoreText: Text = Text.new(
  aiScore as String,
  Vector2(screenBox.getSize().x - screenBox.getSize().x/4.0, _SCORE_HEIGHT_PADDING)
 )


var playerTextHalfWidth: float
var playerScorePosition: Vector2

var aiTextHalfWidth: float
var aiScorePosition: Vector2

# delta key
const RESET_DELTA_KEY: float = 0.0
const MAX_KEY_TIME: float = 0.3
var deltaKeyPress: float = RESET_DELTA_KEY

const MAX_SCORE: int = 3
var isPlayerWin: bool

func _ready() -> void:
  backgroundStream.name = "BackgroundStream"
  backgroundStream.add_child(backgroundManager)
  add_child(backgroundStream)
  
  soundStream.name = "SoundStream"
  soundStream.add_child(soundManager)
  add_child(soundStream)
  
  add_child(ball)
  add_child(playerPaddle)
  add_child(aiPaddle)
  add_child(instructionText)
  add_child(playerScoreText)
  add_child(aiScoreText)
  
func _physics_process(delta: float) -> void:
  
  deltaKeyPress += delta
  
  match currentGameState:
    GAME_STATE.MENU:
      checkChangeState(GAME_STATE.SERVE)
        
    GAME_STATE.SERVE:
      setStartingPosition()
      checkWinner()
      checkChangeState(GAME_STATE.PLAY)
  
    GAME_STATE.PLAY:
      instructionText.updateString("W = Move Up; S = Move Down")
      moveObjects(delta)
      checkCollisions()
      checkChangeState(GAME_STATE.SERVE)

func moveObjects(delta: float) -> void:
  playerPaddle.checkMovement(delta)
  aiPaddle.checkMovement(delta, ball.getPosition())
  ball.moveBall(delta)
  

func setStartingPosition() -> void:
  aiPaddle.resetPosition()
  playerPaddle.resetPosition()
  ball.resetBall(isPlayerServe)
  aiScoreText.updateString(aiScore as String)   
  playerScoreText.updateString(playerScore as String)
    
  if isPlayerServe:
    instructionText.updateString("Player Serve: press spacebar to serve")
  else:
    instructionText.updateString("AI Serve: press spacebar to serve")

func checkChangeState(newState: int) -> void:
  if spaceBarDelay():
    currentGameState = newState
    deltaKeyPress = RESET_DELTA_KEY

func spaceBarDelay() -> bool:
  return Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME

func gamePointPlayer(playerWin: bool) -> void:
  currentGameState = GAME_STATE.SERVE
  deltaKeyPress = RESET_DELTA_KEY
  isPlayerServe = !playerWin
  
  playerScore += 1 if playerWin else 0
  playerScoreText.updateString(playerScore as String)
  
  aiScore += 1 if !playerWin else 0
  aiScoreText.updateString(aiScore as String)   

func checkWinner() -> void:
  match MAX_SCORE:
    playerScore:
      currentGameState = GAME_STATE.MENU
      playerScore = 0
      aiScore = 0
      isPlayerWin = true
      instructionText.updateString("Player Wins! Press spacebar to start a new game")
      soundManager.playWinRound()
    aiScore:
      currentGameState = GAME_STATE.MENU
      playerScore = 0
      aiScore = 0
      isPlayerWin = false
      instructionText.updateString("AI Wins! Press spacebar to start a new game")
      soundManager.playLoseRound()

func checkCollisions() -> void:
  if screenBox.isPastLeftBound(ball.getPosition()):
    gamePointPlayer(false)
    soundManager.playLosePoint()
  
  if screenBox.isPastRightBound(ball.getPosition()):
    gamePointPlayer(true)
    soundManager.playWinPoint()

  if screenBox.isPastTopBound(ball.getTopPoint()) and ball.isMovingUp():
    ball.inverseYSpeed()
    soundManager.playBounce()
    
  if screenBox.isPastBottomBound(ball.getBottomPoint()) and ball.isMovingDown():
    ball.inverseYSpeed()
    soundManager.playBounce()

  if Collisions.pointToRectangle(ball.getPosition(), playerPaddle.getRect()) and ball.isMovingLeft():
    playerPaddle.changeBallDirection(ball)
    soundManager.playBounce()
    
  if Collisions.pointToRectangle(ball.getPosition(), aiPaddle.getRect()) and ball.isMovingRight():
    aiPaddle.changeBallDirection(ball)
    aiPaddle.changeChasePosition()
    soundManager.playBounce()
