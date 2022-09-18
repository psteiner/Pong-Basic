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
onready var ballPosition: Vector2 = Vector2(halfScreenWidth,halfScreenHeight)

# player paddle
onready var playerPosition: Vector2 = Vector2(paddlePadding, halfScreenHeight - halfPaddleHeight)
onready var player: Rect2 = Rect2(playerPosition, paddleSize)

# ai paddle
onready var opponentPosition: Vector2 = Vector2(
  screenWidth - (paddlePadding + paddleSize.x), 
  halfScreenHeight - halfPaddleHeight
)
onready var opponent: Rect2 = Rect2(opponentPosition, paddleSize)

# string variable
var stringPosition: Vector2

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
var stringValue: String = "Hello, World!"

func _ready() -> void:
  font.font_data = robotoFile
  font.size = fontSize
  halfWidthFont = font.get_string_size(stringValue).x/2.0
  heightFont = font.get_height()
  stringPosition = Vector2(halfScreenWidth - halfWidthFont, heightFont)
  
func _physics_process(delta: float) -> void:
  
  deltaKeyPress += delta
  
  match currentGameState:
    GAME_STATE.MENU:
      changeString("MENU!!!")
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
    GAME_STATE.SERVE:
      changeString("SERVE!!!")
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.PLAY
        deltaKeyPress = RESET_DELTA_KEY
    GAME_STATE.PLAY:
      changeString("PLAY!!!")
      if(Input.is_key_pressed(KEY_SPACE) and deltaKeyPress > MAX_KEY_TIME):
        currentGameState = GAME_STATE.SERVE
        deltaKeyPress = RESET_DELTA_KEY
  
func _draw() -> void:
  set_starting_position()

func set_starting_position() -> void:
  draw_circle(ballPosition, ballRadius, ballColor)
  draw_rect(player, paddleColor)
  draw_rect(opponent,paddleColor)
  draw_string(font, stringPosition, stringValue)

func changeString(newStringValue) -> void:
  stringValue = newStringValue
  halfWidthFont = font.get_string_size(stringValue).x/2.0
  stringPosition = Vector2(halfScreenWidth - halfWidthFont, heightFont)
  update() 
