local var0 = class("EquipCodeImpeachCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.shareId
	local var3 = var0.type

	pg.ConnectionMgr.GetInstance():Send(17607, {
		shipgroup = var1,
		shareid = var2,
		report_type = var3
	}, 17608, function(arg0)
		if arg0.result == 0 then
			pg.m02:sendNotification(GAME.EQUIP_CODE_IMPEACH_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_dislike_success"))
		elseif arg0.result == -1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_report_warning"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
