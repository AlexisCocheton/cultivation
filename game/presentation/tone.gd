extends RefCounted

static func play(player: AudioStreamPlayer, frequency: float) -> void:
	var bytes = PackedByteArray()
	var count = 6600
	bytes.resize(count*2)
	for i in range(count):
		var t = i/22050.0
		var value = sin(TAU*frequency*t)*exp(-t*18)*0.45 + sin(TAU*frequency*2.01*t)*exp(-t*30)*0.12
		bytes.encode_s16(i*2,int(value*32767))
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	stream.data = bytes
	player.stream = stream
	player.play()

