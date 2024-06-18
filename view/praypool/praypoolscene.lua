local var0_0 = class("PrayPoolScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "PrayPool"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:initEvents()
end

function var0_0.didEnter(arg0_3)
	local var0_3 = arg0_3.prayProxy:getPageState()

	arg0_3:switchPage(var0_3)
end

function var0_0.willExit(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.subViewList) do
		iter1_4:Destroy()
	end
end

function var0_0.onBackPressed(arg0_5)
	local var0_5

	for iter0_5, iter1_5 in ipairs(arg0_5.subViewList) do
		var0_5 = iter1_5:OnBackPress()
	end

	if not var0_5 then
		arg0_5:emit(var0_0.ON_BACK)
	end
end

function var0_0.findUI(arg0_6)
	arg0_6.subViewContainer = arg0_6:findTF("BG/SubViewContainer")
	arg0_6.helpBtn = arg0_6:findTF("BG/HelpBtn")

	onButton(arg0_6, arg0_6.helpBtn, function()
		if pg.gametip.pray_build_help then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.pray_build_help.tip,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end)
end

function var0_0.initData(arg0_8)
	arg0_8.prayProxy = getProxy(PrayProxy)
	arg0_8.prayPoolHomeView = PrayPoolHomeView.New(arg0_8.subViewContainer, arg0_8.event, arg0_8.contextData)
	arg0_8.prayPoolSelectPoolView = PrayPoolSelectPoolView.New(arg0_8.subViewContainer, arg0_8.event, arg0_8.contextData)
	arg0_8.prayPoolSelectShipView = PrayPoolSelectShipView.New(arg0_8.subViewContainer, arg0_8.event, arg0_8.contextData)
	arg0_8.PrayPoolSuccessView = PrayPoolSuccessView.New(arg0_8.subViewContainer, arg0_8.event, arg0_8.contextData)
	arg0_8.curSubView = nil
	arg0_8.subViewList = {
		[PrayProxy.STATE_HOME] = arg0_8.prayPoolHomeView,
		[PrayProxy.STATE_SELECT_POOL] = arg0_8.prayPoolSelectPoolView,
		[PrayProxy.STAGE_SELECT_SHIP] = arg0_8.prayPoolSelectShipView,
		[PrayProxy.STAGE_BUILD_SUCCESS] = arg0_8.PrayPoolSuccessView
	}
end

function var0_0.initEvents(arg0_9)
	arg0_9:bind(PrayPoolConst.SWITCH_TO_SELECT_POOL_PAGE, function(arg0_10, arg1_10)
		arg0_9:switchPage(arg1_10)
	end)
	arg0_9:bind(PrayPoolConst.SWITCH_TO_SELECT_SHIP_PAGE, function(arg0_11, arg1_11)
		arg0_9:switchPage(arg1_11)
	end)
	arg0_9:bind(PrayPoolConst.SWITCH_TO_HOME_PAGE, function(arg0_12, arg1_12)
		arg0_9:switchPage(arg1_12)
	end)
end

function var0_0.switchPage(arg0_13, arg1_13)
	arg0_13.subViewList[arg1_13]:Reset()
	arg0_13.subViewList[arg1_13]:Load()

	if arg0_13.curSubView then
		arg0_13.curSubView:Destroy()
	end

	arg0_13.curSubView = arg0_13.subViewList[arg1_13]
end

return var0_0
