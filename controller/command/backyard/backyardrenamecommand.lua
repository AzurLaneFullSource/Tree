local var0 = class("BackYardRenameCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(19016, {
		name = var0
	}, 19017, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(DormProxy)
			local var1 = var0:getData()

			var1:setName(var0)
			var0:updateDrom(var1, BackYardConst.DORM_UPDATE_TYPE_NAME)
			arg0:sendNotification(GAME.BACKYARD_RENAME_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_rename_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
