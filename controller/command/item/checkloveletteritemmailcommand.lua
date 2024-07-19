local var0_0 = class("CheckLoveLetterItemMailCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.item_id
	local var2_1 = var0_1.group_id

	pg.ConnectionMgr.GetInstance():Send(30016, {
		item_id = var1_1,
		groupid = var2_1
	}, 30017, function(arg0_2)
		local var0_2 = underscore.rest(arg0_2.years, 1)

		getProxy(BagProxy):SetLoveLetterRepairInfo(var1_1 .. "_" .. var2_1, var0_2)

		if #var0_2 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_recover_tip7"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_recover_tip6", table.concat(var0_2, "、")))
		end

		arg0_1:sendNotification(GAME.LOVE_ITEM_MAIL_CHECK_DONE, {
			itemId = var1_1,
			groupId = var2_1,
			list = var0_2
		})
	end)
end

return var0_0
