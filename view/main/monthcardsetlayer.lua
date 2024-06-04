local var0 = class("MonthCardSetLayer", import("..base.BaseUI"))

var0.PIECES = 100

function var0.getUIName(arg0)
	return "MonthCardSetUI"
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.setRatio(arg0, arg1)
	arg0.ratio = math.clamp(arg1, 0, var0.PIECES)
end

function var0.init(arg0)
	arg0.name = arg0:findTF("window/bg/name")
	arg0.desc = arg0:findTF("window/bg/desc")
	arg0.oil = arg0:findTF("window/black/oil/icon_bg/count")
	arg0.gold = arg0:findTF("window/black/gold/icon_bg/count")
	arg0.slider = arg0:findTF("window/black/slider")
	arg0.rate = arg0:findTF("window/black/misc/rate")
	arg0.confirm = arg0:findTF("window/confirm")
	arg0.cancel = arg0:findTF("window/cancel")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.cancel, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.confirm, function()
		arg0:emit(MonthCardSetMediator.ON_SET_RATIO, arg0.ratio)
	end, SFX_CANCEL)
	onSlider(arg0, arg0.slider, function(arg0)
		arg0:setRatio(arg0)
		arg0:updateRatioView()
	end)
	arg0:updateView()
	arg0:updateRatioView()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.updateView(arg0)
	local var0 = arg0.player:getCardById(VipCard.MONTH)
	local var1 = math.floor((var0:getLeftDate() - pg.TimeMgr.GetInstance():GetServerTime()) / 86400)

	setText(arg0.name, string.format("贸易许可证（剩余%s天）", var1))
	setText(arg0.rate, "1 : 5")
end

function var0.updateRatioView(arg0)
	setSlider(arg0.slider, 0, var0.PIECES, arg0.ratio)
	setText(arg0.oil, 400 * arg0.ratio / var0.PIECES)
	setText(arg0.gold, 2000 * (var0.PIECES - arg0.ratio) / var0.PIECES)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
