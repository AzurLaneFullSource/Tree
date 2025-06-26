pg = pg or {}

local var0_0 = pg
local var1_0 = singletonClass("MsgboxMgr")

var0_0.MsgboxMgr = var1_0
var1_0.BUTTON_BLUE = 1
var1_0.BUTTON_GRAY = 2
var1_0.BUTTON_RED = 3
var1_0.BUTTON_MEDAL = 4
var1_0.BUTTON_RETREAT = 5
var1_0.BUTTON_PREPAGE = 6
var1_0.BUTTON_NEXTPAGE = 7
var1_0.BUTTON_BLUE_WITH_ICON = 8
var1_0.BUTTON_YELLOW = 9
var1_0.TITLE_INFORMATION = "infomation"
var1_0.TITLE_SETTING = "setting"
var1_0.TITLE_WARNING = "warning"
var1_0.TITLE_OBTAIN = "obtain"
var1_0.TITLE_CADPA = "cadpa"
var1_0.TEXT_CANCEL = "text_cancel"
var1_0.TEXT_CONFIRM = "text_confirm"
MSGBOX_TYPE_NORMAL = 1
MSGBOX_TYPE_INPUT = 2
MSGBOX_TYPE_SINGLE_ITEM = 3
MSGBOX_TYPE_EXCHANGE = 4
MSGBOX_TYPE_DROP_ITEM = 5
MSGBOX_TYPE_ITEM_BOX = 6
MSGBOX_TYPE_HELP = 7
MSGBOX_TYPE_SECONDPWD = 8
MSGBOX_TYPE_OBTAIN = 9
MSGBOX_TYPE_ITEMTIP = 10
MSGBOX_TYPE_JUST_FOR_SHOW = 11
MSGBOX_TYPE_MONTH_CARD_TIP = 12
MSGBOX_TYPE_WORLD_RESET = 13
MSGBOX_TYPE_WORLD_STAMINA_EXCHANGE = 14
MSGBOX_TYPE_STORY_CANCEL_TIP = 15
MSGBOX_TYPE_META_SKILL_UNLOCK = 16
MSGBOX_TYPE_CONFIRM_REFORGE_SPWEAPON = 17
MSGBOX_TYPE_ACCOUNTDELETE = 18
MSGBOX_TYPE_STRENGTHEN_BACK = 19
MSGBOX_TYPE_CONTENT_ITEMS = 20
MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM = 21
MSGBOX_TYPE_CONFIRM_DELETE = 22
MSGBOX_TYPE_SUBPATTERN = 23
MSGBOX_TYPE_FILE_DOWNLOAD = 24
MSGBOX_TYPE_LIKN_COLLECT_GUIDE = 25
MSGBOX_TYPE_DROP_ITEM_ESKIN = 26
var1_0.enable = false

local var2_0 = require("Mgr.const.MsgboxBtnNameMap")

function var1_0.Init(arg0_1, arg1_1)
	print("initializing msgbox manager...")
	LoadAndInstantiateAsync("ui", "MsgBox", function(arg0_2)
		arg0_1._go = arg0_2

		arg0_1._go:SetActive(false)

		arg0_1._tf = arg0_1._go.transform

		arg0_1._tf:SetParent(var0_0.UIMgr.GetInstance().OverlayMain, false)

		arg0_1._window = arg0_1._tf:Find("window")

		setActive(arg0_1._window, true)

		arg0_1._top = arg0_1._window:Find("top")
		arg0_1._titleList = arg0_1._top:Find("bg")
		arg0_1._closeBtn = arg0_1._top:Find("btnBack")

		setText(arg0_1._titleList:Find("infomation/title"), i18n("words_information"))
		setText(arg0_1._titleList:Find("cadpa/title"), i18n("cadpa_tip1"))

		arg0_1._res = arg0_1._tf:Find("res")
		arg0_1._msgPanel = arg0_1._window:Find("msg_panel")
		arg0_1.contentText = arg0_1._msgPanel:Find("content"):GetComponent("RichText")

		arg0_1.contentText:AddSprite("diamond", arg0_1._res:Find("diamond"):GetComponent(typeof(Image)).sprite)
		arg0_1.contentText:AddSprite("gold", arg0_1._res:Find("gold"):GetComponent(typeof(Image)).sprite)
		arg0_1.contentText:AddSprite("oil", arg0_1._res:Find("oil"):GetComponent(typeof(Image)).sprite)
		arg0_1.contentText:AddSprite("world_money", arg0_1._res:Find("world_money"):GetComponent(typeof(Image)).sprite)
		arg0_1.contentText:AddSprite("port_money", arg0_1._res:Find("port_money"):GetComponent(typeof(Image)).sprite)
		arg0_1.contentText:AddSprite("guildicon", arg0_1._res:Find("guildicon"):GetComponent(typeof(Image)).sprite)

		arg0_1._exchangeShipPanel = arg0_1._window:Find("exchange_ship_panel")
		arg0_1._itemPanel = arg0_1._window:Find("item_panel")
		arg0_1._itemText = arg0_1._itemPanel:Find("Text"):GetComponent(typeof(Text))
		arg0_1._itemListItemContainer = arg0_1._itemPanel:Find("scrollview/list")
		arg0_1._itemListItemTpl = arg0_1._itemListItemContainer:Find("item")
		arg0_1._eskinPanel = arg0_1._window:Find("eskin_panel")
		arg0_1._eskinText = arg0_1._eskinPanel:Find("Text"):GetComponent(typeof(Text))
		arg0_1._eskinListItemContainer = arg0_1._eskinPanel:Find("scrollview/list")
		arg0_1._eskinListItemTpl = arg0_1._eskinListItemContainer:Find("item")
		arg0_1._sigleItemPanel = arg0_1._window:Find("single_item_panel")
		arg0_1._singleItemshipTypeTF = arg0_1._sigleItemPanel:Find("display_panel/name_container/shiptype")
		arg0_1.singleItemIntro = arg0_1._sigleItemPanel:Find("display_panel/desc/Text")

		local var0_2 = arg0_1.singleItemIntro:GetComponent("RichText")

		var0_2:AddSprite("diamond", arg0_1._res:Find("diamond"):GetComponent(typeof(Image)).sprite)
		var0_2:AddSprite("gold", arg0_1._res:Find("gold"):GetComponent(typeof(Image)).sprite)
		var0_2:AddSprite("oil", arg0_1._res:Find("oil"):GetComponent(typeof(Image)).sprite)
		var0_2:AddSprite("world_money", arg0_1._res:Find("world_money"):GetComponent(typeof(Image)).sprite)
		var0_2:AddSprite("port_money", arg0_1._res:Find("port_money"):GetComponent(typeof(Image)).sprite)
		var0_2:AddSprite("world_boss", arg0_1._res:Find("world_boss"):GetComponent(typeof(Image)).sprite)

		arg0_1._singleItemSubIntroTF = arg0_1._sigleItemPanel:Find("sub_intro")

		setText(arg0_1._sigleItemPanel:Find("ship_group/locked/Text"), i18n("tag_ship_locked"))
		setText(arg0_1._sigleItemPanel:Find("ship_group/unlocked/Text"), i18n("tag_ship_unlocked"))

		arg0_1._inputPanel = arg0_1._window:Find("input_panel")
		arg0_1._inputTitle = arg0_1._inputPanel:Find("label"):GetComponent(typeof(Text))
		arg0_1._inputTF = arg0_1._inputPanel:Find("InputField")
		arg0_1._inputField = arg0_1._inputTF:GetComponent(typeof(InputField))
		arg0_1._placeholderTF = arg0_1._inputTF:Find("Placeholder"):GetComponent(typeof(Text))
		arg0_1._inputConfirmBtn = arg0_1._inputPanel:Find("btns/confirm_btn")
		arg0_1._inputCancelBtn = arg0_1._inputPanel:Find("btns/cancel_btn")
		arg0_1._helpPanel = arg0_1._window:Find("help_panel")
		arg0_1._helpBgTF = arg0_1._tf:Find("bg_help")
		arg0_1._helpList = arg0_1._helpPanel:Find("list")
		arg0_1._helpTpl = arg0_1._helpPanel:Find("list/help_tpl")
		arg0_1._worldResetPanel = arg0_1._window:Find("world_reset_panel")
		arg0_1._worldShopBtn = arg0_1._window:Find("world_shop_btn")
		arg0_1._remasterPanel = arg0_1._window:Find("remaster_info")
		arg0_1._obtainPanel = arg0_1._window:Find("obtain_panel")
		arg0_1._otherPanel = arg0_1._window:Find("other_panel")
		arg0_1._countSelect = arg0_1._window:Find("count_select")
		arg0_1._pageUtil = PageUtil.New(arg0_1._countSelect:Find("value_bg/left"), arg0_1._countSelect:Find("value_bg/right"), arg0_1._countSelect:Find("max"), arg0_1._countSelect:Find("value_bg/value"))
		arg0_1._countDescTxt = arg0_1._countSelect:Find("desc_txt")
		arg0_1._sliders = arg0_1._window:Find("sliders")
		arg0_1._discountInfo = arg0_1._sliders:Find("discountInfo")
		arg0_1._discountDate = arg0_1._sliders:Find("discountDate")
		arg0_1._discount = arg0_1._sliders:Find("discountInfo/discount")
		arg0_1._strike = arg0_1._sliders:Find("strike")
		arg0_1.stopRemindToggle = arg0_1._window:Find("stopRemind"):GetComponent(typeof(Toggle))
		arg0_1.stopRemindText = tf(arg0_1.stopRemindToggle.gameObject):Find("Label"):GetComponent(typeof(Text))
		arg0_1._btnContainer = arg0_1._window:Find("button_container")
		arg0_1._defaultSize = Vector2(930, 620)
		arg0_1._defaultHelpSize = Vector2(870, 480)
		arg0_1._defaultHelpPos = Vector2(0, -40)
		arg0_1.pools = {}
		arg0_1.panelDict = {}
		arg0_1.timers = {}

		arg1_1()
	end, true, true)
