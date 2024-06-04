local var0 = class("ActivityLinerOPCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.callback
	local var2 = getProxy(ActivityProxy)
	local var3 = var2:getActivityById(var0.activity_id)

	if not var3 or var3:isEnd() then
		return
	end

	local var4 = var0.drop

	if var4 then
		local var5 = getProxy(PlayerProxy):getData()

		if var4.type == DROP_TYPE_RESOURCE and var4.id == 1 and var5:GoldMax(var4.count) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

			return
		end

		if var4.type == DROP_TYPE_RESOURCE and var4.id == 2 and var5:OilMax(var4.count) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

			return
		end

		if var4.type == DROP_TYPE_ITEM then
			local var6 = Item.getConfigData(var4.id)

			if var6.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(var4.id) + var4.count > var6.max_num then
				pg.TipsMgr.GetInstance():ShowTips(i18n("expbook_max_tip_title"))

				return
			end
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0.activity_id,
		cmd = var0.cmd or 0,
		arg1 = var0.arg1 or 0,
		arg2 = var0.arg2 or 0,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = {}
			local var1 = PlayerConst.addTranDrop(arg0.award_list)

			if var0.cmd == 1 then
				local var2 = var3:GetCurTime()

				switch(var2:GetType(), {
					[LinerTime.TYPE.TARGET] = function()
						return
					end,
					[LinerTime.TYPE.EXPLORE] = function()
						var3:AddExploredRoom(var0.arg1)
					end,
					[LinerTime.TYPE.EVENT] = function()
						var3:AddEvent(var0.arg1, var0.arg2)
					end,
					[LinerTime.TYPE.STORY] = function()
						return
					end
				})

				if var3:CheckTimeFinish() then
					var3:UpdateTimeIdx()
					var3:UpdateRoomIdx(true)
				end

				if var3:CheckRoomFinish() then
					var3:UpdateRoomIdx(false)
				end
			elseif var0.cmd == 2 then
				var3:AddTimeAwardFlag(var0.arg1)
			elseif var0.cmd == 3 then
				var3:AddRoomAwardFlag(var0.arg1)
			elseif var0.cmd == 4 then
				var3:AddEventAwardFlag(var0.arg1, var0.arg2)
			end

			var2:updateActivity(var3)

			if var1 then
				var1()
			end

			arg0:sendNotification(GAME.ACTIVITY_LINER_OP_DONE, {
				awards = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
