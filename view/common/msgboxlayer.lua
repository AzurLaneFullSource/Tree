local var0_0 = class("MsgboxLayer", import("view.base.BaseUI"))
local var1_0 = require("Mgr.const.MsgboxBtnNameMap")

var0_0.BUTTON_BLUE = 1
var0_0.BUTTON_GRAY = 2
var0_0.BUTTON_RED = 3
var0_0.BUTTON_MEDAL = 4
var0_0.BUTTON_RETREAT = 5
var0_0.BUTTON_PREPAGE = 6
var0_0.BUTTON_NEXTPAGE = 7
var0_0.BUTTON_BLUE_WITH_ICON = 8
var0_0.TITLE_INFORMATION = "infomation"
var0_0.TITLE_SETTING = "setting"
var0_0.TITLE_WARNING = "warning"
var0_0.TITLE_OBTAIN = "obtain"
var0_0.TITLE_CADPA = "cadpa"
var0_0.TEXT_CANCEL = "text_cancel"
var0_0.TEXT_CONFIRM = "text_confirm"

function var0_0.getUIName(arg0_1)
	return "MsgBoxUI"
end

function var0_0.init(arg0_2)
	arg0_2._window = arg0_2._tf:Find("window")

	setActive(arg0_2._window, true)

	arg0_2._top = arg0_2._window:Find("top")
	arg0_2._titleList = arg0_2._top:Find("bg")
	arg0_2._closeBtn = arg0_2._top:Find("btnBack")

	setText(arg0_2._titleList:Find("infomation/title"), i18n("words_information"))
	setText(arg0_2._titleList:Find("cadpa/title"), i18n("cadpa_tip1"))

	arg0_2._res = arg0_2._tf:Find("res")
	arg0_2._msgPanel = arg0_2._window:Find("msg_panel")
	arg0_2.contentText = arg0_2._msgPanel:Find("content"):GetComponent("RichText")

	arg0_2.contentText:AddSprite("diamond", arg0_2._res:Find("diamond"):GetComponent(typeof(Image)).sprite)
	arg0_2.contentText:AddSprite("gold", arg0_2._res:Find("gold"):GetComponent(typeof(Image)).sprite)
	arg0_2.contentText:AddSprite("oil", arg0_2._res:Find("oil"):GetComponent(typeof(Image)).sprite)
	arg0_2.contentText:AddSprite("world_money", arg0_2._res:Find("world_money"):GetComponent(typeof(Image)).sprite)
	arg0_2.contentText:AddSprite("port_money", arg0_2._res:Find("port_money"):GetComponent(typeof(Image)).sprite)
	arg0_2.contentText:AddSprite("guildicon", arg0_2._res:Find("guildicon"):GetComponent(typeof(Image)).sprite)

	arg0_2._exchangeShipPanel = arg0_2._window:Find("exchange_ship_panel")
	arg0_2._itemPanel = arg0_2._window:Find("item_panel")
	arg0_2._itemText = arg0_2._itemPanel:Find("Text"):GetComponent(typeof(Text))
	arg0_2._itemListItemContainer = arg0_2._itemPanel:Find("scrollview/list")
	arg0_2._itemListItemTpl = arg0_2._itemListItemContainer:Find("item")
	arg0_2._eskinPanel = arg0_2._window:Find("eskin_panel")
	arg0_2._eskinText = arg0_2._eskinPanel:Find("Text"):GetComponent(typeof(Text))
	arg0_2._eskinListItemContainer = arg0_2._eskinPanel:Find("scrollview/list")
	arg0_2._eskinListItemTpl = arg0_2._eskinListItemContainer:Find("item")
	arg0_2._sigleItemPanel = arg0_2._window:Find("single_item_panel")
	arg0_2._singleItemshipTypeTF = arg0_2._sigleItemPanel:Find("display_panel/name_container/shiptype")
	arg0_2.singleItemIntro = arg0_2._sigleItemPanel:Find("display_panel/desc/Text")

	local var0_2 = arg0_2.singleItemIntro:GetComponent("RichText")

	var0_2:AddSprite("diamond", arg0_2._res:Find("diamond"):GetComponent(typeof(Image)).sprite)
	var0_2:AddSprite("gold", arg0_2._res:Find("gold"):GetComponent(typeof(Image)).sprite)
	var0_2:AddSprite("oil", arg0_2._res:Find("oil"):GetComponent(typeof(Image)).sprite)
	var0_2:AddSprite("world_money", arg0_2._res:Find("world_money"):GetComponent(typeof(Image)).sprite)
	var0_2:AddSprite("port_money", arg0_2._res:Find("port_money"):GetComponent(typeof(Image)).sprite)
	var0_2:AddSprite("world_boss", arg0_2._res:Find("world_boss"):GetComponent(typeof(Image)).sprite)

	arg0_2._singleItemSubIntroTF = arg0_2._sigleItemPanel:Find("sub_intro")

	setText(arg0_2._sigleItemPanel:Find("ship_group/locked/Text"), i18n("tag_ship_locked"))
	setText(arg0_2._sigleItemPanel:Find("ship_group/unlocked/Text"), i18n("tag_ship_unlocked"))

	arg0_2._inputPanel = arg0_2._window:Find("input_panel")
	arg0_2._inputTitle = arg0_2._inputPanel:Find("label"):GetComponent(typeof(Text))
	arg0_2._inputTF = arg0_2._inputPanel:Find("InputField")
	arg0_2._inputField = arg0_2._inputTF:GetComponent(typeof(InputField))
	arg0_2._placeholderTF = arg0_2._inputTF:Find("Placeholder"):GetComponent(typeof(Text))
	arg0_2._inputConfirmBtn = arg0_2._inputPanel:Find("btns/confirm_btn")
	arg0_2._inputCancelBtn = arg0_2._inputPanel:Find("btns/cancel_btn")
	arg0_2._helpPanel = arg0_2._window:Find("help_panel")
	arg0_2._helpBgTF = arg0_2._tf:Find("bg_help")
	arg0_2._helpList = arg0_2._helpPanel:Find("list")
	arg0_2._helpTpl = arg0_2._helpPanel:Find("list/help_tpl")
	arg0_2._worldResetPanel = arg0_2._window:Find("world_reset_panel")
	arg0_2._worldShopBtn = arg0_2._window:Find("world_shop_btn")
	arg0_2._remasterPanel = arg0_2._window:Find("remaster_info")
	arg0_2._obtainPanel = arg0_2._window:Find("obtain_panel")
	arg0_2._otherPanel = arg0_2._window:Find("other_panel")
	arg0_2._countSelect = arg0_2._window:Find("count_select")
	arg0_2._pageUtil = PageUtil.New(arg0_2._countSelect:Find("value_bg/left"), arg0_2._countSelect:Find("value_bg/right"), arg0_2._countSelect:Find("max"), arg0_2._countSelect:Find("value_bg/value"))
	arg0_2._countDescTxt = arg0_2._countSelect:Find("desc_txt")
	arg0_2._sliders = arg0_2._window:Find("sliders")
	arg0_2._discountInfo = arg0_2._sliders:Find("discountInfo")
	arg0_2._discountDate = arg0_2._sliders:Find("discountDate")
	arg0_2._discount = arg0_2._sliders:Find("discountInfo/discount")
	arg0_2._strike = arg0_2._sliders:Find("strike")
	arg0_2.stopRemindToggle = arg0_2._window:Find("stopRemind"):GetComponent(typeof(Toggle))
	arg0_2.stopRemindText = tf(arg0_2.stopRemindToggle.gameObject):Find("Label"):GetComponent(typeof(Text))
	arg0_2._btnContainer = arg0_2._window:Find("button_container")
	arg0_2._defaultSize = Vector2(930, 620)
	arg0_2._defaultHelpSize = Vector2(870, 480)
	arg0_2._defaultHelpPos = Vector2(0, -40)
	arg0_2.pools = {}
	arg0_2.panelDict = {}
	arg0_2.timers = {}
