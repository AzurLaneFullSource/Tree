local var0 = class("MainActDataExpirationReminderSequence")

function var0.Execute(arg0, arg1)
	seriesAsync({
		function(arg0)
			arg0:CheckSkinCouponActivity(arg0)
		end
	}, arg1)
end

function var0.CheckSkinCouponActivity(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON)

	if not var0 or #var0 == 0 then
		arg1()

		return
	end

	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		if iter1:ShouldTipUsage() then
			table.insert(var1, function(arg0)
				iter1:SaveTipTime()
				arg0:ShowTipMsg(iter1, arg0)
			end)
		end
	end

	seriesAsync(var1, arg1)
end

function var0.ShowTipMsg(arg0, arg1, arg2)
	local var0 = arg1:GetCanUsageCnt()
	local var1 = arg1:GetItemConfig()
	local var2 = {
		{
			type = DROP_TYPE_ITEM,
			id = var1.id,
			count = var0
		}
	}
	local var3 = arg1:GetItemName()
	local var4 = pg.TimeMgr.GetInstance():STimeDescS(arg1.stopTime, "%m.%d")

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		type = MSGBOX_TYPE_ITEM_BOX,
		content = i18n("skin_discount_timelimit", var3, var4),
		items = var2,
		onYes = arg2,
		weight = LayerWeightConst.TOP_LAYER
	})
end

return var0
