atom = {}

atom.name = "wobbler"
atom.author = "default package"
atom.description = "one pole wobbler"

function atom.init()
	atom.power = 0.9
	atom.lastSample = 0
	atom.i = 0
end

function atom.main( inBuf )
	local outBuf = {}

	outBuf[1] = atom.power * atom.lastSample + ( 1 - atom.power ) * inBuf[1]
	for i = 2, system.bufferSize do
		--[[ wobble! ]] atom.power = math.abs( math.sin( 2 * math.pi * 5 * atom.i / system.sampleRate ) ) * 0.1 + 0.9
		outBuf[i] = atom.power * outBuf[i-1] + ( 1 - atom.power ) * inBuf[i]
		atom.i = atom.i + 1
	end

	atom.lastSample = outBuf[system.bufferSize]

	return outBuf
end
