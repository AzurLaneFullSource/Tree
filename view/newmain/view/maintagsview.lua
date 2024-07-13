local var0_0 = class("MainTagsView", import("..base.MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.monthCardTag = findTF(arg0_1._tf, "monthcard")
	arg0_1.sellTag = findTF(arg0_1._tf, "sell")
	arg0_1.skinTag = findTF(arg0_1._tf, "skin")
	arg0_1.buildTag = findTF(arg0_1._tf, "build")
	arg0_1.tecShipGiftTag = findTF(arg0_1._tf, "tecshipgift")
	arg0_1.mallTip = findTF(arg0_1._tf, "tip")
end

function var0_0.Init(arg0_2)
	local var0_2 = {}

	table.insert(var0_2, function(arg0_3)
		TagTipHelper.TecShipGiftTip(arg0_2.tecShipGiftTag)
		onNextTick(arg0_3)
	end)
	table.insert(var0_2, function(arg0_4)
		TagTipHelper.MonthCardTagTip(arg0_2.monthCardTag)
		onNextTick(arg0_4)
	end)
	table.insert(var0_2, function(arg0_5)
		TagTipHelper.SkinTagTip(arg0_2.skinTag)
		onNextTick(arg0_5)
	end)
	table.insert(var0_2, function(arg0_6)
		TagTipHelper.FuDaiTagTip(arg0_2.sellTag)
		onNextTick(arg0_6)
	end)
	table.insert(var0_2, function(arg0_7)
		if not arg0_2:AnyMallTipShowing() then
			TagTipHelper.FreeGiftTag({
				arg0_2.mallTip
			})
		else
			setActive(arg0_2.mallTip, false)
		end

		onNextTick(arg0_7)
	end)
	table.insert(var0_2, function(arg0_8)
		TagTipHelper.FreeBuildTicketTip(arg0_2.buildTag)
		onNextTick(arg0_8)
	end)
	seriesAsync(var0_2)
end

function var0_0.AnyMallTipShowing(arg0_9)
	local var0_9 = {
		arg0_9.monthCardTag,
		arg0_9.sellTag,
		arg0_9.skinTag,
		arg0_9.tecShipGiftTag
	}

	return _.any(var0_9, function(arg0_10)
		return arg0_10:GetComponent(typeof(Image)).enabled
	end)
end

function var0_0.Refresh(arg0_11)
	arg0_11:Init()
end

return var0_0
