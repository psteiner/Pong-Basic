extends Node2D

# states
enum GAME_STATE {MENU, SERVE, PLAY}
var isPlayerServe = true

# scoring
var playerScore: int = 0
var aiScore: int = 0
var _SCORE_HEIGHT_PADDING = 50.0

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
var isPlayerWin

func _ready() -> void:
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
      if(isPlayerWin == true):
        instructionText.updateString("Player Wins! Press spacebar to start a new game")
      if(isPlayerWin == false):
        instructionText.updateString("AI Wins! Press spacebar to start a new game")
      
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
        playerScoreText.updateString(playerScore as String)
        aiScoreText.updateString(aiScore as String)
        
    GAME_STATE.SERVE:
      set_starting_position()
      update()
      
      if(MAX_SCORE == playerScore):
        currentGameState = GAME_STATE.MENU
        playerScore = 0
        aiScore = 0
        isPlayerWin = true
      if(MAX_SCORE == aiScore):
        currentGameState = GAME_STATE.MENU
        playerScore = 0
        aiScore = 0
        isPlayerWin = false

      if isPlayerServe:
        instructionText.updateString("Player Serve: press spacebar to serve")
      else:
        instructionText.updateString("AI Serve: press spacebar to serve")
      
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.PLAY
        deltaKeyPress = RESET_DELTA_KEY
    GAME_STATE.PLAY:
      playerPaddle.checkMovement(delta)
      aiPaddle.checkMovement(delta, ball.getPosition())
      ball.moveBall(delta)
      
      instructionText.updateString("PLAY!!!")
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
      
      if screenBox.isPastLeftBound(ball.getPosition()):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
        isPlayerServe = true
        aiScore += 1
        aiScoreText.updateString(aiScore as String)
      
      if screenBox.isPastRightBound(ball.getPosition()):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
        isPlayerServe = false
        playerScore += 1
        playerScoreText.updateString(playerScore as String)
 
      if screenBox.isPastTopBound(ball.getTopPoint()):
        ball.inverseYSpeed()
      if screenBox.isPastBottomBound(ball.getBottomPoint()):
        ball.inverseYSpeed()

      if(Collisions.pointToRectangle(ball.getPosition(), playerPaddle.getRect())):
        ball.inverseXSpeed()
        
      if(Collisions.pointToRectangle(ball.getPosition(), aiPaddle.getRect())):
        ball.inverseXSpeed()
  
func set_starting_position() -> void:
  playerPaddle.resetPosition()
  aiPaddle.resetPosition()
  ball.resetBall(isPlayerServe)

