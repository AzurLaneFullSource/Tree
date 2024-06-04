local var0 = class("CommanderHomeLayer", import("...base.BaseUI"))

var0.DESC_PAGE_OPEN = "CommanderHomeLayer:DESC_PAGE_OPEN"
var0.DESC_PAGE_CLOSE = "CommanderHomeLayer:DESC_PAGE_CLOSE"

function var0.getUIName(arg0)
	return "CommanderHomeUI"
end

function var0.SetHome(arg0, arg1)
	arg0.home = arg1
end

function var0.OnCatteryUpdate(arg0, arg1)
	local var0

	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.cattery.id == arg1 then
			var0 = iter1.cattery

			iter1:Update(var0)
		end
	end

	if var0 and arg0.catteryDescPage:GetLoaded() and arg0.catteryDescPage:isShowing() then
		arg0.catteryDescPage:OnCatteryUpdate(var0)
	end

	arg0:UpdateMain()
end

function var0.OnCatteryStyleUpdate(arg0, arg1)
	local var0

	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.cattery.id == arg1 then
			var0 = iter1.cattery

			iter1:UpdateStyle(var0)
		end
	end

	if var0 and arg0.catteryDescPage:GetLoaded() and arg0.catteryDescPage:isShowing() then
		arg0.catteryDescPage:OnCatteryStyleUpdate(var0)
	end
end

function var0.OnCommanderExpChange(arg0, arg1)
	for iter0, iter1 in pairs(arg0.cards) do
		local var0 = iter1.cattery

		if var0:ExistCommander() then
			iter1:Update(var0)
		end
	end

	if arg0.catteryDescPage:GetLoaded() and arg0.catteryDescPage:isShowing() then
		arg0.catteryDescPage:FlushCatteryInfo()
	end

	arg0.awardDisplayView:ExecuteAction("AddPlan", {
		homeExp = 0,
		commanderExps = arg1,
		awards = {}
	})
end

function var0.OnCatteryOPDone(arg0)
	arg0:UpdateMain()
end

function var0.OnZeroHour(arg0)
	arg0:UpdateMain()
end

function var0.OnOpAnimtion(arg0, arg1, arg2, arg3)
	setActive(arg0.opAnim.gameObject, true)

	local var0 = ({
		"clean",
		"feed",
		"play"
	})[arg1]

	if not var0 then
		arg3()

		return
	end

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0.timer = Timer.New(function()
		arg0:CancelOpAnim()
	end, 0.8, 1)

	arg0.timer:Start()
	arg0.opAnim:SetTrigger(var0)

	for iter0, iter1 in pairs(arg0.cards) do
		if table.contains(arg2, iter1.cattery.id) then
			floatAni(iter1.char, 20, 0.1, 2)
		end
	end

	arg0.callback = arg3
end

function var0.CancelOpAnim(arg0)
	if arg0.callback then
		arg0.timer:Stop()

		arg0.timer = nil

		arg0.opAnim:SetTrigger("empty")
		arg0.callback()

		arg0.callback = nil

		setActive(arg0.opAnim.gameObject, false)
	end
end

function var0.OnDisplayAwardDone(arg0, arg1)
	arg0.awardDisplayView:ExecuteAction("AddPlan", arg1)
end

function var0.init(arg0)
	arg0.frame = arg0:findTF("bg")
	arg0.closeBtn = arg0:findTF("bg/frame/close_btn")
	arg0.levelInfoBtn = arg0:findTF("bg/frame/title/help")
	arg0.levelTxt = arg0:findTF("bg/frame/title/Text"):GetComponent(typeof(Text))
	arg0.scrollRect = arg0:findTF("bg/frame/scrollrect"):GetComponent("ScrollRect")
	arg0.scrollRectContent = arg0:findTF("bg/frame/scrollrect/content")
	arg0.batchBtn = arg0:findTF("bg/frame/batch")
	arg0.opAnim = arg0:findTF("animation"):GetComponent(typeof(Animator))
	arg0.UIlist = UIItemList.New(arg0.scrollRectContent, arg0.scrollRectContent:Find("tpl"))
	arg0.helpBtn = arg0:findTF("bg/frame/help")
	arg0.cntTxt = arg0:findTF("bg/frame/cnt/Text"):GetComponent(typeof(Text))
	arg0.cards = {}
	arg0.catteryDescPage = CatteryDescPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.levelInfoPage = CommanderHomeLevelInfoPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.awardDisplayView = CatteryOpAnimPage.New(arg0._tf, arg0.event)
	arg0.batchSelPage = CommanderHomeBatchSelPage.New(arg0._tf, arg0.event)
	arg0.flower = CatteryFlowerView.New(arg0:findTF("bg/frame/flower"))
	arg0.bubbleTF = arg0:findTF("bg/bubble")
	arg0.bubbleClean = arg0.bubbleTF:Find("clean")
	arg0.bubbleFeed = arg0.bubbleTF:Find("feed")
	arg0.bubblePlay = arg0.bubbleTF:Find("play")
end

