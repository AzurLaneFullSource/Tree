local var0_0 = class("UpdateShipPreferenceTagCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.tag

	pg.ConnectionMgr.GetInstance():Send(12040, {
		ship_id = var1_1,
		flag = var2_1
	}, 12041, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)
			local var1_2

			if var2_1 == Ship.PREFERENCE_TAG_COMMON then
				var1_2 = "ship_preference_common"
			elseif var2_1 == Ship.PREFERENCE_TAG_NONE then
				var1_2 = "ship_preference_non"
			end

			local var2_2 = var0_2:getShipById(var1_1)

			var2_2:SetPreferenceTag(var2_1)
			var0_2:updateShip(var2_2)
			arg0_1:sendNotification(GAME.UPDATE_PREFERENCE_DONE, var2_2)
			pg.TipsMgr.GetInstance():ShowTips(i18n(var1_2, var2_2:getName()))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_updateShipLock", arg0_2.result))
		end
	end)
end

return var0_0