end

function var1_0.getMsgBoxOb(arg0_3)
	return arg0_3._go
end

local function var3_0(arg0_4, arg1_4)
	arg0_4:commonSetting(arg1_4)
	SetActive(arg0_4._msgPanel, true)

	arg0_4.contentText.alignment = arg0_4.settings.alignment or TextAnchor.MiddleCenter
	arg0_4.contentText.fontSize = arg0_4.settings.fontSize or 36
	arg0_4.contentText.text = arg0_4.settings.content or ""

	arg0_4:Loaded(arg1_4)
end

local function var4_0(arg0_5, arg1_5)
	arg0_5:commonSetting(arg1_5)
	setActive(arg0_5._inputPanel, true)
	setActive(arg0_5._btnContainer, false)

	arg0_5._inputTitle.text = arg1_5.title or ""
	arg0_5._placeholderTF.text = arg1_5.placeholder or ""
	arg0_5._inputField.characterLimit = arg1_5.limit or 0

	setActive(arg0_5._inputCancelBtn, not arg1_5.hideNo)
	arg0_5:updateButton(arg0_5._inputCancelBtn, arg1_5.noText or var1_0.TEXT_CANCEL)
	arg0_5:updateButton(arg0_5._inputConfirmBtn, arg1_5.yesText or var1_0.TEXT_CONFIRM)
	onButton(arg0_5, arg0_5._inputCancelBtn, function()
		arg0_5:hide()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5._inputConfirmBtn, function()
		if arg1_5.onYes then
			arg1_5.onYes(arg0_5._inputField.text)
		end

		arg0_5:hide()
	end, SFX_CONFIRM)
	arg0_5:Loaded(arg1_5)
end

local function var5_0(arg0_8, arg1_8)
	arg0_8:commonSetting(arg1_8)
	SetActive(arg0_8._exchangeShipPanel, true)
	setActive(findTF(arg0_8._exchangeShipPanel, "icon_bg/own"), false)
	updateDrop(arg0_8._exchangeShipPanel, arg1_8.drop)

	local var0_8 = arg0_8._exchangeShipPanel:Find("intro_view/Viewport/intro")

	SetActive(var0_8, arg1_8.drop.type == DROP_TYPE_SHIP or arg1_8.drop.type == DROP_TYPE_RESOURCE or arg1_8.drop.type == DROP_TYPE_ITEM or arg1_8.drop.type == DROP_TYPE_FURNITURE or arg1_8.drop.type == DROP_TYPE_STRATEGY or arg1_8.drop.type == DROP_TYPE_SKIN or arg1_8.drop.type == DROP_TYPE_SKIN_TIMELIMIT)

	local var1_8 = arg0_8.settings.numUpdate

	setActive(arg0_8.singleItemIntro, var1_8 == nil)
	setActive(arg0_8._countDescTxt, var1_8 ~= nil)
	setText(arg0_8._exchangeShipPanel:Find("name_mode/name"), arg1_8.name or arg1_8.drop:getConfig("name") or "")
	setText(arg0_8._exchangeShipPanel:Find("name_mode/name/name"), getText(arg0_8._exchangeShipPanel:Find("name_mode/name")))

	local var2_8 = var0_0.ship_data_statistics[arg1_8.drop.id].skin_id
	local var3_8, var4_8, var5_8 = ShipWordHelper.GetWordAndCV(var2_8, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

	setText(var0_8, var5_8 or i18n("ship_drop_desc_default"))

	if arg1_8.intro then
		setText(var0_8, arg1_8.intro)
	end

	if arg1_8.enabelYesBtn ~= nil then
		local var6_8 = arg0_8._btnContainer:GetChild(1)

		setButtonEnabled(var6_8, arg1_8.enabelYesBtn)
		eachChild(var6_8, function(arg0_9)
			local var0_9 = arg1_8.enabelYesBtn and 1 or 0.3

			GetOrAddComponent(arg0_9, typeof(CanvasGroup)).alpha = var0_9
		end)
	end

	if arg1_8.show_medal then
		arg0_8:createBtn({
			sibling = 0,
			hideEvent = true,
			text = arg1_8.show_medal.desc,
			btnType = var1_0.BUTTON_MEDAL,
			sound = SFX_UI_BUILDING_EXCHANGE
		})
	end

	arg0_8:Loaded(arg1_8)
end

local function var6_0(arg0_10, arg1_10)
	arg0_10:commonSetting(arg1_10)
	SetActive(arg0_10._itemPanel, true)
	setActive(arg0_10._itemText, arg1_10.content)

	arg0_10._itemText.text = arg1_10.content or ""

	local var0_10 = arg1_10.items
	local var1_10 = arg1_10.itemFunc

	UIItemList.StaticAlign(arg0_10._itemListItemContainer, arg0_10._itemListItemTpl, #var0_10, function(arg0_11, arg1_11, arg2_11)
		arg1_11 = arg1_11 + 1

		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = var0_10[arg1_11]

			updateDrop(arg2_11:Find("IconTpl"), var0_11, {
				anonymous = var0_11.anonymous,
				hideName = var0_11.hideName
			})

			local var1_11 = arg2_11:Find("IconTpl/name")

			setText(var1_11, shortenString(getText(var1_11), 5))
			onButton(arg0_10, arg2_11, function()
				if var0_11.anonymous then
					return
				elseif var1_10 then
					var1_10(var0_11)
				end
			end, SFX_UI_CLICK)
		end
	end)
	arg0_10:Loaded(arg1_10)
end

local function var7_0(arg0_13, arg1_13)
	arg0_13:commonSetting(arg1_13)
	SetActive(arg0_13._eskinPanel, true)
	setActive(arg0_13._eskinText, arg1_13.content)

	arg0_13._eskinText.text = arg1_13.content or ""

	local var0_13 = arg1_13.items
	local var1_13 = arg1_13.itemFunc

	UIItemList.StaticAlign(arg0_13._eskinListItemContainer, arg0_13._eskinListItemTpl, #var0_13, function(arg0_14, arg1_14, arg2_14)
		arg1_14 = arg1_14 + 1

		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14]

			updateDrop(arg2_14:Find("IconTpl"), var0_14, {
				anonymous = var0_14.anonymous,
				hideName = var0_14.hideName
			})
			setText(arg2_14:Find("own/Text"), i18n("equip_skin_detail_count") .. var0_14:getOwnedCount())
			onButton(arg0_13, arg2_14, function()
				if var0_14.anonymous then
					return
				elseif var1_13 then
					var1_13(var0_14)
				end
			end, SFX_UI_CLICK)
		end
	end)
	arg0_13:Loaded(arg1_13)
