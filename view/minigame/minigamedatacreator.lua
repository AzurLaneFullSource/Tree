local var0_0 = class("MiniGameDataCreator")

var0_0.ShrineGameID = 3
var0_0.FireWorkGameID = 4
var0_0.TowerClimbingGameID = 13
var0_0.NewYearShrineGameID = 20

function var0_0.DataCreateFunc(arg0_1, arg1_1, arg2_1, arg3_1)
	if arg0_1 == MiniGameOPCommand.CMD_SPECIAL_GAME then
		local var0_1 = arg1_1[1]
		local var1_1 = arg1_1[2]
		local var2_1 = getProxy(MiniGameProxy):GetMiniGameData(var0_1)
		local var3_1 = {}

		if var2_1:getConfig("type") == MiniGameConst.MG_TYPE_3 then
			if var1_1 == 1 then
				var3_1.count = arg2_1[1]
				var3_1.serverGold = arg2_1[2]
				var3_1.isInited = true
			elseif var1_1 == 2 then
				var3_1.count = var2_1:GetRuntimeData("count") - 1
				var3_1.serverGold = arg2_1[1]
			elseif var1_1 == 3 then
				var3_1.serverGold = arg2_1[1]
			end
		elseif var2_1:getConfig("type") == MiniGameConst.MG_TYPE_5 then
			if var1_1 == 1 then
				var3_1.count = arg2_1[1]
				var3_1.isInited = true
			elseif var1_1 == 2 then
				var3_1.count = var2_1:GetRuntimeData("count") - 1

				local var4_1 = arg1_1[4]
				local var5_1 = arg1_1[5]
				local var6_1 = var2_1:GetRuntimeData("kvpElements")
				local var7_1 = var6_1[1]

				table.insert(var7_1, {
					key = var4_1,
					value = var5_1
				})
				var2_1:SetRuntimeData("kvpElements", var6_1)
			end
		elseif var0_1 == var0_0.TowerClimbingGameID and var1_1 == 1 then
			var3_1.isInited = true
		end

		local var8_1 = var2_1:getConfig("type")

		if var8_1 == MiniGameConst.MG_TYPE_2 and var1_1 == 1 or var8_1 == MiniGameConst.MG_TYPE_5 and var1_1 == 1 or var8_1 == MiniGameConst.MG_TYPE_4 then
			local var9_1 = {}

			for iter0_1 = 1, #arg2_1 do
				var9_1[iter0_1] = arg2_1[iter0_1]
			end

			local var10_1 = {}

			for iter1_1, iter2_1 in ipairs(arg3_1) do
				local var11_1 = {}

				for iter3_1, iter4_1 in ipairs(iter2_1.value_list) do
					table.insert(var11_1, {
						key = iter4_1.key,
						value = iter4_1.value,
						value2 = iter4_1.value2
					})
				end

				var10_1[iter2_1.key] = var11_1
			end

			var3_1.elements = var9_1
			var3_1.kvpElements = var10_1
		end

		for iter5_1, iter6_1 in pairs(var3_1) do
			var2_1:SetRuntimeData(iter5_1, iter6_1)
		end
	end
end

return var0_0
