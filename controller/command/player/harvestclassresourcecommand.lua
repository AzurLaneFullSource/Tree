local var0_0 = class("HarvestClassResourceCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(NavalAcademyProxy):GetClassVO()
	local var2_1 = var1_1:GetCanGetResCnt()

	if var2_1 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(22009, {
		type = 0
	}, 22010, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var1_1:GetTarget()
			local var1_2 = var1_1:GetResourceType()
			local var2_2 = Drop.New({
				type = DROP_TYPE_ITEM,
				id = var1_2,
				count = var2_1
			})

			arg0_1:sendNotification(GAME.ADD_ITEM, var2_2)

			local var3_2 = var2_1 * var0_2
			local var4_2 = getProxy(PlayerProxy):getData()

			var4_2:consume({
				[id2res(PlayerConst.ResClassField)] = var3_2
			})
			getProxy(PlayerProxy):updatePlayer(var4_2)

			local var5_2 = var2_2:getConfig("name")

			pg.TipsMgr.GetInstance():ShowTips(i18n("commission_get_award", var5_2, var2_1))
			getProxy(NavalAcademyProxy):getCourse():SetProficiency(arg0_2.exp_in_well)
			arg0_1:sendNotification(GAME.HARVEST_CLASS_RES_DONE, {
				award = var2_2,
				value = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
