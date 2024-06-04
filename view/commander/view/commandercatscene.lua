local var0 = class("CommanderCatScene", import("view.base.BaseUI"))

var0.MODE_VIEW = 1
var0.MODE_SELECT = 2
var0.SELECT_MODE_SINGLE = 1
var0.SELECT_MODE_MULTI = 2
var0.PAGE_PLAY = 1
var0.PAGE_TALENT = 2
var0.PAGE_DOCK = 3
var0.FLEET_TYPE_COMMON = 1
var0.FLEET_TYPE_ACTBOSS = 2
var0.FLEET_TYPE_HARD_CHAPTER = 3
var0.FLEET_TYPE_CHALLENGE = 4
var0.FLEET_TYPE_GUILDBOSS = 5
var0.FLEET_TYPE_WORLD = 6
var0.FLEET_TYPE_BOSSRUSH = 7
var0.FLEET_TYPE_LIMIT_CHALLENGE = 8
var0.FLEET_TYPE_BOSSSINGLE = 9
var0.EVENT_SELECTED = "CommanderCatScene:EVENT_SELECTED"
var0.EVENT_BACK = "CommanderCatScene:EVENT_BACK"
var0.EVENT_FOLD = "CommanderCatScene:EVENT_FOLD"
var0.EVENT_PREV_ONE = "CommanderCatScene:EVENT_PREV_ONE"
var0.EVENT_NEXT_ONE = "CommanderCatScene:EVENT_NEXT_ONE"
var0.EVENT_CLOSE_DESC = "CommanderCatScene:EVENT_CLOSE_DESC"
var0.EVENT_OPEN_DESC = "CommanderCatScene:EVENT_OPEN_DESC"
var0.EVENT_UPGRADE = "CommanderCatScene:EVENT_UPGRADE"
var0.EVENT_QUICKLY_TOOL = "CommanderCatScene:EVENT_QUICKLY_TOOL"
var0.EVENT_SWITCH_PAGE = "CommanderCatScene:EVENT_SWITCH_PAGE"
var0.EVENT_PREVIEW_PLAY = "CommanderCatScene:EVENT_PREVIEW_PLAY"
var0.EVENT_PREVIEW = "CommanderCatScene:EVENT_PREVIEW"
var0.EVENT_PREVIEW_ADDITION = "CommanderCatScene:EVENT_PREVIEW_ADDITION"
var0.MSG_RESERVE_BOX = "CommanderCatScene:MSG_RESERVE_BOX"
var0.MSG_QUICKLY_FINISH_TOOL_ERROR = "CommanderCatScene:MSG_QUICKLY_FINISH_TOOL_ERROR"
var0.MSG_UPGRADE = "CommanderCatScene:MSG_UPGRADE"
var0.MSG_LOCK = "CommanderCatScene:MSG_LOCK"
var0.MSG_RENAME = "CommanderCatScene:MSG_RENAME"
var0.MSG_FETCH_TALENT_LIST = "CommanderCatScene:MSG_FETCH_TALENT_LIST"
var0.MSG_LEARN_TALENT = "CommanderCatScene:MSG_LEARN_TALENT"
var0.MSG_UPDATE = "CommanderCatScene:MSG_UPDATE"
var0.MSG_HOME_TIP = "CommanderCatScene:MSG_HOME_TIP"
var0.MSG_BUILD = "CommanderCatScene:MSG_BUILD"
var0.MSG_OPEN_BOX = "CommanderCatScene:MSG_OPEN_BOX"
var0.MSG_BATCH_BUILD = "CommanderCatScene:MSG_BATCH_BUILD"
var0.MSG_RES_UPDATE = "CommanderCatScene:MSG_RES_UPDATE"

function var0.getUIName(arg0)
	return "CommanderCatUI"
end

