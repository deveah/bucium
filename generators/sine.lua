atom = {}

atom.name = "sine"
atom.author = "default package"
atom.description = "sine wave generator"

function atom.init()
	self.frame = 0
end

function atom.main( inBuf )
	local outBuf = {}

	for i = 1, system.bufferSize do
		outBuf[i] = math.sin( 2 * math.pi * system.freq * self.frame / system.sampleRate )
		self.frame = self.frame + 1
	end

	return outBuf
end
