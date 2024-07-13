local var0_0 = class("LockCommanderCommande", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.commanderId
	local var2_1 = var0_1.flag
	local var3_1 = getProxy(CommanderProxy)
	local var4_1 = var3_1:getCommanderById(var1_1)

	if not var4_1 or var4_1:getLock() == var2_1 then
		return
	end

	local function var5_1()
		pg.ConnectionMgr.GetInstance():Send(25016, {
			commanderid = var1_1,
			flag = var2_1
		}, 25017, function(arg0_3)
			if arg0_3.result == 0 then
				var4_1:setLock(var2_1)
				var3_1:updateCommander(var4_1)
				arg0_1:sendNotification(GAME.COMMANDER_LOCK_DONE, {
					commander = var4_1,
					flag = var2_1
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_lock_erro", arg0_3.result))
			end
		end)
	end

	if var2_1 == 0 then
		local var6_1 = pg.SecondaryPWDMgr.GetInstance()

		var6_1:LimitedOperation(var6_1.UNLOCK_COMMANDER, var1_1, var5_1)
	else
		var5_1()
	end
end

return var0_0
