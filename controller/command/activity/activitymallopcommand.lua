local var0_0 = class("ActivityMallOPCommand", pm.SimpleCommand)

var0_0.CMD = {
	INPUT_GOLD = 4,
	COMPLETE_ORDER = 2,
	TRIGGER_POINT = 6,
	SET_FLOOR_STAFF = 7,
	START_ORDER = 1,
	SETTLE_ROUND = 3,
	GET_STAFF_DATA = 8
}

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = getProxy(ActivityProxy)
	local var3_1 = var0_1.activity_id
	local var4_1 = var2_1:getActivityById(var3_1)

	if not var4_1 or var4_1:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd or 0,
		arg1 = var0_1.arg1 or 0,
		arg2 = var0_1.arg2 or 0,
		arg_list = var0_1.arg_list or {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var2_1:getActivityById(var3_1)
			local var1_2 = var0_2:GetLevelData().level
			local var2_2 = var1_2

			switch(var0_1.cmd, {
				[var0_0.CMD.START_ORDER] = function()
					var0_2:OnStartOrderDone(var0_1.arg1, arg0_2.number[1], var0_1.arg_list)

					for iter0_3, iter1_3 in ipairs(MallOrder.GetCost(var0_1.arg1)) do
						reducePlayerOwn(iter1_3)
					end
				end,
				[var0_0.CMD.COMPLETE_ORDER] = function()
					var2_2 = arg0_2.number[1]

					var0_2:OnCompleteOrderDone(var0_1.arg1)
				end,
				[var0_0.CMD.SETTLE_ROUND] = function()
					var2_2 = arg0_2.number[1]

					var0_2:NextRound(arg0_2.number)
				end,
				[var0_0.CMD.INPUT_GOLD] = function()
					var0_2:ReduceGold(var0_1.arg1)
					pg.TipsMgr.GetInstance():ShowTips(i18n("mall_gold_input_success_tip"))
				end,
				[var0_0.CMD.TRIGGER_POINT] = function()
					var0_2:OnTriggerPointDone(var0_1.arg1)
				end,
				[var0_0.CMD.SET_FLOOR_STAFF] = function()
					var0_2:OnUpdateFloorStaffDone(var0_1.arg_list)
				end,
				[var0_0.CMD.GET_STAFF_DATA] = function()
					assert(#arg0_2.number % 2 == 0, "staff attr data must be even")
					var0_2:SetStaffExtraData(var0_1.arg1, arg0_2.number)
				end
			})

			if var2_2 ~= var1_2 then
				var0_2:OnUpgradeDone(var2_2)
			end

			var2_1:updateActivity(var0_2)

			local var3_2 = {}
			local var4_2 = PlayerConst.addTranDrop(arg0_2.award_list)

			arg0_1:sendNotification(GAME.ACTIVITY_MALL_OP_DONE, {
				cmd = var0_1.cmd,
				awards = var4_2,
				levels = {
					var1_2,
					var2_2
				},
				completeOrderId = var0_1.cmd == var0_0.CMD.COMPLETE_ORDER and var0_1.arg1 or 0
			})
			existCall(var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
