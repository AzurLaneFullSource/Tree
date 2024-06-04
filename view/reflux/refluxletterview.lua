local var0 = class("RefluxLetterView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "RefluxLetterUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateUI()
end

function var0.OnDestroy(arg0)
	return
end

function var0.OnBackPress(arg0)
	arg0:Hide()

	if arg0.closeCB then
		arg0.closeCB()
	end
end

function var0.initData(arg0)
	arg0.refluxProxy = getProxy(RefluxProxy)
end

function var0.initUI(arg0)
	local var0 = arg0:findTF("billboard")

	arg0.billboardTF = var0
	arg0.yearText = arg0:findTF("year", var0)
	arg0.monthText = arg0:findTF("month", var0)
	arg0.dateText = arg0:findTF("date", var0)
	arg0.daysText = arg0:findTF("days", var0)
	arg0.countText = arg0:findTF("count", var0)
	arg0.shareBtn = arg0:findTF("btn_share", var0)

	setActive(arg0.shareBtn, false)
	onButton(arg0, arg0.billboardTF, function()
		arg0:OnBackPress()
	end, SFX_PANEL)
end

function var0.updateUI(arg0)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = arg0.refluxProxy.returnLastTimestamp
	local var2 = arg0.refluxProxy.returnTimestamp
	local var3 = var0:STimeDescS(var1, "*t")

	setText(arg0.yearText, var3.year % 100)
	setText(arg0.monthText, var3.month)
	setText(arg0.dateText, var3.day)
	setText(arg0.daysText, var0:DiffDay(var1, var2))
	setText(arg0.countText, arg0.refluxProxy.returnShipNum)
end

function var0.setCloseFunc(arg0, arg1)
	arg0.closeCB = arg1
end

return var0
