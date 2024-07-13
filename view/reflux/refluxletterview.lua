local var0_0 = class("RefluxLetterView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "RefluxLetterUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateUI()
end

function var0_0.OnDestroy(arg0_3)
	return
end

function var0_0.OnBackPress(arg0_4)
	arg0_4:Hide()

	if arg0_4.closeCB then
		arg0_4.closeCB()
	end
end

function var0_0.initData(arg0_5)
	arg0_5.refluxProxy = getProxy(RefluxProxy)
end

function var0_0.initUI(arg0_6)
	local var0_6 = arg0_6:findTF("billboard")

	arg0_6.billboardTF = var0_6
	arg0_6.yearText = arg0_6:findTF("year", var0_6)
	arg0_6.monthText = arg0_6:findTF("month", var0_6)
	arg0_6.dateText = arg0_6:findTF("date", var0_6)
	arg0_6.daysText = arg0_6:findTF("days", var0_6)
	arg0_6.countText = arg0_6:findTF("count", var0_6)
	arg0_6.shareBtn = arg0_6:findTF("btn_share", var0_6)

	setActive(arg0_6.shareBtn, false)
	onButton(arg0_6, arg0_6.billboardTF, function()
		arg0_6:OnBackPress()
	end, SFX_PANEL)
end

function var0_0.updateUI(arg0_8)
	local var0_8 = pg.TimeMgr.GetInstance()
	local var1_8 = arg0_8.refluxProxy.returnLastTimestamp
	local var2_8 = arg0_8.refluxProxy.returnTimestamp
	local var3_8 = var0_8:STimeDescS(var1_8, "*t")

	setText(arg0_8.yearText, var3_8.year % 100)
	setText(arg0_8.monthText, var3_8.month)
	setText(arg0_8.dateText, var3_8.day)
	setText(arg0_8.daysText, var0_8:DiffDay(var1_8, var2_8))
	setText(arg0_8.countText, arg0_8.refluxProxy.returnShipNum)
end

function var0_0.setCloseFunc(arg0_9, arg1_9)
	arg0_9.closeCB = arg1_9
end

return var0_0
