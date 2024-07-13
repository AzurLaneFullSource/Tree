local var0_0 = class("CommanderHomeLayer", import("...base.BaseUI"))

var0_0.DESC_PAGE_OPEN = "CommanderHomeLayer:DESC_PAGE_OPEN"
var0_0.DESC_PAGE_CLOSE = "CommanderHomeLayer:DESC_PAGE_CLOSE"

function var0_0.getUIName(arg0_1)
	return "CommanderHomeUI"
end

function var0_0.SetHome(arg0_2, arg1_2)
	arg0_2.home = arg1_2
end

function var0_0.OnCatteryUpdate(arg0_3, arg1_3)
	local var0_3

	for iter0_3, iter1_3 in pairs(arg0_3.cards) do
		if iter1_3.cattery.id == arg1_3 then
			var0_3 = iter1_3.cattery

			iter1_3:Update(var0_3)
		end
	end

	if var0_3 and arg0_3.catteryDescPage:GetLoaded() and arg0_3.catteryDescPage:isShowing() then
		arg0_3.catteryDescPage:OnCatteryUpdate(var0_3)
	end

	arg0_3:UpdateMain()
end

function var0_0.OnCatteryStyleUpdate(arg0_4, arg1_4)
	local var0_4

	for iter0_4, iter1_4 in pairs(arg0_4.cards) do
		if iter1_4.cattery.id == arg1_4 then
			var0_4 = iter1_4.cattery

			iter1_4:UpdateStyle(var0_4)
		end
	end

	if var0_4 and arg0_4.catteryDescPage:GetLoaded() and arg0_4.catteryDescPage:isShowing() then
		arg0_4.catteryDescPage:OnCatteryStyleUpdate(var0_4)
	end
end

function var0_0.OnCommanderExpChange(arg0_5, arg1_5)
	for iter0_5, iter1_5 in pairs(arg0_5.cards) do
		local var0_5 = iter1_5.cattery

		if var0_5:ExistCommander() then
			iter1_5:Update(var0_5)
		end
	end

	if arg0_5.catteryDescPage:GetLoaded() and arg0_5.catteryDescPage:isShowing() then
		arg0_5.catteryDescPage:FlushCatteryInfo()
	end

	arg0_5.awardDisplayView:ExecuteAction("AddPlan", {
		homeExp = 0,
		commanderExps = arg1_5,
		awards = {}
	})
end

function var0_0.OnCatteryOPDone(arg0_6)
	arg0_6:UpdateMain()
end

function var0_0.OnZeroHour(arg0_7)
	arg0_7:UpdateMain()
end

function var0_0.OnOpAnimtion(arg0_8, arg1_8, arg2_8, arg3_8)
	setActive(arg0_8.opAnim.gameObject, true)

	local var0_8 = ({
		"clean",
		"feed",
		"play"
	})[arg1_8]

	if not var0_8 then
		arg3_8()

		return
	end

	if arg0_8.timer then
		arg0_8.timer:Stop()

		arg0_8.timer = nil
	end

	arg0_8.timer = Timer.New(function()
		arg0_8:CancelOpAnim()
	end, 0.8, 1)

	arg0_8.timer:Start()
	arg0_8.opAnim:SetTrigger(var0_8)

	for iter0_8, iter1_8 in pairs(arg0_8.cards) do
		if table.contains(arg2_8, iter1_8.cattery.id) then
			floatAni(iter1_8.char, 20, 0.1, 2)
		end
	end

	arg0_8.callback = arg3_8
end

function var0_0.CancelOpAnim(arg0_10)
	if arg0_10.callback then
		arg0_10.timer:Stop()

		arg0_10.timer = nil

		arg0_10.opAnim:SetTrigger("empty")
		arg0_10.callback()

		arg0_10.callback = nil

		setActive(arg0_10.opAnim.gameObject, false)
	end
end

function var0_0.OnDisplayAwardDone(arg0_11, arg1_11)
	arg0_11.awardDisplayView:ExecuteAction("AddPlan", arg1_11)
end

