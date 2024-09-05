local var0_0 = class("CommanderCatScene", import("view.base.BaseUI"))

var0_0.MODE_VIEW = 1
var0_0.MODE_SELECT = 2
var0_0.SELECT_MODE_SINGLE = 1
var0_0.SELECT_MODE_MULTI = 2
var0_0.PAGE_PLAY = 1
var0_0.PAGE_TALENT = 2
var0_0.PAGE_DOCK = 3
var0_0.FLEET_TYPE_COMMON = 1
var0_0.FLEET_TYPE_ACTBOSS = 2
var0_0.FLEET_TYPE_HARD_CHAPTER = 3
var0_0.FLEET_TYPE_CHALLENGE = 4
var0_0.FLEET_TYPE_GUILDBOSS = 5
var0_0.FLEET_TYPE_WORLD = 6
var0_0.FLEET_TYPE_BOSSRUSH = 7
var0_0.FLEET_TYPE_LIMIT_CHALLENGE = 8
var0_0.FLEET_TYPE_BOSSSINGLE = 9
var0_0.EVENT_SELECTED = "CommanderCatScene:EVENT_SELECTED"
var0_0.EVENT_BACK = "CommanderCatScene:EVENT_BACK"
var0_0.EVENT_FOLD = "CommanderCatScene:EVENT_FOLD"
var0_0.EVENT_PREV_ONE = "CommanderCatScene:EVENT_PREV_ONE"
var0_0.EVENT_NEXT_ONE = "CommanderCatScene:EVENT_NEXT_ONE"
var0_0.EVENT_CLOSE_DESC = "CommanderCatScene:EVENT_CLOSE_DESC"
var0_0.EVENT_OPEN_DESC = "CommanderCatScene:EVENT_OPEN_DESC"
var0_0.EVENT_UPGRADE = "CommanderCatScene:EVENT_UPGRADE"
var0_0.EVENT_QUICKLY_TOOL = "CommanderCatScene:EVENT_QUICKLY_TOOL"
var0_0.EVENT_SWITCH_PAGE = "CommanderCatScene:EVENT_SWITCH_PAGE"
var0_0.EVENT_PREVIEW_PLAY = "CommanderCatScene:EVENT_PREVIEW_PLAY"
var0_0.EVENT_PREVIEW = "CommanderCatScene:EVENT_PREVIEW"
var0_0.EVENT_PREVIEW_REVERSE = "CommanderCatScene:EVENT_PREVIEW_REVERSE"
var0_0.EVENT_PREVIEW_ADDITION = "CommanderCatScene:EVENT_PREVIEW_ADDITION"
var0_0.MSG_RESERVE_BOX = "CommanderCatScene:MSG_RESERVE_BOX"
var0_0.MSG_QUICKLY_FINISH_TOOL_ERROR = "CommanderCatScene:MSG_QUICKLY_FINISH_TOOL_ERROR"
var0_0.MSG_UPGRADE = "CommanderCatScene:MSG_UPGRADE"
var0_0.MSG_LOCK = "CommanderCatScene:MSG_LOCK"
var0_0.MSG_RENAME = "CommanderCatScene:MSG_RENAME"
var0_0.MSG_FETCH_TALENT_LIST = "CommanderCatScene:MSG_FETCH_TALENT_LIST"
var0_0.MSG_LEARN_TALENT = "CommanderCatScene:MSG_LEARN_TALENT"
var0_0.MSG_UPDATE = "CommanderCatScene:MSG_UPDATE"
var0_0.MSG_HOME_TIP = "CommanderCatScene:MSG_HOME_TIP"
var0_0.MSG_BUILD = "CommanderCatScene:MSG_BUILD"
var0_0.MSG_OPEN_BOX = "CommanderCatScene:MSG_OPEN_BOX"
var0_0.MSG_BATCH_BUILD = "CommanderCatScene:MSG_BATCH_BUILD"
var0_0.MSG_RES_UPDATE = "CommanderCatScene:MSG_RES_UPDATE"

function var0_0.getUIName(arg0_1)
	return "CommanderCatUI"
end

