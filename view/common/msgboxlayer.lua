local var0 = class("MsgboxLayer", import("view.base.BaseUI"))
local var1 = require("Mgr.const.MsgboxBtnNameMap")

var0.BUTTON_BLUE = 1
var0.BUTTON_GRAY = 2
var0.BUTTON_RED = 3
var0.BUTTON_MEDAL = 4
var0.BUTTON_RETREAT = 5
var0.BUTTON_PREPAGE = 6
var0.BUTTON_NEXTPAGE = 7
var0.BUTTON_BLUE_WITH_ICON = 8
var0.TITLE_INFORMATION = "infomation"
var0.TITLE_SETTING = "setting"
var0.TITLE_WARNING = "warning"
var0.TITLE_OBTAIN = "obtain"
var0.TITLE_CADPA = "cadpa"
var0.TEXT_CANCEL = "text_cancel"
var0.TEXT_CONFIRM = "text_confirm"

function var0.getUIName(arg0)
	return "MsgBoxUI"
end

function var0.init(arg0)
	arg0._window = arg0._tf:Find("window")

	setActive(arg0._window, true)

	arg0._top = arg0._window:Find("top")
	arg0._titleList = arg0._top:Find("bg")
	arg0._closeBtn = arg0._top:Find("btnBack")

	setText(arg0._titleList:Find("infomation/title"), i18n("words_information"))
	setText(arg0._titleList:Find("cadpa/title"), i18n("cadpa_tip1"))

	arg0._res = arg0._tf:Find("res")
	arg0._msgPanel = arg0._window:Find("msg_panel")
	arg0.contentText = arg0._msgPanel:Find("content"):GetComponent("RichText")

	arg0.contentText:AddSprite("diamond", arg0._res:Find("diamond"):GetComponent(typeof(Image)).sprite)
	arg0.contentText:AddSprite("gold", arg0._res:Find("gold"):GetComponent(typeof(Image)).sprite)
	arg0.contentText:AddSprite("oil", arg0._res:Find("oil"):GetComponent(typeof(Image)).sprite)
	arg0.contentText:AddSprite("world_money", arg0._res:Find("world_money"):GetComponent(typeof(Image)).sprite)
	arg0.contentText:AddSprite("port_money", arg0._res:Find("port_money"):GetComponent(typeof(Image)).sprite)
	arg0.contentText:AddSprite("guildicon", arg0._res:Find("guildicon"):GetComponent(typeof(Image)).sprite)

	arg0._exchangeShipPanel = arg0._window:Find("exchange_ship_panel")
	arg0._itemPanel = arg0._window:Find("item_panel")
	arg0._itemText = arg0._itemPanel:Find("Text"):GetComponent(typeof(Text))
	arg0._itemListItemContainer = arg0._itemPanel:Find("scrollview/list")
	arg0._itemListItemTpl = arg0._itemListItemContainer:Find("item")
	arg0._eskinPanel = arg0._window:Find("eskin_panel")
	arg0._eskinText = arg0._eskinPanel:Find("Text"):GetComponent(typeof(Text))
	arg0._eskinListItemContainer = arg0._eskinPanel:Find("scrollview/list")
	arg0._eskinListItemTpl = arg0._eskinListItemContainer:Find("item")
	arg0._sigleItemPanel = arg0._window:Find("single_item_panel")
	arg0._singleItemshipTypeTF = arg0._sigleItemPanel:Find("display_panel/name_container/shiptype")
	arg0.singleItemIntro = arg0._sigleItemPanel:Find("display_panel/desc/Text")

	local var0 = arg0.singleItemIntro:GetComponent("RichText")

	var0:AddSprite("diamond", arg0._res:Find("diamond"):GetComponent(typeof(Image)).sprite)
	var0:AddSprite("gold", arg0._res:Find("gold"):GetComponent(typeof(Image)).sprite)
	var0:AddSprite("oil", arg0._res:Find("oil"):GetComponent(typeof(Image)).sprite)
	var0:AddSprite("world_money", arg0._res:Find("world_money"):GetComponent(typeof(Image)).sprite)
	var0:AddSprite("port_money", arg0._res:Find("port_money"):GetComponent(typeof(Image)).sprite)
	var0:AddSprite("world_boss", arg0._res:Find("world_boss"):GetComponent(typeof(Image)).sprite)

	arg0._singleItemSubIntroTF = arg0._sigleItemPanel:Find("sub_intro")

	setText(arg0._sigleItemPanel:Find("ship_group/locked/Text"), i18n("tag_ship_locked"))
	setText(arg0._sigleItemPanel:Find("ship_group/unlocked/Text"), i18n("tag_ship_unlocked"))

	arg0._inputPanel = arg0._window:Find("input_panel")
	arg0._inputTitle = arg0._inputPanel:Find("label"):GetComponent(typeof(Text))
	arg0._inputTF = arg0._inputPanel:Find("InputField")
	arg0._inputField = arg0._inputTF:GetComponent(typeof(InputField))
	arg0._placeholderTF = arg0._inputTF:Find("Placeholder"):GetComponent(typeof(Text))
	arg0._inputConfirmBtn = arg0._inputPanel:Find("btns/confirm_btn")
	arg0._inputCancelBtn = arg0._inputPanel:Find("btns/cancel_btn")
	arg0._helpPanel = arg0._window:Find("help_panel")
	arg0._helpBgTF = arg0._tf:Find("bg_help")
	arg0._helpList = arg0._helpPanel:Find("list")
	arg0._helpTpl = arg0._helpPanel:Find("list/help_tpl")
	arg0._worldResetPanel = arg0._window:Find("world_reset_panel")
	arg0._worldShopBtn = arg0._window:Find("world_shop_btn")
	arg0._remasterPanel = arg0._window:Find("remaster_info")
	arg0._obtainPanel = arg0._window:Find("obtain_panel")
	arg0._otherPanel = arg0._window:Find("other_panel")
	arg0._countSelect = arg0._window:Find("count_select")
	arg0._pageUtil = PageUtil.New(arg0._countSelect:Find("value_bg/left"), arg0._countSelect:Find("value_bg/right"), arg0._countSelect:Find("max"), arg0._countSelect:Find("value_bg/value"))
	arg0._countDescTxt = arg0._countSelect:Find("desc_txt")
	arg0._sliders = arg0._window:Find("sliders")
	arg0._discountInfo = arg0._sliders:Find("discountInfo")
	arg0._discountDate = arg0._sliders:Find("discountDate")
	arg0._discount = arg0._sliders:Find("discountInfo/discount")
	arg0._strike = arg0._sliders:Find("strike")
	arg0.stopRemindToggle = arg0._window:Find("stopRemind"):GetComponent(typeof(Toggle))
	arg0.stopRemindText = tf(arg0.stopRemindToggle.gameObject):Find("Label"):GetComponent(typeof(Text))
	arg0._btnContainer = arg0._window:Find("button_container")
	arg0._defaultSize = Vector2(930, 620)
	arg0._defaultHelpSize = Vector2(870, 480)
	arg0._defaultHelpPos = Vector2(0, -40)
	arg0.pools = {}
	arg0.panelDict = {}
	arg0.timers = {}