end

function var0_0.didEnter(arg0_3)
	arg0_3:showMsgBox(arg0_3.contextData)
end

function var0_0.showMsgBox(arg0_4, arg1_4)
	local var0_4 = arg1_4.type or MSGBOX_TYPE_NORMAL

	switch(var0_4, {
		[MSGBOX_TYPE_NORMAL] = function()
			arg0_4:showNormalMsgBox(arg1_4)
		end,
		[MSGBOX_TYPE_HELP] = function()
			arg1_4.hideNo = defaultValue(arg1_4.hideNo, true)
			arg1_4.hideYes = defaultValue(arg1_4.hideYes, true)

			arg0_4:showHelpWindow(arg1_4)
		end
	})
end

function var0_0.showNormalMsgBox(arg0_7, arg1_7)
	arg0_7:commonSetting(arg1_7)
	SetActive(arg0_7._msgPanel, true)

	arg0_7.contentText.alignment = arg0_7.settings.alignment or TextAnchor.MiddleCenter
	arg0_7.contentText.fontSize = arg0_7.settings.fontSize or 36
	arg0_7.contentText.text = arg0_7.settings.content or ""

	arg0_7:Loaded(arg1_7)
end

function var0_0.showHelpWindow(arg0_8, arg1_8)
	arg0_8:commonSetting(arg1_8)
	setActive(findTF(arg0_8._helpPanel, "bg"), not arg1_8.helps.pageMode)
	setActive(arg0_8._helpBgTF, arg1_8.helps.pageMode)
	setActive(arg0_8._helpPanel:Find("btn_blueprint"), arg1_8.show_blueprint)

	if arg1_8.show_blueprint then
		onButton(arg0_8, arg0_8._helpPanel:Find("btn_blueprint"), function()
			arg0_8:hide()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT, {
				shipGroupId = arg1_8.show_blueprint
			})
		end, SFX_PANEL)
	end

	if arg1_8.helps.helpSize then
		arg0_8._helpPanel.sizeDelta = Vector2(arg1_8.helps.helpSize.x or arg0_8._defaultHelpSize.x, arg1_8.helps.helpSize.y or arg0_8._defaultHelpSize.y)
	end

	if arg1_8.helps.helpPos then
		setAnchoredPosition(arg0_8._helpPanel, {
			x = arg1_8.helps.helpPos.x or arg0_8._defaultHelpPos.x,
			y = arg1_8.helps.helpPos.y or arg0_8._defaultHelpPos.y
		})
	end

	if arg1_8.helps.windowSize then
		arg0_8._window.sizeDelta = Vector2(arg1_8.helps.windowSize.x or arg0_8._defaultSize.x, arg1_8.helps.windowSize.y or arg0_8._defaultSize.y)
	end

	if arg1_8.helps.windowPos then
		arg0_8._window.sizeDelta = Vector2(arg1_8.helps.windowSize.x or arg0_8._defaultSize.x, arg1_8.helps.windowSize.y or arg0_8._defaultSize.y)

		setAnchoredPosition(arg0_8._window, {
			x = arg1_8.helps.windowPos.x or 0,
			y = arg1_8.helps.windowPos.y or 0
		})
	else
		setAnchoredPosition(arg0_8._window, {
			x = 0,
			y = 0
		})
	end

	if arg1_8.helps.buttonsHeight then
		setAnchoredPosition(arg0_8._btnContainer, {
			y = arg1_8.helps.buttonsHeight
		})
	end

	if arg1_8.helps.disableScroll then
		local var0_8 = arg0_8._helpPanel:Find("list")

		SetCompomentEnabled(arg0_8._helpPanel:Find("list"), typeof(ScrollRect), not arg1_8.helps.disableScroll)
		setAnchoredPosition(var0_8, Vector2.zero)
		setActive(findTF(arg0_8._helpPanel, "Scrollbar"), false)
	end

	if arg1_8.helps.ImageMode then
		setActive(arg0_8._top, false)
		setActive(findTF(arg0_8._window, "bg"), false)
	end

	local var1_8 = arg0_8.settings.helps

	for iter0_8 = #var1_8, arg0_8._helpList.childCount - 1 do
		Destroy(arg0_8._helpList:GetChild(iter0_8))
	end

	for iter1_8 = arg0_8._helpList.childCount, #var1_8 - 1 do
		cloneTplTo(arg0_8._helpTpl, arg0_8._helpList)
	end

	for iter2_8, iter3_8 in ipairs(var1_8) do
		local var2_8 = arg0_8._helpList:GetChild(iter2_8 - 1)

		setActive(var2_8, true)

		local var3_8 = var2_8:Find("icon")

		setActive(var3_8, iter3_8.icon)
		setActive(findTF(var2_8, "line"), iter3_8.line)

		if iter3_8.icon then
			local var4_8 = 1

			if arg1_8.helps.ImageMode then
				var4_8 = 1.5
			end

			var3_8.transform.localScale = Vector2(iter3_8.icon.scale or var4_8, iter3_8.icon.scale or var4_8)

			local var5_8 = iter3_8.icon.path
			local var6_8 = iter3_8.icon.posX and iter3_8.icon.posX or -20
			local var7_8 = iter3_8.icon.posY and iter3_8.icon.posY or 0
			local var8_8 = LoadSprite(iter3_8.icon.atlas, iter3_8.icon.path)

			setImageSprite(var3_8:GetComponent(typeof(Image)), var8_8, true)
			setAnchoredPosition(var3_8, {
				x = var6_8,
				y = var7_8
			})
			setActive(var3_8:Find("corner"), arg1_8.helps.pageMode)
		end

		local var9_8 = var2_8:Find("richText"):GetComponent("RichText")

		if iter3_8.rawIcon then
			local var10_8 = iter3_8.rawIcon.name

			var9_8:AddSprite(var10_8, GetSpriteFromAtlas(iter3_8.rawIcon.atlas, var10_8))

			local var11_8 = HXSet.hxLan(iter3_8.info or "")

			setText(var2_8, "")

			var9_8.text = string.format("<icon name=%s w=0.7 h=0.7/>%s", var10_8, var11_8)
		else
			setText(var2_8, HXSet.hxLan(iter3_8.info and SwitchSpecialChar(iter3_8.info, true) or ""))
		end

		setActive(var9_8.gameObject, iter3_8.rawIcon)
	end

	arg0_8.helpPage = arg1_8.helps.defaultpage or 1

	if arg1_8.helps.pageMode then
		arg0_8:switchHelpPage(arg0_8.helpPage)
	end

	arg0_8:Loaded(arg1_8)
