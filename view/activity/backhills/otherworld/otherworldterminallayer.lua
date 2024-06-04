local var0 = class("OtherworldTerminalLayer", import("view.base.BaseUI"))

var0.PAGE_PERSONAL = 1
var0.PAGE_ADVENTURE = 2
var0.PAGE_GUARDIAN = 3

local var1 = var0.PAGE_PERSONAL

function var0.getUIName(arg0)
	return "OtherworldTerminalUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	return
end

function var0.findUI(arg0)
	arg0.windowTF = arg0:findTF("window")
	arg0.togglesTF = arg0:findTF("toggles", arg0.windowTF)
	arg0.adventureTipTF = arg0:findTF("2/tip", arg0.togglesTF)

	setText(arg0:findTF(var0.PAGE_PERSONAL .. "/Text", arg0.togglesTF), i18n("terminal_personal_title"))
	setText(arg0:findTF(var0.PAGE_ADVENTURE .. "/Text", arg0.togglesTF), i18n("terminal_adventure_title"))
	setText(arg0:findTF(var0.PAGE_GUARDIAN .. "/Text", arg0.togglesTF), i18n("terminal_guardian_title"))

	local var0 = arg0:findTF("pages", arg0.windowTF)
	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_EVENT_ID)

	if var1 and not var1:isEnd() then
		arg0.personalPage = TerminalPersonalPage.New(var0, arg0, {
			upgrade = arg0.contextData.upgrade
		})
	else
		arg0.personalPage = nil
	end

	arg0.adventurePage = TerminalAdventurePage.New(var0, arg0)
	arg0.guardianPage = TerminalGuardianPage.New(var0, arg0)
	arg0.pages = {
		[var0.PAGE_PERSONAL] = arg0.personalPage,
		[var0.PAGE_ADVENTURE] = arg0.adventurePage,
		[var0.PAGE_GUARDIAN] = arg0.guardianPage
	}
end

function var0.addListener(arg0)
	onButton(arg0, arg0:findTF("close_btn", arg0.windowTF), function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("mask"), function()
		arg0:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("help_btn", arg0.windowTF), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.otherworld_terminal_help.tip
		})
	end, SFX_CANCEL)
	eachChild(arg0.togglesTF, function(arg0)
		onToggle(arg0, arg0, function(arg0)
			if arg0 then
				local var0 = tonumber(arg0.name)

				if arg0.curPageIdx and arg0.curPageIdx == var0 then
					return
				end

				if var0 == var0.PAGE_PERSONAL and not arg0.personalPage then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0.curPageIdx = var0

				arg0:SwitchPage()
			end
		end)
	end)
end

function var0.didEnter(arg0)
	local var0 = arg0.contextData.page or var1

	if var0 == var0.PAGE_PERSONAL and not arg0.personalPage then
		var0 = var0.PAGE_ADVENTURE
	end

	triggerToggle(arg0:findTF(tostring(var0), arg0.togglesTF), true)
	arg0:UpdateAdventureTip()
end

function var0.SwitchPage(arg0)
	for iter0, iter1 in pairs(arg0.pages) do
		if iter0 == arg0.curPageIdx then
			iter1:ExecuteAction("Show")

			arg0.curPage = iter1
		else
			iter1:ExecuteAction("Hide")
		end
	end
end

function var0.UpdateAdventurePtAct(arg0, arg1)
	arg0.pages[var0.PAGE_ADVENTURE]:ExecuteAction("UpdatePt", arg1)
end

function var0.UpdateAdventureTip(arg0)
	local var0 = TerminalAdventurePage.IsTip()

	setActive(arg0.adventureTipTF, var0)
end

function var0.UpdateAdventureTaskAct(arg0, arg1)
	arg0.pages[var0.PAGE_ADVENTURE]:ExecuteAction("UpdateTask", arg1)
end

function var0.UpdateGuardianAct(arg0, arg1)
	arg0.pages[var0.PAGE_GUARDIAN]:ExecuteAction("UpdateView", arg1)
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.pages) do
		iter1:Destroy()

		iter1 = nil
	end

	if arg0.contextData.onExit then
		arg0.contextData.onExit()

		arg0.contextData.onExit = nil
	end
end

return var0
