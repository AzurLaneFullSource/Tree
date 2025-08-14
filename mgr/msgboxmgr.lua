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
	setActive(arg0_16._sigleItemPanel:Find("combat_skin"), false)
	setActive(arg0_16._sigleItemPanel:Find("source_panel"), false)

	local var0_16 = arg0_16._sigleItemPanel:Find("display_panel"):GetComponent(typeof(RectTransform))

	var0_16.sizeDelta = Vector2(var0_16.sizeDelta.x, -114.5)

	local var1_16 = arg0_16.singleItemIntro

	SetActive(var1_16, true)
	setText(var1_16, arg1_16.content or "")

	local var2_16 = arg0_16._sigleItemPanel:Find("left/IconTpl")

	setText(var2_16:Find("icon_bg/count"), "")
	SetActive(var2_16:Find("icon_bg/startpl"), false)
	SetCompomentEnabled(var2_16:Find("icon_bg"), typeof(Image), not arg1_16.hideIconBG)
	SetCompomentEnabled(var2_16:Find("icon_bg/frame"), typeof(Image), not arg1_16.hideIconBG)

	local var3_16 = var2_16:Find("icon_bg/frame")

	setFrame(var3_16, arg1_16.frame or 1)
	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg1_16.frame or 1), var2_16:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync(arg1_16.iconPath[1], arg1_16.iconPath[2] or "", var2_16:Find("icon_bg/icon"))
	setText(arg0_16._sigleItemPanel:Find("display_panel/name_container/name/Text"), arg1_16.name or "")
	arg0_16:Loaded(arg1_16)
end

