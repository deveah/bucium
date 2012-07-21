
atom = {}

atom.name = "2opfm"
atom.author = "default package"
atom.description = "simple 2-op fm synth"

function atom.init()
	atom.i = 0
	atom.b = 1		--modulation index
	atom.m = 2		--modulator frequency factor
end

function atom.sgn( n )
	if n > 0 then return 1 else return -1 end
end

function atom.main( inBuf )
	local outBuf = {}

	local f = system.freq / 4

	for i = 1, system.bufferSize do
		local mod = math.sin( 2 * math.pi * f * atom.m * atom.i / system.sampleRate ) * atom.b
		outBuf[i] = atom.sgn( math.sin( 2 * math.pi * ( f * atom.i / system.sampleRate + mod ) ) )
		atom.i = atom.i + 1
	end

	return outBuf
end