end

function var0.didEnter(arg0)
	arg0:showMsgBox(arg0.contextData)
end

function var0.showMsgBox(arg0, arg1)
	local var0 = arg1.type or MSGBOX_TYPE_NORMAL

	switch(var0, {
		[MSGBOX_TYPE_NORMAL] = function()
			arg0:showNormalMsgBox(arg1)
		end,
		[MSGBOX_TYPE_HELP] = function()
			arg1.hideNo = defaultValue(arg1.hideNo, true)
			arg1.hideYes = defaultValue(arg1.hideYes, true)

			arg0:showHelpWindow(arg1)
		end
	})
end

function var0.showNormalMsgBox(arg0, arg1)
	arg0:commonSetting(arg1)
	SetActive(arg0._msgPanel, true)

	arg0.contentText.alignment = arg0.settings.alignment or TextAnchor.MiddleCenter
	arg0.contentText.fontSize = arg0.settings.fontSize or 36
	arg0.contentText.text = arg0.settings.content or ""

	arg0:Loaded(arg1)
end

function var0.showHelpWindow(arg0, arg1)
	arg0:commonSetting(arg1)
	setActive(findTF(arg0._helpPanel, "bg"), not arg1.helps.pageMode)
	setActive(arg0._helpBgTF, arg1.helps.pageMode)
	setActive(arg0._helpPanel:Find("btn_blueprint"), arg1.show_blueprint)

	if arg1.show_blueprint then
		onButton(arg0, arg0._helpPanel:Find("btn_blueprint"), function()
			arg0:hide()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT, {
				shipGroupId = arg1.show_blueprint
			})
		end, SFX_PANEL)
	end

	if arg1.helps.helpSize then
		arg0._helpPanel.sizeDelta = Vector2(arg1.helps.helpSize.x or arg0._defaultHelpSize.x, arg1.helps.helpSize.y or arg0._defaultHelpSize.y)
	end

	if arg1.helps.helpPos then
		setAnchoredPosition(arg0._helpPanel, {
			x = arg1.helps.helpPos.x or arg0._defaultHelpPos.x,
			y = arg1.helps.helpPos.y or arg0._defaultHelpPos.y
		})
	end

	if arg1.helps.windowSize then
		arg0._window.sizeDelta = Vector2(arg1.helps.windowSize.x or arg0._defaultSize.x, arg1.helps.windowSize.y or arg0._defaultSize.y)
	end

	if arg1.helps.windowPos then
		arg0._window.sizeDelta = Vector2(arg1.helps.windowSize.x or arg0._defaultSize.x, arg1.helps.windowSize.y or arg0._defaultSize.y)

		setAnchoredPosition(arg0._window, {
			x = arg1.helps.windowPos.x or 0,
			y = arg1.helps.windowPos.y or 0
		})
	else
		setAnchoredPosition(arg0._window, {
			x = 0,
			y = 0
		})
	end

	if arg1.helps.buttonsHeight then
		setAnchoredPosition(arg0._btnContainer, {
			y = arg1.helps.buttonsHeight
		})
	end

	if arg1.helps.disableScroll then
		local var0 = arg0._helpPanel:Find("list")

		SetCompomentEnabled(arg0._helpPanel:Find("list"), typeof(ScrollRect), not arg1.helps.disableScroll)
		setAnchoredPosition(var0, Vector2.zero)
		setActive(findTF(arg0._helpPanel, "Scrollbar"), false)
	end

	if arg1.helps.ImageMode then
		setActive(arg0._top, false)
		setActive(findTF(arg0._window, "bg"), false)
	end

	local var1 = arg0.settings.helps

	for iter0 = #var1, arg0._helpList.childCount - 1 do
		Destroy(arg0._helpList:GetChild(iter0))
	end

	for iter1 = arg0._helpList.childCount, #var1 - 1 do
		cloneTplTo(arg0._helpTpl, arg0._helpList)
	end

	for iter2, iter3 in ipairs(var1) do
		local var2 = arg0._helpList:GetChild(iter2 - 1)

		setActive(var2, true)

		local var3 = var2:Find("icon")

		setActive(var3, iter3.icon)
		setActive(findTF(var2, "line"), iter3.line)

		if iter3.icon then
			local var4 = 1

			if arg1.helps.ImageMode then
				var4 = 1.5
			end

			var3.transform.localScale = Vector2(iter3.icon.scale or var4, iter3.icon.scale or var4)

			local var5 = iter3.icon.path
			local var6 = iter3.icon.posX and iter3.icon.posX or -20
			local var7 = iter3.icon.posY and iter3.icon.posY or 0
			local var8 = LoadSprite(iter3.icon.atlas, iter3.icon.path)

			setImageSprite(var3:GetComponent(typeof(Image)), var8, true)
			setAnchoredPosition(var3, {
				x = var6,
				y = var7
			})
			setActive(var3:Find("corner"), arg1.helps.pageMode)
		end

		local var9 = var2:Find("richText"):GetComponent("RichText")

		if iter3.rawIcon then
			local var10 = iter3.rawIcon.name

			var9:AddSprite(var10, GetSpriteFromAtlas(iter3.rawIcon.atlas, var10))

			local var11 = HXSet.hxLan(iter3.info or "")

			setText(var2, "")

			var9.text = string.format("<icon name=%s w=0.7 h=0.7/>%s", var10, var11)
		else
			setText(var2, HXSet.hxLan(iter3.info and SwitchSpecialChar(iter3.info, true) or ""))
		end

		setActive(var9.gameObject, iter3.rawIcon)
	end

	arg0.helpPage = arg1.helps.defaultpage or 1

	if arg1.helps.pageMode then
		arg0:switchHelpPage(arg0.helpPage)
	end

	arg0:Loaded(arg1)