local function var9_0(arg0_17, arg1_17)
	arg0_17:commonSetting(arg1_17)
	SetActive(arg0_17._sigleItemPanel, true)

	local var0_17 = arg1_17.drop
	local var1_17 = arg0_17._sigleItemPanel:Find("left/IconTpl")

	setActive(var1_17:Find("timelimit"), var0_17.type == DROP_TYPE_SKIN_TIMELIMIT)
	updateDrop(var1_17, var0_17)
	setActive(arg0_17._singleItemshipTypeTF, var0_17.type == DROP_TYPE_SHIP)
	setActive(arg0_17._sigleItemPanel:Find("combat_skin"), false)
	setActive(arg0_17._sigleItemPanel:Find("source_panel"), false)

	local var2_17 = arg0_17._sigleItemPanel:Find("display_panel"):GetComponent(typeof(RectTransform))

	var2_17.sizeDelta = Vector2(var2_17.sizeDelta.x, -114.5)

	if var0_17.type == DROP_TYPE_SHIP then
		GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var0_17:getConfig("type")), arg0_17._singleItemshipTypeTF, false)
	elseif var0_17.type == DROP_TYPE_ITEM then
		local var3_17 = ItemTipPanel.GetDropLackConfig(var0_17)
		local var4_17 = var3_17 and var3_17.description or {}

		if #var4_17 > 0 then
			var2_17.sizeDelta = Vector2(var2_17.sizeDelta.x, -170.5)

			UIItemList.StaticAlign(arg0_17._sigleItemPanel:Find("source_panel/Viewport/Content"), arg0_17._sigleItemPanel:Find("source_panel/Viewport/Content/sourceItem"), #var4_17, function(arg0_18, arg1_18, arg2_18)
				if arg0_18 == UIItemList.EventUpdate then
					local var0_18 = var4_17[arg1_18 + 1]
					local var1_18, var2_18, var3_18 = unpack(var0_18)

					setText(arg2_18:Find("desc"), var1_18)
					setText(arg2_18:Find("btn/Text"), i18n("feast_res_window_go_label"))

					local var4_18, var5_18 = unpack(var2_18)
					local var6_18 = #var4_18 > 0

					if var3_18 and var3_18 ~= 0 then
						var6_18 = var6_18 and getProxy(ActivityProxy):IsActivityNotEnd(var3_18)
					end

					setActive(arg2_18:Find("btn"), var6_18)
					onButton(arg0_17, arg2_18:Find("btn"), function()
						ItemTipPanel.ConfigGoScene(var4_18, var5_18, function()
							arg0_17:hide()
						end)
					end, SFX_PANEL)
				end
			end)
			setActive(arg0_17._sigleItemPanel:Find("source_panel"), true)
		else
			setActive(arg0_17._sigleItemPanel:Find("source_panel"), false)
		end
	elseif var0_17.type == DROP_TYPE_COMBAT_UI_STYLE then
		var2_17.sizeDelta = Vector2(var2_17.sizeDelta.x, -170.5)

		local var5_17 = var0_0.item_data_battleui[var0_17.id].rare_display
		local var6_17 = UIItemList.New(arg0_17._sigleItemPanel:Find("combat_skin/elementList"), arg0_17._sigleItemPanel:Find("combat_skin/elementList/main"))

		var6_17:make(function(arg0_21, arg1_21, arg2_21)
			if arg0_21 == UIItemList.EventUpdate then
				local var0_21 = var5_17[arg1_21 + 1]

				GetImageSpriteFromAtlasAsync("ui/combatskinrare", CombatSkinConst.TYPE_ICON_NAME[var0_21], arg2_21:Find("icon"), true)
				setScrollText(arg2_21:Find("TextMask/Text"), i18n("battleui_display" .. var0_21))
			end
		end)
		var6_17:align(#var5_17)
		setActive(arg0_17._sigleItemPanel:Find("combat_skin"), true)
	end

	local var7_17 = var0_17.type == DROP_TYPE_SHIP
	local var8_17 = arg0_17._sigleItemPanel:Find("ship_group")

	SetActive(var8_17, var7_17)

	if var7_17 then
		local var9_17 = tobool(getProxy(CollectionProxy):getShipGroup(var0_0.ship_data_template[var0_17.id].group_type))

		SetActive(var8_17:Find("unlocked"), var9_17)
		SetActive(var8_17:Find("locked"), not var9_17)
	end

	if arg1_17.windowSize then
		arg0_17._window.sizeDelta = Vector2(arg1_17.windowSize.x or arg0_17._defaultSize.x, arg1_17.windowSize.y or arg0_17._defaultSize.y)
	end

	local var10_17 = arg0_17.singleItemIntro
	local var11_17 = arg0_17._singleItemSubIntroTF
	local var12_17 = arg0_17.settings.numUpdate

	setActive(arg0_17._countDescTxt, var12_17 ~= nil)
	SetActive(var10_17, var12_17 == nil)

	local var13_17 = arg1_17.name or var0_17:getConfig("name") or ""

	setText(arg0_17._sigleItemPanel:Find("display_panel/name_container/name/Text"), var13_17)
	UpdateOwnDisplay(arg0_17._sigleItemPanel:Find("left/own"), var0_17)
	RegisterDetailButton(arg0_17, arg0_17._sigleItemPanel:Find("left/detail"), var0_17)

	if arg1_17.iconPreservedAspect then
		local var14_17 = var1_17:Find("icon_bg/icon")
		local var15_17 = var14_17:GetComponent(typeof(Image))

		var14_17.pivot = Vector2(0.5, 1)

		local var16_17 = var14_17.rect.width
		local var17_17 = var15_17.preferredHeight / var15_17.preferredWidth * var16_17

		var14_17.sizeDelta = Vector2(-4, var17_17 - var16_17 - 4)
		var14_17.anchoredPosition = Vector2(0, -2)
	end

	if arg1_17.content and arg1_17.content ~= "" then
		setText(var10_17, arg1_17.content)
	elseif var0_17.type == DROP_TYPE_WORLD_COLLECTION then
		var0_17:MsgboxIntroSet(arg1_17, var10_17, arg0_17._sigleItemPanel:Find("name_mode/name_mask/name"))
	else
		var0_17:MsgboxIntroSet(arg1_17, var10_17)
	end

	if arg1_17.intro then
		setText(var10_17, arg1_17.intro)
	end

	setText(var11_17, arg1_17.subIntro or arg1_17.extendDesc or "")

	if arg1_17.enabelYesBtn ~= nil then
		local var18_17 = arg0_17._btnContainer:GetChild(1)

		setButtonEnabled(var18_17, arg1_17.enabelYesBtn)
		eachChild(var18_17, function(arg0_22)
			local var0_22 = arg1_17.enabelYesBtn and 1 or 0.3

			GetOrAddComponent(arg0_22, typeof(CanvasGroup)).alpha = var0_22
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

local function var10_0(arg0_23, arg1_23)
	arg0_23:commonSetting(arg1_23)
	setActive(findTF(arg0_23._helpPanel, "bg"), not arg1_23.helps.pageMode)
	setActive(arg0_23._helpBgTF, arg1_23.helps.pageMode)
	setActive(arg0_23._helpPanel:Find("btn_blueprint"), arg1_23.show_blueprint)

	if arg1_23.show_blueprint then
		onButton(arg0_23, arg0_23._helpPanel:Find("btn_blueprint"), function()
			arg0_23:hide()
			var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT, {
				shipGroupId = arg1_23.show_blueprint
			})
		end, SFX_PANEL)
	end

	if arg1_23.helps.helpSize then
		arg0_23._helpPanel.sizeDelta = Vector2(arg1_23.helps.helpSize.x or arg0_23._defaultHelpSize.x, arg1_23.helps.helpSize.y or arg0_23._defaultHelpSize.y)
	end

	if arg1_23.helps.helpPos then
		setAnchoredPosition(arg0_23._helpPanel, {
			x = arg1_23.helps.helpPos.x or arg0_23._defaultHelpPos.x,
			y = arg1_23.helps.helpPos.y or arg0_23._defaultHelpPos.y
		})
	end

	if arg1_23.helps.windowSize then
		arg0_23._window.sizeDelta = Vector2(arg1_23.helps.windowSize.x or arg0_23._defaultSize.x, arg1_23.helps.windowSize.y or arg0_23._defaultSize.y)
	end

	if arg1_23.helps.windowPos then
		arg0_23._window.sizeDelta = Vector2(arg1_23.helps.windowSize.x or arg0_23._defaultSize.x, arg1_23.helps.windowSize.y or arg0_23._defaultSize.y)

		setAnchoredPosition(arg0_23._window, {
			x = arg1_23.helps.windowPos.x or 0,
			y = arg1_23.helps.windowPos.y or 0
		})
	else
		setAnchoredPosition(arg0_23._window, {
			x = 0,
			y = 0
		})
	end

	if arg1_23.helps.buttonsHeight then
		setAnchoredPosition(arg0_23._btnContainer, {
			y = arg1_23.helps.buttonsHeight
		})
	end

	if arg1_23.helps.disableScroll then
		local var0_23 = arg0_23._helpPanel:Find("list")

		SetCompomentEnabled(arg0_23._helpPanel:Find("list"), typeof(ScrollRect), not arg1_23.helps.disableScroll)
		setAnchoredPosition(var0_23, Vector2.zero)
		setActive(findTF(arg0_23._helpPanel, "Scrollbar"), false)
	end

	if arg1_23.helps.ImageMode then
		setActive(arg0_23._top, false)
		setActive(findTF(arg0_23._window, "bg"), false)
	end

	local var1_23 = arg0_23.settings.helps

	for iter0_23 = #var1_23, arg0_23._helpList.childCount - 1 do
		Destroy(arg0_23._helpList:GetChild(iter0_23))
	end

	for iter1_23 = arg0_23._helpList.childCount, #var1_23 - 1 do
		cloneTplTo(arg0_23._helpTpl, arg0_23._helpList)
	end

	for iter2_23, iter3_23 in ipairs(var1_23) do
		local var2_23 = arg0_23._helpList:GetChild(iter2_23 - 1)

		setActive(var2_23, true)

		local var3_23 = var2_23:Find("icon")

		setActive(var3_23, iter3_23.icon)
		setActive(findTF(var2_23, "line"), iter3_23.line)

		if iter3_23.icon then
			local var4_23 = 1

			if arg1_23.helps.ImageMode then
				var4_23 = 1.5
			end

			var3_23.transform.localScale = Vector2(iter3_23.icon.scale or var4_23, iter3_23.icon.scale or var4_23)

			local var5_23 = iter3_23.icon.path
			local var6_23 = iter3_23.icon.posX and iter3_23.icon.posX or -20
			local var7_23 = iter3_23.icon.posY and iter3_23.icon.posY or 0
			local var8_23 = LoadSprite(iter3_23.icon.atlas, iter3_23.icon.path)

			setImageSprite(var3_23:GetComponent(typeof(Image)), var8_23, true)
			setAnchoredPosition(var3_23, {
				x = var6_23,
				y = var7_23
			})
			setActive(var3_23:Find("corner"), arg1_23.helps.pageMode)
		end

		local var9_23 = var2_23:Find("richText"):GetComponent("RichText")

		if iter3_23.rawIcon then
			local var10_23 = iter3_23.rawIcon.name

			var9_23:AddSprite(var10_23, GetSpriteFromAtlas(iter3_23.rawIcon.atlas, var10_23))

			local var11_23 = HXSet.hxLan(iter3_23.info or "")

			setText(var2_23, "")

			var9_23.text = string.format("<icon name=%s w=0.7 h=0.7/>%s", var10_23, var11_23)
		else
			setText(var2_23, HXSet.hxLan(iter3_23.info and SwitchSpecialChar(iter3_23.info, true) or ""))
		end

		setActive(var9_23.gameObject, iter3_23.rawIcon)
	end

	arg0_23.helpPage = arg1_23.helps.defaultpage or 1

	if arg1_23.helps.pageMode then
		arg0_23:switchHelpPage(arg0_23.helpPage)
	end

	arg0_23:Loaded(arg1_23)
end

local function var11_0(arg0_25, arg1_25)
	arg0_25:commonSetting(arg1_25)
	setActive(arg0_25._otherPanel, true)

	local var0_25 = tf(arg1_25.secondaryUI)

	arg0_25._window.sizeDelta = Vector2(960, arg0_25._defaultSize.y)

	setActive(var0_25, true)

	local var1_25 = arg1_25.mode
	local var2_25 = getProxy(SecondaryPWDProxy):getRawData()
	local var3_25 = var0_25:Find("showresttime")
	local var4_25 = var0_25:Find("settips")

	if var1_25 == "showresttime" then
		setActive(var3_25, true)
		setActive(var4_25, false)

		local var5_25 = var3_25:Find("desc"):GetComponent(typeof(Text))

		if arg0_25.timers.secondaryUItimer then
			arg0_25.timers.secondaryUItimer:Stop()
		end

		local function var6_25()
			local var0_26 = var0_0.TimeMgr.GetInstance():GetServerTime()
			local var1_26 = var2_25.fail_cd and var2_25.fail_cd - var0_26 or 0

			var1_26 = var1_26 < 0 and 0 or var1_26

			local var2_26 = math.floor(var1_26 / 86400)

			if var2_26 > 0 then
				var5_25.text = string.format(i18n("tips_fail_secondarypwd_much_times"), var2_26 .. i18n("word_date"))
			else
				local var3_26 = math.floor(var1_26 / 3600)

				if var3_26 > 0 then
					var5_25.text = string.format(i18n("tips_fail_secondarypwd_much_times"), var3_26 .. i18n("word_hour"))
				else
					local var4_26 = ""
					local var5_26 = math.floor(var1_26 / 60)

					if var5_26 > 0 then
						var4_26 = var4_26 .. var5_26 .. i18n("word_minute")
					end

					local var6_26 = math.max(var1_26 - var5_26 * 60, 0)

					var5_25.text = string.format(i18n("tips_fail_secondarypwd_much_times"), var4_26 .. var6_26 .. i18n("word_second"))
				end
			end
		end

		var6_25()

		local var7_25 = Timer.New(var6_25, 1, -1)

		var7_25:Start()

		arg0_25.timers.secondaryUItimer = var7_25
	elseif var1_25 == "settips" then
		setActive(var3_25, false)
		setActive(var4_25, true)

		local var8_25 = var4_25:Find("InputField"):GetComponent(typeof(InputField))

		arg1_25.references.inputfield = var8_25
		var8_25.text = arg1_25.references.lasttext or ""

		local var9_25 = 20

		var8_25.onValueChanged:AddListener(function()
			local var0_27, var1_27 = utf8_to_unicode(var8_25.text)

			if var1_27 > var9_25 then
				var8_25.text = SecondaryPasswordMediator.ClipUnicodeStr(var8_25.text, var9_25)
			end
		end)

		local function var10_25()
			if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
				return false
			end

			local var0_28 = var8_25.text
			local var1_28, var2_28 = wordVer(var0_28, {
				isReplace = true
			})

			if var1_28 > 0 or var2_28 ~= var0_28 then
				var0_0.TipsMgr.GetInstance():ShowTips(i18n("secondarypassword_illegal_tip"))

				var8_25.text = var2_28

				return true
			else
				return false
			end
		end

		arg0_25:createBtn({
			text = var1_0.TEXT_CONFIRM,
			btnType = var1_0.BUTTON_BLUE,
			onCallback = arg0_25.settings.onYes,
			sound = SFX_CONFIRM,
			noQuit = var10_25
		})
	end

	arg0_25:Loaded(arg1_25)
end

local function var12_0(arg0_29, arg1_29)
	arg0_29:commonSetting(arg1_29)
	setActive(arg0_29._worldResetPanel, true)
	setActive(arg0_29._worldShopBtn, false)
	setText(arg0_29._worldResetPanel:Find("content/Text"), arg1_29.tipWord)

	local var0_29 = arg0_29._worldResetPanel:Find("IconTpl")

	setActive(var0_29, false)

	local var1_29 = arg0_29._worldResetPanel:Find("content/item_list")

	removeAllChildren(var1_29)

	for iter0_29, iter1_29 in ipairs(arg1_29.drops) do
		local var2_29 = cloneTplTo(var0_29, var1_29)

		updateDrop(var2_29, iter1_29)

		local var3_29 = findTF(var2_29, "name")

		changeToScrollText(var3_29, getText(var3_29))

		if arg1_29.itemFunc then
			onButton(arg0_29, var2_29, function()
				arg1_29.itemFunc(iter1_29)
			end, SFX_PANEL)
		end
	end

	onButton(arg0_29, arg0_29._worldShopBtn, function()
		arg0_29:hide()

		return existCall(arg1_29.goShop)
	end, SFX_MAIN)
	arg0_29:Loaded(arg1_29)
end

local function var13_0(arg0_32, arg1_32)
	arg0_32:commonSetting(arg1_32)

	arg0_32._window.sizeDelta = Vector2(arg0_32._defaultSize.x, 520)

	setActive(arg0_32._obtainPanel, true)
	setActive(arg0_32._btnContainer, false)

	local var0_32 = {
		type = DROP_TYPE_SHIP,
		id = arg1_32.shipId
	}

	updateDrop(arg0_32._obtainPanel, var0_32, arg1_32)

	local var1_32
	local var4_32

	if Ship.isMetaShipByConfigID(arg1_32.shipId) then
		local var2_32 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg1_32.shipId)
		local var3_32 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var2_32)

		if var3_32 and (var3_32:isInAct() or var3_32:isInArchive()) then
			var4_32 = true
		else
			var4_32 = false
		end
	else
		var4_32 = true
	end

	arg0_32.obtainSkipList = arg0_32.obtainSkipList or UIItemList.New(arg0_32._obtainPanel:Find("skipable_list"), arg0_32._obtainPanel:Find("skipable_list/tpl"))

	arg0_32.obtainSkipList:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = arg1_32.list[arg1_33 + 1]
			local var1_33 = var0_33[1]
			local var2_33 = var0_33[2]
			local var3_33 = var0_33[3]
			local var4_33 = HXSet.hxLan(var1_33)

			arg2_33:Find("mask/title"):GetComponent("ScrollText"):SetText(var4_33)
			setActive(arg2_33:Find("skip_btn"), var4_32 and var2_33[1] ~= "" and var2_33[1] ~= "COLLECTSHIP")

			if var2_33[1] ~= "" then
				onButton(arg0_32, arg2_33:Find("skip_btn"), function()
					if var3_33 and var3_33 ~= 0 then
						local var0_34 = getProxy(ActivityProxy):getActivityById(var3_33)

						if not var0_34 or var0_34:isEnd() then
							var0_0.TipsMgr.GetInstance():ShowTips(i18n("collection_way_is_unopen"))

							return
						end
					elseif var2_33[1] == "SHOP" and var2_33[2].warp == NewShopsScene.TYPE_MILITARY_SHOP and not var0_0.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "MilitaryExerciseMediator") then
						var0_0.TipsMgr.GetInstance():ShowTips(i18n("military_shop_no_open_tip"))

						return
					elseif var2_33[1] == "LEVEL" and var2_33[2] then
						local var1_34 = var2_33[2].chapterid
						local var2_34 = getProxy(ChapterProxy)
						local var3_34 = var2_34:getChapterById(var1_34)

						if var3_34:isUnlock() then
							local var4_34 = var2_34:getActiveChapter()

							if var4_34 and var4_34.id ~= var1_34 then
								arg0_32:ShowMsgBox({
									content = i18n("collect_chapter_is_activation"),
									onYes = function()
										var0_0.m02:sendNotification(GAME.CHAPTER_OP, {
											type = ChapterConst.OpRetreat
										})
									end
								})

								return
							else
								local var5_34 = {
									mapIdx = var3_34:getConfig("map")
								}

								if var3_34.active then
									var5_34.chapterId = var3_34.id
								else
									var5_34.openChapterId = var1_34
								end

								var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var5_34)
							end
						else
							var0_0.TipsMgr.GetInstance():ShowTips(i18n("acquisitionmode_is_not_open"))

							return
						end
					elseif var2_33[1] == "COLLECTSHIP" then
						if arg1_32.mediatorName == CollectionMediator.__cname then
							var0_0.m02:sendNotification(CollectionMediator.EVENT_OBTAIN_SKIP, {
								toggle = 2,
								displayGroupId = var2_33[2].shipGroupId
							})
						else
							var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE.COLLECTSHIP, {
								toggle = 2,
								displayGroupId = var2_33[2].shipGroupId
							})
						end
					elseif var2_33[1] == "SHOP" then
						var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE[var2_33[1]], var2_33[2])
					else
						var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE[var2_33[1]], var2_33[2])
					end

					arg0_32:hide()
				end, SFX_PANEL)
			end
		end
	end)
	arg0_32.obtainSkipList:align(#arg1_32.list)
	arg0_32:Loaded(arg1_32)
end

function var1_0.nextPage(arg0_36)
	arg0_36.helpPage = arg0_36.helpPage + 1

	if arg0_36.helpPage < 1 then
		arg0_36.helpPage = 1
	end

	if arg0_36.helpPage > arg0_36._helpList.childCount then
		arg0_36.helpPage = 1
	end

	arg0_36:switchHelpPage(arg0_36.helpPage)
end

function var1_0.prePage(arg0_37)
	arg0_37.helpPage = arg0_37.helpPage - 1

	if arg0_37.helpPage < 1 then
		arg0_37.helpPage = arg0_37._helpList.childCount
	end

	if arg0_37.helpPage > arg0_37._helpList.childCount then
		arg0_37.helpPage = arg0_37._helpList.childCount
	end

	arg0_37:switchHelpPage(arg0_37.helpPage)
end

function var1_0.switchHelpPage(arg0_38, arg1_38)
	for iter0_38 = 1, arg0_38._helpList.childCount do
		local var0_38 = arg0_38._helpList:GetChild(iter0_38 - 1)

		setActive(var0_38, arg1_38 == iter0_38)
		setText(var0_38:Find("icon/corner/Text"), iter0_38)
	end
end

function var1_0.commonSetting(arg0_39, arg1_39)
	rtf(arg0_39._window).sizeDelta = arg0_39._defaultSize
	rtf(arg0_39._helpPanel).sizeDelta = arg0_39._defaultHelpSize
	arg0_39.enable = true

	var0_0.DelegateInfo.New(arg0_39)
	setActive(arg0_39._msgPanel, false)
	setActive(arg0_39._exchangeShipPanel, false)
	setActive(arg0_39._itemPanel, false)
	setActive(arg0_39._eskinPanel, false)
	setActive(arg0_39._sigleItemPanel, false)
	setActive(arg0_39._inputPanel, false)
	setActive(arg0_39._obtainPanel, false)
	setActive(arg0_39._otherPanel, false)
	setActive(arg0_39._worldResetPanel, false)
	setActive(arg0_39._worldShopBtn, false)
	setActive(arg0_39._helpBgTF, false)
	setActive(arg0_39._helpPanel, arg1_39.helps)

	for iter0_39, iter1_39 in pairs(arg0_39.panelDict) do
		iter1_39.buffer:Hide()
	end

	setActive(arg0_39._btnContainer, true)

	arg0_39.stopRemindToggle.isOn = arg1_39.toggleStatus or false

	setActive(go(arg0_39.stopRemindToggle), arg1_39.showStopRemind)

	arg0_39.stopRemindText.text = arg1_39.stopRamindContent or i18n("dont_remind_today")

	removeAllChildren(arg0_39._btnContainer)

	arg0_39.settings = arg1_39

	SetActive(arg0_39._go, true)

	local var0_39 = arg0_39.settings.needCounter or false

	setActive(arg0_39._countSelect, var0_39)

	local var1_39 = arg0_39.settings.numUpdate
	local var2_39 = arg0_39.settings.addNum or 1
	local var3_39 = arg0_39.settings.maxNum or -1
	local var4_39 = arg0_39.settings.defaultNum or 1

	arg0_39._pageUtil:setNumUpdate(function(arg0_40)
		if var1_39 ~= nil then
			var1_39(arg0_39._countDescTxt, arg0_40)
		end
	end)
	arg0_39._pageUtil:setAddNum(var2_39)
	arg0_39._pageUtil:setMaxNum(var3_39)
	arg0_39._pageUtil:setDefaultNum(var4_39)
	setActive(arg0_39._sliders, arg0_39.settings.discount)

	if arg0_39.settings.discount then
		arg0_39._discount:GetComponent(typeof(Text)).text = arg0_39.settings.discount.discount .. "%OFF"
		arg0_39._discountDate:GetComponent(typeof(Text)).text = arg0_39.settings.discount.date
	end

	setActive(arg0_39._remasterPanel, arg0_39.settings.remaster)

	if arg0_39.settings.remaster then
		local var5_39 = arg0_39.settings.remaster

		setText(arg0_39._remasterPanel:Find("content/Text"), var5_39.word)
		setText(arg0_39._remasterPanel:Find("content/count"), var5_39.number or "")
		setText(arg0_39._remasterPanel:Find("btn/pic"), var5_39.btn_text)
		onButton(arg0_39, arg0_39._remasterPanel:Find("btn"), function()
			if var5_39.btn_call then
				var5_39.btn_call()
			end

			arg0_39:hide()
		end)
	end

	local var6_39 = arg0_39.settings.hideNo or false
	local var7_39 = arg0_39.settings.hideYes or false
	local var8_39 = arg0_39.settings.modal or false
	local var9_39 = arg0_39.settings.onYes or function()
		return
	end
	local var10_39 = arg0_39.settings.onNo or function()
		return
	end

	onButton(arg0_39, tf(arg0_39._go):Find("bg"), function()
		if arg0_39.settings.onClose then
			arg0_39.settings.onClose()
		else
			var10_39()
		end

		arg0_39:hide()
	end, SFX_CANCEL)
	SetCompomentEnabled(tf(arg0_39._go):Find("bg"), typeof(Button), not var8_39)

	local var11_39
	local var12_39

	if not var6_39 then
		local var13_39 = arg0_39:createBtn({
			text = arg0_39.settings.noText or var1_0.TEXT_CANCEL,
			btnType = arg0_39.settings.noBtnType or var1_0.BUTTON_GRAY,
			onCallback = var10_39,
			sound = arg1_39.noSound or SFX_CANCEL
		})
	end

	if not var7_39 then
		var12_39 = arg0_39:createBtn({
			text = arg0_39.settings.yesText or var1_0.TEXT_CONFIRM,
			btnType = arg0_39.settings.yesBtnType or var1_0.BUTTON_BLUE,
			onCallback = var9_39,
			sound = arg1_39.yesSound or SFX_CONFIRM,
			alignment = arg0_39.settings.yesSize and TextAnchor.MiddleCenter,
			gray = arg0_39.settings.yesGray,
			delayButton = arg0_39.settings.delayConfirm
		})

		if arg0_39.settings.yesSize then
			var12_39.sizeDelta = arg0_39.settings.yesSize
		end
	end

	if arg0_39.settings.yseBtnLetf then
		var12_39:SetAsFirstSibling()
	end

	local var14_39

	if arg0_39.settings.type == MSGBOX_TYPE_HELP and arg0_39.settings.helps.pageMode and #arg0_39.settings.helps > 1 then
		arg0_39:createBtn({
			noQuit = true,
			btnType = var1_0.BUTTON_PREPAGE,
			onCallback = function()
				arg0_39:prePage()
			end,
			sound = SFX_CANCEL
		})

		var14_39 = #arg0_39.settings.helps
	end

	if arg0_39.settings.custom ~= nil then
		for iter2_39, iter3_39 in ipairs(arg0_39.settings.custom) do
			arg0_39:createBtn(iter3_39)
		end
	end

	if not var14_39 then
		-- block empty
	elseif var14_39 > 1 then
		arg0_39:createBtn({
			noQuit = true,
			btnType = var1_0.BUTTON_NEXTPAGE,
			onCallback = function()
				arg0_39:nextPage()
			end,
			sound = SFX_CONFIRM
		})
	end

	setActive(arg0_39._closeBtn, not arg1_39.hideClose)
	onButton(arg0_39, arg0_39._closeBtn, function()
		local var0_47 = arg0_39.settings.onClose

		if arg0_39.settings and arg0_39.settings.hideClose and not var0_47 and arg0_39.settings.onYes then
			arg0_39.settings.onYes()
		end

		arg0_39:hide()

		if var0_47 then
			var0_47()
		else
			var10_39()
		end
	end, SFX_CANCEL)

	local var15_39 = arg0_39.settings.title or var1_0.TITLE_INFORMATION
	local var16_39 = 0
	local var17_39 = arg0_39._titleList.transform.childCount

	while var16_39 < var17_39 do
		local var18_39 = arg0_39._titleList.transform:GetChild(var16_39)

		SetActive(var18_39, var18_39.name == var15_39)

		var16_39 = var16_39 + 1
	end

	local var19_39 = arg0_39._go.transform.localPosition

	arg0_39._go.transform.localPosition = Vector3(var19_39.x, var19_39.y, arg0_39.settings.zIndex or 0)
	arg0_39.locked = arg0_39.settings.locked or false
end

function var1_0.createBtn(arg0_48, arg1_48)
	local var0_48 = arg1_48.btnType or var1_0.BUTTON_BLUE
	local var1_48 = arg1_48.noQuit
	local var2_48 = arg0_48._go.transform:Find("custom_btn_list/custom_button_" .. var0_48)
	local var3_48 = cloneTplTo(var2_48, arg0_48._btnContainer)

	if arg1_48.label then
		go(var3_48).name = arg1_48.label
	end

	SetActive(var3_48, true)

	if arg1_48.scale then
		local var4_48 = arg1_48.scale.x or 1
		local var5_48 = arg1_48.scale.y or 1

		var3_48.localScale = Vector2(var4_48, var5_48)
	end

	local var6_48

	if var0_48 == var1_0.BUTTON_MEDAL then
		setText(var3_48:Find("text"), arg1_48.text)

		var6_48 = var3_48:Find("text")
	elseif var0_48 ~= var1_0.BUTTON_RETREAT and var0_48 ~= var1_0.BUTTON_PREPAGE and var0_48 ~= var1_0.BUTTON_NEXTPAGE then
		arg0_48:updateButton(var3_48, arg1_48.text, arg1_48.alignment)

		var6_48 = var3_48:Find("pic")
	end

	if var0_48 == var1_0.BUTTON_BLUE_WITH_ICON and arg1_48.iconName then
		local var7_48 = var3_48:Find("ticket/icon")

		setImageSprite(var7_48, LoadSprite(arg1_48.iconName[1], arg1_48.iconName[2]))
	end

	local var8_48

	if arg1_48.delayButton then
		local var9_48 = arg1_48.delayButton
		local var10_48 = getText(var6_48)

		var8_48 = Timer.New(function()
			var9_48 = var9_48 - 1

			if var9_48 > 0 then
				setText(var6_48, var10_48 .. string.format("(%d)", var9_48))
			else
				setText(var6_48, var10_48)
				setGray(var3_48, arg1_48.gray, true)

				var8_48 = nil
			end
		end, 1, var9_48)
		arg0_48.timers[var3_48] = var8_48

		var8_48:Start()
		setText(var6_48, var10_48 .. string.format("(%d)", var9_48))
		setGray(var3_48, true, true)
	else
		setGray(var3_48, arg1_48.gray, true)
	end

	if not arg1_48.hideEvent then
		onButton(arg0_48, var3_48, function()
			if var8_48 then
				return
			end

			if type(var1_48) == "function" then
				if var1_48() then
					return
				else
					arg0_48:hide()
				end
			elseif not var1_48 then
				arg0_48:hide()
			end

			return existCall(arg1_48.onCallback)
		end, arg1_48.sound or SFX_CONFIRM)
	end

	if arg1_48.sibling then
		var3_48:SetSiblingIndex(arg1_48.sibling)
	end

	return var3_48
end

function var1_0.updateButton(arg0_51, arg1_51, arg2_51, arg3_51)
	local var0_51 = var2_0[arg2_51]
	local var1_51 = arg1_51:Find("pic")

	if IsNil(var1_51) then
		return
	end

	if var0_51 then
		setText(var1_51, i18n(var0_51))
	else
		if string.len(arg2_51) > 12 then
			GetComponent(var1_51, typeof(Text)).resizeTextForBestFit = true
		end

		setText(var1_51, arg2_51)
	end

	if arg3_51 then
		var1_51:GetComponent(typeof(Text)).alignment = arg3_51
	end
end

function var1_0.Loaded(arg0_52, arg1_52)
	var0_0.UIMgr.GetInstance():BlurPanel(arg0_52._tf, false, {
		groupName = arg1_52.groupName,
		weight = arg1_52.weight or LayerWeightConst.SECOND_LAYER,
		blurLevelCamera = arg1_52.blurLevelCamera,
		parent = arg1_52.parent
	})
	var0_0.m02:sendNotification(GAME.OPEN_MSGBOX_DONE)
end

function var1_0.Clear(arg0_53)
	for iter0_53, iter1_53 in pairs(arg0_53.panelDict) do
		iter1_53:Destroy()
	end

	table.clear(arg0_53.panelDict)

	rtf(arg0_53._window).sizeDelta = arg0_53._defaultSize
	rtf(arg0_53._helpPanel).sizeDelta = arg0_53._defaultHelpSize

	setAnchoredPosition(arg0_53._window, {
		x = 0,
		y = 0
	})
	setAnchoredPosition(arg0_53._btnContainer, {
		y = 15
	})
	setAnchoredPosition(arg0_53._helpPanel, {
		x = arg0_53._defaultHelpPos.x,
		y = arg0_53._defaultHelpPos.y
	})
	SetCompomentEnabled(arg0_53._helpPanel:Find("list"), typeof(ScrollRect), true)
	setActive(arg0_53._top, true)
	setActive(findTF(arg0_53._window, "bg"), true)
	setActive(arg0_53._sigleItemPanel:Find("left/own"), false)

	local var0_53 = arg0_53._sigleItemPanel:Find("left/IconTpl")

	SetCompomentEnabled(var0_53:Find("icon_bg"), typeof(Image), true)
	SetCompomentEnabled(var0_53:Find("icon_bg/frame"), typeof(Image), true)
	setActive(var0_53:Find("icon_bg/slv"), false)

	local var1_53 = findTF(var0_53, "icon_bg/icon")

	var1_53.pivot = Vector2(0.5, 0.5)
	var1_53.sizeDelta = Vector2(-4, -4)
	var1_53.anchoredPosition = Vector2(0, 0)

	setActive(arg0_53.singleItemIntro, false)
	setText(arg0_53._singleItemSubIntroTF, "")

	for iter2_53 = 0, arg0_53._helpList.childCount - 1 do
		arg0_53._helpList:GetChild(iter2_53):Find("icon"):GetComponent(typeof(Image)).sprite = nil
	end

	for iter3_53, iter4_53 in pairs(arg0_53.pools) do
		if iter4_53 then
			PoolMgr.GetInstance():ReturnUI(iter4_53.name, iter4_53)
		end
	end

	arg0_53.pools = {}

	for iter5_53, iter6_53 in pairs(arg0_53.timers) do
		iter6_53:Stop()
	end

	arg0_53.timers = {}

	var0_0.DelegateInfo.Dispose(arg0_53)
	removeAllChildren(arg0_53._btnContainer)
	var0_0.UIMgr.GetInstance():UnblurPanel(arg0_53._tf, var0_0.UIMgr.GetInstance().OverlayMain)
	arg0_53.contentText:RemoveAllListeners()

	arg0_53.settings = nil
	arg0_53.enable = false
	arg0_53.locked = nil
end

function var1_0.ShowMsgBox(arg0_54, arg1_54)
	if arg0_54.locked then
		return
	end

	local var0_54 = arg1_54.type or MSGBOX_TYPE_NORMAL

	switch(var0_54, {
		[MSGBOX_TYPE_NORMAL] = function()
			var3_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_INPUT] = function()
			var4_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_SINGLE_ITEM] = function()
			var9_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_EXCHANGE] = function()
			var5_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_DROP_ITEM] = function()
			var8_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_ITEM_BOX] = function()
			var6_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_DROP_ITEM_ESKIN] = function()
			var7_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_HELP] = function()
			arg1_54.hideNo = defaultValue(arg1_54.hideNo, true)
			arg1_54.hideYes = defaultValue(arg1_54.hideYes, true)

			var10_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_SECONDPWD] = function()
			PoolMgr.GetInstance():GetUI("Msgbox4SECPWD", true, function(arg0_64)
				arg0_54.pools.SedondaryUI = arg0_64

				if arg1_54.onPreShow then
					arg1_54.onPreShow()
				end

				arg1_54.secondaryUI = arg0_64

				SetParent(arg0_64, arg0_54._otherPanel, false)
				var11_0(arg0_54, arg1_54)
			end)
		end,
		[MSGBOX_TYPE_WORLD_RESET] = function()
			var12_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_OBTAIN] = function()
			arg1_54.title = arg1_54.title or var1_0.TITLE_OBTAIN

			var13_0(arg0_54, arg1_54)
		end,
		[MSGBOX_TYPE_ITEMTIP] = function()
			arg0_54:GetPanel(ItemTipPanel).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_JUST_FOR_SHOW] = function()
			arg0_54:GetPanel(ItemShowPanel).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_MONTH_CARD_TIP] = function()
			arg0_54:GetPanel(MonthCardOutDateTipPanel).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_STORY_CANCEL_TIP] = function()
			arg0_54:GetPanel(StoryCancelTipPanel).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_META_SKILL_UNLOCK] = function()
			arg0_54:GetPanel(MetaSkillUnlockPanel).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_ACCOUNTDELETE] = function()
			arg0_54:GetPanel(AccountDeletePanel).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_STRENGTHEN_BACK] = function()
			arg0_54:GetPanel(StrengthenBackPanel).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_CONTENT_ITEMS] = function()
			arg0_54:GetPanel(Msgbox4ContentItems).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM] = function()
			arg0_54:GetPanel(Msgbox4BlueprintUnlockItem).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_CONFIRM_DELETE] = function()
			arg0_54:GetPanel(ConfirmEquipmentDeletePanel).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_CONFIRM_REFORGE_SPWEAPON] = function()
			arg0_54:GetPanel(Msgbox4SpweaponConfirm).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_SUBPATTERN] = function()
			arg0_54:GetPanel(arg1_54.patternClass).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_FILE_DOWNLOAD] = function()
			arg0_54:GetPanel(FileDownloadPanel).buffer:UpdateView(arg1_54)
		end,
		[MSGBOX_TYPE_LIKN_COLLECT_GUIDE] = function()
			arg0_54:GetPanel(Msgbox4LinkCollectGuide).buffer:UpdateView(arg1_54)
		end
	})
