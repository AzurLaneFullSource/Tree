local var0 = class("RefluxScene", import("..base.BaseUI"))

var0.Sign = 1
var0.Task = 2
var0.PT = 3
var0.Shop = 4

function var0.getUIName(arg0)
	return "RefluxUI"
end

function var0.init(arg0)
	arg0:findUI()
	arg0:initData()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updateRedPotList()

	if not getProxy(RefluxProxy):isInRefluxTime() then
		arg0:closeView()

		return
	end

	if not arg0:tryOpenLetterView() then
		arg0:tryAutoOpenLastView()
	end

	arg0:updateDay()
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.viewList) do
		if iter1 and iter1:GetLoaded() then
			iter1:Destroy()
		end
	end

	if arg0.signView and arg0.signView:GetLoaded() then
		arg0.signView:Destroy()
	end

	if arg0.taskView and arg0.taskView:GetLoaded() then
		arg0.taskView:Destroy()
	end

	if arg0.ptView and arg0.ptView:GetLoaded() then
		arg0.ptView:Destroy()
	end

	if arg0.shopView and arg0.shopView:GetLoaded() then
		arg0.shopView:Destroy()
	end
end

function var0.onBackPressed(arg0)
	if arg0.letterView and arg0.letterView:isShowing() then
		arg0.letterView:OnBackPress()

		return
	end

	arg0:closeView()
end

function var0.findUI(arg0)
	arg0.letterContainer = arg0:findTF("PanelLetter")
	arg0.panelContainer = arg0:findTF("PanelContainer")

	local var0 = arg0:findTF("left/left_bar")

	arg0.letterBtn = arg0:findTF("letter", var0)
	arg0.signToggle = arg0:findTF("tabs/sign", var0)
	arg0.taskToggle = arg0:findTF("tabs/task", var0)
	arg0.ptToggle = arg0:findTF("tabs/pt", var0)
	arg0.shopToggle = arg0:findTF("tabs/shop", var0)
	arg0.toggleList = {
		[var0.Sign] = arg0.signToggle,
		[var0.Task] = arg0.taskToggle,
		[var0.PT] = arg0.ptToggle,
		[var0.Shop] = arg0.shopToggle
	}
	arg0.redPotList = {
		[var0.Sign] = arg0:findTF("Red", arg0.signToggle),
		[var0.Task] = arg0:findTF("Red", arg0.taskToggle),
		[var0.PT] = arg0:findTF("Red", arg0.ptToggle),
		[var0.Shop] = arg0:findTF("Red", arg0.shopToggle)
	}
	arg0.backBtn = arg0:findTF("back", var0)
	arg0.dayText = arg0:findTF("time/text")

	local var1 = arg0:findTF("time/icon")

	setText(var1, i18n("reflux_word_1"))

	local var2 = arg0:findTF("time/icon1")

	setText(var2, i18n("word_date"))
end

function var0.initData(arg0)
	arg0.curViewIndex = 0
	arg0.letterView = RefluxLetterView.New(arg0.letterContainer, arg0.event, arg0.contextData)
	arg0.signView = RefluxSignView.New(arg0.panelContainer, arg0.event, arg0.contextData)
	arg0.taskView = RefluxTaskView.New(arg0.panelContainer, arg0.event, arg0.contextData)
	arg0.ptView = RefluxPTView.New(arg0.panelContainer, arg0.event, arg0.contextData)
	arg0.shopView = RefluxShopView.New(arg0.panelContainer, arg0.event, arg0.contextData)
	arg0.viewList = {
		[var0.Sign] = arg0.signView,
		[var0.Task] = arg0.taskView,
		[var0.PT] = arg0.ptView,
		[var0.Shop] = arg0.shopView
	}
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0.letterBtn, function()
		arg0:switchLetter()
	end, SFX_PANEL)
	onToggle(arg0, arg0.signToggle, function(arg0)
		if arg0 == true then
			arg0:switchPage(var0.Sign)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.taskToggle, function(arg0)
		if arg0 == true then
			arg0:switchPage(var0.Task)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.ptToggle, function(arg0)
		if arg0 == true then
			arg0:switchPage(var0.PT)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.shopToggle, function(arg0)
		if arg0 == true then
			arg0:switchPage(var0.Shop)
			arg0:updateRedPotList()
		end
	end, SFX_PANEL)
end

function var0.tryOpenLetterView(arg0)
	local var0 = getProxy(RefluxProxy).returnTimestamp
	local var1 = getProxy(PlayerProxy):getRawData().id .. "_" .. var0

	if PlayerPrefs.GetInt(var1, 0) ~= 1 then
		PlayerPrefs.SetInt(var1, 1)
		PlayerPrefs.Save()
		arg0.letterView:ActionInvoke("setCloseFunc", function()
			triggerToggle(arg0.toggleList[var0.Sign], true)
		end)
		arg0:switchLetter()

		return true
	else
		return false
	end
end

function var0.switchPage(arg0, arg1)
	if arg0.curViewIndex ~= arg1 then
		local var0 = arg0.viewList[arg1]

		var0:Load()
		var0:ActionInvoke("Show")
		var0:ActionInvoke("updateOutline")

		if arg0.curViewIndex > 0 then
			arg0.viewList[arg0.curViewIndex]:Hide()
		end

		arg0.curViewIndex = arg1
		arg0.contextData.lastViewIndex = arg1
	end
end

function var0.tryAutoOpenLastView(arg0)
	if arg0.contextData.lastViewIndex then
		triggerToggle(arg0.toggleList[arg0.contextData.lastViewIndex], true)
	else
		triggerToggle(arg0.toggleList[var0.Sign], true)
	end
end

function var0.switchLetter(arg0)
	arg0.letterView:Load()
	arg0.letterView:ActionInvoke("Show")
end

function var0.updateRedPotList(arg0)
	local var0 = RefluxTaskView.isAnyTaskCanGetAward()
	local var1 = RefluxPTView.isAnyPTCanGetAward()
	local var2 = RefluxShopView.isShowRedPot()

	setActive(arg0.redPotList[var0.Sign], false)
	setActive(arg0.redPotList[var0.Task], var0)
	setActive(arg0.redPotList[var0.PT], var1)
	setActive(arg0.redPotList[var0.Shop], var2)
end

function var0.updateDay(arg0)
	local var0 = getProxy(RefluxProxy)
	local var1 = pg.TimeMgr.GetInstance()
	local var2 = #pg.return_sign_template.all
	local var3 = math.clamp(var1:DiffDay(var0.returnTimestamp, var1:GetServerTime()), 0, var2 - 1)

	setText(arg0.dayText, var2 - var3)
end

return var0
