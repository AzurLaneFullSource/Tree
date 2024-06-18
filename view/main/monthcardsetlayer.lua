local var0_0 = class("MonthCardSetLayer", import("..base.BaseUI"))

var0_0.PIECES = 100

function var0_0.getUIName(arg0_1)
	return "MonthCardSetUI"
end

function var0_0.setPlayer(arg0_2, arg1_2)
	arg0_2.player = arg1_2
end

function var0_0.setRatio(arg0_3, arg1_3)
	arg0_3.ratio = math.clamp(arg1_3, 0, var0_0.PIECES)
end

function var0_0.init(arg0_4)
	arg0_4.name = arg0_4:findTF("window/bg/name")
	arg0_4.desc = arg0_4:findTF("window/bg/desc")
	arg0_4.oil = arg0_4:findTF("window/black/oil/icon_bg/count")
	arg0_4.gold = arg0_4:findTF("window/black/gold/icon_bg/count")
	arg0_4.slider = arg0_4:findTF("window/black/slider")
	arg0_4.rate = arg0_4:findTF("window/black/misc/rate")
	arg0_4.confirm = arg0_4:findTF("window/confirm")
	arg0_4.cancel = arg0_4:findTF("window/cancel")
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.cancel, function()
		arg0_5:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.confirm, function()
		arg0_5:emit(MonthCardSetMediator.ON_SET_RATIO, arg0_5.ratio)
	end, SFX_CANCEL)
	onSlider(arg0_5, arg0_5.slider, function(arg0_9)
		arg0_5:setRatio(arg0_9)
		arg0_5:updateRatioView()
	end)
	arg0_5:updateView()
	arg0_5:updateRatioView()
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
end

function var0_0.updateView(arg0_10)
	local var0_10 = arg0_10.player:getCardById(VipCard.MONTH)
	local var1_10 = math.floor((var0_10:getLeftDate() - pg.TimeMgr.GetInstance():GetServerTime()) / 86400)

	setText(arg0_10.name, string.format("贸易许可证（剩余%s天）", var1_10))
	setText(arg0_10.rate, "1 : 5")
end

function var0_0.updateRatioView(arg0_11)
	setSlider(arg0_11.slider, 0, var0_0.PIECES, arg0_11.ratio)
	setText(arg0_11.oil, 400 * arg0_11.ratio / var0_0.PIECES)
	setText(arg0_11.gold, 2000 * (var0_0.PIECES - arg0_11.ratio) / var0_0.PIECES)
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf)
end

return var0_0
