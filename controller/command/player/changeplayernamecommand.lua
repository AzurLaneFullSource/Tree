local var0 = class("ChangePlayerNameCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.name
	local var2 = var0.type or 1
	local var3 = var0.onSuccess

	if not var1 or var1 == "" then
		return
	end

	local var4 = getProxy(PlayerProxy):getData()

	if not var4 then
		return
	end

	if var1 == var4.name then
		pg.TipsMgr.GetInstance():ShowTips(i18n("same_player_name_tip"))

		return
	end

	if not nameValidityCheck(var1, 4, 14, {
		"spece_illegal_tip",
		"login_newPlayerScene_name_tooShort",
		"login_newPlayerScene_name_tooLong",
		"login_newPlayerScene_invalideName"
	}) then
		return
	end

	if var2 == 1 then
		arg0:ModifyNameByItem(var4, var1, var3)
	elseif var2 == 2 then
		arg0:ForceModifyName(var4, var1, var3)
	end
end

function var0.ModifyNameByItem(arg0, arg1, arg2, arg3)
	local var0, var1 = arg1:canModifyName()

	if not var0 then
		pg.TipsMgr.GetInstance():ShowTips(var1)

		return
	end

	local var2 = getProxy(PlayerProxy)
	local var3 = arg1:getModifyNameComsume()
	local var4 = getProxy(BagProxy)
	local var5

	if var3[1] == DROP_TYPE_RESOURCE then
		if arg1:getResById(var3[2]) < var3[3] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end

		var5 = Drop.New({
			type = DROP_TYPE_ITEM,
			id = id2ItemId(var3[2]),
			count = var3[3]
		})
	elseif var3[1] == DROP_TYPE_ITEM then
		local var6 = var4:getItemById(var3[2])

		if not var6 or var6.count < var3[3] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end

		var5 = Drop.New({
			type = DROP_TYPE_ITEM,
			id = var3[2],
			count = var3[3]
		})
	else
		assert(false, "type is not supported >> " .. var3[1])

		return
	end

	local var7 = pg.gameset.player_name_cold_time.key_value

	local function var8()
		pg.ConnectionMgr.GetInstance():Send(11007, {
			type = 1,
			name = arg2
		}, 11008, function(arg0)
			if arg0.result == 0 then
				arg1.name = arg2

				local var0 = pg.TimeMgr.GetInstance():GetServerTime() + var7

				arg1:updateModifyNameColdTime(var0)
				var2:updatePlayer(arg1)
				arg0:sendNotification(GAME.CONSUME_ITEM, Drop.Create(var3))

				if arg3 then
					arg3()
				end

				arg0:sendNotification(GAME.CHANGE_PLAYER_NAME_DONE)
				pg.TipsMgr.GetInstance():ShowTips(i18n("player_changePlayerName_ok"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("player_changePlayerName", arg0.result))
			end
		end)
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("player_name_change_warning", var5.count, var5:getConfig("name"), arg2),
		onYes = function()
			var8()
		end
	})
end

function var0.ForceModifyName(arg0, arg1, arg2, arg3)
	local var0 = getProxy(PlayerProxy)

	pg.ConnectionMgr.GetInstance():Send(11007, {
		type = 2,
		name = arg2
	}, 11008, function(arg0)
		if arg0.result == 0 then
			arg1.name = arg2

			arg1:CancelCommonFlag(ILLEGALITY_PLAYER_NAME)
			var0:updatePlayer(arg1)

			if arg3 then
				arg3()
			end

			arg0:sendNotification(GAME.CHANGE_PLAYER_NAME_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("player_changePlayerName_ok"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_changePlayerName", arg0.result))
		end
	end)
end

return var0
