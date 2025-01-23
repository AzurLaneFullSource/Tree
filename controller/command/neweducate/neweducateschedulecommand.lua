local var0_0 = class("NewEducateScheduleCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.planKVs
	local var3_1 = var0_1.isSkip

	pg.ConnectionMgr.GetInstance():Send(29040, {
		id = var1_1,
		plans = var2_1
	}, 29041, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar()
			local var1_2 = var0_2:GetFSM()

			var1_2:SetStystemNo(NewEducateFSM.STYSTEM.PLAN)

			local var2_2 = var1_2:GetState(NewEducateFSM.STYSTEM.PLAN)
			local var3_2 = arg0_2.plans or var2_1

			arg0_1:TrackPlan(var0_2, var2_1, var3_2)
			var2_2:SetPlans(var3_2)
			var2_2:SetResources(var0_2:GetResources())
			var2_2:SetAttrs(var0_2:GetAttrs())

			local var4_2 = getProxy(NewEducateProxy):GetCurChar():GetPlanDiscountInfos()

			for iter0_2, iter1_2 in ipairs(var2_1) do
				local var5_2 = NewEducatePlan.New(iter1_2.value):GetCostWithBenefit(var4_2)

				getProxy(NewEducateProxy):Costs(var5_2)
			end

			local var6_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var6_2)

			local function var7_2()
				if #var3_2 > 0 then
					if not var3_1 then
						arg0_1:sendNotification(GAME.NEW_EDUCATE_NEXT_PLAN, {
							id = var1_1
						})
					else
						arg0_1:sendNotification(GAME.NEW_EDUCATE_SCHEDULE_SKIP, {
							id = var1_1
						})
					end
				else
					arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_EXTRA_DROP, {
						id = var1_1,
						scheduleDrops = {}
					})
				end
			end

			arg0_1:sendNotification(GAME.NEW_EDUCATE_SCHEDULE_DONE, {
				drops = NewEducateHelper.FilterBenefit(var6_2),
				callback = var7_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_Schedule: ", arg0_2.result))
		end
	end)
end

function var0_0.TrackPlan(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = underscore.map(arg2_4, function(arg0_5)
		return arg0_5.value
	end)

	table.sort(arg3_4, CompareFuncs({
		function(arg0_6)
			return arg0_6.key
		end
	}))

	local var1_4 = underscore.map(arg3_4, function(arg0_7)
		return arg0_7.value
	end)

	pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataPlan(arg1_4.id, arg1_4:GetGameCnt(), arg1_4:GetRoundData().round, table.concat(var0_4, ","), table.concat(var1_4, ",")))
end

return var0_0
