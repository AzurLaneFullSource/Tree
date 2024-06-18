local var0_0 = class("ChangePlayerNameCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.name
	local var2_1 = var0_1.type or 1
	local var3_1 = var0_1.onSuccess

	if not var1_1 or var1_1 == "" then
		return
	end

	local var4_1 = getProxy(PlayerProxy):getData()

	if not var4_1 then
		return
	end

	if var1_1 == var4_1.name then
		pg.TipsMgr.GetInstance():ShowTips(i18n("same_player_name_tip"))

		return
	end

	if not nameValidityCheck(var1_1, 4, 14, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"login_newPlayerScene_name_tooLong",
		"login_newPlayerScene_invalideName"
	}) then
		return
	end

	if var2_1 == 1 then
		arg0_1:ModifyNameByItem(var4_1, var1_1, var3_1)
	elseif var2_1 == 2 then
		arg0_1:ForceModifyName(var4_1, var1_1, var3_1)
	end
end

function var0_0.ModifyNameByItem(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2, var1_2 = arg1_2:canModifyName()

	if not var0_2 then
		pg.TipsMgr.GetInstance():ShowTips(var1_2)

		return
	end

	local var2_2 = getProxy(PlayerProxy)
	local var3_2 = arg1_2:getModifyNameComsume()
	local var4_2 = getProxy(BagProxy)
	local var5_2

	if var3_2[1] == DROP_TYPE_RESOURCE then
		if arg1_2:getResById(var3_2[2]) < var3_2[3] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end

		var5_2 = Drop.New({
			type = DROP_TYPE_ITEM,
			id = id2ItemId(var3_2[2]),
			count = var3_2[3]
		})
	elseif var3_2[1] == DROP_TYPE_ITEM then
		local var6_2 = var4_2:getItemById(var3_2[2])

		if not var6_2 or var6_2.count < var3_2[3] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end

		var5_2 = Drop.New({
			type = DROP_TYPE_ITEM,
			id = var3_2[2],
			count = var3_2[3]
		})
	else
		assert(false, "type is not supported >> " .. var3_2[1])

		return
	end

	local var7_2 = pg.gameset.player_name_cold_time.key_value

	local function var8_2()
		pg.ConnectionMgr.GetInstance():Send(11007, {
			type = 1,
			name = arg2_2
		}, 11008, function(arg0_4)
			if arg0_4.result == 0 then
				arg1_2.name = arg2_2

				local var0_4 = pg.TimeMgr.GetInstance():GetServerTime() + var7_2

				arg1_2:updateModifyNameColdTime(var0_4)
				var2_2:updatePlayer(arg1_2)
				arg0_2:sendNotification(GAME.CONSUME_ITEM, Drop.Create(var3_2))

				if arg3_2 then
					arg3_2()
				end

				arg0_2:sendNotification(GAME.CHANGE_PLAYER_NAME_DONE)
				pg.TipsMgr.GetInstance():ShowTips(i18n("player_changePlayerName_ok"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("player_changePlayerName", arg0_4.result))
			end
		end)
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("player_name_change_warning", var5_2.count, var5_2:getConfig("name"), arg2_2),
		onYes = function()
			var8_2()
		end
	})
end

function var0_0.ForceModifyName(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = getProxy(PlayerProxy)

	pg.ConnectionMgr.GetInstance():Send(11007, {
		type = 2,
		name = arg2_6
	}, 11008, function(arg0_7)
		if arg0_7.result == 0 then
			arg1_6.name = arg2_6

			arg1_6:CancelCommonFlag(ILLEGALITY_PLAYER_NAME)
			var0_6:updatePlayer(arg1_6)

			if arg3_6 then
				arg3_6()
			end

			arg0_6:sendNotification(GAME.CHANGE_PLAYER_NAME_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_changePlayerName_ok"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_changePlayerName", arg0_7.result))
		end
	end)
end

return var0_0
