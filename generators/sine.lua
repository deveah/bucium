atom = {}

atom.name = "sine"
atom.author = "default package"
atom.description = "sine wave generator"

function atom.init()
	atom.i = 0
end

function atom.main( inBuf )
	local outBuf = {}

	for i = 1, system.bufferSize do
		outBuf[i] = math.sin( 2 * math.pi * system.freq * atom.i / system.sampleRate )
		atom.i = atom.i + 1
	end

	return outBuf
end