end

local function var8_0(arg0_16, arg1_16)
	arg0_16:commonSetting(arg1_16)
	SetActive(arg0_16._sigleItemPanel, true)
	SetActive(arg0_16._sigleItemPanel:Find("ship_group"), false)
	SetActive(arg0_16._singleItemshipTypeTF, false)
	SetActive(arg0_16._sigleItemPanel:Find("left/detail"), false)

	local var0_16 = arg0_16.singleItemIntro

	SetActive(var0_16, true)
	setText(var0_16, arg1_16.content or "")

	local var1_16 = arg0_16._sigleItemPanel:Find("left/IconTpl")

	setText(var1_16:Find("icon_bg/count"), "")
	SetActive(var1_16:Find("icon_bg/startpl"), false)
	SetCompomentEnabled(var1_16:Find("icon_bg"), typeof(Image), not arg1_16.hideIconBG)
	SetCompomentEnabled(var1_16:Find("icon_bg/frame"), typeof(Image), not arg1_16.hideIconBG)

	local var2_16 = var1_16:Find("icon_bg/frame")

	setFrame(var2_16, arg1_16.frame or 1)
	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg1_16.frame or 1), var1_16:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync(arg1_16.iconPath[1], arg1_16.iconPath[2] or "", var1_16:Find("icon_bg/icon"))
	setText(arg0_16._sigleItemPanel:Find("display_panel/name_container/name/Text"), arg1_16.name or "")
	arg0_16:Loaded(arg1_16)
end

