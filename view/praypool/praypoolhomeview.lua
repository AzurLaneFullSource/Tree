local var0 = class("PrayPoolHomeView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "PrayPoolHomeView"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:Show()
end

function var0.OnDestroy(arg0)
	return
end

function var0.OnBackPress(arg0)
	return
end

function var0.initData(arg0)
	arg0.prayProxy = getProxy(PrayProxy)
end

function var0.initUI(arg0)
	arg0.startBtn = arg0:findTF("StartBtn")

	onButton(arg0, arg0.startBtn, function()
		arg0.prayProxy:updatePageState(PrayProxy.STATE_SELECT_POOL)
		arg0:emit(PrayPoolConst.SWITCH_TO_SELECT_POOL_PAGE, PrayProxy.STATE_SELECT_POOL)
	end, SFX_PANEL)
end

return var0
