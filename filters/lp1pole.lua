atom = {}

atom.name = "lp1pole"
atom.author = "default package"
atom.description = "one pole low pass filter"

function atom.init()
	atom.power = 0.99
	atom.lastSample = 0
end

function atom.main( inBuf )
	local outBuf = {}

	outBuf[1] = atom.power * atom.lastSample + ( 1 - atom.power ) * inBuf[1]
	for i = 2, system.bufferSize do
		outBuf[i] = atom.power * outBuf[i-1] + ( 1 - atom.power ) * inBuf[i]
	end

	atom.lastSample = outBuf[system.bufferSize]

	return outBuf
end