end

function var0_0.switchHelpPage(arg0_10, arg1_10)
	for iter0_10 = 1, arg0_10._helpList.childCount do
		local var0_10 = arg0_10._helpList:GetChild(iter0_10 - 1)

		setActive(var0_10, arg1_10 == iter0_10)
		setText(var0_10:Find("icon/corner/Text"), iter0_10)
	end
end

function var0_0.commonSetting(arg0_11, arg1_11)
	rtf(arg0_11._window).sizeDelta = arg0_11._defaultSize
	rtf(arg0_11._helpPanel).sizeDelta = arg0_11._defaultHelpSize
	arg0_11.enable = true

	setActive(arg0_11._msgPanel, false)
	setActive(arg0_11._exchangeShipPanel, false)
	setActive(arg0_11._itemPanel, false)
	setActive(arg0_11._sigleItemPanel, false)
	setActive(arg0_11._inputPanel, false)
	setActive(arg0_11._obtainPanel, false)
	setActive(arg0_11._otherPanel, false)
	setActive(arg0_11._worldResetPanel, false)
	setActive(arg0_11._worldShopBtn, false)
	setActive(arg0_11._helpBgTF, false)
	setActive(arg0_11._helpPanel, arg1_11.helps)

	for iter0_11, iter1_11 in pairs(arg0_11.panelDict) do
		iter1_11.buffer:Hide()
	end

	setActive(arg0_11._btnContainer, true)

	arg0_11.stopRemindToggle.isOn = arg1_11.toggleStatus or false

	setActive(go(arg0_11.stopRemindToggle), arg1_11.showStopRemind)

	arg0_11.stopRemindText.text = arg1_11.stopRamindContent or i18n("dont_remind_today")

	removeAllChildren(arg0_11._btnContainer)

	arg0_11.settings = arg1_11

	SetActive(arg0_11._go, true)

	local var0_11 = arg0_11.settings.needCounter or false

	setActive(arg0_11._countSelect, var0_11)

	local var1_11 = arg0_11.settings.numUpdate
	local var2_11 = arg0_11.settings.addNum or 1
	local var3_11 = arg0_11.settings.maxNum or -1
	local var4_11 = arg0_11.settings.defaultNum or 1

	arg0_11._pageUtil:setNumUpdate(function(arg0_12)
		if var1_11 ~= nil then
			var1_11(arg0_11._countDescTxt, arg0_12)
		end
	end)
	arg0_11._pageUtil:setAddNum(var2_11)
	arg0_11._pageUtil:setMaxNum(var3_11)
	arg0_11._pageUtil:setDefaultNum(var4_11)
	setActive(arg0_11._sliders, arg0_11.settings.discount)

	if arg0_11.settings.discount then
		arg0_11._discount:GetComponent(typeof(Text)).text = arg0_11.settings.discount.discount .. "%OFF"
		arg0_11._discountDate:GetComponent(typeof(Text)).text = arg0_11.settings.discount.date
	end

	setActive(arg0_11._remasterPanel, arg0_11.settings.remaster)

	if arg0_11.settings.remaster then
		local var5_11 = arg0_11.settings.remaster

		setText(arg0_11._remasterPanel:Find("content/Text"), var5_11.word)
		setText(arg0_11._remasterPanel:Find("content/count"), var5_11.number or "")
		setText(arg0_11._remasterPanel:Find("btn/pic"), var5_11.btn_text)
		onButton(arg0_11, arg0_11._remasterPanel:Find("btn"), function()
			if var5_11.btn_call then
				var5_11.btn_call()
			end

			arg0_11:hide()
		end)
	end

	local var6_11 = arg0_11.settings.hideNo or false
	local var7_11 = arg0_11.settings.hideYes or false
	local var8_11 = arg0_11.settings.modal or false
	local var9_11 = arg0_11.settings.onYes or function()
		return
	end
	local var10_11 = arg0_11.settings.onNo or function()
		return
	end

	onButton(arg0_11, tf(arg0_11._go):Find("bg"), function()
		if arg0_11.settings.onClose then
			arg0_11.settings.onClose()
		else
			var10_11()
		end

		arg0_11:hide()
	end, SFX_CANCEL)
	SetCompomentEnabled(tf(arg0_11._go):Find("bg"), typeof(Button), not var8_11)

	local var11_11
	local var12_11

	if not var6_11 then
		local var13_11 = arg0_11:createBtn({
			text = arg0_11.settings.noText or var0_0.TEXT_CANCEL,
			btnType = arg0_11.settings.noBtnType or var0_0.BUTTON_GRAY,
			onCallback = var10_11,
			sound = arg1_11.noSound or SFX_CANCEL
		})
	end

	if not var7_11 then
		var12_11 = arg0_11:createBtn({
			text = arg0_11.settings.yesText or var0_0.TEXT_CONFIRM,
			btnType = arg0_11.settings.yesBtnType or var0_0.BUTTON_BLUE,
			onCallback = var9_11,
			sound = arg1_11.yesSound or SFX_CONFIRM,
			alignment = arg0_11.settings.yesSize and TextAnchor.MiddleCenter
		})

		if arg0_11.settings.yesSize then
			var12_11.sizeDelta = arg0_11.settings.yesSize
		end

		setGray(var12_11, arg0_11.settings.yesGray, true)
	end

	if arg0_11.settings.yseBtnLetf then
		var12_11:SetAsFirstSibling()
	end

	if arg0_11.settings.custom ~= nil then
		for iter2_11, iter3_11 in ipairs(arg0_11.settings.custom) do
			arg0_11:createBtn(iter3_11)
		end
	end

	setActive(arg0_11._closeBtn, not arg1_11.hideClose)
	onButton(arg0_11, arg0_11._closeBtn, function()
		local var0_17 = arg0_11.settings.onClose

		if arg0_11.settings and arg0_11.settings.hideClose and not var0_17 and arg0_11.settings.onYes then
			arg0_11.settings.onYes()
		end

		arg0_11:hide()

		if var0_17 then
			var0_17()
		else
			var10_11()
		end
	end, SFX_CANCEL)

	local var14_11 = arg0_11.settings.title or var0_0.TITLE_INFORMATION
	local var15_11 = 0
	local var16_11 = arg0_11._titleList.transform.childCount

	while var15_11 < var16_11 do
		local var17_11 = arg0_11._titleList.transform:GetChild(var15_11)

		SetActive(var17_11, var17_11.name == var14_11)

		var15_11 = var15_11 + 1
	end

	local var18_11 = arg0_11._go.transform.localPosition

	arg0_11._go.transform.localPosition = Vector3(var18_11.x, var18_11.y, arg0_11.settings.zIndex or 0)
	arg0_11.locked = arg0_11.settings.locked or false

	arg0_11:AddSprites()
