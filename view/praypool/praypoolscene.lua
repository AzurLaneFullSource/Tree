local var0 = class("PrayPoolScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "PrayPool"
end

function var0.init(arg0)
	arg0:findUI()
	arg0:initData()
	arg0:initEvents()
end

function var0.didEnter(arg0)
	local var0 = arg0.prayProxy:getPageState()

	arg0:switchPage(var0)
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.subViewList) do
		iter1:Destroy()
	end
end

function var0.onBackPressed(arg0)
	local var0

	for iter0, iter1 in ipairs(arg0.subViewList) do
		var0 = iter1:OnBackPress()
	end

	if not var0 then
		arg0:emit(var0.ON_BACK)
	end
end

function var0.findUI(arg0)
	arg0.subViewContainer = arg0:findTF("BG/SubViewContainer")
	arg0.helpBtn = arg0:findTF("BG/HelpBtn")

	onButton(arg0, arg0.helpBtn, function()
		if pg.gametip.pray_build_help then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.pray_build_help.tip,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end)
end

function var0.initData(arg0)
	arg0.prayProxy = getProxy(PrayProxy)
	arg0.prayPoolHomeView = PrayPoolHomeView.New(arg0.subViewContainer, arg0.event, arg0.contextData)
	arg0.prayPoolSelectPoolView = PrayPoolSelectPoolView.New(arg0.subViewContainer, arg0.event, arg0.contextData)
	arg0.prayPoolSelectShipView = PrayPoolSelectShipView.New(arg0.subViewContainer, arg0.event, arg0.contextData)
	arg0.PrayPoolSuccessView = PrayPoolSuccessView.New(arg0.subViewContainer, arg0.event, arg0.contextData)
	arg0.curSubView = nil
	arg0.subViewList = {
		[PrayProxy.STATE_HOME] = arg0.prayPoolHomeView,
		[PrayProxy.STATE_SELECT_POOL] = arg0.prayPoolSelectPoolView,
		[PrayProxy.STAGE_SELECT_SHIP] = arg0.prayPoolSelectShipView,
		[PrayProxy.STAGE_BUILD_SUCCESS] = arg0.PrayPoolSuccessView
	}
end

function var0.initEvents(arg0)
	arg0:bind(PrayPoolConst.SWITCH_TO_SELECT_POOL_PAGE, function(arg0, arg1)
		arg0:switchPage(arg1)
	end)
	arg0:bind(PrayPoolConst.SWITCH_TO_SELECT_SHIP_PAGE, function(arg0, arg1)
		arg0:switchPage(arg1)
	end)
	arg0:bind(PrayPoolConst.SWITCH_TO_HOME_PAGE, function(arg0, arg1)
		arg0:switchPage(arg1)
	end)
end

function var0.switchPage(arg0, arg1)
	arg0.subViewList[arg1]:Reset()
	arg0.subViewList[arg1]:Load()

	if arg0.curSubView then
		arg0.curSubView:Destroy()
	end

	arg0.curSubView = arg0.subViewList[arg1]
end

return var0
