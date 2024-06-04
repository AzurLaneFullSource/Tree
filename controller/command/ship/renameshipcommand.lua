local var0 = class("RenameShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.name
	local var3 = getProxy(BayProxy)
	local var4 = var3:getShipById(var1)

	if not var4 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var1))

		return
	end

	local var5 = var4:isRemoulded() and pg.ship_skin_template[var4:getRemouldSkinId()].name or pg.ship_data_statistics[var4.configId].name

	if var4:getName() == var2 then
		arg0:sendNotification(GAME.RENAME_SHIP_DONE, {
			ship = var4
		})

		return
	end

	if var2 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("login_createNewPlayer_error_nameNull"))

		return
	end

	if var2 ~= var5 and not nameValidityCheck(var2, 0, 40, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"ship_renameShip_error_2011",
		"playerinfo_mask_word"
	}) then
		return
	end

	local function var6()
		pg.ConnectionMgr.GetInstance():Send(12034, {
			ship_id = var1,
			name = var2 == var5 and "" or var2
		}, 12035, function(arg0)
			if arg0.result == 0 then
				var4.name = var2
				var4.renameTime = pg.TimeMgr.GetInstance():GetServerTime()

				var3:updateShip(var4)
				arg0:sendNotification(BayProxy.SHIP_UPDATED, var4)
				arg0:sendNotification(GAME.RENAME_SHIP_DONE, {
					ship = var4
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_renameShip", arg0.result))
			end
		end)
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("word_rename_time_warning", var4:getName(), var2),
		onYes = function()
			var6()
		end
	})
end

return var0
