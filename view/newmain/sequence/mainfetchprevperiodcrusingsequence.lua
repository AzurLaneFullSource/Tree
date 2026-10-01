local var0_0 = class("MainFetchPrevPeriodCrusingSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_1 and not var0_1:isEnd() then
		local var1_1 = var0_1:GetPreviousPeriodAct()

		if var1_1 and #var1_1:GetCrusingUnreceiveAward() > 0 then
			arg0_1:GetAllAward(var1_1, arg1_1)

			return
		end
	end

	arg1_1()
end

function var0_0.GetAllAward(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2:GetCrusingUnreceiveAward()

	if #var0_2 > 0 then
		local var1_2 = {}

		if arg0_2:CheckLimitMax(var0_2) then
			table.insert(var1_2, function(arg0_3)
				pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
					contentText = i18n("player_expResource_mail_fullBag"),
					onConfirm = arg0_3
				})
			end)
		end

		seriesAsync(var1_2, function()
			pg.m02:sendNotification(GAME.PREV_CRUSING_CMD, {
				cmd = 5,
				activity_id = arg1_2.id,
				callback = arg2_2
			})
		end)
	end
end

function var0_0.CheckLimitMax(arg0_5, arg1_5)
	local var0_5 = getProxy(PlayerProxy):getRawData()

	for iter0_5, iter1_5 in ipairs(arg1_5) do
		if iter1_5.type == DROP_TYPE_RESOURCE then
			if iter1_5.id == 1 then
				if var0_5:GoldMax(iter1_5.count) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

					return true
				end
			elseif iter1_5.id == 2 and var0_5:OilMax(iter1_5.count) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

				return true
			end
		elseif iter1_5.type == DROP_TYPE_ITEM then
			local var1_5 = Item.getConfigData(iter1_5.id)

			if var1_5.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(iter1_5.id) + iter1_5.count > var1_5.max_num then
				return true
			end
		end
	end

	return false
end

return var0_0