end

function var0_0.AddSprites(arg0_18)
	local var0_18 = arg0_18.contextData

	table.Foreach(var0_18.contextSprites or {}, function(arg0_19, arg1_19)
		arg0_18.contentText:AddSprite(arg1_19.name, LoadSprite(arg1_19.path, arg1_19.name))
	end)
end

function var0_0.createBtn(arg0_20, arg1_20)
	local var0_20 = arg1_20.btnType or var0_0.BUTTON_BLUE
	local var1_20 = arg1_20.noQuit
	local var2_20 = arg0_20._go.transform:Find("custom_btn_list/custom_button_" .. var0_20)
	local var3_20 = cloneTplTo(var2_20, arg0_20._btnContainer)

	if arg1_20.label then
		go(var3_20).name = arg1_20.label
	end

	SetActive(var3_20, true)

	if arg1_20.scale then
		local var4_20 = arg1_20.scale.x or 1
		local var5_20 = arg1_20.scale.y or 1

		var3_20.localScale = Vector2(var4_20, var5_20)
	end

	if var0_20 == var0_0.BUTTON_MEDAL then
		setText(var3_20:Find("text"), arg1_20.text)
	elseif var0_20 ~= var0_0.BUTTON_RETREAT and var0_20 ~= var0_0.BUTTON_PREPAGE and var0_20 ~= var0_0.BUTTON_NEXTPAGE then
		arg0_20:updateButton(var3_20, arg1_20.text, arg1_20.alignment)
	end

	if var0_20 == var0_0.BUTTON_BLUE_WITH_ICON and arg1_20.iconName then
		local var6_20 = var3_20:Find("ticket/icon")

		setImageSprite(var6_20, LoadSprite(arg1_20.iconName[1], arg1_20.iconName[2]))
	end

	if not arg1_20.hideEvent then
		onButton(arg0_20, var3_20, function()
			if type(var1_20) == "function" then
				if var1_20() then
					return
				else
					arg0_20:hide()
				end
			elseif not var1_20 then
				arg0_20:hide()
			end

			return existCall(arg1_20.onCallback)
		end, arg1_20.sound or SFX_CONFIRM)
	end

	if arg1_20.sibling then
		var3_20:SetSiblingIndex(arg1_20.sibling)
	end

	return var3_20
