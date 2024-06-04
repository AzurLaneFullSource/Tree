local var0 = class("BaseVO")

function var0.Ctor(arg0, arg1)
	for iter0, iter1 in pairs(arg1) do
		arg0[iter0] = iter1
	end
end

function var0.display(arg0, arg1, arg2)
	if arg1 == "loaded" or not arg2 then
		return
	end

	local var0 = arg0.__cname .. " id: " .. tostring(arg0.id) .. " " .. (arg1 or ".")

	for iter0, iter1 in pairs(arg0) do
		if iter0 ~= "class" then
			local var1 = type(iter1)

			var0 = var0 .. "\n" .. iter0 .. ":" .. tostring(iter1)

			if var1 == "table" then
				var0 = var0 .. " ["

				for iter2, iter3 in pairs(iter1) do
					var0 = var0 .. tostring(iter3) .. ", "
				end

				var0 = var0 .. "]"
			end
		end
	end

	print(var0)
end

function var0.clone(arg0)
	return Clone(arg0)
end

function var0.bindConfigTable(arg0)
	return
end

function var0.GetConfigID(arg0)
	return arg0.configId
end

function var0.getConfigTable(arg0)
	local var0 = arg0:bindConfigTable()

	assert(var0, "should bindConfigTable() first: " .. arg0.__cname)

	return var0[arg0.configId]
end

function var0.getConfig(arg0, arg1)
	local var0 = arg0:getConfigTable()

	assert(var0 ~= nil, "Config missed, type -" .. arg0.__cname .. " configId: " .. tostring(arg0.configId))

	return var0[arg1]
end

return var0
