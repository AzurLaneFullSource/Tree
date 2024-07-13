local var0_0 = class("BackYardRenameCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(19016, {
		name = var0_1
	}, 19017, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(DormProxy)
			local var1_2 = var0_2:getData()

			var1_2:setName(var0_1)
			var0_2:updateDrom(var1_2, BackYardConst.DORM_UPDATE_TYPE_NAME)
			arg0_1:sendNotification(GAME.BACKYARD_RENAME_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_rename_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
