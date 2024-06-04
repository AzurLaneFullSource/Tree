local var0 = class("DealMailOperationCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.cmd
	local var2 = var0.filter
	local var3 = var0.ignoreTips
	local var4 = var0.noAttachTip
	local var5 = switch(var2.type, {
		all = function()
			return {}
		end,
		ids = function()
			return {
				{
					type = 1,
					arg_list = underscore.rest(var2.list, 1)
				}
			}
		end,
		drops = function()
			local var0 = {}
			local var1 = {}

			for iter0, iter1 in ipairs(var2.list) do
				if iter1.type == DROP_TYPE_RESOURCE then
					table.insert(var0, iter1.id)
				elseif iter1.type == DROP_TYPE_ITEM then
					table.insert(var1, iter1.id)
				else
					assert(false)
				end
			end

			return {
				{
					type = 2,
					arg_list = var0
				},
				{
					type = 3,
					arg_list = var1
				}
			}
		end
	})

	local function var6(arg0, arg1)
		pg.ConnectionMgr.GetInstance():Send(30006, {
			cmd = table.indexof(MailProxy.DEAL_CMD_LIST, arg0),
			match_list = var5
		}, 30007, function(arg0)
			if arg0.result == 0 then
				local var0 = getProxy(MailProxy)
				local var1 = underscore.rest(arg0.mail_id_list, 1)

				table.sort(var1, CompareFuncs({
					function(arg0)
						return -arg0
					end
				}))

				for iter0, iter1 in ipairs(var1) do
					var0:DealMailOperation(iter1, arg0)
				end

				var0:unpdateUnreadCount(arg0.unread_number)
				arg1(arg0)
			elseif arg0.result == 6 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("mail_moveto_markroom_max"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
			end
		end)
	end

	local var7 = {}

	if var1 == "attachment" or var1 == "move" then
		local var8 = {}

		table.insert(var8, function(arg0, arg1)
			local var0 = GetItemsOverflowDic(arg1)
			local var1, var2 = CheckOverflow(var0, true)

			if not var1 then
				switch(var2, {
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
				arg0(var2)
			end
		end)
		table.insert(var8, function(arg0, arg1)
			if arg1.isStoreOverflow then
				table.insert(var8, function(arg0)
					local var0, var1 = unpack(arg1.isStoreOverflow)
					local var2 = {}

					if var0 > 0 then
						table.insert(var2, Drop.New({
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = var0
						}))
					end

					if var1 > 0 then
						table.insert(var2, Drop.New({
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResOil,
							count = var1
						}))
					end

					arg0:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
						type = MailProxy.MailMessageBoxType.OverflowConfirm,
						content = i18n("mail_storeroom_max_1"),
						onYes = arg0,
						dropList = var2
					})
				end)
			end

			for iter0, iter1 in ipairs(arg1.isExpBookOverflow) do
				table.insert(var8, function(arg0)
					arg0:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
						type = MailProxy.MailMessageBoxType.ShowTips,
						content = i18n("player_expResource_mail_overflow", Item.getConfigData(iter1).name),
						onYes = arg0
					})
				end)
			end

			arg0()
		end)

		if var2.type == "ids" then
			table.insert(var7, function(arg0)
				arg0(getProxy(MailProxy):GetMailsAttachments(var2.list), var2.list)
			end)
		else
			table.insert(var7, function(arg0)
				var6("overflow", arg0)
			end)
			table.insert(var7, function(arg0, arg1)
				arg0(underscore.map(arg1.drop_list, function(arg0)
					return Drop.New({
						type = arg0.type,
						id = arg0.id,
						count = arg0.number
					})
				end), arg1.mail_id_list)
			end)
		end

		if not var4 then
			table.insert(var7, function(arg0, arg1, arg2)
				if #arg2 > 0 then
					arg0:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
						type = MailProxy.MailMessageBoxType.ReceiveAward,
						content = i18n("mail_take_all_mail_msgbox"),
						onYes = function()
							arg0(arg1)
						end,
						items = arg1,
						mailids = arg2
					})
				else
					arg0:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
						type = MailProxy.MailMessageBoxType.ShowTips,
						content = i18n("mail_manage_3")
					})
				end
			end)
		end

		table.insert(var7, function(arg0, arg1)
			if arg1 and #arg1 > 0 then
				seriesAsyncExtend(var8, arg0, arg1)
			else
				arg0()
			end
		end)
	end

	table.insert(var7, function(arg0)
		var6(var1, arg0)
	end)
	seriesAsync(var7, function(arg0)
		local var0 = PlayerConst.addTranDrop(arg0.drop_list)

		arg0:sendNotification(GAME.DEAL_MAIL_OPERATION_DONE, {
			cmd = var1,
			ids = underscore.rest(arg0.mail_id_list, 1),
			items = var0,
			ignoreTips = var3
		})
	end)
end

return var0
