local var0_0 = class("UpdateCustomFleetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().chapterId
	local var1_1 = getProxy(BayProxy):getRawData()
	local var2_1 = getProxy(ChapterProxy):getChapterById(var0_1)
	local var3_1 = var2_1:getConfig("formation")
	local var4_1 = var2_1:getEliteFleetList()
	local var5_1 = var2_1:getEliteFleetCommanders()
	local var6_1 = {}

	for iter0_1, iter1_1 in ipairs(var4_1) do
		local var7_1 = {}
		local var8_1 = {}
		local var9_1 = {}

		for iter2_1, iter3_1 in ipairs(iter1_1) do
			var8_1[#var8_1 + 1] = iter3_1
		end

		local var10_1 = var5_1[iter0_1]

		for iter4_1, iter5_1 in pairs(var10_1) do
			table.insert(var9_1, {
				pos = iter4_1,
				id = iter5_1
			})
		end

		var7_1.map_id = var3_1
		var7_1.main_id = var8_1
		var7_1.commanders = var9_1
		var6_1[#var6_1 + 1] = var7_1
	end

	local var11_1 = var2_1:getSupportFleet()
	local var12_1 = var2_1:getConfig("map")
	local var13_1 = {}
	local var14_1 = {}

	for iter6_1, iter7_1 in ipairs(var11_1) do
		var14_1[#var14_1 + 1] = iter7_1
	end

	var13_1.map_id = var12_1
	var13_1.main_id = var14_1
	var13_1.commanders = {}
	var6_1[#var6_1 + 1] = var13_1

	pg.ConnectionMgr.GetInstance():Send(13107, {
		id = var3_1,
		elite_fleet_list = var6_1
	}, 13108, function(arg0_2)
		if arg0_2.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("update_custom_fleet", arg0_2.result))
		end
	end)
end

return var0_0