function var0_0.init(arg0_12)
	arg0_12.frame = arg0_12:findTF("bg")
	arg0_12.closeBtn = arg0_12:findTF("bg/frame/close_btn")
	arg0_12.levelInfoBtn = arg0_12:findTF("bg/frame/title/help")
	arg0_12.levelTxt = arg0_12:findTF("bg/frame/title/Text"):GetComponent(typeof(Text))
	arg0_12.scrollRect = arg0_12:findTF("bg/frame/scrollrect"):GetComponent("ScrollRect")
	arg0_12.scrollRectContent = arg0_12:findTF("bg/frame/scrollrect/content")
	arg0_12.batchBtn = arg0_12:findTF("bg/frame/batch")
	arg0_12.opAnim = arg0_12:findTF("animation"):GetComponent(typeof(Animator))
	arg0_12.UIlist = UIItemList.New(arg0_12.scrollRectContent, arg0_12.scrollRectContent:Find("tpl"))
	arg0_12.helpBtn = arg0_12:findTF("bg/frame/help")
	arg0_12.cntTxt = arg0_12:findTF("bg/frame/cnt/Text"):GetComponent(typeof(Text))
	arg0_12.cards = {}
	arg0_12.catteryDescPage = CatteryDescPage.New(arg0_12._tf, arg0_12.event, arg0_12.contextData)
	arg0_12.levelInfoPage = CommanderHomeLevelInfoPage.New(arg0_12._tf, arg0_12.event, arg0_12.contextData)
	arg0_12.awardDisplayView = CatteryOpAnimPage.New(arg0_12._tf, arg0_12.event)
	arg0_12.batchSelPage = CommanderHomeBatchSelPage.New(arg0_12._tf, arg0_12.event)
	arg0_12.flower = CatteryFlowerView.New(arg0_12:findTF("bg/frame/flower"))
	arg0_12.bubbleTF = arg0_12:findTF("bg/bubble")
	arg0_12.bubbleClean = arg0_12.bubbleTF:Find("clean")
	arg0_12.bubbleFeed = arg0_12.bubbleTF:Find("feed")
	arg0_12.bubblePlay = arg0_12.bubbleTF:Find("play")
end

function var0_0.RegisterEvent(arg0_13)
	arg0_13:bind(var0_0.DESC_PAGE_CLOSE, function()
		setActive(arg0_13.frame, true)
	end)
	arg0_13:bind(var0_0.DESC_PAGE_OPEN, function()
		setActive(arg0_13.frame, false)
	end)
end

function var0_0.didEnter(arg0_16)
	arg0_16:RegisterEvent()
	onButton(arg0_16, arg0_16.closeBtn, function()
		arg0_16:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16._tf, function()
		if arg0_16.forbiddenClose then
			return
		end

		arg0_16:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.levelInfoBtn, function()
		arg0_16.levelInfoPage:ExecuteAction("Show", arg0_16.home)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.cat_home_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.bubbleClean, function()
		arg0_16:CancelOpAnim()
		arg0_16:emit(CommanderHomeMediator.ON_CLEAN)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.bubbleFeed, function()
		arg0_16:CancelOpAnim()
		arg0_16:emit(CommanderHomeMediator.ON_FEED)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.bubblePlay, function()
		arg0_16:CancelOpAnim()
		arg0_16:emit(CommanderHomeMediator.ON_PLAY)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.batchBtn, function()
		arg0_16.batchSelPage:ExecuteAction("Update", arg0_16.home)
	end, SFX_PANEL)
	arg0_16.UIlist:make(function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			arg0_16:OnUpdateItem(arg2_25, arg0_16.displays[arg1_25 + 1])
		end
	end)
	arg0_16:UpdateMain()

	arg0_16.UIMgr = pg.UIMgr.GetInstance()

	arg0_16.UIMgr:BlurPanel(arg0_16._tf)
end