local function var9_0(arg0_17, arg1_17)
	arg0_17:commonSetting(arg1_17)
	SetActive(arg0_17._sigleItemPanel, true)

	local var0_17 = arg0_17._sigleItemPanel:Find("left/IconTpl")

	setActive(var0_17:Find("timelimit"), arg1_17.drop.type == DROP_TYPE_SKIN_TIMELIMIT)
	updateDrop(var0_17, arg1_17.drop)
	setActive(arg0_17._singleItemshipTypeTF, arg1_17.drop.type == DROP_TYPE_SHIP)
	setActive(arg0_17._sigleItemPanel:Find("combat_skin"), false)

	local var1_17 = arg0_17._sigleItemPanel:Find("display_panel"):GetComponent(typeof(RectTransform))

	var1_17.sizeDelta = Vector2(var1_17.sizeDelta.x, -114.5)

	if arg1_17.drop.type == DROP_TYPE_SHIP then
		GetImageSpriteFromAtlasAsync("shiptype", shipType2print(arg1_17.drop:getConfig("type")), arg0_17._singleItemshipTypeTF, false)
	elseif arg1_17.drop.type == DROP_TYPE_COMBAT_UI_STYLE then
		var1_17.sizeDelta = Vector2(var1_17.sizeDelta.x, -170.5)

		local var2_17 = var0_0.item_data_battleui[arg1_17.drop.id].rare_display
		local var3_17 = UIItemList.New(arg0_17._sigleItemPanel:Find("combat_skin/elementList"), arg0_17._sigleItemPanel:Find("combat_skin/elementList/main"))

		var3_17:make(function(arg0_18, arg1_18, arg2_18)
			if arg0_18 == UIItemList.EventUpdate then
				local var0_18 = var2_17[arg1_18 + 1]

				GetImageSpriteFromAtlasAsync("ui/combatskinrare", CombatSkinConst.TYPE_ICON_NAME[var0_18], arg2_18:Find("icon"), true)
				setScrollText(arg2_18:Find("TextMask/Text"), i18n("battleui_display" .. var0_18))
			end
		end)
		var3_17:align(#var2_17)
		setActive(arg0_17._sigleItemPanel:Find("combat_skin"), true)
	end

	local var4_17 = arg1_17.drop.type == DROP_TYPE_SHIP
	local var5_17 = arg0_17._sigleItemPanel:Find("ship_group")

	SetActive(var5_17, var4_17)

	if var4_17 then
		local var6_17 = tobool(getProxy(CollectionProxy):getShipGroup(var0_0.ship_data_template[arg1_17.drop.id].group_type))

		SetActive(var5_17:Find("unlocked"), var6_17)
		SetActive(var5_17:Find("locked"), not var6_17)
	end

	if arg1_17.windowSize then
		arg0_17._window.sizeDelta = Vector2(arg1_17.windowSize.x or arg0_17._defaultSize.x, arg1_17.windowSize.y or arg0_17._defaultSize.y)
	end

	local var7_17 = arg0_17.singleItemIntro
	local var8_17 = arg0_17._singleItemSubIntroTF
	local var9_17 = arg0_17.settings.numUpdate

	setActive(arg0_17._countDescTxt, var9_17 ~= nil)
	SetActive(var7_17, var9_17 == nil)

	local var10_17 = arg1_17.name or arg1_17.drop:getConfig("name") or ""

	setText(arg0_17._sigleItemPanel:Find("display_panel/name_container/name/Text"), var10_17)
	UpdateOwnDisplay(arg0_17._sigleItemPanel:Find("left/own"), arg1_17.drop)
	RegisterDetailButton(arg0_17, arg0_17._sigleItemPanel:Find("left/detail"), arg1_17.drop)

	if arg1_17.iconPreservedAspect then
		local var11_17 = var0_17:Find("icon_bg/icon")
		local var12_17 = var11_17:GetComponent(typeof(Image))

		var11_17.pivot = Vector2(0.5, 1)

		local var13_17 = var11_17.rect.width
		local var14_17 = var12_17.preferredHeight / var12_17.preferredWidth * var13_17

		var11_17.sizeDelta = Vector2(-4, var14_17 - var13_17 - 4)
		var11_17.anchoredPosition = Vector2(0, -2)
	end

	if arg1_17.content and arg1_17.content ~= "" then
		setText(var7_17, arg1_17.content)
	elseif arg1_17.drop.type == DROP_TYPE_WORLD_COLLECTION then
		arg1_17.drop:MsgboxIntroSet(arg1_17, var7_17, arg0_17._sigleItemPanel:Find("name_mode/name_mask/name"))
	else
		arg1_17.drop:MsgboxIntroSet(arg1_17, var7_17)
	end

	if arg1_17.intro then
		setText(var7_17, arg1_17.intro)
	end

	setText(var8_17, arg1_17.subIntro or arg1_17.extendDesc or "")

	if arg1_17.enabelYesBtn ~= nil then
		local var15_17 = arg0_17._btnContainer:GetChild(1)

		setButtonEnabled(var15_17, arg1_17.enabelYesBtn)
		eachChild(var15_17, function(arg0_19)
			local var0_19 = arg1_17.enabelYesBtn and 1 or 0.3

			GetOrAddComponent(arg0_19, typeof(CanvasGroup)).alpha = var0_19
		end)
	end

	if arg1_17.show_medal then
		arg0_17:createBtn({
			sibling = 0,
			hideEvent = true,
			text = arg1_17.show_medal.desc,
			btnType = var1_0.BUTTON_MEDAL,
			sound = SFX_UI_BUILDING_EXCHANGE
		})
	end

	arg0_17:Loaded(arg1_17)
end

local function var10_0(arg0_20, arg1_20)
	arg0_20:commonSetting(arg1_20)
	setActive(findTF(arg0_20._helpPanel, "bg"), not arg1_20.helps.pageMode)
	setActive(arg0_20._helpBgTF, arg1_20.helps.pageMode)
	setActive(arg0_20._helpPanel:Find("btn_blueprint"), arg1_20.show_blueprint)

	if arg1_20.show_blueprint then
		onButton(arg0_20, arg0_20._helpPanel:Find("btn_blueprint"), function()
			arg0_20:hide()
			var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT, {
				shipGroupId = arg1_20.show_blueprint
			})
		end, SFX_PANEL)
	end

	if arg1_20.helps.helpSize then
		arg0_20._helpPanel.sizeDelta = Vector2(arg1_20.helps.helpSize.x or arg0_20._defaultHelpSize.x, arg1_20.helps.helpSize.y or arg0_20._defaultHelpSize.y)
	end

	if arg1_20.helps.helpPos then
		setAnchoredPosition(arg0_20._helpPanel, {
			x = arg1_20.helps.helpPos.x or arg0_20._defaultHelpPos.x,
			y = arg1_20.helps.helpPos.y or arg0_20._defaultHelpPos.y
		})
	end

	if arg1_20.helps.windowSize then
		arg0_20._window.sizeDelta = Vector2(arg1_20.helps.windowSize.x or arg0_20._defaultSize.x, arg1_20.helps.windowSize.y or arg0_20._defaultSize.y)
	end

	if arg1_20.helps.windowPos then
		arg0_20._window.sizeDelta = Vector2(arg1_20.helps.windowSize.x or arg0_20._defaultSize.x, arg1_20.helps.windowSize.y or arg0_20._defaultSize.y)

		setAnchoredPosition(arg0_20._window, {
			x = arg1_20.helps.windowPos.x or 0,
			y = arg1_20.helps.windowPos.y or 0
		})
	else
		setAnchoredPosition(arg0_20._window, {
			x = 0,
			y = 0
		})
	end

	if arg1_20.helps.buttonsHeight then
		setAnchoredPosition(arg0_20._btnContainer, {
			y = arg1_20.helps.buttonsHeight
		})
	end

	if arg1_20.helps.disableScroll then
		local var0_20 = arg0_20._helpPanel:Find("list")

		SetCompomentEnabled(arg0_20._helpPanel:Find("list"), typeof(ScrollRect), not arg1_20.helps.disableScroll)
		setAnchoredPosition(var0_20, Vector2.zero)
		setActive(findTF(arg0_20._helpPanel, "Scrollbar"), false)
	end

	if arg1_20.helps.ImageMode then
		setActive(arg0_20._top, false)
		setActive(findTF(arg0_20._window, "bg"), false)
	end

	local var1_20 = arg0_20.settings.helps

	for iter0_20 = #var1_20, arg0_20._helpList.childCount - 1 do
		Destroy(arg0_20._helpList:GetChild(iter0_20))
	end

	for iter1_20 = arg0_20._helpList.childCount, #var1_20 - 1 do
		cloneTplTo(arg0_20._helpTpl, arg0_20._helpList)
	end

	for iter2_20, iter3_20 in ipairs(var1_20) do
		local var2_20 = arg0_20._helpList:GetChild(iter2_20 - 1)

		setActive(var2_20, true)

		local var3_20 = var2_20:Find("icon")

		setActive(var3_20, iter3_20.icon)
		setActive(findTF(var2_20, "line"), iter3_20.line)

		if iter3_20.icon then
			local var4_20 = 1

			if arg1_20.helps.ImageMode then
				var4_20 = 1.5
			end

			var3_20.transform.localScale = Vector2(iter3_20.icon.scale or var4_20, iter3_20.icon.scale or var4_20)

			local var5_20 = iter3_20.icon.path
			local var6_20 = iter3_20.icon.posX and iter3_20.icon.posX or -20
			local var7_20 = iter3_20.icon.posY and iter3_20.icon.posY or 0
			local var8_20 = LoadSprite(iter3_20.icon.atlas, iter3_20.icon.path)

			setImageSprite(var3_20:GetComponent(typeof(Image)), var8_20, true)
			setAnchoredPosition(var3_20, {
				x = var6_20,
				y = var7_20
			})
			setActive(var3_20:Find("corner"), arg1_20.helps.pageMode)
		end

		local var9_20 = var2_20:Find("richText"):GetComponent("RichText")

		if iter3_20.rawIcon then
			local var10_20 = iter3_20.rawIcon.name

			var9_20:AddSprite(var10_20, GetSpriteFromAtlas(iter3_20.rawIcon.atlas, var10_20))

			local var11_20 = HXSet.hxLan(iter3_20.info or "")

			setText(var2_20, "")

			var9_20.text = string.format("<icon name=%s w=0.7 h=0.7/>%s", var10_20, var11_20)
		else
			setText(var2_20, HXSet.hxLan(iter3_20.info and SwitchSpecialChar(iter3_20.info, true) or ""))
		end

		setActive(var9_20.gameObject, iter3_20.rawIcon)
	end

	arg0_20.helpPage = arg1_20.helps.defaultpage or 1

	if arg1_20.helps.pageMode then
		arg0_20:switchHelpPage(arg0_20.helpPage)
	end

	arg0_20:Loaded(arg1_20)
