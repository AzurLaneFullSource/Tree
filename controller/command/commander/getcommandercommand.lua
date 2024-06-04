local var0 = class("GetCommanderCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.callback
	local var3 = defaultValue(var0.notify, true)
	local var4 = getProxy(CommanderProxy)
	local var5 = var4:getBoxById(var1)

	if getProxy(PlayerProxy):getRawData().commanderBagMax <= var4:getCommanderCnt() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_capcity_is_max"))

		if var2 then
			var2()
		end

		return
	end

	if var5:getState() ~= CommanderBox.STATE_FINISHED then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25004, {
		boxid = var1
	}, 25005, function(arg0)
		if arg0.result == 0 then
			local var0 = Commander.New(arg0.commander)

			var4:addCommander(var0)
			var5:finish()

			if var3 then
				arg0:sendNotification(GAME.COMMANDER_ON_OPEN_BOX_DONE, {
					commander = var0:clone(),
					boxId = var1,
					callback = var2
				})
			elseif var2 then
				var2(var0)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_acquire_erro", arg0.result))

			if var2 then
				var2()
			end
		end
	end)
end

return var0
