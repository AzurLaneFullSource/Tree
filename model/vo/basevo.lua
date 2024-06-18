local var0_0 = class("BaseVO")

function var0_0.Ctor(arg0_1, arg1_1)
	for iter0_1, iter1_1 in pairs(arg1_1) do
		arg0_1[iter0_1] = iter1_1
	end
end

function var0_0.display(arg0_2, arg1_2, arg2_2)
	if arg1_2 == "loaded" or not arg2_2 then
		return
	end

	local var0_2 = arg0_2.__cname .. " id: " .. tostring(arg0_2.id) .. " " .. (arg1_2 or ".")

	for iter0_2, iter1_2 in pairs(arg0_2) do
		if iter0_2 ~= "class" then
			local var1_2 = type(iter1_2)

			var0_2 = var0_2 .. "\n" .. iter0_2 .. ":" .. tostring(iter1_2)

			if var1_2 == "table" then
				var0_2 = var0_2 .. " ["

				for iter2_2, iter3_2 in pairs(iter1_2) do
					var0_2 = var0_2 .. tostring(iter3_2) .. ", "
				end

				var0_2 = var0_2 .. "]"
			end
		end
	end

	print(var0_2)
end

function var0_0.clone(arg0_3)
	return Clone(arg0_3)
end

function var0_0.bindConfigTable(arg0_4)
	return
end

function var0_0.GetConfigID(arg0_5)
	return arg0_5.configId
end

function var0_0.getConfigTable(arg0_6)
	local var0_6 = arg0_6:bindConfigTable()

	assert(var0_6, "should bindConfigTable() first: " .. arg0_6.__cname)

	return var0_6[arg0_6.configId]
end

function var0_0.getConfig(arg0_7, arg1_7)
	local var0_7 = arg0_7:getConfigTable()

	assert(var0_7 ~= nil, "Config missed, type -" .. arg0_7.__cname .. " configId: " .. tostring(arg0_7.configId))

	return var0_7[arg1_7]
end

return var0_0