function var0_0.OnUpdateItem(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg0_26.cards[arg1_26]

	if not var0_26 then
		var0_26 = CatteryCard.New(arg1_26)
		arg0_26.cards[arg1_26] = var0_26
	end

	onButton(arg0_26, var0_26._tf, function()
		if not var0_26.cattery:IsLocked() then
			arg0_26.catteryDescPage:ExecuteAction("Update", arg0_26.home, var0_26.cattery)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("cat_home_unlock"))
		end
	end, SFX_PANEL)
	var0_26:Update(arg2_26)
end

function var0_0.UpdateMain(arg0_28)
	arg0_28.levelTxt.text = "LV." .. arg0_28.home:GetLevel()

	arg0_28:InitCatteries()
	arg0_28.flower:Update(arg0_28.home)
end

function var0_0.InitCatteries(arg0_29)
	local var0_29 = arg0_29.home

	arg0_29.displays = {}

	local var1_29 = var0_29:GetCatteries()
	local var2_29 = 0
	local var3_29 = 0

	for iter0_29, iter1_29 in pairs(var1_29) do
		table.insert(arg0_29.displays, iter1_29)

		if iter1_29:ExistCommander() then
			var3_29 = var3_29 + 1
		end

		if not iter1_29:IsLocked() then
			var2_29 = var2_29 + 1
		end
	end

	arg0_29.UIlist:align(#arg0_29.displays)
	arg0_29:UpdateBubble()

	arg0_29.cntTxt.text = var3_29 .. "/" .. var2_29
end

function var0_0.UpdateBubble(arg0_30)
	local var0_30 = arg0_30.home:GetCatteries()
	local var1_30 = false
	local var2_30 = false
	local var3_30 = false

	for iter0_30, iter1_30 in pairs(var0_30) do
		if iter1_30:ExistCleanOP() and iter1_30:CommanderCanClean() then
			var1_30 = true
		end

		if iter1_30:ExiseFeedOP() and iter1_30:CommanderCanFeed() then
			var2_30 = true
		end

		if iter1_30:ExistPlayOP() and iter1_30:CommanderCanPlay() then
			var3_30 = true
		end
	end

	local var4_30 = var1_30 or var2_30 or var3_30

	setActive(arg0_30.bubbleTF, var4_30)

	if LeanTween.isTweening(arg0_30.bubbleTF.gameObject) then
		LeanTween.cancel(arg0_30.bubbleTF.gameObject)
	end

	if var4_30 then
		floatAni(arg0_30.bubbleTF, 20, 0.5, -1)
		setActive(arg0_30.bubbleClean, var1_30)
		setActive(arg0_30.bubbleFeed, var2_30 and not var1_30)
		setActive(arg0_30.bubblePlay, var3_30 and not var2_30)
	end
end

function var0_0.willExit(arg0_31)
	arg0_31.UIMgr:UnblurPanel(arg0_31._tf, arg0_31.UIMgr._normalUIMain)

	if LeanTween.isTweening(arg0_31.bubbleTF.gameObject) then
		LeanTween.cancel(arg0_31.bubbleTF.gameObject)
	end

	for iter0_31, iter1_31 in pairs(arg0_31.cards) do
		iter1_31:Dispose()
	end

	if arg0_31.timer then
		arg0_31.timer:Stop()

		arg0_31.timer = nil
	end

	arg0_31.cards = nil

	arg0_31.flower:Dispose()

	arg0_31.flower = nil

	arg0_31.catteryDescPage:Destroy()

	arg0_31.catteryDescPage = nil

	arg0_31.levelInfoPage:Destroy()

	arg0_31.levelInfoPage = nil

	arg0_31.awardDisplayView:Destroy()
end

function var0_0.onBackPressed(arg0_32)
	if arg0_32.catteryDescPage:GetLoaded() and arg0_32.catteryDescPage:isShowing() then
		arg0_32.catteryDescPage:Hide()

		return
	end

	if arg0_32.levelInfoPage:GetLoaded() and arg0_32.levelInfoPage:isShowing() then
		arg0_32.levelInfoPage:Hide()

		return
	end

	if arg0_32.batchSelPage:GetLoaded() and arg0_32.batchSelPage:isShowing() then
		arg0_32.batchSelPage:Hide()
	end

	var0_0.super.onBackPressed(arg0_32)
end

return var0_0
