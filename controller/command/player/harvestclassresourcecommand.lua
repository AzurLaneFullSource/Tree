local var0 = class("HarvestClassResourceCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(NavalAcademyProxy):GetClassVO()
	local var2 = var1:GetCanGetResCnt()

	if var2 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(22009, {
		type = 0
	}, 22010, function(arg0)
		if arg0.result == 0 then
			local var0 = var1:GetTarget()
			local var1 = var1:GetResourceType()
			local var2 = Drop.New({
				type = DROP_TYPE_ITEM,
				id = var1,
				count = var2
			})

			arg0:sendNotification(GAME.ADD_ITEM, var2)

			local var3 = var2 * var0
			local var4 = getProxy(PlayerProxy):getData()

			var4:consume({
				[id2res(PlayerConst.ResClassField)] = var3
			})
			getProxy(PlayerProxy):updatePlayer(var4)

			local var5 = var2:getConfig("name")

			pg.TipsMgr.GetInstance():ShowTips(i18n("commission_get_award", var5, var2))
			getProxy(NavalAcademyProxy):getCourse():SetProficiency(arg0.exp_in_well)
			arg0:sendNotification(GAME.HARVEST_CLASS_RES_DONE, {
				award = var2,
				value = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
