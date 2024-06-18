local var0_0 = class("EducateUpgradeFavorCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = getProxy(EducateProxy):GetCharData():GetFavorPerformIds()

	pg.ConnectionMgr.GetInstance():Send(27006, {
		type = 0
	}, 27007, function(arg0_2)
		if arg0_2.result == 0 then
			EducateHelper.UpdateDropsData(arg0_2.drops)
			getProxy(EducateProxy):GetCharData():UpgradeFavor()
			arg0_1:sendNotification(GAME.EDUCATE_UPGRADE_FAVOR_DONE, {
				drops = arg0_2.drops,
				performs = var2_1,
				cb = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate upgrad favor error: ", arg0_2.result))
		end
	end)
end

return var0_0
