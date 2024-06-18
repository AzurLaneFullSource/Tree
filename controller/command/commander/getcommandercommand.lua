local var0_0 = class("GetCommanderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.callback
	local var3_1 = defaultValue(var0_1.notify, true)
	local var4_1 = getProxy(CommanderProxy)
	local var5_1 = var4_1:getBoxById(var1_1)

	if getProxy(PlayerProxy):getRawData().commanderBagMax <= var4_1:getCommanderCnt() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_capcity_is_max"))

		if var2_1 then
			var2_1()
		end

		return
	end

	if var5_1:getState() ~= CommanderBox.STATE_FINISHED then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25004, {
		boxid = var1_1
	}, 25005, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = Commander.New(arg0_2.commander)

			var4_1:addCommander(var0_2)
			var5_1:finish()

			if var3_1 then
				arg0_1:sendNotification(GAME.COMMANDER_ON_OPEN_BOX_DONE, {
					commander = var0_2:clone(),
					boxId = var1_1,
					callback = var2_1
				})
			elseif var2_1 then
				var2_1(var0_2)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_acquire_erro", arg0_2.result))

			if var2_1 then
				var2_1()
			end
		end
	end)
end

return var0_0
