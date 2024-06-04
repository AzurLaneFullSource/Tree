local var0 = class("UpdateCustomFleetCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().chapterId
	local var1 = getProxy(BayProxy):getRawData()
	local var2 = getProxy(ChapterProxy):getChapterById(var0)
	local var3 = var2:getConfig("formation")
	local var4 = var2:getEliteFleetList()
	local var5 = var2:getEliteFleetCommanders()
	local var6 = {}

	for iter0, iter1 in ipairs(var4) do
		local var7 = {}
		local var8 = {}
		local var9 = {}

		for iter2, iter3 in ipairs(iter1) do
			var8[#var8 + 1] = iter3
		end

		local var10 = var5[iter0]

		for iter4, iter5 in pairs(var10) do
			table.insert(var9, {
				pos = iter4,
				id = iter5
			})
		end

		var7.map_id = var3
		var7.main_id = var8
		var7.commanders = var9
		var6[#var6 + 1] = var7
	end

	local var11 = var2:getSupportFleet()
	local var12 = var2:getConfig("map")
	local var13 = {}
	local var14 = {}

	for iter6, iter7 in ipairs(var11) do
		var14[#var14 + 1] = iter7
	end

	var13.map_id = var12
	var13.main_id = var14
	var13.commanders = {}
	var6[#var6 + 1] = var13

	pg.ConnectionMgr.GetInstance():Send(13107, {
		id = var3,
		elite_fleet_list = var6
	}, 13108, function(arg0)
		if arg0.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("update_custom_fleet", arg0.result))
		end
	end)
end

return var0
