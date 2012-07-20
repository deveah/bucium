
atomlist = {}

function berror( context, string )
	print( "bucium: error @ " .. context .. ": " .. string )
end

function copytbl( src )
	local r = {}
	for k, v in pairs( src ) do
		if type( v ) ~= "table" then
			r[k] = v
		else
			r[k] = copy( v )
		end
	end

	return r
end

function levelPrint( level, string )
	for i = 1, level do
		io.write( "> " )
	end
	print( string )
end

function deepPrint( src, level )
	if level == nil then level = 0 end
	for k, v in pairs( src ) do
		if type( v ) ~= "table" then
			levelPrint( level, k .. " = " .. tostring( v ) )
		else
			deepPrint( src[k], level+1 )
		end
	end
end

function init()
	for i = 1, #args do
		local F = loadfile( args[i] )
		if not F then
			berror( "argument " .. args[i], "file error" )
			return false
		end

		F()
		-- check for duplicates
		for j = 1, #atomlist do
			if atomlist[j].name == atom.name then
				atom.name = atom.name .. "~"
			end
		end

		atom.init()
		atomlist[#atomlist+1] = copytbl( atom )
		atom = atomlist[#atomlist]
		print( "initializing '" .. atom.name .. "'" )

		atom = nil
		F = nil
	end

	return true
end

function main()
	local r = {}

	for i = 1, #atomlist do
		atom = atomlist[i]
		r = atomlist[i].main( r )
	end

	return r
end