function var0.init(arg0)
	arg0.bgTF = arg0:findTF("background")
	arg0.bgImg = arg0.bgTF:GetComponent(typeof(Image))
	arg0.paintingTF = arg0:findTF("painting/frame")
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.backBtn = findTF(arg0.blurPanel, "top/back_btn")
	arg0.topPanel = findTF(arg0.blurPanel, "top")
	arg0.pageContainer = findTF(arg0.blurPanel, "pages")
	arg0.leftPanel = findTF(arg0.blurPanel, "left_panel")
	arg0.eyeBtn = findTF(arg0.leftPanel, "eye")
	arg0.helpBtn = findTF(arg0.leftPanel, "help_btn")
	arg0.titles = {
		[var0.PAGE_PLAY] = findTF(arg0._tf, "blur_panel/top/title/play"),
		[var0.PAGE_TALENT] = findTF(arg0._tf, "blur_panel/top/title/talent"),
		[var0.PAGE_DOCK] = findTF(arg0._tf, "blur_panel/top/title/Text")
	}
	arg0.toggles = {
		[var0.PAGE_PLAY] = findTF(arg0.leftPanel, "toggles/play"),
		[var0.PAGE_TALENT] = findTF(arg0.leftPanel, "toggles/talent"),
		[var0.PAGE_DOCK] = findTF(arg0.leftPanel, "toggles/detail")
	}
	arg0.pages = {
		[var0.PAGE_PLAY] = CommanderCatPlayPage.New(arg0.pageContainer, arg0.event, arg0.contextData),
		[var0.PAGE_TALENT] = CommanderCatTalentPage.New(arg0.pageContainer, arg0.event, arg0.contextData),
		[var0.PAGE_DOCK] = CommanderCatDockPage.New(arg0.pageContainer, arg0.event, arg0.contextData)
	}
	arg0.detailPage = CommanderDetailPage.New(arg0.pageContainer, arg0.event, arg0.contextData)
	arg0.contextData.msgBox = CommanderMsgBoxPage.New(arg0._tf, arg0.event)
	arg0.contextData.treePanel = CommanderTreePage.New(pg.UIMgr.GetInstance().OverlayMain, arg0.event)
	arg0.commanderPaintingUtil = CommanderPaintingUtil.New(arg0.paintingTF)
	arg0.resources = {
		findTF(arg0.blurPanel, "top/res/1/Text"):GetComponent(typeof(Text)),
		findTF(arg0.blurPanel, "top/res/2/Text"):GetComponent(typeof(Text)),
		findTF(arg0.blurPanel, "top/res/3/Text"):GetComponent(typeof(Text))
	}
	arg0.goldTxt = findTF(arg0.blurPanel, "top/res/gold/Text"):GetComponent(typeof(Text))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		if arg0.pageType == var0.PAGE_PLAY or arg0.pageType == var0.PAGE_TALENT then
			triggerButton(arg0.toggles[var0.PAGE_DOCK])
		else
			arg0:emit(var0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_commander_info.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.eyeBtn, function()
		arg0:Fold()
	end, SFX_PANEL)
	addSlip(SLIP_TYPE_HRZ, arg0.bgTF, function()
		arg0:emit(CommanderCatScene.EVENT_PREV_ONE, arg0.selectedCommander.id)
	end, function()
		arg0:emit(CommanderCatScene.EVENT_NEXT_ONE, arg0.selectedCommander.id)
	end)

	arg0.contextData.mode = arg0.contextData.mode or var0.MODE_VIEW

	arg0:RegisterEvent()
	arg0:UpdateStyle()
	arg0:UpdateResources()
	arg0:UpdateGold()
	arg0:UpdateToggles()
	triggerButton(arg0.toggles[var0.PAGE_DOCK])
	setActive(arg0.toggles[var0.PAGE_DOCK], false)
end

function var0.RegisterEvent(arg0)
	arg0:bind(var0.EVENT_SELECTED, function(arg0, arg1, arg2)
		arg0:UpdateMainView(arg1, arg2)
	end)
	arg0:bind(var0.EVENT_BACK, function(arg0)
		arg0:emit(var0.ON_BACK)
	end)
	arg0:bind(var0.MSG_RESERVE_BOX, function(arg0, arg1)
		arg0:UpdateResources()
		arg0:UpdateGold()
	end)
	arg0:bind(var0.MSG_RES_UPDATE, function(arg0)
		arg0:UpdateGold()
	end)
	arg0:bind(var0.MSG_BUILD, function(arg0)
		arg0:UpdateResources()
	end)
end

function var0.UpdateStyle(arg0)
	setActive(arg0.helpBtn, var0.MODE_VIEW == arg0.contextData.mode)

	if arg0.contextData.mode == var0.MODE_SELECT then
		if arg0.contextData.maxCount > 1 then
			setActive(arg0.topPanel, false)
			onButton(arg0, go(arg0.bgTF), function()
				arg0:emit(var0.ON_BACK)
			end, SOUND_BACK)
		end

		setActive(arg0.leftPanel, false)
	end
end

function var0.UpdateResources(arg0)
	local var0 = getProxy(CommanderProxy):getPools()

	for iter0, iter1 in pairs(var0) do
		local var1 = arg0.resources[iter1.id]

		if var1 then
			var1.text = iter1:getItemCount()
		end
	end
end

