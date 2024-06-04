local var0 = class("EquipCodeShareCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.code

	pg.ConnectionMgr.GetInstance():Send(17603, {
		shipgroup = var1,
		eqcode = var2
	}, 17604, function(arg0)
		if arg0.result == 0 then
			pg.m02:sendNotification(GAME.EQUIP_CODE_SHARE_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_success"))
		elseif arg0.result == 7 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_errorcode7"))
		elseif arg0.result == 44 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_share_errorcode44"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
