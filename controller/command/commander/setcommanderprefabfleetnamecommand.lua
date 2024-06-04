local var0 = class("SetCommanderPrefabFleetNameCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.name
	local var3 = var0.onFailed
	local var4 = getProxy(CommanderProxy):getPrefabFleetById(var1)

	if var4:getName() == var2 or var2 == "" then
		if var3 then
			var3()
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("login_newPlayerScene_name_tooShort"))

		return
	end

	local var5, var6 = var4:canRename()

	if not var5 then
		pg.TipsMgr.GetInstance():ShowTips(var6)

		if var3 then
			var3()
		end

		return
	end

	if not nameValidityCheck(var2, 0, 12, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"login_newPlayerScene_name_tooLong",
		"playerinfo_mask_word"
	}) then
		if var3 then
			var3()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25024, {
		id = var1,
		name = var2
	}, 25025, function(arg0)
		if arg0.result == 0 then
			getProxy(CommanderProxy):updatePrefabFleetName(var1, var2)
			arg0:sendNotification(GAME.SET_COMMANDER_PREFAB_NAME_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_prefab_rename_success"))
		else
			if var3 then
				var3()
			end

			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result])
		end
	end)
end

return var0
