local var0 = class("LockCommanderCommande", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.commanderId
	local var2 = var0.flag
	local var3 = getProxy(CommanderProxy)
	local var4 = var3:getCommanderById(var1)

	if not var4 or var4:getLock() == var2 then
		return
	end

	local function var5()
		pg.ConnectionMgr.GetInstance():Send(25016, {
			commanderid = var1,
			flag = var2
		}, 25017, function(arg0)
			if arg0.result == 0 then
				var4:setLock(var2)
				var3:updateCommander(var4)
				arg0:sendNotification(GAME.COMMANDER_LOCK_DONE, {
					commander = var4,
					flag = var2
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_lock_erro", arg0.result))
			end
		end)
	end

	if var2 == 0 then
		local var6 = pg.SecondaryPWDMgr.GetInstance()

		var6:LimitedOperation(var6.UNLOCK_COMMANDER, var1, var5)
	else
		var5()
	end
end

return var0