end

function var0.switchHelpPage(arg0, arg1)
	for iter0 = 1, arg0._helpList.childCount do
		local var0 = arg0._helpList:GetChild(iter0 - 1)

		setActive(var0, arg1 == iter0)
		setText(var0:Find("icon/corner/Text"), iter0)
	end
end

function var0.commonSetting(arg0, arg1)
	rtf(arg0._window).sizeDelta = arg0._defaultSize
	rtf(arg0._helpPanel).sizeDelta = arg0._defaultHelpSize
	arg0.enable = true

	setActive(arg0._msgPanel, false)
	setActive(arg0._exchangeShipPanel, false)
	setActive(arg0._itemPanel, false)
	setActive(arg0._sigleItemPanel, false)
	setActive(arg0._inputPanel, false)
	setActive(arg0._obtainPanel, false)
	setActive(arg0._otherPanel, false)
	setActive(arg0._worldResetPanel, false)
	setActive(arg0._worldShopBtn, false)
	setActive(arg0._helpBgTF, false)
	setActive(arg0._helpPanel, arg1.helps)

	for iter0, iter1 in pairs(arg0.panelDict) do
		iter1.buffer:Hide()
	end

	setActive(arg0._btnContainer, true)

	arg0.stopRemindToggle.isOn = arg1.toggleStatus or false

	setActive(go(arg0.stopRemindToggle), arg1.showStopRemind)

	arg0.stopRemindText.text = arg1.stopRamindContent or i18n("dont_remind_today")

	removeAllChildren(arg0._btnContainer)

	arg0.settings = arg1

	SetActive(arg0._go, true)

	local var0 = arg0.settings.needCounter or false

	setActive(arg0._countSelect, var0)

	local var1 = arg0.settings.numUpdate
	local var2 = arg0.settings.addNum or 1
	local var3 = arg0.settings.maxNum or -1
	local var4 = arg0.settings.defaultNum or 1

	arg0._pageUtil:setNumUpdate(function(arg0)
		if var1 ~= nil then
			var1(arg0._countDescTxt, arg0)
		end
	end)
	arg0._pageUtil:setAddNum(var2)
	arg0._pageUtil:setMaxNum(var3)
	arg0._pageUtil:setDefaultNum(var4)
	setActive(arg0._sliders, arg0.settings.discount)

	if arg0.settings.discount then
		arg0._discount:GetComponent(typeof(Text)).text = arg0.settings.discount.discount .. "%OFF"
		arg0._discountDate:GetComponent(typeof(Text)).text = arg0.settings.discount.date
	end

	setActive(arg0._remasterPanel, arg0.settings.remaster)

	if arg0.settings.remaster then
		local var5 = arg0.settings.remaster

		setText(arg0._remasterPanel:Find("content/Text"), var5.word)
		setText(arg0._remasterPanel:Find("content/count"), var5.number or "")
		setText(arg0._remasterPanel:Find("btn/pic"), var5.btn_text)
		onButton(arg0, arg0._remasterPanel:Find("btn"), function()
			if var5.btn_call then
				var5.btn_call()
			end

			arg0:hide()
		end)
	end

	local var6 = arg0.settings.hideNo or false
	local var7 = arg0.settings.hideYes or false
	local var8 = arg0.settings.modal or false
	local var9 = arg0.settings.onYes or function()
		return
	end
	local var10 = arg0.settings.onNo or function()
		return
	end

	onButton(arg0, tf(arg0._go):Find("bg"), function()
		if arg0.settings.onClose then
			arg0.settings.onClose()
		else
			var10()
		end

		arg0:hide()
	end, SFX_CANCEL)
	SetCompomentEnabled(tf(arg0._go):Find("bg"), typeof(Button), not var8)

	local var11
	local var12

	if not var6 then
		local var13 = arg0:createBtn({
			text = arg0.settings.noText or var0.TEXT_CANCEL,
			btnType = arg0.settings.noBtnType or var0.BUTTON_GRAY,
			onCallback = var10,
			sound = arg1.noSound or SFX_CANCEL
		})
	end

	if not var7 then
		var12 = arg0:createBtn({
			text = arg0.settings.yesText or var0.TEXT_CONFIRM,
			btnType = arg0.settings.yesBtnType or var0.BUTTON_BLUE,
			onCallback = var9,
			sound = arg1.yesSound or SFX_CONFIRM,
			alignment = arg0.settings.yesSize and TextAnchor.MiddleCenter
		})

		if arg0.settings.yesSize then
			var12.sizeDelta = arg0.settings.yesSize
		end

		setGray(var12, arg0.settings.yesGray, true)
	end

	if arg0.settings.yseBtnLetf then
		var12:SetAsFirstSibling()
	end

	if arg0.settings.custom ~= nil then
		for iter2, iter3 in ipairs(arg0.settings.custom) do
			arg0:createBtn(iter3)
		end
	end

	setActive(arg0._closeBtn, not arg1.hideClose)
	onButton(arg0, arg0._closeBtn, function()
		local var0 = arg0.settings.onClose

		if arg0.settings and arg0.settings.hideClose and not var0 and arg0.settings.onYes then
			arg0.settings.onYes()
		end

		arg0:hide()

		if var0 then
			var0()
		else
			var10()
		end
	end, SFX_CANCEL)

	local var14 = arg0.settings.title or var0.TITLE_INFORMATION
	local var15 = 0
	local var16 = arg0._titleList.transform.childCount

	while var15 < var16 do
		local var17 = arg0._titleList.transform:GetChild(var15)

		SetActive(var17, var17.name == var14)

		var15 = var15 + 1
	end

	local var18 = arg0._go.transform.localPosition

	arg0._go.transform.localPosition = Vector3(var18.x, var18.y, arg0.settings.zIndex or 0)
	arg0.locked = arg0.settings.locked or false

	arg0:AddSprites()
