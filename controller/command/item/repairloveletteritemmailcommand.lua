local var0_0 = class("RepairLoveLetterItemMailCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.item_id
	local var2_1 = var0_1.group_id

	pg.ConnectionMgr.GetInstance():Send(30018, {
		item_id = var1_1,
		year = var0_1.year or 0,
		groupid = var2_1 or 0
	}, 30019, function(arg0_2)
		if arg0_2.ret == 0 then
			getProxy(BagProxy):SetLoveLetterRepairInfo(var1_1 .. "_" .. var2_1, nil)
			getProxy(BagProxy):removeItemById(var1_1, 1, var2_1)

			getProxy(MailProxy).collectionIds = nil

			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			arg0_1:sendNotification(GAME.LOVE_ITEM_MAIL_REPAIR_DONE, {
				awards = underscore.filter(var0_2, function(arg0_3)
					return not arg0_3:isLoveLetter()
				end)
			})
		elseif arg0_2.ret == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_recover_tip5"))
		elseif arg0_2.ret == 7 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_recover_tip3"))
		elseif arg0_2.ret == 40 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.ret))
		end
	end)
end

return var0_0
