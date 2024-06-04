local var0 = class("PutCommanderInCatteryCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.commanderId
	local var3 = var2 == 0
	local var4 = var0.callback
	local var5 = var0.tip
	local var6 = getProxy(CommanderProxy)

	if not var3 and not var6:getCommanderById(var2) then
		if var4 then
			var4()
		end

		return
	end

	local var7 = var6:GetCommanderHome()

	if not var7 then
		if var4 then
			var4()
		end

		return
	end

	local var8 = var7:GetCatteryById(var1)

	if not var8 or not var8:CanUse() then
		if var4 then
			var4()
		end

		return
	end

	if not var3 and var8:ExistCommander() and var8:GetCommanderId() == var2 then
		if var4 then
			var4()
		end

		return
	end

	if var3 and not var8:ExistCommander() then
		if var4 then
			var4()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25030, {
		slotidx = var1,
		commander_id = var2
	}, 25031, function(arg0)
		if arg0.result == 0 then
			if var3 then
				local var0 = var8:GetCommanderId()

				arg0:UpdateCommanderLevelAndExp(var0, arg0)
				var8:RemoveCommander()

				if var5 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("cattery_remove_commander_success"))
				end
			else
				if var8:ExistCommander() then
					local var1 = var8:GetCommanderId()

					arg0:UpdateCommanderLevelAndExp(var1, arg0)
				end

				var8:AddCommander(var2, arg0.time)

				local var2 = var6:getCommanderById(var2)
				local var3 = var2:ExistCleanFlag()
				local var4 = var2:ExitFeedFlag()
				local var5 = var2:ExitPlayFlag()

				if var3 and var8:ExistCleanOP() then
					var8:ResetCleanOP()
				end

				if var4 and var8:ExiseFeedOP() then
					var8:ResetFeedOP()
				end

				if var5 and var8:ExistPlayOP() then
					var8:ResetPlayOP()
				end

				local var6 = {}

				if not var3 then
					table.insert(var6, i18n("common_clean"))
				end

				if not var4 then
					table.insert(var6, i18n("common_feed"))
				end

				if not var5 then
					table.insert(var6, i18n("common_play"))
				end

				if #var6 > 0 then
					local var7 = table.concat(var6, ", ")

					pg.TipsMgr.GetInstance():ShowTips(i18n("cat_home_interaction", var7))
				elseif var5 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("cattery_add_commander_success"))
				end
			end

			if var4 then
				var4()
			end

			arg0:sendNotification(GAME.PUT_COMMANDER_IN_CATTERY_DONE, {
				id = var8.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

function var0.UpdateCommanderLevelAndExp(arg0, arg1, arg2)
	local var0 = arg2.commander_level
	local var1 = arg2.commander_exp

	if var0 > 0 then
		local var2 = getProxy(CommanderProxy)
		local var3 = var2:getCommanderById(arg1)

		var3:UpdateLevelAndExp(var0, var1)
		var2:updateCommander(var3)
	end
end

return var0