end

function var0.AddSprites(arg0)
	local var0 = arg0.contextData

	table.Foreach(var0.contextSprites or {}, function(arg0, arg1)
		arg0.contentText:AddSprite(arg1.name, LoadSprite(arg1.path, arg1.name))
	end)
end

function var0.createBtn(arg0, arg1)
	local var0 = arg1.btnType or var0.BUTTON_BLUE
	local var1 = arg1.noQuit
	local var2 = arg0._go.transform:Find("custom_btn_list/custom_button_" .. var0)
	local var3 = cloneTplTo(var2, arg0._btnContainer)

	if arg1.label then
		go(var3).name = arg1.label
	end

	SetActive(var3, true)

	if arg1.scale then
		local var4 = arg1.scale.x or 1
		local var5 = arg1.scale.y or 1

		var3.localScale = Vector2(var4, var5)
	end

	if var0 == var0.BUTTON_MEDAL then
		setText(var3:Find("text"), arg1.text)
	elseif var0 ~= var0.BUTTON_RETREAT and var0 ~= var0.BUTTON_PREPAGE and var0 ~= var0.BUTTON_NEXTPAGE then
		arg0:updateButton(var3, arg1.text, arg1.alignment)
	end

	if var0 == var0.BUTTON_BLUE_WITH_ICON and arg1.iconName then
		local var6 = var3:Find("ticket/icon")

		setImageSprite(var6, LoadSprite(arg1.iconName[1], arg1.iconName[2]))
	end

	if not arg1.hideEvent then
		onButton(arg0, var3, function()
			if type(var1) == "function" then
				if var1() then
					return
				else
					arg0:hide()
				end
			elseif not var1 then
				arg0:hide()
			end

			return existCall(arg1.onCallback)
		end, arg1.sound or SFX_CONFIRM)
	end

	if arg1.sibling then
		var3:SetSiblingIndex(arg1.sibling)
	end

	return var3
