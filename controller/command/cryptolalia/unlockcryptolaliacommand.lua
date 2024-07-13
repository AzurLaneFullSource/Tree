local var0_0 = class("UnlockCryptolaliaCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.costType
	local var3_1 = getProxy(PlayerProxy):getRawData()
	local var4_1 = var3_1:GetCryptolaliaList()
	local var5_1

	for iter0_1, iter1_1 in ipairs(var4_1) do
		if iter1_1.id == var1_1 then
			var5_1 = iter1_1

			break
		end
	end

	if not var5_1 or not var5_1:IsLock() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if not var5_1:InTime() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var6_1 = var5_1:GetCost(var2_1)

	if var3_1:getResById(var6_1.id) < var6_1.count then
		if var2_1 == Cryptolalia.COST_TYPE_TICKET then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_no_ticket"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(16205, {
		id = var1_1,
		cost_type = var2_1
	}, 16206, function(arg0_2)
		if arg0_2.ret == 0 then
			var3_1:UnlockCryptolalia(var1_1)
			var3_1:consume({
				[id2res(var6_1.id)] = var6_1.count
			})
			getProxy(PlayerProxy):updatePlayer(var3_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_exchange_success"))
			arg0_1:sendNotification(GAME.UNLOCK_CRYPTOLALIA_DONE, {
				id = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.ret] .. arg0_2.ret)
		end
	end)
end

return var0_0
