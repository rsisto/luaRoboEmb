local properties={}

--guarda una tabla en un archivo de properties
--sirve para tablas con valores y claves de cadenas de caracteres.
function properties.savePropertyFile (filename , tabla)
	local f = assert(io.open(filename,"w"))
	for k, v in pairs(tabla) do
		f:write(k .. "=" .. v .. "\n")
	end	
	f:close()
end

--Cargar properties de un archivo
function 	properties.loadPropertyFile( filename )
	local props = {}
	local f = io.open(filename,"r")
	
	--Si se encuentra el archivo se retorna. Si no devuelvo la tabla vacía.
	if f ~= nil then
		local lines = {}	
			for line in f:lines() do
				for k, v in string.gmatch(line, "(%w+)=(.*)") do
					props[k]=v
				end	
		end
		f:close()
	end
	return props
end

--ejemplo de uso :
--local tabla
--tabla = loadPropertyFile("arch.txt")
--tabla["dos"] = "numerodos"
--savePropertyFile("arch3.txt",tabla)

return properties
