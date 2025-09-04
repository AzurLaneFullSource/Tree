local var0_0 = class("AgoraMap")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.map = arg0_1:GenMap(arg1_1)
end

function var0_0.GenMap(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = AgoraCalc.GetArea(Vector2.zero, arg1_2)

	for iter0_2, iter1_2 in ipairs(var1_2) do
		local var2_2 = iter1_2.x
		local var3_2 = iter1_2.y

		if not var0_2[var2_2] then
			var0_2[var2_2] = {}
		end

		var0_2[var2_2][var3_2] = true
	end

	return var0_2
end

function var0_0.UpdateSize(arg0_3, arg1_3)
	local var0_3 = arg0_3:GenMap(arg1_3)
	local var1_3 = arg0_3.map

	for iter0_3, iter1_3 in pairs(var0_3) do
		for iter2_3, iter3_3 in pairs(iter1_3) do
			if var1_3[iter0_3] ~= nil and var1_3[iter0_3][iter2_3] ~= nil then
				var0_3[iter0_3][iter2_3] = var1_3[iter0_3][iter2_3]
			end
		end
	end

	arg0_3.map = var0_3
end

function var0_0.UpdateMapState(arg0_4, arg1_4, arg2_4, arg3_4)
	assert(arg0_4.map[arg1_4], " position x is illegal " .. arg1_4)

	arg0_4.map[arg1_4][arg2_4] = arg3_4
end

function var0_0.GetMapState(arg0_5, arg1_5, arg2_5)
	return arg0_5.map[arg1_5][arg2_5]
end

function var0_0.IsEmptyPoint(arg0_6, arg1_6)
	return arg0_6.map[arg1_6.x] and arg0_6.map[arg1_6.x][arg1_6.y] == true
end

return var0_0
