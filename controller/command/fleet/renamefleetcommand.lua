local var0 = class("FleetRenameCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.name
	local var3 = getProxy(FleetProxy)

	if not var3:getFleetById(var1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("fleet_error_no_fleet"))

		return
	end

	if not nameValidityCheck(var2, 2, 24, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"login_newPlayerScene_name_tooLong",
		"playerinfo_mask_word"
	}) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(12104, {
		id = var1,
		name = var2
	}, 12105, function(arg0)
		if arg0.result == 0 then
			var3:renameFleet(var1, var2)
			arg0:sendNotification(GAME.RENAME_FLEET_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result])
		end
	end)
end

return var0