function var0.UpdateGold(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	arg0.goldTxt.text = var0.gold
end

function var0.UpdateToggles(arg0)
	for iter0, iter1 in pairs(arg0.toggles) do
		onButton(arg0, iter1, function()
			if arg0.pageType then
				setActive(arg0.toggles[arg0.pageType]:Find("Image"), false)
			end

			arg0:SwitchPage(iter0)
			setActive(iter1:Find("Image"), true)
		end, SFX_PANEL)
	end
end

function var0.SwitchPage(arg0, arg1)
	if (arg1 == var0.PAGE_PLAY or arg1 == var0.PAGE_TALENT) and not arg0.selectedCommander then
		return
	end

	if arg1 == var0.PAGE_PLAY and arg0.selectedCommander.inBattle then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_battle"))

		return
	end

	if arg0.pageType then
		local var0 = arg0.pages[arg0.pageType]

		if var0:GetLoaded() then
			var0:Hide()
		end

		setActive(arg0.titles[arg0.pageType], false)
	end

	local var1 = arg0.pages[arg1]

	if arg1 == var0.PAGE_DOCK then
		var1:ExecuteAction("Show")
	else
		var1:ExecuteAction("Show", arg0.selectedCommander)
	end

	setActive(arg0.titles[arg1], true)
	arg0:CheckFirstHelp(arg1)

	arg0.pageType = arg1

	arg0:emit(var0.EVENT_SWITCH_PAGE, arg1)
end

function var0.CheckFirstHelp(arg0, arg1)
	if arg1 == var0.PAGE_PLAY then
		checkFirstHelpShow("help_commander_play")
	elseif arg1 == var0.PAGE_TALENT then
		checkFirstHelpShow("help_commander_ability")
	end
end

function var0.UpdateMainView(arg0, arg1, arg2)
	if not arg2 and arg0.selectedCommander and arg1.id == arg0.selectedCommander.id then
		return
	end

	local var0 = arg1:getPainting()

	if not arg0.paintingName or var0 ~= arg0.paintingName then
		arg0.paintingName = var0

		arg0:ReturnCommanderPainting()
		setCommanderPaintingPrefab(arg0.paintingTF, var0, "info")

		local var1 = arg0.paintingTF:Find("fitter"):GetChild(0)

		if var1 then
			var1:GetComponent(typeof(Image)).raycastTarget = false
		end
	end

	local var2 = arg1:getConfig("bg")

	if arg0.bgName ~= var2 then
		LoadSpriteAsync("bg/commander_bg_" .. var2, function(arg0)
			if arg0.exited then
				return
			end

			arg0.bgImg.sprite = arg0
		end)

		arg0.bgName = var2
	end

	arg0.detailPage:ExecuteAction("Update", arg1, arg0.contextData.mode == var0.MODE_SELECT)

	local var3 = arg1:getTalentPoint()

	if var3 > 0 then
		setText(arg0.toggles[var0.PAGE_TALENT]:Find("tip/Text"), var3)
	end

	setActive(arg0.toggles[var0.PAGE_TALENT]:Find("tip"), var3 > 0)

	arg0.selectedCommander = arg1
end

function var0.ReturnCommanderPainting(arg0)
	if arg0.selectedCommander then
		retCommanderPaintingPrefab(arg0.paintingTF, arg0.selectedCommander:getPainting())

		arg0.selectedCommander = nil
	end
end

function var0.Fold(arg0)
	if arg0.doAnimation then
		return
	end

	arg0.doAnimation = true

	arg0.commanderPaintingUtil:Fold()
	LeanTween.moveX(rtf(arg0.leftPanel), -300, 0.5)
	LeanTween.moveY(rtf(arg0.topPanel), 300, 0.5):setOnComplete(System.Action(function()
		arg0.doAnimation = false
	end))
	onButton(arg0, arg0.bgTF, function()
		arg0:UnFold()
	end, SFX_PANEL)
	arg0:emit(var0.EVENT_FOLD, true)
end

function var0.UnFold(arg0)
	if arg0.doAnimation then
		return
	end

	arg0.doAnimation = true

	removeOnButton(arg0.bgTF)
	arg0.commanderPaintingUtil:UnFold()
	LeanTween.moveX(rtf(arg0.leftPanel), 0, 0.5)
	LeanTween.moveY(rtf(arg0.topPanel), 0, 0.5):setOnComplete(System.Action(function()
		arg0.doAnimation = false
	end))
	arg0:emit(var0.EVENT_FOLD, false)
end

function var0.onBackPressed(arg0)
	if arg0.pageType and (arg0.pageType == var0.PAGE_PLAY or arg0.pageType == var0.PAGE_TALENT) then
		triggerButton(arg0.toggles[var0.PAGE_DOCK])

		return
	end

	if arg0.contextData.msgBox and arg0.contextData.msgBox:GetLoaded() and arg0.contextData.msgBox:isShowing() then
		arg0.contextData.msgBox:Hide()

		return
	end

	if arg0.contextData.treePanel and arg0.contextData.treePanel:GetLoaded() and arg0.contextData.treePanel:isShowing() then
		arg0.contextData.treePanel:Hide()

		return
	end

	if arg0.pageType and arg0.pages[arg0.pageType] then
		local var0 = arg0.pages[arg0.pageType]

		if var0.CanBack and not var0:CanBack() then
			return
		end
	end

	if arg0.detailPage and arg0.detailPage:GetLoaded() and arg0.detailPage.CanBack and not arg0.detailPage:CanBack() then
		return false
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	arg0:ReturnCommanderPainting()

	for iter0, iter1 in pairs(arg0.pages) do
		iter1:Destroy()
	end

	arg0.pages = {}

	if arg0.detailPage then
		arg0.detailPage:Destroy()

		arg0.detailPage = nil
	end

	if arg0.contextData.msgBox then
		arg0.contextData.msgBox:Destroy()

		arg0.contextData.msgBox = nil
	end

	if arg0.contextData.treePanel then
		arg0.contextData.treePanel:Destroy()

		arg0.contextData.treePanel = nil
	end
end

return var0
