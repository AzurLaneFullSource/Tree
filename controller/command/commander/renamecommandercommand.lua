local var0_0 = class("RenameCommanderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.commanderId
	local var2_1 = var0_1.name
	local var3_1 = getProxy(CommanderProxy)
	local var4_1 = var3_1:getCommanderById(var1_1)

	if not var4_1 then
		return
	end

	if not var4_1:canModifyName() then
		return
	end

	if not var2_1 or var2_1 == "" then
		return
	end

	if var4_1:getName() == var2_1 then
		return
	end

	if not nameValidityCheck(var2_1, 0, 20, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"login_newPlayerScene_name_tooLong",
		"playerinfo_mask_word"
	}) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25020, {
		commanderid = var1_1,
		name = var2_1
	}, 25021, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:setName(var2_1)

			local var0_2 = pg.gameset.commander_rename_coldtime.key_value
			local var1_2 = pg.TimeMgr.GetInstance():GetServerTime() + var0_2

			var4_1:setRenameTime(var1_2)
			var3_1:updateCommander(var4_1)
			arg0_1:sendNotification(GAME.COMMANDER_RENAME_DONE, {
				id = var4_1.id,
				name = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("rename_commander_erro", arg0_2.result))
		end
	end)
end

return var0_0
