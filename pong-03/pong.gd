extends Node2D

# states
enum GAME_STATE {MENU, SERVE, PLAY}
var isPlayerServe = true

# current state
var currentGameState = GAME_STATE.MENU

# screen values
onready var screenWidth: int = get_tree().get_root().size.x
onready var halfScreenWidth: int = screenWidth / 2.0
onready var screenHeight: int  = get_tree().get_root().size.y
onready var halfScreenHeight: int  = screenHeight / 2.0

# paddle variables
var paddleColor: Color = Color.white
var paddleSize: Vector2 = Vector2(10.0, 100.0)
var halfPaddleHeight: int = paddleSize.y/2.0
var paddlePadding: float = 10.0

# ball variables
var ballRadius: float = 10.0
var ballColor: Color = Color.white
onready var startingBallPosition: Vector2 = Vector2(halfScreenWidth,halfScreenHeight)
onready var ballPosition: Vector2 = startingBallPosition

# player paddle
onready var playerPosition: Vector2 = Vector2(paddlePadding, halfScreenHeight - halfPaddleHeight)
onready var playerRectangle: Rect2 = Rect2(playerPosition, paddleSize)

# ai paddle
onready var aiPosition: Vector2 = Vector2(
  screenWidth - (paddlePadding + paddleSize.x), 
  halfScreenHeight - halfPaddleHeight
)
onready var aiRectangle: Rect2 = Rect2(aiPosition, paddleSize)

# string variable
var stringPosition: Vector2

# ball speed
var startingSpeed: Vector2 = Vector2(600.0,0.0)
var ballSpeed: Vector2 = startingSpeed

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
var fontSize: int = 24
var halfWidthFont: float
var heightFont: float
var stringValue: String = "Start a game by pressing the spacebar"

func _ready() -> void:
  font.font_data = robotoFile
  font.size = fontSize
  halfWidthFont = font.get_string_size(stringValue).x/2.0
  heightFont = font.get_height()
  stringPosition = Vector2(halfScreenWidth - halfWidthFont, heightFont)
  
  playerTextHalfWidth = font.get_string_size(playerScoreText).x/2.0
  playerScorePosition = Vector2(halfScreenWidth - (halfScreenWidth/2.0) - 
    playerTextHalfWidth, heightFont + 50)
  aiTextHalfWidth = font.get_string_size(aiScoreText).x/2.0
  aiScorePosition = Vector2(halfScreenWidth + (halfScreenWidth/2.0) - 
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
        ballSpeed = startingSpeed
        change_string("Player Serve: press spacebar to serve")
      else:
        ballSpeed = -startingSpeed
        change_string("AI Serve: press spacebar to serve")
      
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.PLAY
        deltaKeyPress = RESET_DELTA_KEY
    GAME_STATE.PLAY:
      change_string("PLAY!!!")
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
      
      ballPosition += ballSpeed * delta
      
      if ballPosition.x <= 0:
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
        isPlayerServe = true
        aiScore += 1
        aiScoreText = aiScore as String
      
      if ballPosition.x >= screenWidth:
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
        isPlayerServe = false
        playerScore += 1
        playerScoreText = playerScore as String
        
        
      if ballPosition.y - ballRadius <= 0.0:
        ballSpeed.y = -ballSpeed.y
      if ballPosition.y + ballRadius >= screenHeight:
        ballSpeed.y = -ballSpeed.y

      if (ballPosition.x - ballRadius >= playerPosition.x and 
      ballPosition.x - ballRadius <= playerPosition.x + paddleSize.x):
        
        var paddleDivide: float = paddleSize.y/3
        
        if(ballPosition.y >= playerPosition.y and
          ballPosition.y <= playerPosition.y + paddleDivide):
            var tempBall: Vector2 = Vector2(-ballSpeed.x, -400.0)
            ballSpeed = tempBall
        elif(ballPosition.y >= playerPosition.y and
          ballPosition.y <= playerPosition.y + paddleDivide*2):
            var tempBall: Vector2 = Vector2(-ballSpeed.x, 0.0)
            ballSpeed = tempBall
        elif(ballPosition.y >= playerPosition.y and
          ballPosition.y <= playerPosition.y + paddleDivide*3):
            var tempBall: Vector2 = Vector2(-ballSpeed.x, 400.0)
            ballSpeed = tempBall

      if (ballPosition.x + ballRadius >= aiPosition.x and 
      ballPosition.x + ballRadius <= aiPosition.x + paddleSize.x):
        
        var paddleDivide: float = paddleSize.y/3
        
        if(ballPosition.y >= aiPosition.y and
        ballPosition.y <= aiPosition.y + paddleDivide):
            var tempBall: Vector2 = Vector2(-ballSpeed.x, -400.0)
            ballSpeed = tempBall
        elif(ballPosition.y >= aiPosition.y and
        ballPosition.y <= aiPosition.y + paddleDivide*2):
            var tempBall: Vector2 = Vector2(-ballSpeed.x, 0.0)
            ballSpeed = tempBall
        elif(ballPosition.y >= aiPosition.y and
        ballPosition.y <= aiPosition.y + paddleDivide*3):
            var tempBall: Vector2 = Vector2(-ballSpeed.x, 400.0)
            ballSpeed = tempBall
        
      if(Input.is_key_pressed(KEY_W)):
        playerPosition.y += -playerSpeed * delta
        playerPosition.y = clamp(playerPosition.y, 0.0, screenHeight - paddleSize.y)
        playerRectangle = Rect2(playerPosition, paddleSize)
      if(Input.is_key_pressed(KEY_S)):
        playerPosition.y += playerSpeed * delta
        playerPosition.y = clamp(playerPosition.y, 0.0, screenHeight - paddleSize.y)
        playerRectangle = Rect2(playerPosition, paddleSize)
      
      if ballPosition.y > aiPosition.y + (paddleSize.y/2 + 10):
        aiPosition.y += 250 * delta
      if ballPosition.y < aiPosition.y + (paddleSize.y/2 - 10):
        aiPosition.y -= 250 * delta
      aiPosition.y = clamp(aiPosition.y, 0.0, screenHeight - paddleSize.y)
      aiRectangle = Rect2(aiPosition, paddleSize)
      update()
  
func _draw() -> void:
  draw_circle(ballPosition, ballRadius, ballColor)
  draw_rect(playerRectangle, paddleColor)
  draw_rect(aiRectangle,paddleColor)
  draw_string(font, stringPosition, stringValue)
  draw_string(font, playerScorePosition, playerScoreText)
  draw_string(font, aiScorePosition, aiScoreText)

func set_starting_position() -> void:
  aiPosition = Vector2(screenWidth - (paddlePadding + paddleSize.x),
  halfScreenHeight - halfPaddleHeight)
  aiRectangle = Rect2(aiPosition, paddleSize)

  playerPosition = Vector2(paddlePadding,  halfScreenHeight - halfPaddleHeight)
  playerRectangle = Rect2(playerPosition, paddleSize)
  ballPosition = startingBallPosition

func change_string(newStringValue) -> void:
  stringValue = newStringValue
  halfWidthFont = font.get_string_size(stringValue).x/2.0
  stringPosition = Vector2(halfScreenWidth - halfWidthFont, heightFont)
  update() 
