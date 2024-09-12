local var0_0 = class("GetCompensateRewardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.reward_id

	local function var3_1(arg0_2)
		pg.ConnectionMgr.GetInstance():Send(30104, {
			reward_id = var0_1.reward_id
		}, 30105, function(arg0_3)
			if arg0_3.result == 0 then
				local var0_3 = getProxy(CompensateProxy)

				var0_3:DealMailOperation(var2_1)
				var0_3:unpdateLatestTime(arg0_3.max_timestamp)
				var0_3:unpdateUnreadCount(arg0_3.number)
				arg0_2(arg0_3)
			elseif arg0_3.result == 6 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("mail_moveto_markroom_max"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_3.result))
			end
		end)
	end

	local var4_1 = {}

	table.insert(var4_1, function(arg0_4, arg1_4)
		local var0_4 = GetItemsOverflowDic(arg1_4)
		local var1_4, var2_4 = CheckOverflow(var0_4)

		if not var1_4 then
			switch(var2_4, {
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
			arg0_4(var2_4)
		end
	end)
	table.insert(var4_1, function(arg0_9, arg1_9)
		for iter0_9, iter1_9 in ipairs(arg1_9.isExpBookOverflow) do
			table.insert(var4_1, function(arg0_10)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("player_expResource_mail_overflow", Item.getConfigData(iter1_9).name),
					onYes = arg0_10
				})
			end)
		end

		arg0_9()
	end)

	local var5_1 = {}

	table.insert(var5_1, function(arg0_11)
		arg0_11(getProxy(CompensateProxy):GetCompensateAttachments(var2_1))
	end)
	table.insert(var5_1, function(arg0_12, arg1_12)
		if arg1_12 and #arg1_12 > 0 then
			seriesAsyncExtend(var4_1, arg0_12, arg1_12)
		else
			arg0_12()
		end
	end)
	table.insert(var5_1, function(arg0_13)
		var3_1(arg0_13)
	end)
	seriesAsync(var5_1, function(arg0_14)
		local var0_14 = PlayerConst.addTranDrop(arg0_14.drop_list)

		arg0_1:sendNotification(GAME.DEAL_COMPENSATE_REWARD_DONE, {
			items = var0_14
		})
	end)
end

return var0_0
