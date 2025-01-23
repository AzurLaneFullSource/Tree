local var0_0 = class("NewEducateUpgradeFavorCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(29027, {
		id = var1_1
	}, 29028, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):GetCurChar():UpgradeFavor()

			local var0_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var0_2)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_UPGRADE_FAVOR_DONE, {
				drops = NewEducateHelper.FilterBenefit(var0_2),
				callback = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_UpgradeFavor", arg0_2.result))
		end
	end)
end

return var0_0
