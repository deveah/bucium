atom = {}

atom.name = "noise"
atom.author = "default package"
atom.description = "white noise generator"

function atom.init()
	-- needs no initialization
end

function atom.main( inBuf )
	local outBuf = {}

	for i = 1, system.bufferSize do
		outBuf[i] = 2 * math.random() - 1
	end

	return outBuf
end
