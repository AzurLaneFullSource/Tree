local var0_0 = class("OtherworldTerminalLayer", import("view.base.BaseUI"))

var0_0.PAGE_PERSONAL = 1
var0_0.PAGE_ADVENTURE = 2
var0_0.PAGE_GUARDIAN = 3

local var1_0 = var0_0.PAGE_PERSONAL

function var0_0.getUIName(arg0_1)
	return "OtherworldTerminalUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	return
end

function var0_0.findUI(arg0_4)
	arg0_4.windowTF = arg0_4:findTF("window")
	arg0_4.togglesTF = arg0_4:findTF("toggles", arg0_4.windowTF)
	arg0_4.adventureTipTF = arg0_4:findTF("2/tip", arg0_4.togglesTF)

	setText(arg0_4:findTF(var0_0.PAGE_PERSONAL .. "/Text", arg0_4.togglesTF), i18n("terminal_personal_title"))
	setText(arg0_4:findTF(var0_0.PAGE_ADVENTURE .. "/Text", arg0_4.togglesTF), i18n("terminal_adventure_title"))
	setText(arg0_4:findTF(var0_0.PAGE_GUARDIAN .. "/Text", arg0_4.togglesTF), i18n("terminal_guardian_title"))

	local var0_4 = arg0_4:findTF("pages", arg0_4.windowTF)
	local var1_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_EVENT_ID)

	if var1_4 and not var1_4:isEnd() then
		arg0_4.personalPage = TerminalPersonalPage.New(var0_4, arg0_4, {
			upgrade = arg0_4.contextData.upgrade
		})
	else
		arg0_4.personalPage = nil
	end

	arg0_4.adventurePage = TerminalAdventurePage.New(var0_4, arg0_4)
	arg0_4.guardianPage = TerminalGuardianPage.New(var0_4, arg0_4)
	arg0_4.pages = {
		[var0_0.PAGE_PERSONAL] = arg0_4.personalPage,
		[var0_0.PAGE_ADVENTURE] = arg0_4.adventurePage,
		[var0_0.PAGE_GUARDIAN] = arg0_4.guardianPage
	}
end

function var0_0.addListener(arg0_5)
	onButton(arg0_5, arg0_5:findTF("close_btn", arg0_5.windowTF), function()
		arg0_5:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("mask"), function()
		arg0_5:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5:findTF("help_btn", arg0_5.windowTF), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.otherworld_terminal_help.tip
		})
	end, SFX_CANCEL)
	eachChild(arg0_5.togglesTF, function(arg0_9)
		onToggle(arg0_5, arg0_9, function(arg0_10)
			if arg0_10 then
				local var0_10 = tonumber(arg0_9.name)

				if arg0_5.curPageIdx and arg0_5.curPageIdx == var0_10 then
					return
				end

				if var0_10 == var0_0.PAGE_PERSONAL and not arg0_5.personalPage then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_5.curPageIdx = var0_10

				arg0_5:SwitchPage()
			end
		end)
	end)
end

function var0_0.didEnter(arg0_11)
	local var0_11 = arg0_11.contextData.page or var1_0

	if var0_11 == var0_0.PAGE_PERSONAL and not arg0_11.personalPage then
		var0_11 = var0_0.PAGE_ADVENTURE
	end

	triggerToggle(arg0_11:findTF(tostring(var0_11), arg0_11.togglesTF), true)
	arg0_11:UpdateAdventureTip()
end

function var0_0.SwitchPage(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.pages) do
		if iter0_12 == arg0_12.curPageIdx then
			iter1_12:ExecuteAction("Show")

			arg0_12.curPage = iter1_12
		else
			iter1_12:ExecuteAction("Hide")
		end
	end
end

function var0_0.UpdateAdventurePtAct(arg0_13, arg1_13)
	arg0_13.pages[var0_0.PAGE_ADVENTURE]:ExecuteAction("UpdatePt", arg1_13)
end

function var0_0.UpdateAdventureTip(arg0_14)
	local var0_14 = TerminalAdventurePage.IsTip()

	setActive(arg0_14.adventureTipTF, var0_14)
end

function var0_0.UpdateAdventureTaskAct(arg0_15, arg1_15)
	arg0_15.pages[var0_0.PAGE_ADVENTURE]:ExecuteAction("UpdateTask", arg1_15)
end

function var0_0.UpdateGuardianAct(arg0_16, arg1_16)
	arg0_16.pages[var0_0.PAGE_GUARDIAN]:ExecuteAction("UpdateView", arg1_16)
end

function var0_0.willExit(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.pages) do
		iter1_17:Destroy()

		iter1_17 = nil
	end

	if arg0_17.contextData.onExit then
		arg0_17.contextData.onExit()

		arg0_17.contextData.onExit = nil
	end
end

return var0_0