function var0.RegisterEvent(arg0)
	arg0:bind(var0.DESC_PAGE_CLOSE, function()
		setActive(arg0.frame, true)
	end)
	arg0:bind(var0.DESC_PAGE_OPEN, function()
		setActive(arg0.frame, false)
	end)
end

function var0.didEnter(arg0)
	arg0:RegisterEvent()
	onButton(arg0, arg0.closeBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		if arg0.forbiddenClose then
			return
		end

		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0, arg0.levelInfoBtn, function()
		arg0.levelInfoPage:ExecuteAction("Show", arg0.home)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.cat_home_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.bubbleClean, function()
		arg0:CancelOpAnim()
		arg0:emit(CommanderHomeMediator.ON_CLEAN)
	end, SFX_PANEL)
	onButton(arg0, arg0.bubbleFeed, function()
		arg0:CancelOpAnim()
		arg0:emit(CommanderHomeMediator.ON_FEED)
	end, SFX_PANEL)
	onButton(arg0, arg0.bubblePlay, function()
		arg0:CancelOpAnim()
		arg0:emit(CommanderHomeMediator.ON_PLAY)
	end, SFX_PANEL)
	onButton(arg0, arg0.batchBtn, function()
		arg0.batchSelPage:ExecuteAction("Update", arg0.home)
	end, SFX_PANEL)
	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:OnUpdateItem(arg2, arg0.displays[arg1 + 1])
		end
	end)
	arg0:UpdateMain()

	arg0.UIMgr = pg.UIMgr.GetInstance()

	arg0.UIMgr:BlurPanel(arg0._tf)
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg1]

	if not var0 then
		var0 = CatteryCard.New(arg1)
		arg0.cards[arg1] = var0
	end

	onButton(arg0, var0._tf, function()
		if not var0.cattery:IsLocked() then
			arg0.catteryDescPage:ExecuteAction("Update", arg0.home, var0.cattery)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("cat_home_unlock"))
		end
	end, SFX_PANEL)
	var0:Update(arg2)
end

function var0.UpdateMain(arg0)
	arg0.levelTxt.text = "LV." .. arg0.home:GetLevel()

	arg0:InitCatteries()
	arg0.flower:Update(arg0.home)
end

function var0.InitCatteries(arg0)
	local var0 = arg0.home

	arg0.displays = {}

	local var1 = var0:GetCatteries()
	local var2 = 0
	local var3 = 0

	for iter0, iter1 in pairs(var1) do
		table.insert(arg0.displays, iter1)

		if iter1:ExistCommander() then
			var3 = var3 + 1
		end

		if not iter1:IsLocked() then
			var2 = var2 + 1
		end
	end

	arg0.UIlist:align(#arg0.displays)
	arg0:UpdateBubble()

	arg0.cntTxt.text = var3 .. "/" .. var2
end

function var0.UpdateBubble(arg0)
	local var0 = arg0.home:GetCatteries()
	local var1 = false
	local var2 = false
	local var3 = false

	for iter0, iter1 in pairs(var0) do
		if iter1:ExistCleanOP() and iter1:CommanderCanClean() then
			var1 = true
		end

		if iter1:ExiseFeedOP() and iter1:CommanderCanFeed() then
			var2 = true
		end

		if iter1:ExistPlayOP() and iter1:CommanderCanPlay() then
			var3 = true
		end
	end

	local var4 = var1 or var2 or var3

	setActive(arg0.bubbleTF, var4)

	if LeanTween.isTweening(arg0.bubbleTF.gameObject) then
		LeanTween.cancel(arg0.bubbleTF.gameObject)
	end

	if var4 then
		floatAni(arg0.bubbleTF, 20, 0.5, -1)
		setActive(arg0.bubbleClean, var1)
		setActive(arg0.bubbleFeed, var2 and not var1)
		setActive(arg0.bubblePlay, var3 and not var2)
	end
end

function var0.willExit(arg0)
	arg0.UIMgr:UnblurPanel(arg0._tf, arg0.UIMgr._normalUIMain)

	if LeanTween.isTweening(arg0.bubbleTF.gameObject) then
		LeanTween.cancel(arg0.bubbleTF.gameObject)
	end

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0.cards = nil

	arg0.flower:Dispose()

	arg0.flower = nil

	arg0.catteryDescPage:Destroy()

	arg0.catteryDescPage = nil

	arg0.levelInfoPage:Destroy()

	arg0.levelInfoPage = nil

	arg0.awardDisplayView:Destroy()
end

function var0.onBackPressed(arg0)
	if arg0.catteryDescPage:GetLoaded() and arg0.catteryDescPage:isShowing() then
		arg0.catteryDescPage:Hide()

		return
	end

	if arg0.levelInfoPage:GetLoaded() and arg0.levelInfoPage:isShowing() then
		arg0.levelInfoPage:Hide()

		return
	end

	if arg0.batchSelPage:GetLoaded() and arg0.batchSelPage:isShowing() then
		arg0.batchSelPage:Hide()
	end

	var0.super.onBackPressed(arg0)
end

return var0
