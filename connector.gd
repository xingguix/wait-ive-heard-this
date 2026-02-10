extends Node

var SERVER_IP = "120.48.7.161"
var SERVER_PORT = 8000
var http_client: HTTPClient = null

enum Status {
	IDLE,
	SEARCH_WORD,
	GET_LINE_OGG
}

var word: String = ""
var line_id: int = 0
var current_status: Status = Status.IDLE
var body_buffer := PackedByteArray()

signal request_completed(result)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # 延迟在请求时再创建 HTTPClient

func _process(_delta: float) -> void:
	if http_client == null:
		return

	http_client.poll()

	match http_client.get_status():
		HTTPClient.STATUS_CONNECTED:
			var error
			match current_status:
				Status.SEARCH_WORD:
					error = http_client.request(HTTPClient.METHOD_GET, "/search/" + word, [])
				Status.GET_LINE_OGG:
					error = http_client.request(HTTPClient.METHOD_GET, "/get_line_ogg/" + str(line_id), [])
				_:
					error = OK
			if error != OK:
				push_error("请求发送失败: " + str(error))
				_reset_client()
				
		HTTPClient.STATUS_BODY:
			if not http_client.has_response():
				push_error("empty response")
				_reset_client()
				return

			var code = http_client.get_response_code()
			if code != 200:
				push_error("请求失败: code=" + str(code))
				_reset_client()
				return

			var chunk = http_client.read_response_body_chunk()
			if chunk.size() > 0:
				body_buffer.append_array(chunk)

			var total_len = http_client.get_response_body_length()
			if total_len != -1 and body_buffer.size() < total_len:
				return

			# 数据收完整了
			var result
			match current_status:
				Status.SEARCH_WORD:
					result = JSON.parse_string(body_buffer.get_string_from_utf8())
				Status.GET_LINE_OGG:
					result = AudioStreamOggVorbis.load_from_buffer(body_buffer)

			emit_signal("request_completed", result)
			_reset_client()

# 新建一个 HTTPClient 并连接
func _create_client():
	http_client = HTTPClient.new()
	var err = http_client.connect_to_host(SERVER_IP, SERVER_PORT)
	if err != OK:
		push_error("连接失败: " + str(err))
		http_client = null
		return false
	body_buffer.clear()
	return true

func _reset_client():
	current_status = Status.IDLE
	body_buffer.clear()
	if http_client:
		http_client.close()
		http_client = null

# 公共请求接口
func search_word(new_word: String):
	await _wait_idle()
	word = new_word
	current_status = Status.SEARCH_WORD
	_create_client()

func get_line_ogg(new_line_id: int):
	await _wait_idle()
	line_id = new_line_id
	current_status = Status.GET_LINE_OGG
	_create_client()

# 等待上一个请求完成
func _wait_idle() -> void:
	while current_status != Status.IDLE:
		await create_tween().tween_interval(0.05).finished