end

local function var11_0(arg0_22, arg1_22)
	arg0_22:commonSetting(arg1_22)
	setActive(arg0_22._otherPanel, true)

	local var0_22 = tf(arg1_22.secondaryUI)

	arg0_22._window.sizeDelta = Vector2(960, arg0_22._defaultSize.y)

	setActive(var0_22, true)

	local var1_22 = arg1_22.mode
	local var2_22 = getProxy(SecondaryPWDProxy):getRawData()
	local var3_22 = var0_22:Find("showresttime")
	local var4_22 = var0_22:Find("settips")

	if var1_22 == "showresttime" then
		setActive(var3_22, true)
		setActive(var4_22, false)

		local var5_22 = var3_22:Find("desc"):GetComponent(typeof(Text))

		if arg0_22.timers.secondaryUItimer then
			arg0_22.timers.secondaryUItimer:Stop()
		end

		local function var6_22()
			local var0_23 = var0_0.TimeMgr.GetInstance():GetServerTime()
			local var1_23 = var2_22.fail_cd and var2_22.fail_cd - var0_23 or 0

			var1_23 = var1_23 < 0 and 0 or var1_23

			local var2_23 = math.floor(var1_23 / 86400)

			if var2_23 > 0 then
				var5_22.text = string.format(i18n("tips_fail_secondarypwd_much_times"), var2_23 .. i18n("word_date"))
			else
				local var3_23 = math.floor(var1_23 / 3600)

				if var3_23 > 0 then
					var5_22.text = string.format(i18n("tips_fail_secondarypwd_much_times"), var3_23 .. i18n("word_hour"))
				else
					local var4_23 = ""
					local var5_23 = math.floor(var1_23 / 60)

					if var5_23 > 0 then
						var4_23 = var4_23 .. var5_23 .. i18n("word_minute")
					end

					local var6_23 = math.max(var1_23 - var5_23 * 60, 0)

					var5_22.text = string.format(i18n("tips_fail_secondarypwd_much_times"), var4_23 .. var6_23 .. i18n("word_second"))
				end
			end
		end

		var6_22()

		local var7_22 = Timer.New(var6_22, 1, -1)

		var7_22:Start()

		arg0_22.timers.secondaryUItimer = var7_22
	elseif var1_22 == "settips" then
		setActive(var3_22, false)
		setActive(var4_22, true)

		local var8_22 = var4_22:Find("InputField"):GetComponent(typeof(InputField))

		arg1_22.references.inputfield = var8_22
		var8_22.text = arg1_22.references.lasttext or ""

		local var9_22 = 20

		var8_22.onValueChanged:AddListener(function()
			local var0_24, var1_24 = utf8_to_unicode(var8_22.text)

			if var1_24 > var9_22 then
				var8_22.text = SecondaryPasswordMediator.ClipUnicodeStr(var8_22.text, var9_22)
			end
		end)

		local function var10_22()
			if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
				return false
			end

			local var0_25 = var8_22.text
			local var1_25, var2_25 = wordVer(var0_25, {
				isReplace = true
			})

			if var1_25 > 0 or var2_25 ~= var0_25 then
				var0_0.TipsMgr.GetInstance():ShowTips(i18n("secondarypassword_illegal_tip"))

				var8_22.text = var2_25

				return true
			else
				return false
			end
		end

		arg0_22:createBtn({
			text = var1_0.TEXT_CONFIRM,
			btnType = var1_0.BUTTON_BLUE,
			onCallback = arg0_22.settings.onYes,
			sound = SFX_CONFIRM,
			noQuit = var10_22
		})
	end

	arg0_22:Loaded(arg1_22)
end

local function var12_0(arg0_26, arg1_26)
	arg0_26:commonSetting(arg1_26)
	setActive(arg0_26._worldResetPanel, true)
	setActive(arg0_26._worldShopBtn, false)
	setText(arg0_26._worldResetPanel:Find("content/Text"), arg1_26.tipWord)

	local var0_26 = arg0_26._worldResetPanel:Find("IconTpl")

	setActive(var0_26, false)

	local var1_26 = arg0_26._worldResetPanel:Find("content/item_list")

	removeAllChildren(var1_26)

	for iter0_26, iter1_26 in ipairs(arg1_26.drops) do
		local var2_26 = cloneTplTo(var0_26, var1_26)

		updateDrop(var2_26, iter1_26)

		local var3_26 = findTF(var2_26, "name")

		changeToScrollText(var3_26, getText(var3_26))

		if arg1_26.itemFunc then
			onButton(arg0_26, var2_26, function()
				arg1_26.itemFunc(iter1_26)
			end, SFX_PANEL)
		end
	end

	onButton(arg0_26, arg0_26._worldShopBtn, function()
		arg0_26:hide()

		return existCall(arg1_26.goShop)
	end, SFX_MAIN)
	arg0_26:Loaded(arg1_26)
end

