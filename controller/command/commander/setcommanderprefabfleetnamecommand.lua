local var0_0 = class("SetCommanderPrefabFleetNameCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.name
	local var3_1 = var0_1.onFailed
	local var4_1 = getProxy(CommanderProxy):getPrefabFleetById(var1_1)

	if var4_1:getName() == var2_1 or var2_1 == "" then
		if var3_1 then
			var3_1()
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("login_newPlayerScene_name_tooShort"))

		return
	end

	local var5_1, var6_1 = var4_1:canRename()

	if not var5_1 then
		pg.TipsMgr.GetInstance():ShowTips(var6_1)

		if var3_1 then
			var3_1()
		end

		return
	end

	if not nameValidityCheck(var2_1, 0, 12, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"login_newPlayerScene_name_tooLong",
		"playerinfo_mask_word"
	}) then
		if var3_1 then
			var3_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25024, {
		id = var1_1,
		name = var2_1
	}, 25025, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(CommanderProxy):updatePrefabFleetName(var1_1, var2_1)
			arg0_1:sendNotification(GAME.SET_COMMANDER_PREFAB_NAME_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_prefab_rename_success"))
		else
			if var3_1 then
				var3_1()
			end

			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result])
		end
	end)
end

return var0_0
