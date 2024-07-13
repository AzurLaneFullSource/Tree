local var0_0 = class("RenameShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.name
	local var3_1 = getProxy(BayProxy)
	local var4_1 = var3_1:getShipById(var1_1)

	if not var4_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var1_1))

		return
	end

	local var5_1 = var4_1:isRemoulded() and pg.ship_skin_template[var4_1:getRemouldSkinId()].name or pg.ship_data_statistics[var4_1.configId].name

	if var4_1:getName() == var2_1 then
		arg0_1:sendNotification(GAME.RENAME_SHIP_DONE, {
			ship = var4_1
		})

		return
	end

	if var2_1 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("login_createNewPlayer_error_nameNull"))

		return
	end

	if var2_1 ~= var5_1 and not nameValidityCheck(var2_1, 0, 40, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"ship_renameShip_error_2011",
		"playerinfo_mask_word"
	}) then
		return
	end

	local function var6_1()
		pg.ConnectionMgr.GetInstance():Send(12034, {
			ship_id = var1_1,
			name = var2_1 == var5_1 and "" or var2_1
		}, 12035, function(arg0_3)
			if arg0_3.result == 0 then
				var4_1.name = var2_1
				var4_1.renameTime = pg.TimeMgr.GetInstance():GetServerTime()

				var3_1:updateShip(var4_1)
				arg0_1:sendNotification(BayProxy.SHIP_UPDATED, var4_1)
				arg0_1:sendNotification(GAME.RENAME_SHIP_DONE, {
					ship = var4_1
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_renameShip", arg0_3.result))
			end
		end)
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("word_rename_time_warning", var4_1:getName(), var2_1),
		onYes = function()
			var6_1()
		end
	})
end

return var0_0
