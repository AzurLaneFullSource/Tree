local var0_0 = class("ActivityTownOPCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = getProxy(ActivityProxy)
	local var3_1 = var2_1:getActivityById(var0_1.activity_id)

	if not var3_1 or var3_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd or 0,
		arg1 = var0_1.arg1 or 0,
		arg2 = var0_1.arg2 or 0,
		kvargs1 = var0_1.kvargs1
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}
			local var1_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			var3_1 = var2_1:getActivityById(var0_1.activity_id)

			switch(var0_1.cmd, {
				[TownActivity.OPERATION.UPGRADE_TOWN] = function()
					var3_1:OnUpgradeTown(arg0_2.number[1])
				end,
				[TownActivity.OPERATION.UPGRADE_PLACE] = function()
					var3_1:OnUpgradePlace(var0_1.arg1, arg0_2.number[1])
				end,
				[TownActivity.OPERATION.CHANGE_SHIPS] = function()
					var3_1:OnChangeShips(var0_1.kvargs1)
				end,
				[TownActivity.OPERATION.CLICK_BUBBLE] = function()
					var3_1:OnGetBubbleAward(var0_1.arg1, arg0_2.number[1])
				end,
				[TownActivity.OPERATION.SETTLE_GOLD] = function()
					var3_1:OnSettleGold(arg0_2.number[1])
				end
			})
			var2_1:updateActivity(var3_1)

			if var1_1 then
				var1_1()
			end

			arg0_1:sendNotification(GAME.ACTIVITY_TOWN_OP_DONE, {
				awards = var1_2,
				cmd = var0_1.cmd
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
