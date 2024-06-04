local var0 = class("MainTagsView", import("..base.MainBaseView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.monthCardTag = findTF(arg0._tf, "monthcard")
	arg0.sellTag = findTF(arg0._tf, "sell")
	arg0.skinTag = findTF(arg0._tf, "skin")
	arg0.buildTag = findTF(arg0._tf, "build")
	arg0.tecShipGiftTag = findTF(arg0._tf, "tecshipgift")
	arg0.mallTip = findTF(arg0._tf, "tip")
end

function var0.Init(arg0)
	local var0 = {}

	table.insert(var0, function(arg0)
		TagTipHelper.TecShipGiftTip(arg0.tecShipGiftTag)
		onNextTick(arg0)
	end)
	table.insert(var0, function(arg0)
		TagTipHelper.MonthCardTagTip(arg0.monthCardTag)
		onNextTick(arg0)
	end)
	table.insert(var0, function(arg0)
		TagTipHelper.SkinTagTip(arg0.skinTag)
		onNextTick(arg0)
	end)
	table.insert(var0, function(arg0)
		TagTipHelper.FuDaiTagTip(arg0.sellTag)
		onNextTick(arg0)
	end)
	table.insert(var0, function(arg0)
		if not arg0:AnyMallTipShowing() then
			TagTipHelper.FreeGiftTag({
				arg0.mallTip
			})
		else
			setActive(arg0.mallTip, false)
		end

		onNextTick(arg0)
	end)
	table.insert(var0, function(arg0)
		TagTipHelper.FreeBuildTicketTip(arg0.buildTag)
		onNextTick(arg0)
	end)
	seriesAsync(var0)
end

function var0.AnyMallTipShowing(arg0)
	local var0 = {
		arg0.monthCardTag,
		arg0.sellTag,
		arg0.skinTag,
		arg0.tecShipGiftTag
	}

	return _.any(var0, function(arg0)
		return arg0:GetComponent(typeof(Image)).enabled
	end)
end

function var0.Refresh(arg0)
	arg0:Init()
end

return var0
