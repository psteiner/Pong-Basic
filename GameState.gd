extends Node2D

# states
enum GAME_STATE {MENU, SERVE, PLAY}
var isPlayerServe = true

# current state
var currentGameState = GAME_STATE.MENU
onready var screen: Rect2 = get_tree().get_root().get_visible_rect()
onready var screenBox: BoundBox = BoundBox.new(screen)

onready var ball: Ball = Ball.new(screenBox.getCenter())
onready var playerPaddle: PlayerPaddle = PlayerPaddle.new(screenBox)

# ai paddle
var paddlePadding = 10.0
var paddleSize = Vector2(10.0,100.0)
var halfPaddleHeight = paddleSize.y/2.0
var paddleColor: Color = Color.white
onready var aiPosition: Vector2 = Vector2(
  screenBox.getSize().x - (paddlePadding + paddleSize.x), 
  screenBox.getHalfHeight() - halfPaddleHeight
)
onready var aiRectangle: Rect2 = Rect2(aiPosition, paddleSize)

# string variable
var stringPosition: Vector2

var playerSpeed: float = 200.00

var playerScore: int = 0
var playerScoreText: String = playerScore as String
var playerTextHalfWidth: float
var playerScorePosition: Vector2

var aiScore: int = 0
var aiScoreText: String = aiScore as String
var aiTextHalfWidth: float
var aiScorePosition: Vector2

const MAX_SCORE: int = 3
var isPlayerWin

# delta key
const RESET_DELTA_KEY: float = 0.0
const MAX_KEY_TIME: float = 0.3
var deltaKeyPress: float = RESET_DELTA_KEY

# font variable
var font: DynamicFont = DynamicFont.new()
var robotoFile: DynamicFontData = load("Roboto-Light.ttf")
var fontSize: int = 36
var halfWidthFont: float
var heightFont: float
var stringValue: String = "Start a game by pressing the spacebar"

func _ready() -> void:
  add_child(ball)
  add_child(playerPaddle)
  font.font_data = robotoFile
  font.size = fontSize
  halfWidthFont = font.get_string_size(stringValue).x/2.0
  heightFont = font.get_height()
  stringPosition = Vector2(screenBox.getHalfWidth() - halfWidthFont, heightFont)
  
  playerTextHalfWidth = font.get_string_size(playerScoreText).x/2.0
  playerScorePosition = Vector2(screenBox.getHalfWidth() - (screenBox.getHalfWidth()/2.0) - 
    playerTextHalfWidth, heightFont + 50)
  aiTextHalfWidth = font.get_string_size(aiScoreText).x/2.0
  aiScorePosition = Vector2(screenBox.getHalfWidth() + (screenBox.getHalfWidth()/2.0) - 
    aiTextHalfWidth, heightFont + 50)
  
func _physics_process(delta: float) -> void:
  
  deltaKeyPress += delta
  
  match currentGameState:
    GAME_STATE.MENU:
      if(isPlayerWin == true):
        change_string("Player Wins! Press spacebar to start a new game")
      if(isPlayerWin == false):
        change_string("AI Wins! Press spacebar to start a new game")
      
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
        playerScoreText = playerScore as String
        aiScoreText = aiScore as String
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
#        ball.resetBall(isPlayerServe)
        change_string("Player Serve: press spacebar to serve")
      else:
#        ball.resetBall(isPlayerServe)
        change_string("AI Serve: press spacebar to serve")
      
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.PLAY
        deltaKeyPress = RESET_DELTA_KEY
    GAME_STATE.PLAY:
      playerPaddle.checkMovement(delta)
      change_string("PLAY!!!")
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
      
      ball.moveBall(delta)
      
      if screenBox.isPastLeftBound(ball.getPosition()):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
        isPlayerServe = true
        aiScore += 1
        aiScoreText = aiScore as String
      
      if screenBox.isPastRightBound(ball.getPosition()):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
        isPlayerServe = false
        playerScore += 1
        playerScoreText = playerScore as String
 
      if screenBox.isPastTopBound(ball.getTopPoint()):
        ball.inverseYSpeed()
      if screenBox.isPastBottomBound(ball.getBottomPoint()):
        ball.inverseYSpeed()

      if(Collisions.pointToRectangle(ball.getPosition(), playerPaddle.getRect())):
        ball.inverseXSpeed()
        
      if(Collisions.pointToRectangle(ball.getPosition(), Rect2(aiPosition, paddleSize))):
        ball.inverseXSpeed()

      
      if ball.getPosition().y > aiPosition.y + (paddleSize.y/2 + 10):
        aiPosition.y += 250 * delta
      if ball.getPosition().y < aiPosition.y + (paddleSize.y/2 - 10):
        aiPosition.y -= 250 * delta
      aiPosition.y = clamp(aiPosition.y, 0.0, screenBox.getSize().y - paddleSize.y)
      aiRectangle = Rect2(aiPosition, paddleSize)
      update()
  
func _draw() -> void:
  draw_rect(aiRectangle,paddleColor)
  draw_string(font, stringPosition, stringValue)
  draw_string(font, playerScorePosition, playerScoreText)
  draw_string(font, aiScorePosition, aiScoreText)

func set_starting_position() -> void:
  aiPosition = Vector2(screenBox.getSize().x - (paddlePadding + paddleSize.x),
  screenBox.getHalfHeight() - halfPaddleHeight)
  aiRectangle = Rect2(aiPosition, paddleSize)

  playerPaddle.resetPosition()
  ball.resetBall(isPlayerServe)

func change_string(newStringValue) -> void:
  stringValue = newStringValue
  halfWidthFont = font.get_string_size(stringValue).x/2.0
  stringPosition = Vector2(screenBox.getHalfWidth() - halfWidthFont, heightFont)
  update() 
