local var0 = class("EducateUpgradeFavorCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback
	local var2 = getProxy(EducateProxy):GetCharData():GetFavorPerformIds()

	pg.ConnectionMgr.GetInstance():Send(27006, {
		type = 0
	}, 27007, function(arg0)
		if arg0.result == 0 then
			EducateHelper.UpdateDropsData(arg0.drops)
			getProxy(EducateProxy):GetCharData():UpgradeFavor()
			arg0:sendNotification(GAME.EDUCATE_UPGRADE_FAVOR_DONE, {
				drops = arg0.drops,
				performs = var2,
				cb = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate upgrad favor error: ", arg0.result))
		end
	end)
end

return var0