end

function var1_0.GetPanel(arg0_81, arg1_81)
	if not arg0_81.panelDict[arg1_81] then
		arg0_81.panelDict[arg1_81] = arg1_81.New(arg0_81)

		arg0_81.panelDict[arg1_81]:Load()
		arg0_81.panelDict[arg1_81].buffer:SetParent(arg0_81._window)
	end

	return arg0_81.panelDict[arg1_81]
end

function var1_0.CloseAndHide(arg0_82)
	if not arg0_82.enable then
		return
	end

	local var0_82 = arg0_82.settings
	local var1_82 = var0_82.onClose or not var0_82.hideNo and var0_82.onNo or nil

	existCall(var1_82)
	arg0_82:hide()
end

function var1_0.hide(arg0_83)
	if not arg0_83.enable then
		return
	end

	arg0_83._go:SetActive(false)
	arg0_83:Clear()
	var0_0.m02:sendNotification(GAME.CLOSE_MSGBOX_DONE)
end

function var1_0.emit(arg0_84, arg1_84, ...)
	if not arg0_84.analogyMediator then
		arg0_84.analogyMediator = {
			addSubLayers = function(arg0_85, arg1_85)
				var0_0.m02:sendNotification(GAME.LOAD_LAYERS, {
					parentContext = getProxy(ContextProxy):getCurrentContext(),
					context = arg1_85
				})
			end,
			sendNotification = function(arg0_86, ...)
				var0_0.m02:sendNotification(...)
			end,
			viewComponent = arg0_84
		}
	end

	return ContextMediator.CommonBindDic[arg1_84](arg0_84.analogyMediator, arg1_84, ...)
end

function var1_0.closeView(arg0_87)
	arg0_87:hide()
end

return var1_0
