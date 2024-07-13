local var0_0 = class("ActivityLinerOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = getProxy(ActivityProxy)
	local var3_1 = var2_1:getActivityById(var0_1.activity_id)

	if not var3_1 or var3_1:isEnd() then
		return
	end

	local var4_1 = var0_1.drop

	if var4_1 then
		local var5_1 = getProxy(PlayerProxy):getData()

		if var4_1.type == DROP_TYPE_RESOURCE and var4_1.id == 1 and var5_1:GoldMax(var4_1.count) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

			return
		end

		if var4_1.type == DROP_TYPE_RESOURCE and var4_1.id == 2 and var5_1:OilMax(var4_1.count) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

			return
		end

		if var4_1.type == DROP_TYPE_ITEM then
			local var6_1 = Item.getConfigData(var4_1.id)

			if var6_1.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(var4_1.id) + var4_1.count > var6_1.max_num then
				pg.TipsMgr.GetInstance():ShowTips(i18n("expbook_max_tip_title"))

				return
			end
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd or 0,
		arg1 = var0_1.arg1 or 0,
		arg2 = var0_1.arg2 or 0,
		arg_list = {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}
			local var1_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			if var0_1.cmd == 1 then
				local var2_2 = var3_1:GetCurTime()

				switch(var2_2:GetType(), {
					[LinerTime.TYPE.TARGET] = function()
						return
					end,
					[LinerTime.TYPE.EXPLORE] = function()
						var3_1:AddExploredRoom(var0_1.arg1)
					end,
					[LinerTime.TYPE.EVENT] = function()
						var3_1:AddEvent(var0_1.arg1, var0_1.arg2)
					end,
					[LinerTime.TYPE.STORY] = function()
						return
					end
				})

				if var3_1:CheckTimeFinish() then
					var3_1:UpdateTimeIdx()
					var3_1:UpdateRoomIdx(true)
				end

				if var3_1:CheckRoomFinish() then
					var3_1:UpdateRoomIdx(false)
				end
			elseif var0_1.cmd == 2 then
				var3_1:AddTimeAwardFlag(var0_1.arg1)
			elseif var0_1.cmd == 3 then
				var3_1:AddRoomAwardFlag(var0_1.arg1)
			elseif var0_1.cmd == 4 then
				var3_1:AddEventAwardFlag(var0_1.arg1, var0_1.arg2)
			end

			var2_1:updateActivity(var3_1)

			if var1_1 then
				var1_1()
			end

			arg0_1:sendNotification(GAME.ACTIVITY_LINER_OP_DONE, {
				awards = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
