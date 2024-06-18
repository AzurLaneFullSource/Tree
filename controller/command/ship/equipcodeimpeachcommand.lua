local var0_0 = class("EquipCodeImpeachCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.shareId
	local var3_1 = var0_1.type

	pg.ConnectionMgr.GetInstance():Send(17607, {
		shipgroup = var1_1,
		shareid = var2_1,
		report_type = var3_1
	}, 17608, function(arg0_2)
		if arg0_2.result == 0 then
			pg.m02:sendNotification(GAME.EQUIP_CODE_IMPEACH_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_dislike_success"))
		elseif arg0_2.result == -1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_report_warning"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
