
-- resonant low pass filter, taken from musicdsp.org
-- original author: madbrain[AT]videotron[DOT]ca

atom = {}

atom.name = "lpreso"
atom.author = "default package"
atom.description = "resonant low pass filter"

function atom.init()
	atom.lastSample = 0
	atom.cutoff = 80
	atom.resonance = 10

	atom.c = math.pow( 0.5, (128-atom.cutoff)/16 )
	atom.r = math.pow( 0.5, atom.resonance / 16 )
	atom.v0 = 0
	atom.v1 = 1
end

function atom.main( inBuf )
	local outBuf = {}

	for i = 1, system.bufferSize do
		atom.v0 = (1-atom.r*atom.c)*atom.v0 - atom.c*atom.v1 + atom.c*inBuf[i]
		atom.v1 = (1-atom.r*atom.c)*atom.v1 + atom.c*atom.v0
		outBuf[i] = atom.v0
	end

	return outBuf
end
