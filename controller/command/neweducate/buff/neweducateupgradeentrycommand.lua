local var0_0 = class("NewEducateUpgradeEntryCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.entryId

	pg.ConnectionMgr.GetInstance():Send(29122, {
		id = var1_1,
		affixid = var2_1
	}, 29123, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:GetPriorityState():MarkFinish()
			var0_2:CheckPriorityStystem()

			local var1_2 = NewEducateDropHelper.HandleDrops(arg0_2.drop)

			arg0_1:sendNotification(GAME.NEW_EDUCATE_UPGRADE_ENTRY_DONE, {
				entryId = var2_1,
				drops = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_UpgradeEntry_Error: " .. arg0_2.result)
		end
	end)
end

return var0_0
