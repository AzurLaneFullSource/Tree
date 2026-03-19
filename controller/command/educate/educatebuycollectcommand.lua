local var0_0 = class("EducateBuyCollectCommand", pm.SimpleCommand)

var0_0.TYPE = {
	ENDING = 1,
	POLAROID = 3,
	MEMORY = 2
}

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.id
	local var3_1 = var0_1.cost
	local var4_1 = getProxy(PlayerProxy)
	local var5_1 = var4_1:getData()

	if var3_1 > var5_1.gold then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	local var6_1 = getProxy(EducateProxy)

	if var1_1 == var0_0.TYPE.ENDING and table.contains(var6_1:GetAllEndings(), var2_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

		return
	end

	if var1_1 == var0_0.TYPE.MEMORY and table.contains(var6_1:GetMemories(), var2_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

		return
	end

	if var1_1 == var0_0.TYPE.POLAROID and table.contains(var6_1:GetPolaroidList(), var2_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_already owned"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(27049, {
		type = var1_1,
		ids = var2_1
	}, 27050, function(arg0_2)
		if arg0_2.result == 0 then
			var5_1:consume({
				gold = var3_1
			})
			var4_1:updatePlayer(var5_1)
			switch(var1_1, {
				[var0_0.TYPE.ENDING] = function()
					var6_1:AddEndingFromBuy(var2_1)
					var6_1:AddEndingBuyCnt()
				end,
				[var0_0.TYPE.MEMORY] = function()
					var6_1:AddMemory(var2_1)
					var6_1:AddMemoryBuyCnt()
				end,
				[var0_0.TYPE.POLAROID] = function()
					local var0_5 = pg.child_polaroid[var2_1].group
					local var1_5 = pg.child_polaroid.get_id_list_by_group[var0_5]

					for iter0_5, iter1_5 in ipairs(var1_5) do
						var6_1:AddPolaroid(iter1_5)
					end

					var6_1:AddPolaroidBuyCnt()
				end
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("child_buy_collect_success"))
			arg0_1:sendNotification(GAME.EDUCATE_BUY_COLLECT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate buy collect error: ", arg0_2.result))
		end
	end)
end

return var0_0