function var0_0.init(arg0_2)
	arg0_2.bgTF = arg0_2:findTF("background")
	arg0_2.bgImg = arg0_2.bgTF:GetComponent(typeof(Image))
	arg0_2.paintingTF = arg0_2:findTF("painting/frame")
	arg0_2.blurPanel = arg0_2:findTF("blur_panel")
	arg0_2.backBtn = findTF(arg0_2.blurPanel, "top/back_btn")
	arg0_2.topPanel = findTF(arg0_2.blurPanel, "top")
	arg0_2.pageContainer = findTF(arg0_2.blurPanel, "pages")
	arg0_2.leftPanel = findTF(arg0_2.blurPanel, "left_panel")
	arg0_2.eyeBtn = findTF(arg0_2.leftPanel, "eye")
	arg0_2.helpBtn = findTF(arg0_2.leftPanel, "help_btn")
	arg0_2.titles = {
		[var0_0.PAGE_PLAY] = findTF(arg0_2._tf, "blur_panel/top/title/play"),
		[var0_0.PAGE_TALENT] = findTF(arg0_2._tf, "blur_panel/top/title/talent"),
		[var0_0.PAGE_DOCK] = findTF(arg0_2._tf, "blur_panel/top/title/Text")
	}
	arg0_2.toggles = {
		[var0_0.PAGE_PLAY] = findTF(arg0_2.leftPanel, "toggles/play"),
		[var0_0.PAGE_TALENT] = findTF(arg0_2.leftPanel, "toggles/talent"),
		[var0_0.PAGE_DOCK] = findTF(arg0_2.leftPanel, "toggles/detail")
	}
	arg0_2.pages = {
		[var0_0.PAGE_PLAY] = CommanderCatPlayPage.New(arg0_2.pageContainer, arg0_2.event, arg0_2.contextData),
		[var0_0.PAGE_TALENT] = CommanderCatTalentPage.New(arg0_2.pageContainer, arg0_2.event, arg0_2.contextData),
		[var0_0.PAGE_DOCK] = CommanderCatDockPage.New(arg0_2.pageContainer, arg0_2.event, arg0_2.contextData)
	}
	arg0_2.detailPage = CommanderDetailPage.New(arg0_2.pageContainer, arg0_2.event, arg0_2.contextData)
	arg0_2.contextData.msgBox = CommanderMsgBoxPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.contextData.treePanel = CommanderTreePage.New(pg.UIMgr.GetInstance().OverlayMain, arg0_2.event)
	arg0_2.commanderPaintingUtil = CommanderPaintingUtil.New(arg0_2.paintingTF)
	arg0_2.resources = {
		findTF(arg0_2.blurPanel, "top/res/1/Text"):GetComponent(typeof(Text)),
		findTF(arg0_2.blurPanel, "top/res/2/Text"):GetComponent(typeof(Text)),
		findTF(arg0_2.blurPanel, "top/res/3/Text"):GetComponent(typeof(Text))
	}
	arg0_2.goldTxt = findTF(arg0_2.blurPanel, "top/res/gold/Text"):GetComponent(typeof(Text))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		if arg0_3.pageType == var0_0.PAGE_PLAY or arg0_3.pageType == var0_0.PAGE_TALENT then
			triggerButton(arg0_3.toggles[var0_0.PAGE_DOCK])
		else
			arg0_3:emit(var0_0.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_commander_info.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.eyeBtn, function()
		arg0_3:Fold()
	end, SFX_PANEL)
	addSlip(SLIP_TYPE_HRZ, arg0_3.bgTF, function()
		arg0_3:emit(CommanderCatScene.EVENT_PREV_ONE, arg0_3.selectedCommander.id)
	end, function()
		arg0_3:emit(CommanderCatScene.EVENT_NEXT_ONE, arg0_3.selectedCommander.id)
	end)

	arg0_3.contextData.mode = arg0_3.contextData.mode or var0_0.MODE_VIEW

	arg0_3:RegisterEvent()
	arg0_3:UpdateStyle()
	arg0_3:UpdateResources()
	arg0_3:UpdateGold()
	arg0_3:UpdateToggles()
	triggerButton(arg0_3.toggles[var0_0.PAGE_DOCK])
	setActive(arg0_3.toggles[var0_0.PAGE_DOCK], false)
end

