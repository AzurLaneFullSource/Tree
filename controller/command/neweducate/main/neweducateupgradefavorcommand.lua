local var0_0 = class("NewEducateUpgradeFavorCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1 and var0_1.callback

	if getProxy(NewEducateProxy):GetCurChar():GetFSM():CheckPriorityStystem() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(29027, {
		id = var1_1
	}, 29028, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):GetCurChar():UpgradeFavor()

			local var0_2 = NewEducateDropHelper.HandleDrops(arg0_2.drop)

			arg0_1:sendNotification(GAME.NEW_EDUCATE_UPGRADE_FAVOR_DONE, {
				drops = var0_2,
				callback = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_UpgradeFavor: " .. arg0_2.result)
		end
	end)
end

return var0_0
