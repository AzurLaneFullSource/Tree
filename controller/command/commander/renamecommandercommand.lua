local var0 = class("RenameCommanderCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.commanderId
	local var2 = var0.name
	local var3 = getProxy(CommanderProxy)
	local var4 = var3:getCommanderById(var1)

	if not var4 then
		return
	end

	if not var4:canModifyName() then
		return
	end

	if not var2 or var2 == "" then
		return
	end

	if var4:getName() == var2 then
		return
	end

	if not nameValidityCheck(var2, 0, 20, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"login_newPlayerScene_name_tooLong",
		"playerinfo_mask_word"
	}) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25020, {
		commanderid = var1,
		name = var2
	}, 25021, function(arg0)
		if arg0.result == 0 then
			var4:setName(var2)

			local var0 = pg.gameset.commander_rename_coldtime.key_value
			local var1 = pg.TimeMgr.GetInstance():GetServerTime() + var0

			var4:setRenameTime(var1)
			var3:updateCommander(var4)
			arg0:sendNotification(GAME.COMMANDER_RENAME_DONE, {
				id = var4.id,
				name = var2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("rename_commander_erro", arg0.result))
		end
	end)
end

return var0