function var0_0.RegisterEvent(arg0_9)
	arg0_9:bind(var0_0.EVENT_SELECTED, function(arg0_10, arg1_10, arg2_10)
		arg0_9:UpdateMainView(arg1_10, arg2_10)
	end)
	arg0_9:bind(var0_0.EVENT_BACK, function(arg0_11)
		arg0_9:emit(var0_0.ON_BACK)
	end)
	arg0_9:bind(var0_0.MSG_RESERVE_BOX, function(arg0_12, arg1_12)
		arg0_9:UpdateResources()
		arg0_9:UpdateGold()
	end)
	arg0_9:bind(var0_0.MSG_RES_UPDATE, function(arg0_13)
		arg0_9:UpdateGold()
	end)
	arg0_9:bind(var0_0.MSG_BUILD, function(arg0_14)
		arg0_9:UpdateResources()
	end)
end

function var0_0.UpdateStyle(arg0_15)
	setActive(arg0_15.helpBtn, var0_0.MODE_VIEW == arg0_15.contextData.mode)

	if arg0_15.contextData.mode == var0_0.MODE_SELECT then
		if arg0_15.contextData.maxCount > 1 then
			setActive(arg0_15.topPanel, false)
			onButton(arg0_15, go(arg0_15.bgTF), function()
				arg0_15:emit(var0_0.ON_BACK)
			end, SOUND_BACK)
		end

		setActive(arg0_15.leftPanel, false)
	end
end

function var0_0.UpdateResources(arg0_17)
	local var0_17 = getProxy(CommanderProxy):getPools()

	for iter0_17, iter1_17 in pairs(var0_17) do
		local var1_17 = arg0_17.resources[iter1_17.id]

		if var1_17 then
			var1_17.text = iter1_17:getItemCount()
		end
	end
end

function var0_0.UpdateGold(arg0_18)
	local var0_18 = getProxy(PlayerProxy):getRawData()

	arg0_18.goldTxt.text = var0_18.gold
end

