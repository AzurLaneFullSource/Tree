local var0_0 = class("FleetRenameCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.name
	local var3_1 = getProxy(FleetProxy)

	if not var3_1:getFleetById(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("fleet_error_no_fleet"))

		return
	end

	if not nameValidityCheck(var2_1, 2, 24, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"login_newPlayerScene_name_tooLong",
		"playerinfo_mask_word"
	}) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(12104, {
		id = var1_1,
		name = var2_1
	}, 12105, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:renameFleet(var1_1, var2_1)
			arg0_1:sendNotification(GAME.RENAME_FLEET_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result])
		end
	end)
end

return var0_0
