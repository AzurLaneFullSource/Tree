local var0_0 = class("NewEducateUpgradePlanCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.planIds

	pg.ConnectionMgr.GetInstance():Send(29044, {
		id = var1_1,
		plan_ids = var2_1
	}, 29045, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar()

			for iter0_2, iter1_2 in ipairs(var2_1) do
				local var1_2 = NewEducatePlan.New(iter1_2):GetNextId()

				var0_2:OnUpgradedPlan(var1_2)

				local var2_2 = NewEducatePlan.New(var1_2)

				while var2_2:GetNextId() and var0_2:IsMatchComplex(var2_2:getConfig("level_condition")) do
					local var3_2 = var2_2:GetNextId()

					var0_2:OnUpgradedPlan(var3_2)

					var2_2 = NewEducatePlan.New(var3_2)
				end
			end

			arg0_1:sendNotification(GAME.NEW_EDUCATE_UPGRADE_PLAN_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_UpgradePlan", arg0_2.result))
		end
	end)
end

return var0_0
