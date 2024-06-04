local var0 = class("StartTechnologyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.pool_id
	local var3 = getProxy(TechnologyProxy)
	local var4 = var3:getTechnologyById(var1)

	if not var4 then
		return
	end

	if tobool(var3:getActivateTechnology()) then
		return
	end

	local var5, var6 = var4:hasResToStart()

	if not var5 then
		pg.TipsMgr.GetInstance():ShowTips(var6)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(63001, {
		tech_id = var1,
		refresh_id = var2
	}, 63002, function(arg0)
		if arg0.result == 0 then
			local var0 = var4:getConfig("consume")

			for iter0, iter1 in ipairs(var0) do
				arg0:sendNotification(GAME.CONSUME_ITEM, Drop.Create(iter1))
			end

			var4:start(arg0.time)
			var3:updateTechnology(var4)
			arg0:sendNotification(GAME.START_TECHNOLOGY_DONE, {
				technologyId = var4.id
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_start_up"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_start_erro") .. arg0.result)
		end
	end)
end

return var0
