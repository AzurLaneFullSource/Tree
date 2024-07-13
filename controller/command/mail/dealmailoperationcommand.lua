local var0_0 = class("DealMailOperationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.cmd
	local var2_1 = var0_1.filter
	local var3_1 = var0_1.ignoreTips
	local var4_1 = var0_1.noAttachTip
	local var5_1 = switch(var2_1.type, {
		all = function()
			return {}
		end,
		ids = function()
			return {
				{
					type = 1,
					arg_list = underscore.rest(var2_1.list, 1)
				}
			}
		end,
		drops = function()
			local var0_4 = {}
			local var1_4 = {}

			for iter0_4, iter1_4 in ipairs(var2_1.list) do
				if iter1_4.type == DROP_TYPE_RESOURCE then
					table.insert(var0_4, iter1_4.id)
				elseif iter1_4.type == DROP_TYPE_ITEM then
					table.insert(var1_4, iter1_4.id)
				else
					assert(false)
				end
			end

			return {
				{
					type = 2,
					arg_list = var0_4
				},
				{
					type = 3,
					arg_list = var1_4
				}
			}
		end
	})

	local function var6_1(arg0_5, arg1_5)
		pg.ConnectionMgr.GetInstance():Send(30006, {
			cmd = table.indexof(MailProxy.DEAL_CMD_LIST, arg0_5),
			match_list = var5_1
		}, 30007, function(arg0_6)
			if arg0_6.result == 0 then
				local var0_6 = getProxy(MailProxy)
				local var1_6 = underscore.rest(arg0_6.mail_id_list, 1)

				table.sort(var1_6, CompareFuncs({
					function(arg0_7)
						return -arg0_7
					end
				}))

				for iter0_6, iter1_6 in ipairs(var1_6) do
					var0_6:DealMailOperation(iter1_6, arg0_5)
				end

				var0_6:unpdateUnreadCount(arg0_6.unread_number)
				arg1_5(arg0_6)
			elseif arg0_6.result == 6 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("mail_moveto_markroom_max"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_6.result))
			end
		end)
	end

	local var7_1 = {}

	if var1_1 == "attachment" or var1_1 == "move" then
		local var8_1 = {}

		table.insert(var8_1, function(arg0_8, arg1_8)
			local var0_8 = GetItemsOverflowDic(arg1_8)
			local var1_8, var2_8 = CheckOverflow(var0_8, true)

			if not var1_8 then
				switch(var2_8, {
					gold = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))
					end,
					oil = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))
					end,
					equip = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("mail_takeAttachment_error_magazine_full"))
					end,
					ship = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("mail_takeAttachment_error_dockYrad_full"))
					end
				})
			else
				arg0_8(var2_8)
			end
		end)
		table.insert(var8_1, function(arg0_13, arg1_13)
			if arg1_13.isStoreOverflow then
				table.insert(var8_1, function(arg0_14)
					local var0_14, var1_14 = unpack(arg1_13.isStoreOverflow)
					local var2_14 = {}

					if var0_14 > 0 then
						table.insert(var2_14, Drop.New({
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = var0_14
						}))
					end

					if var1_14 > 0 then
						table.insert(var2_14, Drop.New({
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = var1_14
						}))
					end

					arg0_1:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
						type = MailProxy.MailMessageBoxType.OverflowConfirm,
						content = i18n("mail_storeroom_max_1"),
						onYes = arg0_14,
						dropList = var2_14
					})
				end)
			end

			for iter0_13, iter1_13 in ipairs(arg1_13.isExpBookOverflow) do
				table.insert(var8_1, function(arg0_15)
					arg0_1:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
						type = MailProxy.MailMessageBoxType.ShowTips,
						content = i18n("player_expResource_mail_overflow", Item.getConfigData(iter1_13).name),
						onYes = arg0_15
					})
				end)
			end

			arg0_13()
		end)

		if var2_1.type == "ids" then
			table.insert(var7_1, function(arg0_16)
				arg0_16(getProxy(MailProxy):GetMailsAttachments(var2_1.list), var2_1.list)
			end)
		else
			table.insert(var7_1, function(arg0_17)
				var6_1("overflow", arg0_17)
			end)
			table.insert(var7_1, function(arg0_18, arg1_18)
				arg0_18(underscore.map(arg1_18.drop_list, function(arg0_19)
					return Drop.New({
						type = arg0_19.type,
						id = arg0_19.id,
						count = arg0_19.number
					})
				end), arg1_18.mail_id_list)
			end)
		end

		if not var4_1 then
			table.insert(var7_1, function(arg0_20, arg1_20, arg2_20)
				if #arg2_20 > 0 then
					arg0_1:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
						type = MailProxy.MailMessageBoxType.ReceiveAward,
						content = i18n("mail_take_all_mail_msgbox"),
						onYes = function()
							arg0_20(arg1_20)
						end,
						items = arg1_20,
						mailids = arg2_20
					})
				else
					arg0_1:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
						type = MailProxy.MailMessageBoxType.ShowTips,
						content = i18n("mail_manage_3")
					})
				end
			end)
		end

		table.insert(var7_1, function(arg0_22, arg1_22)
			if arg1_22 and #arg1_22 > 0 then
				seriesAsyncExtend(var8_1, arg0_22, arg1_22)
			else
				arg0_22()
			end
		end)
	end

	table.insert(var7_1, function(arg0_23)
		var6_1(var1_1, arg0_23)
	end)
	seriesAsync(var7_1, function(arg0_24)
		local var0_24 = PlayerConst.addTranDrop(arg0_24.drop_list)

		arg0_1:sendNotification(GAME.DEAL_MAIL_OPERATION_DONE, {
			cmd = var1_1,
			ids = underscore.rest(arg0_24.mail_id_list, 1),
			items = var0_24,
			ignoreTips = var3_1
		})
	end)
end

return var0_0
