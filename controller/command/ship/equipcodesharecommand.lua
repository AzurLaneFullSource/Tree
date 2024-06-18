local var0_0 = class("EquipCodeShareCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.code

	pg.ConnectionMgr.GetInstance():Send(17603, {
		shipgroup = var1_1,
		eqcode = var2_1
	}, 17604, function(arg0_2)
		if arg0_2.result == 0 then
			pg.m02:sendNotification(GAME.EQUIP_CODE_SHARE_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_success"))
		elseif arg0_2.result == 7 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_errorcode7"))
		elseif arg0_2.result == 44 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_errorcode44"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
