local var0 = class("MiniGameDataCreator")

var0.ShrineGameID = 3
var0.FireWorkGameID = 4
var0.TowerClimbingGameID = 13
var0.NewYearShrineGameID = 20

function var0.DataCreateFunc(arg0, arg1, arg2, arg3)
	if arg0 == MiniGameOPCommand.CMD_SPECIAL_GAME then
		local var0 = arg1[1]
		local var1 = arg1[2]
		local var2 = getProxy(MiniGameProxy):GetMiniGameData(var0)
		local var3 = {}

		if var2:getConfig("type") == MiniGameConst.MG_TYPE_3 then
			if var1 == 1 then
				var3.count = arg2[1]
				var3.serverGold = arg2[2]
				var3.isInited = true
			elseif var1 == 2 then
				var3.count = var2:GetRuntimeData("count") - 1
				var3.serverGold = arg2[1]
			elseif var1 == 3 then
				var3.serverGold = arg2[1]
			end
		elseif var2:getConfig("type") == MiniGameConst.MG_TYPE_5 then
			if var1 == 1 then
				var3.count = arg2[1]
				var3.isInited = true
			elseif var1 == 2 then
				var3.count = var2:GetRuntimeData("count") - 1

				local var4 = arg1[4]
				local var5 = arg1[5]
				local var6 = var2:GetRuntimeData("kvpElements")
				local var7 = var6[1]

				table.insert(var7, {
					key = var4,
					value = var5
				})
				var2:SetRuntimeData("kvpElements", var6)
			end
		elseif var0 == var0.TowerClimbingGameID and var1 == 1 then
			var3.isInited = true
		end

		local var8 = var2:getConfig("type")

		if var8 == MiniGameConst.MG_TYPE_2 and var1 == 1 or var8 == MiniGameConst.MG_TYPE_5 and var1 == 1 or var8 == MiniGameConst.MG_TYPE_4 then
			local var9 = {}

			for iter0 = 1, #arg2 do
				var9[iter0] = arg2[iter0]
			end

			local var10 = {}

			for iter1, iter2 in ipairs(arg3) do
				local var11 = {}

				for iter3, iter4 in ipairs(iter2.value_list) do
					table.insert(var11, {
						key = iter4.key,
						value = iter4.value,
						value2 = iter4.value2
					})
				end

				var10[iter2.key] = var11
			end

			var3.elements = var9
			var3.kvpElements = var10
		end

		for iter5, iter6 in pairs(var3) do
			var2:SetRuntimeData(iter5, iter6)
		end
	end
end

return var0