end

function var0.updateButton(arg0, arg1, arg2, arg3)
	local var0 = var1[arg2]
	local var1 = arg1:Find("pic")

	if IsNil(var1) then
		return
	end

	if var0 then
		setText(var1, i18n(var0))
	else
		if string.len(arg2) > 12 then
			GetComponent(var1, typeof(Text)).resizeTextForBestFit = true
		end

		setText(var1, arg2)
	end

	if arg3 then
		var1:GetComponent(typeof(Text)).alignment = arg3
	end
end

function var0.Loaded(arg0, arg1)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		groupName = arg1.groupName,
		weight = arg1.weight or LayerWeightConst.SECOND_LAYER,
		blurLevelCamera = arg1.blurLevelCamera,
		parent = arg1.parent
	})
	pg.m02:sendNotification(GAME.OPEN_MSGBOX_DONE)
end

function var0.Clear(arg0)
	for iter0, iter1 in pairs(arg0.panelDict) do
		iter1:Destroy()
	end

	table.clear(arg0.panelDict)

	rtf(arg0._window).sizeDelta = arg0._defaultSize
	rtf(arg0._helpPanel).sizeDelta = arg0._defaultHelpSize

	setAnchoredPosition(arg0._window, {
		x = 0,
		y = 0
	})
	setAnchoredPosition(arg0._btnContainer, {
		y = 15
	})
	setAnchoredPosition(arg0._helpPanel, {
		x = arg0._defaultHelpPos.x,
		y = arg0._defaultHelpPos.y
	})
	SetCompomentEnabled(arg0._helpPanel:Find("list"), typeof(ScrollRect), true)
	setActive(arg0._top, true)
	setActive(findTF(arg0._window, "bg"), true)
	setActive(arg0._sigleItemPanel:Find("left/own"), false)

	local var0 = arg0._sigleItemPanel:Find("left/IconTpl")

	SetCompomentEnabled(var0:Find("icon_bg"), typeof(Image), true)
	SetCompomentEnabled(var0:Find("icon_bg/frame"), typeof(Image), true)
	setActive(var0:Find("icon_bg/slv"), false)

	local var1 = findTF(var0, "icon_bg/icon")

	var1.pivot = Vector2(0.5, 0.5)
	var1.sizeDelta = Vector2(-4, -4)
	var1.anchoredPosition = Vector2(0, 0)

	setActive(arg0.singleItemIntro, false)
	setText(arg0._singleItemSubIntroTF, "")

	for iter2 = 0, arg0._helpList.childCount - 1 do
		arg0._helpList:GetChild(iter2):Find("icon"):GetComponent(typeof(Image)).sprite = nil
	end

	for iter3, iter4 in pairs(arg0.pools) do
		if iter4 then
			PoolMgr.GetInstance():ReturnUI(iter4.name, iter4)
		end
	end

	arg0.pools = {}

	for iter5, iter6 in pairs(arg0.timers) do
		iter6:Stop()
	end

	arg0.timers = {}

	removeAllChildren(arg0._btnContainer)
	arg0.contentText:RemoveAllListeners()

	arg0.settings = nil
	arg0.enable = false
	arg0.locked = nil
end

function var0.willExit(arg0)
	arg0._pageUtil:Dispose()
end

function var0.hide(arg0)
	if not arg0.enable then
		return
	end

	arg0:Clear()
	arg0:closeView()
	pg.m02:sendNotification(GAME.CLOSE_MSGBOX_DONE)
end

return var0