local function var13_0(arg0_29, arg1_29)
	arg0_29:commonSetting(arg1_29)

	arg0_29._window.sizeDelta = Vector2(arg0_29._defaultSize.x, 520)

	setActive(arg0_29._obtainPanel, true)
	setActive(arg0_29._btnContainer, false)

	local var0_29 = {
		type = DROP_TYPE_SHIP,
		id = arg1_29.shipId
	}

	updateDrop(arg0_29._obtainPanel, var0_29, arg1_29)

	local var1_29
	local var4_29

	if Ship.isMetaShipByConfigID(arg1_29.shipId) then
		local var2_29 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg1_29.shipId)
		local var3_29 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var2_29)

		if var3_29 and (var3_29:isInAct() or var3_29:isInArchive()) then
			var4_29 = true
		else
			var4_29 = false
		end
	else
		var4_29 = true
	end

	arg0_29.obtainSkipList = arg0_29.obtainSkipList or UIItemList.New(arg0_29._obtainPanel:Find("skipable_list"), arg0_29._obtainPanel:Find("skipable_list/tpl"))

	arg0_29.obtainSkipList:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			local var0_30 = arg1_29.list[arg1_30 + 1]
			local var1_30 = var0_30[1]
			local var2_30 = var0_30[2]
			local var3_30 = var0_30[3]
			local var4_30 = HXSet.hxLan(var1_30)

			arg2_30:Find("mask/title"):GetComponent("ScrollText"):SetText(var4_30)
			setActive(arg2_30:Find("skip_btn"), var4_29 and var2_30[1] ~= "" and var2_30[1] ~= "COLLECTSHIP")

			if var2_30[1] ~= "" then
				onButton(arg0_29, arg2_30:Find("skip_btn"), function()
					if var3_30 and var3_30 ~= 0 then
						local var0_31 = getProxy(ActivityProxy):getActivityById(var3_30)

						if not var0_31 or var0_31:isEnd() then
							var0_0.TipsMgr.GetInstance():ShowTips(i18n("collection_way_is_unopen"))

							return
						end
					elseif var2_30[1] == "SHOP" and var2_30[2].warp == NewShopsScene.TYPE_MILITARY_SHOP and not var0_0.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "MilitaryExerciseMediator") then
						var0_0.TipsMgr.GetInstance():ShowTips(i18n("military_shop_no_open_tip"))

						return
					elseif var2_30[1] == "LEVEL" and var2_30[2] then
						local var1_31 = var2_30[2].chapterid
						local var2_31 = getProxy(ChapterProxy)
						local var3_31 = var2_31:getChapterById(var1_31)

						if var3_31:isUnlock() then
							local var4_31 = var2_31:getActiveChapter()

							if var4_31 and var4_31.id ~= var1_31 then
								arg0_29:ShowMsgBox({
									content = i18n("collect_chapter_is_activation"),
									onYes = function()
										var0_0.m02:sendNotification(GAME.CHAPTER_OP, {
											type = ChapterConst.OpRetreat
										})
									end
								})

								return
							else
								local var5_31 = {
									mapIdx = var3_31:getConfig("map")
								}

								if var3_31.active then
									var5_31.chapterId = var3_31.id
								else
									var5_31.openChapterId = var1_31
								end

								var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var5_31)
							end
						else
							var0_0.TipsMgr.GetInstance():ShowTips(i18n("acquisitionmode_is_not_open"))

							return
						end
					elseif var2_30[1] == "COLLECTSHIP" then
						if arg1_29.mediatorName == CollectionMediator.__cname then
							var0_0.m02:sendNotification(CollectionMediator.EVENT_OBTAIN_SKIP, {
								toggle = 2,
								displayGroupId = var2_30[2].shipGroupId
							})
						else
							var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE.COLLECTSHIP, {
								toggle = 2,
								displayGroupId = var2_30[2].shipGroupId
							})
						end
					elseif var2_30[1] == "SHOP" then
						var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE[var2_30[1]], var2_30[2])
					else
						var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE[var2_30[1]], var2_30[2])
					end

					arg0_29:hide()
				end, SFX_PANEL)
			end
		end
	end)
	arg0_29.obtainSkipList:align(#arg1_29.list)
	arg0_29:Loaded(arg1_29)
end

function var1_0.nextPage(arg0_33)
	arg0_33.helpPage = arg0_33.helpPage + 1

	if arg0_33.helpPage < 1 then
		arg0_33.helpPage = 1
	end

	if arg0_33.helpPage > arg0_33._helpList.childCount then
		arg0_33.helpPage = 1
	end

	arg0_33:switchHelpPage(arg0_33.helpPage)
end

function var1_0.prePage(arg0_34)
	arg0_34.helpPage = arg0_34.helpPage - 1

	if arg0_34.helpPage < 1 then
		arg0_34.helpPage = arg0_34._helpList.childCount
	end

	if arg0_34.helpPage > arg0_34._helpList.childCount then
		arg0_34.helpPage = arg0_34._helpList.childCount
	end

	arg0_34:switchHelpPage(arg0_34.helpPage)
end

function var1_0.switchHelpPage(arg0_35, arg1_35)
	for iter0_35 = 1, arg0_35._helpList.childCount do
		local var0_35 = arg0_35._helpList:GetChild(iter0_35 - 1)

		setActive(var0_35, arg1_35 == iter0_35)
		setText(var0_35:Find("icon/corner/Text"), iter0_35)
	end
end

function var1_0.commonSetting(arg0_36, arg1_36)
	rtf(arg0_36._window).sizeDelta = arg0_36._defaultSize
	rtf(arg0_36._helpPanel).sizeDelta = arg0_36._defaultHelpSize
	arg0_36.enable = true

	var0_0.DelegateInfo.New(arg0_36)
	setActive(arg0_36._msgPanel, false)
	setActive(arg0_36._exchangeShipPanel, false)
	setActive(arg0_36._itemPanel, false)
	setActive(arg0_36._eskinPanel, false)
	setActive(arg0_36._sigleItemPanel, false)
	setActive(arg0_36._inputPanel, false)
	setActive(arg0_36._obtainPanel, false)
	setActive(arg0_36._otherPanel, false)
	setActive(arg0_36._worldResetPanel, false)
	setActive(arg0_36._worldShopBtn, false)
	setActive(arg0_36._helpBgTF, false)
	setActive(arg0_36._helpPanel, arg1_36.helps)

	for iter0_36, iter1_36 in pairs(arg0_36.panelDict) do
		iter1_36.buffer:Hide()
	end

	setActive(arg0_36._btnContainer, true)

	arg0_36.stopRemindToggle.isOn = arg1_36.toggleStatus or false

	setActive(go(arg0_36.stopRemindToggle), arg1_36.showStopRemind)

	arg0_36.stopRemindText.text = arg1_36.stopRamindContent or i18n("dont_remind_today")

	removeAllChildren(arg0_36._btnContainer)

	arg0_36.settings = arg1_36

	SetActive(arg0_36._go, true)

	local var0_36 = arg0_36.settings.needCounter or false

	setActive(arg0_36._countSelect, var0_36)

	local var1_36 = arg0_36.settings.numUpdate
	local var2_36 = arg0_36.settings.addNum or 1
	local var3_36 = arg0_36.settings.maxNum or -1
	local var4_36 = arg0_36.settings.defaultNum or 1

	arg0_36._pageUtil:setNumUpdate(function(arg0_37)
		if var1_36 ~= nil then
			var1_36(arg0_36._countDescTxt, arg0_37)
		end
	end)
	arg0_36._pageUtil:setAddNum(var2_36)
	arg0_36._pageUtil:setMaxNum(var3_36)
	arg0_36._pageUtil:setDefaultNum(var4_36)
	setActive(arg0_36._sliders, arg0_36.settings.discount)

	if arg0_36.settings.discount then
		arg0_36._discount:GetComponent(typeof(Text)).text = arg0_36.settings.discount.discount .. "%OFF"
		arg0_36._discountDate:GetComponent(typeof(Text)).text = arg0_36.settings.discount.date
	end

	setActive(arg0_36._remasterPanel, arg0_36.settings.remaster)

	if arg0_36.settings.remaster then
		local var5_36 = arg0_36.settings.remaster

		setText(arg0_36._remasterPanel:Find("content/Text"), var5_36.word)
		setText(arg0_36._remasterPanel:Find("content/count"), var5_36.number or "")
		setText(arg0_36._remasterPanel:Find("btn/pic"), var5_36.btn_text)
		onButton(arg0_36, arg0_36._remasterPanel:Find("btn"), function()
			if var5_36.btn_call then
				var5_36.btn_call()
			end

			arg0_36:hide()
		end)
	end

	local var6_36 = arg0_36.settings.hideNo or false
	local var7_36 = arg0_36.settings.hideYes or false
	local var8_36 = arg0_36.settings.modal or false
	local var9_36 = arg0_36.settings.onYes or function()
		return
	end
	local var10_36 = arg0_36.settings.onNo or function()
		return
	end

	onButton(arg0_36, tf(arg0_36._go):Find("bg"), function()
		if arg0_36.settings.onClose then
			arg0_36.settings.onClose()
		else
			var10_36()
		end

		arg0_36:hide()
	end, SFX_CANCEL)
	SetCompomentEnabled(tf(arg0_36._go):Find("bg"), typeof(Button), not var8_36)

	local var11_36
	local var12_36

	if not var6_36 then
		local var13_36 = arg0_36:createBtn({
			text = arg0_36.settings.noText or var1_0.TEXT_CANCEL,
			btnType = arg0_36.settings.noBtnType or var1_0.BUTTON_GRAY,
			onCallback = var10_36,
			sound = arg1_36.noSound or SFX_CANCEL
		})
	end

	if not var7_36 then
		var12_36 = arg0_36:createBtn({
			text = arg0_36.settings.yesText or var1_0.TEXT_CONFIRM,
			btnType = arg0_36.settings.yesBtnType or var1_0.BUTTON_BLUE,
			onCallback = var9_36,
			sound = arg1_36.yesSound or SFX_CONFIRM,
			alignment = arg0_36.settings.yesSize and TextAnchor.MiddleCenter,
			gray = arg0_36.settings.yesGray,
			delayButton = arg0_36.settings.delayConfirm
		})

		if arg0_36.settings.yesSize then
			var12_36.sizeDelta = arg0_36.settings.yesSize
		end
	end

	if arg0_36.settings.yseBtnLetf then
		var12_36:SetAsFirstSibling()
	end

	local var14_36

	if arg0_36.settings.type == MSGBOX_TYPE_HELP and arg0_36.settings.helps.pageMode and #arg0_36.settings.helps > 1 then
		arg0_36:createBtn({
			noQuit = true,
			btnType = var1_0.BUTTON_PREPAGE,
			onCallback = function()
				arg0_36:prePage()
			end,
			sound = SFX_CANCEL
		})

		var14_36 = #arg0_36.settings.helps
	end

	if arg0_36.settings.custom ~= nil then
		for iter2_36, iter3_36 in ipairs(arg0_36.settings.custom) do
			arg0_36:createBtn(iter3_36)
		end
	end

	if not var14_36 then
		-- block empty
	elseif var14_36 > 1 then
		arg0_36:createBtn({
			noQuit = true,
			btnType = var1_0.BUTTON_NEXTPAGE,
			onCallback = function()
				arg0_36:nextPage()
			end,
			sound = SFX_CONFIRM
		})
	end

	setActive(arg0_36._closeBtn, not arg1_36.hideClose)
	onButton(arg0_36, arg0_36._closeBtn, function()
		local var0_44 = arg0_36.settings.onClose

		if arg0_36.settings and arg0_36.settings.hideClose and not var0_44 and arg0_36.settings.onYes then
			arg0_36.settings.onYes()
		end

		arg0_36:hide()

		if var0_44 then
			var0_44()
		else
			var10_36()
		end
	end, SFX_CANCEL)

	local var15_36 = arg0_36.settings.title or var1_0.TITLE_INFORMATION
	local var16_36 = 0
	local var17_36 = arg0_36._titleList.transform.childCount

	while var16_36 < var17_36 do
		local var18_36 = arg0_36._titleList.transform:GetChild(var16_36)

		SetActive(var18_36, var18_36.name == var15_36)

		var16_36 = var16_36 + 1
	end

	local var19_36 = arg0_36._go.transform.localPosition

	arg0_36._go.transform.localPosition = Vector3(var19_36.x, var19_36.y, arg0_36.settings.zIndex or 0)
	arg0_36.locked = arg0_36.settings.locked or false
end

function var1_0.createBtn(arg0_45, arg1_45)
	local var0_45 = arg1_45.btnType or var1_0.BUTTON_BLUE
	local var1_45 = arg1_45.noQuit
	local var2_45 = arg0_45._go.transform:Find("custom_btn_list/custom_button_" .. var0_45)
	local var3_45 = cloneTplTo(var2_45, arg0_45._btnContainer)

	if arg1_45.label then
		go(var3_45).name = arg1_45.label
	end

	SetActive(var3_45, true)

	if arg1_45.scale then
		local var4_45 = arg1_45.scale.x or 1
		local var5_45 = arg1_45.scale.y or 1

		var3_45.localScale = Vector2(var4_45, var5_45)
	end

	local var6_45

	if var0_45 == var1_0.BUTTON_MEDAL then
		setText(var3_45:Find("text"), arg1_45.text)

		var6_45 = var3_45:Find("text")
	elseif var0_45 ~= var1_0.BUTTON_RETREAT and var0_45 ~= var1_0.BUTTON_PREPAGE and var0_45 ~= var1_0.BUTTON_NEXTPAGE then
		arg0_45:updateButton(var3_45, arg1_45.text, arg1_45.alignment)

		var6_45 = var3_45:Find("pic")
	end

	if var0_45 == var1_0.BUTTON_BLUE_WITH_ICON and arg1_45.iconName then
		local var7_45 = var3_45:Find("ticket/icon")

		setImageSprite(var7_45, LoadSprite(arg1_45.iconName[1], arg1_45.iconName[2]))
	end

	local var8_45

	if arg1_45.delayButton then
		local var9_45 = arg1_45.delayButton
		local var10_45 = getText(var6_45)

		var8_45 = Timer.New(function()
			var9_45 = var9_45 - 1

			if var9_45 > 0 then
				setText(var6_45, var10_45 .. string.format("(%d)", var9_45))
			else
				setText(var6_45, var10_45)
				setGray(var3_45, arg1_45.gray, true)

				var8_45 = nil
			end
		end, 1, var9_45)
		arg0_45.timers[var3_45] = var8_45

		var8_45:Start()
		setText(var6_45, var10_45 .. string.format("(%d)", var9_45))
		setGray(var3_45, true, true)
	else
		setGray(var3_45, arg1_45.gray, true)
	end

	if not arg1_45.hideEvent then
		onButton(arg0_45, var3_45, function()
			if var8_45 then
				return
			end

			if type(var1_45) == "function" then
				if var1_45() then
					return
				else
					arg0_45:hide()
				end
			elseif not var1_45 then
				arg0_45:hide()
			end

			return existCall(arg1_45.onCallback)
		end, arg1_45.sound or SFX_CONFIRM)
	end

	if arg1_45.sibling then
		var3_45:SetSiblingIndex(arg1_45.sibling)
	end

	return var3_45
end

function var1_0.updateButton(arg0_48, arg1_48, arg2_48, arg3_48)
	local var0_48 = var2_0[arg2_48]
	local var1_48 = arg1_48:Find("pic")

	if IsNil(var1_48) then
		return
	end

	if var0_48 then
		setText(var1_48, i18n(var0_48))
	else
		if string.len(arg2_48) > 12 then
			GetComponent(var1_48, typeof(Text)).resizeTextForBestFit = true
		end

		setText(var1_48, arg2_48)
	end

	if arg3_48 then
		var1_48:GetComponent(typeof(Text)).alignment = arg3_48
	end
end

function var1_0.Loaded(arg0_49, arg1_49)
	var0_0.UIMgr.GetInstance():BlurPanel(arg0_49._tf, false, {
		groupName = arg1_49.groupName,
		weight = arg1_49.weight or LayerWeightConst.SECOND_LAYER,
		blurLevelCamera = arg1_49.blurLevelCamera,
		parent = arg1_49.parent
	})
	var0_0.m02:sendNotification(GAME.OPEN_MSGBOX_DONE)
end

function var1_0.Clear(arg0_50)
	for iter0_50, iter1_50 in pairs(arg0_50.panelDict) do
		iter1_50:Destroy()
	end

	table.clear(arg0_50.panelDict)

	rtf(arg0_50._window).sizeDelta = arg0_50._defaultSize
	rtf(arg0_50._helpPanel).sizeDelta = arg0_50._defaultHelpSize

	setAnchoredPosition(arg0_50._window, {
		x = 0,
		y = 0
	})
	setAnchoredPosition(arg0_50._btnContainer, {
		y = 15
	})
	setAnchoredPosition(arg0_50._helpPanel, {
		x = arg0_50._defaultHelpPos.x,
		y = arg0_50._defaultHelpPos.y
	})
	SetCompomentEnabled(arg0_50._helpPanel:Find("list"), typeof(ScrollRect), true)
	setActive(arg0_50._top, true)
	setActive(findTF(arg0_50._window, "bg"), true)
	setActive(arg0_50._sigleItemPanel:Find("left/own"), false)

	local var0_50 = arg0_50._sigleItemPanel:Find("left/IconTpl")

	SetCompomentEnabled(var0_50:Find("icon_bg"), typeof(Image), true)
	SetCompomentEnabled(var0_50:Find("icon_bg/frame"), typeof(Image), true)
	setActive(var0_50:Find("icon_bg/slv"), false)

	local var1_50 = findTF(var0_50, "icon_bg/icon")

	var1_50.pivot = Vector2(0.5, 0.5)
	var1_50.sizeDelta = Vector2(-4, -4)
	var1_50.anchoredPosition = Vector2(0, 0)

	setActive(arg0_50.singleItemIntro, false)
	setText(arg0_50._singleItemSubIntroTF, "")

	for iter2_50 = 0, arg0_50._helpList.childCount - 1 do
		arg0_50._helpList:GetChild(iter2_50):Find("icon"):GetComponent(typeof(Image)).sprite = nil
	end

	for iter3_50, iter4_50 in pairs(arg0_50.pools) do
		if iter4_50 then
			PoolMgr.GetInstance():ReturnUI(iter4_50.name, iter4_50)
		end
	end

	arg0_50.pools = {}

	for iter5_50, iter6_50 in pairs(arg0_50.timers) do
		iter6_50:Stop()
	end

	arg0_50.timers = {}

	var0_0.DelegateInfo.Dispose(arg0_50)
	removeAllChildren(arg0_50._btnContainer)
	var0_0.UIMgr.GetInstance():UnblurPanel(arg0_50._tf, var0_0.UIMgr.GetInstance().OverlayMain)
	arg0_50.contentText:RemoveAllListeners()

	arg0_50.settings = nil
	arg0_50.enable = false
	arg0_50.locked = nil
end

function var1_0.ShowMsgBox(arg0_51, arg1_51)
	if arg0_51.locked then
		return
	end

	local var0_51 = arg1_51.type or MSGBOX_TYPE_NORMAL

	switch(var0_51, {
		[MSGBOX_TYPE_NORMAL] = function()
			var3_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_INPUT] = function()
			var4_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_SINGLE_ITEM] = function()
			var9_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_EXCHANGE] = function()
			var5_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_DROP_ITEM] = function()
			var8_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_ITEM_BOX] = function()
			var6_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_DROP_ITEM_ESKIN] = function()
			var7_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_HELP] = function()
			arg1_51.hideNo = defaultValue(arg1_51.hideNo, true)
			arg1_51.hideYes = defaultValue(arg1_51.hideYes, true)

			var10_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_SECONDPWD] = function()
			PoolMgr.GetInstance():GetUI("Msgbox4SECPWD", true, function(arg0_61)
				arg0_51.pools.SedondaryUI = arg0_61

				if arg1_51.onPreShow then
					arg1_51.onPreShow()
				end

				arg1_51.secondaryUI = arg0_61

				SetParent(arg0_61, arg0_51._otherPanel, false)
				var11_0(arg0_51, arg1_51)
			end)
		end,
		[MSGBOX_TYPE_WORLD_RESET] = function()
			var12_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_OBTAIN] = function()
			arg1_51.title = arg1_51.title or var1_0.TITLE_OBTAIN

			var13_0(arg0_51, arg1_51)
		end,
		[MSGBOX_TYPE_ITEMTIP] = function()
			arg0_51:GetPanel(ItemTipPanel).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_JUST_FOR_SHOW] = function()
			arg0_51:GetPanel(ItemShowPanel).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_MONTH_CARD_TIP] = function()
			arg0_51:GetPanel(MonthCardOutDateTipPanel).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_STORY_CANCEL_TIP] = function()
			arg0_51:GetPanel(StoryCancelTipPanel).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_META_SKILL_UNLOCK] = function()
			arg0_51:GetPanel(MetaSkillUnlockPanel).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_ACCOUNTDELETE] = function()
			arg0_51:GetPanel(AccountDeletePanel).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_STRENGTHEN_BACK] = function()
			arg0_51:GetPanel(StrengthenBackPanel).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_CONTENT_ITEMS] = function()
			arg0_51:GetPanel(Msgbox4ContentItems).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM] = function()
			arg0_51:GetPanel(Msgbox4BlueprintUnlockItem).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_CONFIRM_DELETE] = function()
			arg0_51:GetPanel(ConfirmEquipmentDeletePanel).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_CONFIRM_REFORGE_SPWEAPON] = function()
			arg0_51:GetPanel(Msgbox4SpweaponConfirm).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_SUBPATTERN] = function()
			arg0_51:GetPanel(arg1_51.patternClass).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_FILE_DOWNLOAD] = function()
			arg0_51:GetPanel(FileDownloadPanel).buffer:UpdateView(arg1_51)
		end,
		[MSGBOX_TYPE_LIKN_COLLECT_GUIDE] = function()
			arg0_51:GetPanel(Msgbox4LinkCollectGuide).buffer:UpdateView(arg1_51)
		end
	})