function var0_0.UpdateToggles(arg0_19)
	for iter0_19, iter1_19 in pairs(arg0_19.toggles) do
		onButton(arg0_19, iter1_19, function()
			if arg0_19.pageType then
				setActive(arg0_19.toggles[arg0_19.pageType]:Find("Image"), false)
			end

			arg0_19:SwitchPage(iter0_19)
			setActive(iter1_19:Find("Image"), true)
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPage(arg0_21, arg1_21)
	if (arg1_21 == var0_0.PAGE_PLAY or arg1_21 == var0_0.PAGE_TALENT) and not arg0_21.selectedCommander then
		return
	end

	if arg1_21 == var0_0.PAGE_PLAY and arg0_21.selectedCommander.inBattle then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_battle"))

		return
	end

	if arg0_21.pageType then
		local var0_21 = arg0_21.pages[arg0_21.pageType]

		if var0_21:GetLoaded() then
			var0_21:Hide()
		end

		setActive(arg0_21.titles[arg0_21.pageType], false)
	end

	local var1_21 = arg0_21.pages[arg1_21]

	if arg1_21 == var0_0.PAGE_DOCK then
		var1_21:ExecuteAction("Show")
	else
		var1_21:ExecuteAction("Show", arg0_21.selectedCommander)
	end

	setActive(arg0_21.titles[arg1_21], true)
	arg0_21:CheckFirstHelp(arg1_21)

	arg0_21.pageType = arg1_21

	arg0_21:emit(var0_0.EVENT_SWITCH_PAGE, arg1_21)
end

function var0_0.CheckFirstHelp(arg0_22, arg1_22)
	if arg1_22 == var0_0.PAGE_PLAY then
		checkFirstHelpShow("help_commander_play")
	elseif arg1_22 == var0_0.PAGE_TALENT then
		checkFirstHelpShow("help_commander_ability")
	end
end

function var0_0.UpdateMainView(arg0_23, arg1_23, arg2_23)
	if not arg2_23 and arg0_23.selectedCommander and arg1_23.id == arg0_23.selectedCommander.id then
		return
	end

	local var0_23 = arg1_23:getPainting()

	if not arg0_23.paintingName or var0_23 ~= arg0_23.paintingName then
		arg0_23.paintingName = var0_23

		arg0_23:ReturnCommanderPainting()
		setCommanderPaintingPrefab(arg0_23.paintingTF, var0_23, "info")

		local var1_23 = arg0_23.paintingTF:Find("fitter"):GetChild(0)

		if var1_23 then
			var1_23:GetComponent(typeof(Image)).raycastTarget = false
		end
	end

	local var2_23 = arg1_23:getConfig("bg")

	if arg0_23.bgName ~= var2_23 then
		LoadSpriteAsync("bg/commander_bg_" .. var2_23, function(arg0_24)
			if arg0_23.exited then
				return
			end

			arg0_23.bgImg.sprite = arg0_24
		end)

		arg0_23.bgName = var2_23
	end

	arg0_23.detailPage:ExecuteAction("Update", arg1_23, arg0_23.contextData.mode == var0_0.MODE_SELECT)

	local var3_23 = arg1_23:getTalentPoint()

	if var3_23 > 0 then
		setText(arg0_23.toggles[var0_0.PAGE_TALENT]:Find("tip/Text"), var3_23)
	end

	setActive(arg0_23.toggles[var0_0.PAGE_TALENT]:Find("tip"), var3_23 > 0)

	arg0_23.selectedCommander = arg1_23
end

function var0_0.ReturnCommanderPainting(arg0_25)
	if arg0_25.selectedCommander then
		retCommanderPaintingPrefab(arg0_25.paintingTF, arg0_25.selectedCommander:getPainting())

		arg0_25.selectedCommander = nil
	end
end

function var0_0.Fold(arg0_26)
	if arg0_26.doAnimation then
		return
	end

	arg0_26.doAnimation = true

	arg0_26.commanderPaintingUtil:Fold()
	LeanTween.moveX(rtf(arg0_26.leftPanel), -300, 0.5)
	LeanTween.moveY(rtf(arg0_26.topPanel), 300, 0.5):setOnComplete(System.Action(function()
		arg0_26.doAnimation = false
	end))
	onButton(arg0_26, arg0_26.bgTF, function()
		arg0_26:UnFold()
	end, SFX_PANEL)
	arg0_26:emit(var0_0.EVENT_FOLD, true)
end

function var0_0.UnFold(arg0_29)
	if arg0_29.doAnimation then
		return
	end

	arg0_29.doAnimation = true

	removeOnButton(arg0_29.bgTF)
	arg0_29.commanderPaintingUtil:UnFold()
	LeanTween.moveX(rtf(arg0_29.leftPanel), 0, 0.5)
	LeanTween.moveY(rtf(arg0_29.topPanel), 0, 0.5):setOnComplete(System.Action(function()
		arg0_29.doAnimation = false
	end))
	arg0_29:emit(var0_0.EVENT_FOLD, false)
end

function var0_0.onBackPressed(arg0_31)
	if arg0_31.pageType and (arg0_31.pageType == var0_0.PAGE_PLAY or arg0_31.pageType == var0_0.PAGE_TALENT) then
		triggerButton(arg0_31.toggles[var0_0.PAGE_DOCK])

		return
	end

	if arg0_31.contextData.msgBox and arg0_31.contextData.msgBox:GetLoaded() and arg0_31.contextData.msgBox:isShowing() then
		arg0_31.contextData.msgBox:Hide()

		return
	end

	if arg0_31.contextData.treePanel and arg0_31.contextData.treePanel:GetLoaded() and arg0_31.contextData.treePanel:isShowing() then
		arg0_31.contextData.treePanel:Hide()

		return
	end

	if arg0_31.pageType and arg0_31.pages[arg0_31.pageType] then
		local var0_31 = arg0_31.pages[arg0_31.pageType]

		if var0_31.CanBack and not var0_31:CanBack() then
			return
		end
	end

	if arg0_31.detailPage and arg0_31.detailPage:GetLoaded() and arg0_31.detailPage.CanBack and not arg0_31.detailPage:CanBack() then
		return false
	end

	var0_0.super.onBackPressed(arg0_31)
end

function var0_0.willExit(arg0_32)
	arg0_32:ReturnCommanderPainting()

	for iter0_32, iter1_32 in pairs(arg0_32.pages) do
		iter1_32:Destroy()
	end

	arg0_32.pages = {}

	if arg0_32.detailPage then
		arg0_32.detailPage:Destroy()

		arg0_32.detailPage = nil
	end

	if arg0_32.contextData.msgBox then
		arg0_32.contextData.msgBox:Destroy()

		arg0_32.contextData.msgBox = nil
	end

	if arg0_32.contextData.treePanel then
		arg0_32.contextData.treePanel:Destroy()

		arg0_32.contextData.treePanel = nil
	end
end

return var0_0
