local var0 = class("UnlockCryptolaliaCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.costType
	local var3 = getProxy(PlayerProxy):getRawData()
	local var4 = var3:GetCryptolaliaList()
	local var5

	for iter0, iter1 in ipairs(var4) do
		if iter1.id == var1 then
			var5 = iter1

			break
		end
	end

	if not var5 or not var5:IsLock() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if not var5:InTime() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	local var6 = var5:GetCost(var2)

	if var3:getResById(var6.id) < var6.count then
		if var2 == Cryptolalia.COST_TYPE_TICKET then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_no_ticket"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(16205, {
		id = var1,
		cost_type = var2
	}, 16206, function(arg0)
		if arg0.ret == 0 then
			var3:UnlockCryptolalia(var1)
			var3:consume({
				[id2res(var6.id)] = var6.count
			})
			getProxy(PlayerProxy):updatePlayer(var3)
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_exchange_success"))
			arg0:sendNotification(GAME.UNLOCK_CRYPTOLALIA_DONE, {
				id = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.ret] .. arg0.ret)
		end
	end)
end

return var0