end

function var1_0.GetPanel(arg0_78, arg1_78)
	if not arg0_78.panelDict[arg1_78] then
		arg0_78.panelDict[arg1_78] = arg1_78.New(arg0_78)

		arg0_78.panelDict[arg1_78]:Load()
		arg0_78.panelDict[arg1_78].buffer:SetParent(arg0_78._window)
	end

	return arg0_78.panelDict[arg1_78]
end

function var1_0.CloseAndHide(arg0_79)
	if not arg0_79.enable then
		return
	end

	local var0_79 = arg0_79.settings
	local var1_79 = var0_79.onClose or not var0_79.hideNo and var0_79.onNo or nil

	existCall(var1_79)
	arg0_79:hide()
end

function var1_0.hide(arg0_80)
	if not arg0_80.enable then
		return
	end

	arg0_80._go:SetActive(false)
	arg0_80:Clear()
	var0_0.m02:sendNotification(GAME.CLOSE_MSGBOX_DONE)
end

function var1_0.emit(arg0_81, arg1_81, ...)
	if not arg0_81.analogyMediator then
		arg0_81.analogyMediator = {
			addSubLayers = function(arg0_82, arg1_82)
				var0_0.m02:sendNotification(GAME.LOAD_LAYERS, {
					parentContext = getProxy(ContextProxy):getCurrentContext(),
					context = arg1_82
				})
			end,
			sendNotification = function(arg0_83, ...)
				var0_0.m02:sendNotification(...)
			end,
			viewComponent = arg0_81
		}
	end

	return ContextMediator.CommonBindDic[arg1_81](arg0_81.analogyMediator, arg1_81, ...)
end

function var1_0.closeView(arg0_84)
	arg0_84:hide()
end

return var1_0
