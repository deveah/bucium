atom = {}

atom.name = "square"
atom.author = "default package"
atom.description = "square wave generator"

function atom.init()
	atom.i = 0
end

function atom.main( inBuf )
	local outBuf = {}
	local w = system.sampleRate / system.freq

	for i = 1, system.bufferSize do
		if atom.i % w > w/2 then
			outBuf[i] = -0.5
		else
			outBuf[i] = 0.5
		end

		atom.i = atom.i + 1
	end

	return outBuf
end
