local var0_0 = class("SetIslandNameCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.name
	local var2_1 = var0_1.currency

	if not getProxy(IslandProxy):GetIsland():CanModifyName() then
		return
	end

	if not nameValidityCheck(var1_1, 1, 18, {
		"island_name_exist_special_word",
		"island_name_too_long_or_too_short",
		"island_name_too_long_or_too_short",
		"island_name_exist_ban_word"
	}) then
		return
	end

	if var2_1 == 2 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("island_rename_tip"),
			onYes = function()
				arg0_1:Send(var1_1, var2_1)
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("island_rename_confirm", var1_1),
			onYes = function()
				arg0_1:Send(var1_1, var2_1)
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end
end

function var0_0.Send(arg0_4, arg1_4, arg2_4)
	pg.ConnectionMgr.GetInstance():Send(21004, {
		name = arg1_4,
		type = arg2_4
	}, 21005, function(arg0_5)
		if arg0_5.ret == 0 then
			local var0_5 = getProxy(IslandProxy):GetIsland()

			if not var0_5:IsNew() then
				local var1_5 = var0_5:GetModifyNameConsume()

				for iter0_5, iter1_5 in ipairs({
					var1_5
				}) do
					local var2_5 = Drop.New({
						type = iter1_5[1],
						id = iter1_5[2],
						count = iter1_5[3]
					})

					arg0_4:sendNotification(GAME.CONSUME_ITEM, var2_5)
				end
			end

			var0_5:SetName(arg1_4)
			arg0_4:sendNotification(GAME.ISLAND_SET_NAME_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_5.ret] .. arg0_5.ret)
		end
	end)
end

return var0_0
