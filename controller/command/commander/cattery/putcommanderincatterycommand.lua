local var0_0 = class("PutCommanderInCatteryCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.commanderId
	local var3_1 = var2_1 == 0
	local var4_1 = var0_1.callback
	local var5_1 = var0_1.tip
	local var6_1 = getProxy(CommanderProxy)

	if not var3_1 and not var6_1:getCommanderById(var2_1) then
		if var4_1 then
			var4_1()
		end

		return
	end

	local var7_1 = var6_1:GetCommanderHome()

	if not var7_1 then
		if var4_1 then
			var4_1()
		end

		return
	end

	local var8_1 = var7_1:GetCatteryById(var1_1)

	if not var8_1 or not var8_1:CanUse() then
		if var4_1 then
			var4_1()
		end

		return
	end

	if not var3_1 and var8_1:ExistCommander() and var8_1:GetCommanderId() == var2_1 then
		if var4_1 then
			var4_1()
		end

		return
	end

	if var3_1 and not var8_1:ExistCommander() then
		if var4_1 then
			var4_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25030, {
		slotidx = var1_1,
		commander_id = var2_1
	}, 25031, function(arg0_2)
		if arg0_2.result == 0 then
			if var3_1 then
				local var0_2 = var8_1:GetCommanderId()

				arg0_1:UpdateCommanderLevelAndExp(var0_2, arg0_2)
				var8_1:RemoveCommander()

				if var5_1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("cattery_remove_commander_success"))
				end
			else
				if var8_1:ExistCommander() then
					local var1_2 = var8_1:GetCommanderId()

					arg0_1:UpdateCommanderLevelAndExp(var1_2, arg0_2)
				end

				var8_1:AddCommander(var2_1, arg0_2.time)

				local var2_2 = var6_1:getCommanderById(var2_1)
				local var3_2 = var2_2:ExistCleanFlag()
				local var4_2 = var2_2:ExitFeedFlag()
				local var5_2 = var2_2:ExitPlayFlag()

				if var3_2 and var8_1:ExistCleanOP() then
					var8_1:ResetCleanOP()
				end

				if var4_2 and var8_1:ExiseFeedOP() then
					var8_1:ResetFeedOP()
				end

				if var5_2 and var8_1:ExistPlayOP() then
					var8_1:ResetPlayOP()
				end

				local var6_2 = {}

				if not var3_2 then
					table.insert(var6_2, i18n("common_clean"))
				end

				if not var4_2 then
					table.insert(var6_2, i18n("common_feed"))
				end

				if not var5_2 then
					table.insert(var6_2, i18n("common_play"))
				end

				if #var6_2 > 0 then
					local var7_2 = table.concat(var6_2, ", ")

					pg.TipsMgr.GetInstance():ShowTips(i18n("cat_home_interaction", var7_2))
				elseif var5_1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("cattery_add_commander_success"))
				end
			end

			if var4_1 then
				var4_1()
			end

			arg0_1:sendNotification(GAME.PUT_COMMANDER_IN_CATTERY_DONE, {
				id = var8_1.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.UpdateCommanderLevelAndExp(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg2_3.commander_level
	local var1_3 = arg2_3.commander_exp

	if var0_3 > 0 then
		local var2_3 = getProxy(CommanderProxy)
		local var3_3 = var2_3:getCommanderById(arg1_3)

		var3_3:UpdateLevelAndExp(var0_3, var1_3)
		var2_3:updateCommander(var3_3)
	end
end

return var0_0
