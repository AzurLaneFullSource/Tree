local var0_0 = class("RefluxScene", import("..base.BaseUI"))

var0_0.Sign = 1
var0_0.Task = 2
var0_0.PT = 3
var0_0.Shop = 4

function var0_0.getUIName(arg0_1)
	return "RefluxUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local function var0_2()
		arg1_2()
	end

	if getProxy(ShopsProxy):ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = var0_2
		})
	else
		var0_2()
	end
end

function var0_0.init(arg0_4)
	arg0_4:findUI()
	arg0_4:initData()
	arg0_4:addListener()
end

function var0_0.didEnter(arg0_5)
	arg0_5:updateRedPotList()

	if not getProxy(RefluxProxy):isInRefluxTime() then
		arg0_5:closeView()

		return
	end

	if not arg0_5:tryOpenLetterView() then
		arg0_5:tryAutoOpenLastView()
	end

	arg0_5:updateDay()
	arg0_5:OverlayPanel(arg0_5._tf)
end

function var0_0.willExit(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.viewList) do
		if iter1_6 and iter1_6:GetLoaded() then
			iter1_6:Destroy()
		end
	end

	if arg0_6.letterView then
		arg0_6.letterView:Destroy()

		arg0_6.letterView = nil

		return
	end

	arg0_6:UnOverlayPanel(arg0_6._tf, arg0_6._parentTf)
end

function var0_0.onBackPressed(arg0_7)
	if arg0_7.letterView and arg0_7.letterView:isShowing() then
		arg0_7.letterView:Hide()

		arg0_7.letterView = nil

		return
	end

	arg0_7:closeView()
end

function var0_0.findUI(arg0_8)
	arg0_8.letterContainer = arg0_8._tf:Find("PanelLetter")
	arg0_8.panelContainer = arg0_8._tf:Find("PanelContainer")

	local var0_8 = arg0_8._tf:Find("left/left_bar")

	arg0_8.letterBtn = var0_8:Find("letter")
	arg0_8.signToggle = var0_8:Find("tabs/sign")
	arg0_8.taskToggle = var0_8:Find("tabs/task")
	arg0_8.ptToggle = var0_8:Find("tabs/pt")
	arg0_8.shopToggle = var0_8:Find("tabs/shop")
	arg0_8.toggleList = {
		[var0_0.Sign] = arg0_8.signToggle,
		[var0_0.Task] = arg0_8.taskToggle,
		[var0_0.PT] = arg0_8.ptToggle,
		[var0_0.Shop] = arg0_8.shopToggle
	}
	arg0_8.redPotList = {
		[var0_0.Sign] = arg0_8.signToggle:Find("Red"),
		[var0_0.Task] = arg0_8.taskToggle:Find("Red"),
		[var0_0.PT] = arg0_8.ptToggle:Find("Red"),
		[var0_0.Shop] = arg0_8.shopToggle:Find("Red")
	}
	arg0_8.backBtn = var0_8:Find("back")
	arg0_8.dayText = arg0_8._tf:Find("time/text")

	local var1_8 = arg0_8._tf:Find("time/icon")

	setText(var1_8, i18n("reflux_word_1"))

	local var2_8 = arg0_8._tf:Find("time/icon1")

	setText(var2_8, i18n("word_date"))
end

function var0_0.initData(arg0_9)
	arg0_9.curViewIndex = 0
	arg0_9.letterView = RefluxAnimationPlayer.New(pg.UIMgr.GetInstance().OverlayUITop)
	arg0_9.signView = RefluxSignView.New(arg0_9.panelContainer, arg0_9.event, arg0_9.contextData)
	arg0_9.taskView = RefluxTaskView.New(arg0_9.panelContainer, arg0_9.event, arg0_9.contextData)
	arg0_9.ptView = RefluxPTView.New(arg0_9.panelContainer, arg0_9.event, arg0_9.contextData)
	arg0_9.shopView = RefluxShopView.New(arg0_9.panelContainer, arg0_9.event, arg0_9.contextData)
	arg0_9.viewList = {
		[var0_0.Sign] = arg0_9.signView,
		[var0_0.Task] = arg0_9.taskView,
		[var0_0.PT] = arg0_9.ptView,
		[var0_0.Shop] = arg0_9.shopView
	}
end

function var0_0.addListener(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.letterBtn, function()
		arg0_10:switchLetter()
	end, SFX_PANEL)
	onToggle(arg0_10, arg0_10.signToggle, function(arg0_13)
		if arg0_13 == true then
			arg0_10:switchPage(var0_0.Sign)
		end
	end, SFX_PANEL)
	onToggle(arg0_10, arg0_10.taskToggle, function(arg0_14)
		if arg0_14 == true then
			arg0_10:switchPage(var0_0.Task)
		end
	end, SFX_PANEL)
	onToggle(arg0_10, arg0_10.ptToggle, function(arg0_15)
		if arg0_15 == true then
			arg0_10:switchPage(var0_0.PT)
		end
	end, SFX_PANEL)
	onToggle(arg0_10, arg0_10.shopToggle, function(arg0_16)
		if arg0_16 == true then
			arg0_10:switchPage(var0_0.Shop)
			arg0_10:updateRedPotList()
		end
	end, SFX_PANEL)
end

function var0_0.tryOpenLetterView(arg0_17)
	return false
end

function var0_0.switchPage(arg0_18, arg1_18)
	if arg0_18.curViewIndex ~= arg1_18 then
		local var0_18 = arg0_18.viewList[arg1_18]

		var0_18:Load()
		var0_18:ActionInvoke("Show")
		var0_18:ActionInvoke("updateOutline")

		if arg0_18.curViewIndex > 0 then
			arg0_18.viewList[arg0_18.curViewIndex]:Hide()
		end

		arg0_18.curViewIndex = arg1_18
		arg0_18.contextData.lastViewIndex = arg1_18
	end
end

function var0_0.tryAutoOpenLastView(arg0_19)
	if arg0_19.contextData.lastViewIndex then
		triggerToggle(arg0_19.toggleList[arg0_19.contextData.lastViewIndex], true)
	else
		triggerToggle(arg0_19.toggleList[var0_0.Sign], true)
	end
end

function var0_0.switchLetter(arg0_20)
	local var0_20 = getProxy(RefluxProxy):GetRefluxBgs()

	arg0_20.letterView:ExecuteAction("Play4Review", var0_20, function()
		arg0_20.letterView:Hide()
	end)
end

function var0_0.updateRedPotList(arg0_22)
	local var0_22 = RefluxTaskView.isAnyTaskCanGetAward()
	local var1_22 = RefluxPTView.isAnyPTCanGetAward()
	local var2_22 = RefluxShopView.isShowRedPot()

	setActive(arg0_22.redPotList[var0_0.Sign], false)
	setActive(arg0_22.redPotList[var0_0.Task], var0_22)
	setActive(arg0_22.redPotList[var0_0.PT], var1_22)
	setActive(arg0_22.redPotList[var0_0.Shop], var2_22)
end

function var0_0.updateDay(arg0_23)
	local var0_23 = getProxy(RefluxProxy)
	local var1_23 = pg.TimeMgr.GetInstance()
	local var2_23 = #pg.return_sign_template.all
	local var3_23 = math.clamp(var1_23:DiffDay(var0_23.returnTimestamp, var1_23:GetServerTime()), 0, var2_23 - 1)

	setText(arg0_23.dayText, var2_23 - var3_23)
end

return var0_0
