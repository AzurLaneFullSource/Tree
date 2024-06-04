local var0 = class("UpdateShipPreferenceTagCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.tag

	pg.ConnectionMgr.GetInstance():Send(12040, {
		ship_id = var1,
		flag = var2
	}, 12041, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy)
			local var1

			if var2 == Ship.PREFERENCE_TAG_COMMON then
				var1 = "ship_preference_common"
			elseif var2 == Ship.PREFERENCE_TAG_NONE then
				var1 = "ship_preference_non"
			end

			local var2 = var0:getShipById(var1)

			var2:SetPreferenceTag(var2)
			var0:updateShip(var2)
			arg0:sendNotification(GAME.UPDATE_PREFERENCE_DONE, var2)
			pg.TipsMgr.GetInstance():ShowTips(i18n(var1, var2:getName()))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_updateShipLock", arg0.result))
		end
	end)
end

return var0
