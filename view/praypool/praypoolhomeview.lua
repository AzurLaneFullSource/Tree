local var0_0 = class("PrayPoolHomeView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PrayPoolHomeView"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:Show()
end

function var0_0.OnDestroy(arg0_3)
	return
end

function var0_0.OnBackPress(arg0_4)
	return
end

function var0_0.initData(arg0_5)
	arg0_5.prayProxy = getProxy(PrayProxy)
end

function var0_0.initUI(arg0_6)
	arg0_6.startBtn = arg0_6:findTF("StartBtn")

	onButton(arg0_6, arg0_6.startBtn, function()
		arg0_6.prayProxy:updatePageState(PrayProxy.STATE_SELECT_POOL)
		arg0_6:emit(PrayPoolConst.SWITCH_TO_SELECT_POOL_PAGE, PrayProxy.STATE_SELECT_POOL)
	end, SFX_PANEL)
end

return var0_0
