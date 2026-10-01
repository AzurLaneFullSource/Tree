local var0_0 = class("RefluxScene", import("..base.BaseUI"))

var0_0.Sign = 1
var0_0.Task = 2
var0_0.PT = 3
var0_0.Shop = 4

function var0_0.getUIName(arg0_1)
	return "RefluxUI"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updateRedPotList()

	if not getProxy(RefluxProxy):isInRefluxTime() then
		arg0_3:closeView()

		return
	end

	if not arg0_3:tryOpenLetterView() then
		arg0_3:tryAutoOpenLastView()
	end

	arg0_3:updateDay()
	arg0_3:OverlayPanel(arg0_3._tf)
end

function var0_0.willExit(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.viewList) do
		if iter1_4 and iter1_4:GetLoaded() then
			iter1_4:Destroy()
		end
	end

	if arg0_4.letterView then
		arg0_4.letterView:Destroy()

		arg0_4.letterView = nil

		return
	end

	arg0_4:UnOverlayPanel(arg0_4._tf, arg0_4._parentTf)
end

function var0_0.onBackPressed(arg0_5)
	if arg0_5.letterView and arg0_5.letterView:isShowing() then
		arg0_5.letterView:Hide()

		arg0_5.letterView = nil

		return
	end

	arg0_5:closeView()
end

function var0_0.findUI(arg0_6)
	arg0_6.letterContainer = arg0_6._tf:Find("PanelLetter")
	arg0_6.panelContainer = arg0_6._tf:Find("PanelContainer")

	local var0_6 = arg0_6._tf:Find("left/left_bar")

	arg0_6.letterBtn = var0_6:Find("letter")
	arg0_6.signToggle = var0_6:Find("tabs/sign")
	arg0_6.taskToggle = var0_6:Find("tabs/task")
	arg0_6.ptToggle = var0_6:Find("tabs/pt")
	arg0_6.shopToggle = var0_6:Find("tabs/shop")
	arg0_6.toggleList = {
		[var0_0.Sign] = arg0_6.signToggle,
		[var0_0.Task] = arg0_6.taskToggle,
		[var0_0.PT] = arg0_6.ptToggle,
		[var0_0.Shop] = arg0_6.shopToggle
	}
	arg0_6.redPotList = {
		[var0_0.Sign] = arg0_6.signToggle:Find("Red"),
		[var0_0.Task] = arg0_6.taskToggle:Find("Red"),
		[var0_0.PT] = arg0_6.ptToggle:Find("Red"),
		[var0_0.Shop] = arg0_6.shopToggle:Find("Red")
	}
	arg0_6.backBtn = var0_6:Find("back")
	arg0_6.dayText = arg0_6._tf:Find("time/text")

	local var1_6 = arg0_6._tf:Find("time/icon")

	setText(var1_6, i18n("reflux_word_1"))

	local var2_6 = arg0_6._tf:Find("time/icon1")

	setText(var2_6, i18n("word_date"))
end

function var0_0.initData(arg0_7)
	arg0_7.curViewIndex = 0
	arg0_7.letterView = RefluxAnimationPlayer.New(pg.UIMgr.GetInstance().OverlayUITop)
	arg0_7.signView = RefluxSignView.New(arg0_7.panelContainer, arg0_7.event, arg0_7.contextData)
	arg0_7.taskView = RefluxTaskView.New(arg0_7.panelContainer, arg0_7.event, arg0_7.contextData)
	arg0_7.ptView = RefluxPTView.New(arg0_7.panelContainer, arg0_7.event, arg0_7.contextData)
	arg0_7.shopView = RefluxShopView.New(arg0_7.panelContainer, arg0_7.event, arg0_7.contextData)
	arg0_7.viewList = {
		[var0_0.Sign] = arg0_7.signView,
		[var0_0.Task] = arg0_7.taskView,
		[var0_0.PT] = arg0_7.ptView,
		[var0_0.Shop] = arg0_7.shopView
	}
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.letterBtn, function()
		arg0_8:switchLetter()
	end, SFX_PANEL)
	onToggle(arg0_8, arg0_8.signToggle, function(arg0_11)
		if arg0_11 == true then
			arg0_8:switchPage(var0_0.Sign)
		end
	end, SFX_PANEL)
	onToggle(arg0_8, arg0_8.taskToggle, function(arg0_12)
		if arg0_12 == true then
			arg0_8:switchPage(var0_0.Task)
		end
	end, SFX_PANEL)
	onToggle(arg0_8, arg0_8.ptToggle, function(arg0_13)
		if arg0_13 == true then
			arg0_8:switchPage(var0_0.PT)
		end
	end, SFX_PANEL)
	onToggle(arg0_8, arg0_8.shopToggle, function(arg0_14)
		if arg0_14 == true then
			arg0_8:switchPage(var0_0.Shop)
			arg0_8:updateRedPotList()
		end
	end, SFX_PANEL)
end

function var0_0.tryOpenLetterView(arg0_15)
	return false
end

function var0_0.switchPage(arg0_16, arg1_16)
	if arg0_16.curViewIndex ~= arg1_16 then
		local var0_16 = arg0_16.viewList[arg1_16]

		var0_16:Load()
		var0_16:ActionInvoke("Show")
		var0_16:ActionInvoke("updateOutline")

		if arg0_16.curViewIndex > 0 then
			arg0_16.viewList[arg0_16.curViewIndex]:Hide()
		end

		arg0_16.curViewIndex = arg1_16
		arg0_16.contextData.lastViewIndex = arg1_16
	end
end

function var0_0.tryAutoOpenLastView(arg0_17)
	if arg0_17.contextData.lastViewIndex then
		triggerToggle(arg0_17.toggleList[arg0_17.contextData.lastViewIndex], true)
	else
		triggerToggle(arg0_17.toggleList[var0_0.Sign], true)
	end
end

function var0_0.switchLetter(arg0_18)
	local var0_18 = getProxy(RefluxProxy):GetRefluxBgs()

	arg0_18.letterView:ExecuteAction("Play4Review", var0_18, function()
		arg0_18.letterView:Hide()
	end)
end

function var0_0.updateRedPotList(arg0_20)
	local var0_20 = RefluxTaskView.isAnyTaskCanGetAward()
	local var1_20 = RefluxPTView.isAnyPTCanGetAward()
	local var2_20 = RefluxShopView.isShowRedPot()

	setActive(arg0_20.redPotList[var0_0.Sign], false)
	setActive(arg0_20.redPotList[var0_0.Task], var0_20)
	setActive(arg0_20.redPotList[var0_0.PT], var1_20)
	setActive(arg0_20.redPotList[var0_0.Shop], var2_20)
end

function var0_0.updateDay(arg0_21)
	local var0_21 = getProxy(RefluxProxy)
	local var1_21 = pg.TimeMgr.GetInstance()
	local var2_21 = #pg.return_sign_template.all
	local var3_21 = math.clamp(var1_21:DiffDay(var0_21.returnTimestamp, var1_21:GetServerTime()), 0, var2_21 - 1)

	setText(arg0_21.dayText, var2_21 - var3_21)
end

return var0_0