end

function var0_0.updateButton(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = var1_0[arg2_22]
	local var1_22 = arg1_22:Find("pic")

	if IsNil(var1_22) then
		return
	end

	if var0_22 then
		setText(var1_22, i18n(var0_22))
	else
		if string.len(arg2_22) > 12 then
			GetComponent(var1_22, typeof(Text)).resizeTextForBestFit = true
		end

		setText(var1_22, arg2_22)
	end

	if arg3_22 then
		var1_22:GetComponent(typeof(Text)).alignment = arg3_22
	end
end

function var0_0.Loaded(arg0_23, arg1_23)
	pg.UIMgr.GetInstance():BlurPanel(arg0_23._tf, false, {
		groupName = arg1_23.groupName,
		weight = arg1_23.weight or LayerWeightConst.SECOND_LAYER,
		blurLevelCamera = arg1_23.blurLevelCamera,
		parent = arg1_23.parent
	})
	pg.m02:sendNotification(GAME.OPEN_MSGBOX_DONE)
end

function var0_0.Clear(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.panelDict) do
		iter1_24:Destroy()
	end

	table.clear(arg0_24.panelDict)

	rtf(arg0_24._window).sizeDelta = arg0_24._defaultSize
	rtf(arg0_24._helpPanel).sizeDelta = arg0_24._defaultHelpSize

	setAnchoredPosition(arg0_24._window, {
		x = 0,
		y = 0
	})
	setAnchoredPosition(arg0_24._btnContainer, {
		y = 15
	})
	setAnchoredPosition(arg0_24._helpPanel, {
		x = arg0_24._defaultHelpPos.x,
		y = arg0_24._defaultHelpPos.y
	})
	SetCompomentEnabled(arg0_24._helpPanel:Find("list"), typeof(ScrollRect), true)
	setActive(arg0_24._top, true)
	setActive(findTF(arg0_24._window, "bg"), true)
	setActive(arg0_24._sigleItemPanel:Find("left/own"), false)

	local var0_24 = arg0_24._sigleItemPanel:Find("left/IconTpl")

	SetCompomentEnabled(var0_24:Find("icon_bg"), typeof(Image), true)
	SetCompomentEnabled(var0_24:Find("icon_bg/frame"), typeof(Image), true)
	setActive(var0_24:Find("icon_bg/slv"), false)

	local var1_24 = findTF(var0_24, "icon_bg/icon")

	var1_24.pivot = Vector2(0.5, 0.5)
	var1_24.sizeDelta = Vector2(-4, -4)
	var1_24.anchoredPosition = Vector2(0, 0)

	setActive(arg0_24.singleItemIntro, false)
	setText(arg0_24._singleItemSubIntroTF, "")

	for iter2_24 = 0, arg0_24._helpList.childCount - 1 do
		arg0_24._helpList:GetChild(iter2_24):Find("icon"):GetComponent(typeof(Image)).sprite = nil
	end

	for iter3_24, iter4_24 in pairs(arg0_24.pools) do
		if iter4_24 then
			PoolMgr.GetInstance():ReturnUI(iter4_24.name, iter4_24)
		end
	end

	arg0_24.pools = {}

	for iter5_24, iter6_24 in pairs(arg0_24.timers) do
		iter6_24:Stop()
	end

	arg0_24.timers = {}

	removeAllChildren(arg0_24._btnContainer)
	arg0_24.contentText:RemoveAllListeners()

	arg0_24.settings = nil
	arg0_24.enable = false
	arg0_24.locked = nil
end

function var0_0.willExit(arg0_25)
	arg0_25._pageUtil:Dispose()
end

function var0_0.hide(arg0_26)
	if not arg0_26.enable then
		return
	end

	arg0_26:Clear()
	arg0_26:closeView()
	pg.m02:sendNotification(GAME.CLOSE_MSGBOX_DONE)
end

return var0_0
