local var0_0 = class("MainActDataExpirationReminderSequence")

function var0_0.Execute(arg0_1, arg1_1)
	seriesAsync({
		function(arg0_2)
			arg0_1:CheckSkinCouponActivity(arg0_2)
		end
	}, arg1_1)
end

function var0_0.CheckSkinCouponActivity(arg0_3, arg1_3)
	local var0_3 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON)

	if not var0_3 or #var0_3 == 0 then
		arg1_3()

		return
	end

	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if iter1_3:ShouldTipUsage() then
			table.insert(var1_3, function(arg0_4)
				iter1_3:SaveTipTime()
				arg0_3:ShowTipMsg(iter1_3, arg0_4)
			end)
		end
	end

	seriesAsync(var1_3, arg1_3)
end

function var0_0.ShowTipMsg(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:GetCanUsageCnt()
	local var1_5 = arg1_5:GetItemConfig()
	local var2_5 = {
		{
			type = DROP_TYPE_ITEM,
			id = var1_5.id,
			count = var0_5
		}
	}
	local var3_5 = arg1_5:GetItemName()
	local var4_5 = pg.TimeMgr.GetInstance():STimeDescS(arg1_5.stopTime, "%m.%d")

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		type = MSGBOX_TYPE_ITEM_BOX,
		content = i18n("skin_discount_timelimit", var3_5, var4_5),
		items = var2_5,
		onYes = arg2_5,
		weight = LayerWeightConst.TOP_LAYER
	})
end

return var0_0
