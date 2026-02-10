extends Node

var SERVER_IP = "127.0.0.1"
var SERVER_PORT = 8000
var http_client: HTTPClient
enum Status{
	IDLE,
	SEARCH_WORD,
	GET_LINE_OGG
}
var word: String = ""
var line_id: int = 0
var requested = false
var current_status: Status = Status.IDLE

signal request_completed(result)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	http_client = HTTPClient.new()
	var err = http_client.connect_to_host(SERVER_IP, SERVER_PORT)
	if err != OK:
		print("连接失败: ", err)
		return
	print("开始连接...")

func _process(_delta: float) -> void:
	http_client.poll()
	match http_client.get_status():
		HTTPClient.STATUS_CONNECTED:
			if requested:
				return
			var error
			match current_status:
				Status.SEARCH_WORD:
					error = http_client.request(HTTPClient.METHOD_GET, "/search/"+word, [])
					
				Status.GET_LINE_OGG:
					error = http_client.request(HTTPClient.METHOD_GET, "/get_line_ogg/"+str(line_id), [])
				_:
					error = OK
			if error != OK:
				push_error("出错：", error)
			requested = true
					
		HTTPClient.STATUS_BODY:
			if not http_client.has_response():
				push_error("empty response")
				return
			var code = http_client.get_response_code()
			if code != 200:
				push_error("request_failed: code="+code)
				return
			var chunk = http_client.read_response_body_chunk()
			var result
			match current_status:
				Status.SEARCH_WORD:
					result = JSON.parse_string(chunk.get_string_from_utf8())
				Status.GET_LINE_OGG:
					result = AudioStreamOggVorbis.load_from_buffer(chunk)
			emit_signal("request_completed", result)
			current_status = Status.IDLE

func search_word(new_word: String):
	while current_status != Status.IDLE:
		await create_tween().tween_interval(0.1).finished
	word = new_word
	current_status = Status.SEARCH_WORD
	requested = false

func get_line_ogg(new_line_id: int):
	while current_status != Status.IDLE:
		await create_tween().tween_interval(0.1).finished
	line_id = new_line_id
	current_status = Status.GET_LINE_OGG
	requested = false
	
