local var0_0 = class("StartTechnologyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.pool_id
	local var3_1 = getProxy(TechnologyProxy)
	local var4_1 = var3_1:getTechnologyById(var1_1)

	if not var4_1 then
		return
	end

	if tobool(var3_1:getActivateTechnology()) then
		return
	end

	local var5_1, var6_1 = var4_1:hasResToStart()

	if not var5_1 then
		pg.TipsMgr.GetInstance():ShowTips(var6_1)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(63001, {
		tech_id = var1_1,
		refresh_id = var2_1
	}, 63002, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var4_1:getConfig("consume")

			for iter0_2, iter1_2 in ipairs(var0_2) do
				arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.Create(iter1_2))
			end

			var4_1:start(arg0_2.time)
			var3_1:updateTechnology(var4_1)
			arg0_1:sendNotification(GAME.START_TECHNOLOGY_DONE, {
				technologyId = var4_1.id
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_start_up"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_start_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
