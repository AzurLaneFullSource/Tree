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
		local var14_17 = arg0_17._btnContainer:GetChild(1)

		setButtonEnabled(var14_17, arg1_17.enabelYesBtn)
		eachChild(var14_17, function(arg0_22)
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
	else
		setActive(arg0_23._top, true)
		setActive(findTF(arg0_23._window, "bg"), true)
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

local function var13_0(arg0_32)
	if not arg0_32 then
		return false
	end

	for iter0_32, iter1_32 in ipairs(arg0_32) do
		local var0_32 = iter1_32[2]
		local var1_32 = var0_32 and var0_32[1] == "SHOP"
		local var2_32 = var0_32[2] and var0_32[2].warp == "meta"

		if var1_32 and var2_32 then
			return true
		end
	end

	return false
end

local function var14_0(arg0_33)
	if not arg0_33 then
		return false
	end

	for iter0_33, iter1_33 in ipairs(arg0_33) do
		local var0_33 = iter1_33[2]

		if var0_33 and var0_33[1] == "GETBOAT" then
			return true
		end
	end

	return false
end

local function var15_0(arg0_34)
	if Ship.isMetaShipByConfigID(arg0_34.shipId) then
		local var0_34 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0_34.shipId)
		local var1_34 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var0_34)
		local var2_34 = var1_34 and (var1_34:isInAct() or var1_34:isInArchive())
		local var3_34 = var13_0(arg0_34.list)
		local var4_34 = var14_0(arg0_34.list)

		return var2_34 or var3_34 or var4_34
	end

	return true
end

local function var16_0(arg0_35, arg1_35)
	arg0_35:commonSetting(arg1_35)

	arg0_35._window.sizeDelta = Vector2(arg0_35._defaultSize.x, 520)

	setActive(arg0_35._obtainPanel, true)
	setActive(arg0_35._btnContainer, false)

	local var0_35 = {
		type = DROP_TYPE_SHIP,
		id = arg1_35.shipId
	}

	updateDrop(arg0_35._obtainPanel, var0_35, arg1_35)

	local var1_35 = var15_0(arg1_35)

	arg0_35.obtainSkipList = arg0_35.obtainSkipList or UIItemList.New(arg0_35._obtainPanel:Find("skipable_list"), arg0_35._obtainPanel:Find("skipable_list/tpl"))

	arg0_35.obtainSkipList:make(function(arg0_36, arg1_36, arg2_36)
		if arg0_36 == UIItemList.EventUpdate then
			local var0_36 = arg1_35.list[arg1_36 + 1]
			local var1_36 = var0_36[1]
			local var2_36 = var0_36[2]
			local var3_36 = var0_36[3]
			local var4_36 = HXSet.hxLan(var1_36)

			arg2_36:Find("mask/title"):GetComponent("ScrollText"):SetText(var4_36)
			setActive(arg2_36:Find("skip_btn"), var1_35 and var2_36[1] ~= "" and var2_36[1] ~= "COLLECTSHIP")

			if var2_36[1] ~= "" then
				onButton(arg0_35, arg2_36:Find("skip_btn"), function()
					if var3_36 and var3_36 ~= 0 then
						local var0_37 = getProxy(ActivityProxy):getActivityById(var3_36)

						if not var0_37 or var0_37:isEnd() then
							var0_0.TipsMgr.GetInstance():ShowTips(i18n("collection_way_is_unopen"))

							return
						end
					elseif var2_36[1] == "SHOP" and var2_36[2].warp == NewShopsScene.TYPE_MILITARY_SHOP and not var0_0.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "MilitaryExerciseMediator") then
						var0_0.TipsMgr.GetInstance():ShowTips(i18n("military_shop_no_open_tip"))

						return
					elseif var2_36[1] == "LEVEL" and var2_36[2] then
						local var1_37 = var2_36[2].chapterid
						local var2_37 = getProxy(ChapterProxy)
						local var3_37 = var2_37:getChapterById(var1_37)

						if var3_37:isUnlock() then
							local var4_37 = var2_37:getActiveChapter()

							if var4_37 and var4_37.id ~= var1_37 then
								arg0_35:ShowMsgBox({
									content = i18n("collect_chapter_is_activation"),
									onYes = function()
										var0_0.m02:sendNotification(GAME.CHAPTER_OP, {
											type = ChapterConst.OpRetreat
										})
									end
								})

								return
							else
								local var5_37 = {
									mapIdx = var3_37:getConfig("map")
								}

								if var3_37.active then
									var5_37.chapterId = var3_37.id
								else
									var5_37.openChapterId = var1_37
								end

								var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var5_37)
							end
						else
							var0_0.TipsMgr.GetInstance():ShowTips(i18n("acquisitionmode_is_not_open"))

							return
						end
					elseif var2_36[1] == "COLLECTSHIP" then
						if arg1_35.mediatorName == CollectionMediator.__cname then
							var0_0.m02:sendNotification(CollectionMediator.EVENT_OBTAIN_SKIP, {
								toggle = 2,
								displayGroupId = var2_36[2].shipGroupId
							})
						else
							var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE.COLLECTSHIP, {
								toggle = 2,
								displayGroupId = var2_36[2].shipGroupId
							})
						end
					elseif var2_36[1] == "SHOP" then
						var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE[var2_36[1]], var2_36[2])
					else
						var0_0.m02:sendNotification(GAME.GO_SCENE, SCENE[var2_36[1]], var2_36[2])
					end

					arg0_35:hide()
				end, SFX_PANEL)
			end
		end
	end)
	arg0_35.obtainSkipList:align(#arg1_35.list)
	arg0_35:Loaded(arg1_35)
end

function var1_0.nextPage(arg0_39)
	arg0_39.helpPage = arg0_39.helpPage + 1

	if arg0_39.helpPage < 1 then
		arg0_39.helpPage = 1
	end

	if arg0_39.helpPage > arg0_39._helpList.childCount then
		arg0_39.helpPage = 1
	end

	arg0_39:switchHelpPage(arg0_39.helpPage)
end

function var1_0.prePage(arg0_40)
	arg0_40.helpPage = arg0_40.helpPage - 1

	if arg0_40.helpPage < 1 then
		arg0_40.helpPage = arg0_40._helpList.childCount
	end

	if arg0_40.helpPage > arg0_40._helpList.childCount then
		arg0_40.helpPage = arg0_40._helpList.childCount
	end

	arg0_40:switchHelpPage(arg0_40.helpPage)
end

function var1_0.switchHelpPage(arg0_41, arg1_41)
	for iter0_41 = 1, arg0_41._helpList.childCount do
		local var0_41 = arg0_41._helpList:GetChild(iter0_41 - 1)

		setActive(var0_41, arg1_41 == iter0_41)
		setText(var0_41:Find("icon/corner/Text"), iter0_41)
	end
end

function var1_0.commonSetting(arg0_42, arg1_42)
	rtf(arg0_42._window).sizeDelta = arg0_42._defaultSize
	rtf(arg0_42._helpPanel).sizeDelta = arg0_42._defaultHelpSize
	arg0_42.enable = true

	var0_0.DelegateInfo.New(arg0_42)
	setActive(arg0_42._msgPanel, false)
	setActive(arg0_42._exchangeShipPanel, false)
	setActive(arg0_42._itemPanel, false)
	setActive(arg0_42._eskinPanel, false)
	setActive(arg0_42._sigleItemPanel, false)
	setActive(arg0_42._inputPanel, false)
	setActive(arg0_42._obtainPanel, false)
	setActive(arg0_42._otherPanel, false)
	setActive(arg0_42._worldResetPanel, false)
	setActive(arg0_42._worldShopBtn, false)
	setActive(arg0_42._helpBgTF, false)
	setActive(arg0_42._helpPanel, arg1_42.helps)

	for iter0_42, iter1_42 in pairs(arg0_42.panelDict) do
		iter1_42.buffer:Hide()
	end

	setActive(arg0_42._btnContainer, true)

	arg0_42.stopRemindToggle.isOn = arg1_42.toggleStatus or false

	setActive(go(arg0_42.stopRemindToggle), arg1_42.showStopRemind)

	arg0_42.stopRemindText.text = arg1_42.stopRamindContent or i18n("dont_remind_today")

	removeAllChildren(arg0_42._btnContainer)

	arg0_42.settings = arg1_42

	SetActive(arg0_42._go, true)

	local var0_42 = arg0_42.settings.needCounter or false

	setActive(arg0_42._countSelect, var0_42)

	local var1_42 = arg0_42.settings.numUpdate
	local var2_42 = arg0_42.settings.addNum or 1
	local var3_42 = arg0_42.settings.maxNum or -1
	local var4_42 = arg0_42.settings.defaultNum or 1

	arg0_42._pageUtil:setNumUpdate(function(arg0_43)
		if var1_42 ~= nil then
			var1_42(arg0_42._countDescTxt, arg0_43)
		end
	end)
	arg0_42._pageUtil:setAddNum(var2_42)
	arg0_42._pageUtil:setMaxNum(var3_42)
	arg0_42._pageUtil:setDefaultNum(var4_42)
	setActive(arg0_42._sliders, arg0_42.settings.discount)

	if arg0_42.settings.discount then
		arg0_42._discount:GetComponent(typeof(Text)).text = arg0_42.settings.discount.discount .. "%OFF"
		arg0_42._discountDate:GetComponent(typeof(Text)).text = arg0_42.settings.discount.date
	end

	setActive(arg0_42._remasterPanel, arg0_42.settings.remaster)

	if arg0_42.settings.remaster then
		local var5_42 = arg0_42.settings.remaster

		setText(arg0_42._remasterPanel:Find("content/Text"), var5_42.word)
		setText(arg0_42._remasterPanel:Find("content/count"), var5_42.number or "")
		setText(arg0_42._remasterPanel:Find("btn/pic"), var5_42.btn_text)
		onButton(arg0_42, arg0_42._remasterPanel:Find("btn"), function()
			if var5_42.btn_call then
				var5_42.btn_call()
			end

			arg0_42:hide()
		end)
	end

	local var6_42 = arg0_42.settings.hideNo or false
	local var7_42 = arg0_42.settings.hideYes or false
	local var8_42 = arg0_42.settings.modal or false
	local var9_42 = arg0_42.settings.onYes or function()
		return
	end
	local var10_42 = arg0_42.settings.onNo or function()
		return
	end

	onButton(arg0_42, tf(arg0_42._go):Find("bg"), function()
		if arg0_42.settings.onClose then
			arg0_42.settings.onClose()
		else
			var10_42()
		end

		arg0_42:hide()
	end, SFX_CANCEL)
	SetCompomentEnabled(tf(arg0_42._go):Find("bg"), typeof(Button), not var8_42)

	local var11_42
	local var12_42

	if not var6_42 then
		local var13_42 = arg0_42:createBtn({
			text = arg0_42.settings.noText or var1_0.TEXT_CANCEL,
			btnType = arg0_42.settings.noBtnType or var1_0.BUTTON_GRAY,
			onCallback = var10_42,
			sound = arg1_42.noSound or SFX_CANCEL
		})
	end

	if not var7_42 then
		var12_42 = arg0_42:createBtn({
			text = arg0_42.settings.yesText or var1_0.TEXT_CONFIRM,
			btnType = arg0_42.settings.yesBtnType or var1_0.BUTTON_BLUE,
			onCallback = var9_42,
			sound = arg1_42.yesSound or SFX_CONFIRM,
			alignment = arg0_42.settings.yesSize and TextAnchor.MiddleCenter,
			gray = arg0_42.settings.yesGray,
			delayButton = arg0_42.settings.delayConfirm
		})

		if arg0_42.settings.yesSize then
			var12_42.sizeDelta = arg0_42.settings.yesSize
		end
	end

	if arg0_42.settings.yseBtnLetf then
		var12_42:SetAsFirstSibling()
	end

	local var14_42

	if arg0_42.settings.type == MSGBOX_TYPE_HELP and arg0_42.settings.helps.pageMode and #arg0_42.settings.helps > 1 then
		arg0_42:createBtn({
			noQuit = true,
			btnType = var1_0.BUTTON_PREPAGE,
			onCallback = function()
				arg0_42:prePage()
			end,
			sound = SFX_CANCEL
		})

		var14_42 = #arg0_42.settings.helps
	end

	if arg0_42.settings.custom ~= nil then
		for iter2_42, iter3_42 in ipairs(arg0_42.settings.custom) do
			arg0_42:createBtn(iter3_42)
		end
	end

	if not var14_42 then
		-- block empty
	elseif var14_42 > 1 then
		arg0_42:createBtn({
			noQuit = true,
			btnType = var1_0.BUTTON_NEXTPAGE,
			onCallback = function()
				arg0_42:nextPage()
			end,
			sound = SFX_CONFIRM
		})
	end

	setActive(arg0_42._closeBtn, not arg1_42.hideClose)
	onButton(arg0_42, arg0_42._closeBtn, function()
		local var0_50 = arg0_42.settings.onClose

		if arg0_42.settings and arg0_42.settings.hideClose and not var0_50 and arg0_42.settings.onYes then
			arg0_42.settings.onYes()
		end

		arg0_42:hide()

		if var0_50 then
			var0_50()
		else
			var10_42()
		end
	end, SFX_CANCEL)

	local var15_42 = arg0_42.settings.title or var1_0.TITLE_INFORMATION
	local var16_42 = 0
	local var17_42 = arg0_42._titleList.transform.childCount

	while var16_42 < var17_42 do
		local var18_42 = arg0_42._titleList.transform:GetChild(var16_42)

		SetActive(var18_42, var18_42.name == var15_42)

		var16_42 = var16_42 + 1
	end

	local var19_42 = arg0_42._go.transform.localPosition

	arg0_42._go.transform.localPosition = Vector3(var19_42.x, var19_42.y, arg0_42.settings.zIndex or 0)
	arg0_42.locked = arg0_42.settings.locked or false
end

function var1_0.createBtn(arg0_51, arg1_51)
	local var0_51 = arg1_51.btnType or var1_0.BUTTON_BLUE
	local var1_51 = arg1_51.noQuit
	local var2_51 = arg0_51._go.transform:Find("custom_btn_list/custom_button_" .. var0_51)
	local var3_51 = cloneTplTo(var2_51, arg0_51._btnContainer)

	if arg1_51.label then
		go(var3_51).name = arg1_51.label
	end

	SetActive(var3_51, true)

	if arg1_51.scale then
		local var4_51 = arg1_51.scale.x or 1
		local var5_51 = arg1_51.scale.y or 1

		var3_51.localScale = Vector2(var4_51, var5_51)
	end

	local var6_51

	if var0_51 == var1_0.BUTTON_MEDAL then
		setText(var3_51:Find("text"), arg1_51.text)

		var6_51 = var3_51:Find("text")
	elseif var0_51 ~= var1_0.BUTTON_RETREAT and var0_51 ~= var1_0.BUTTON_PREPAGE and var0_51 ~= var1_0.BUTTON_NEXTPAGE then
		arg0_51:updateButton(var3_51, arg1_51.text, arg1_51.alignment)

		var6_51 = var3_51:Find("pic")
	end

	if var0_51 == var1_0.BUTTON_BLUE_WITH_ICON and arg1_51.iconName then
		local var7_51 = var3_51:Find("ticket/icon")

		setImageSprite(var7_51, LoadSprite(arg1_51.iconName[1], arg1_51.iconName[2]))
	end

	local var8_51

	if arg1_51.delayButton then
		local var9_51 = arg1_51.delayButton
		local var10_51 = getText(var6_51)

		var8_51 = Timer.New(function()
			var9_51 = var9_51 - 1

			if var9_51 > 0 then
				setText(var6_51, var10_51 .. string.format("(%d)", var9_51))
			else
				setText(var6_51, var10_51)
				setGray(var3_51, arg1_51.gray, true)

				var8_51 = nil
			end
		end, 1, var9_51)
		arg0_51.timers[var3_51] = var8_51

		var8_51:Start()
		setText(var6_51, var10_51 .. string.format("(%d)", var9_51))
		setGray(var3_51, true, true)
	else
		setGray(var3_51, arg1_51.gray, true)
	end

	if not arg1_51.hideEvent then
		onButton(arg0_51, var3_51, function()
			if var8_51 then
				return
			end

			if type(var1_51) == "function" then
				if var1_51() then
					return
				else
					arg0_51:hide()
				end
			elseif not var1_51 then
				arg0_51:hide()
			end

			return existCall(arg1_51.onCallback)
		end, arg1_51.sound or SFX_CONFIRM)
	end

	if arg1_51.sibling then
		var3_51:SetSiblingIndex(arg1_51.sibling)
	end

	return var3_51
end

function var1_0.updateButton(arg0_54, arg1_54, arg2_54, arg3_54)
	local var0_54 = var2_0[arg2_54]
	local var1_54 = arg1_54:Find("pic")

	if IsNil(var1_54) then
		return
	end

	if var0_54 then
		setText(var1_54, i18n(var0_54))
	else
		if string.len(arg2_54) > 12 then
			GetComponent(var1_54, typeof(Text)).resizeTextForBestFit = true
		end

		setText(var1_54, arg2_54)
	end

	if arg3_54 then
		var1_54:GetComponent(typeof(Text)).alignment = arg3_54
	end
end

function var1_0.Loaded(arg0_55, arg1_55)
	var0_0.UIMgr.GetInstance():BlurPanel(arg0_55._tf, {
		groupName = arg1_55.groupName,
		parent = arg1_55.parent
	})
	var0_0.m02:sendNotification(GAME.OPEN_MSGBOX_DONE)
end

function var1_0.Clear(arg0_56)
	for iter0_56, iter1_56 in pairs(arg0_56.panelDict) do
		iter1_56:Destroy()
	end

	table.clear(arg0_56.panelDict)

	rtf(arg0_56._window).sizeDelta = arg0_56._defaultSize
	rtf(arg0_56._helpPanel).sizeDelta = arg0_56._defaultHelpSize

	setAnchoredPosition(arg0_56._window, {
		x = 0,
		y = 0
	})
	setAnchoredPosition(arg0_56._btnContainer, {
		y = 15
	})
	setAnchoredPosition(arg0_56._helpPanel, {
		x = arg0_56._defaultHelpPos.x,
		y = arg0_56._defaultHelpPos.y
	})
	SetCompomentEnabled(arg0_56._helpPanel:Find("list"), typeof(ScrollRect), true)
	setActive(arg0_56._top, true)
	setActive(findTF(arg0_56._window, "bg"), true)
	setActive(arg0_56._sigleItemPanel:Find("left/own"), false)

	local var0_56 = arg0_56._sigleItemPanel:Find("left/IconTpl")

	SetCompomentEnabled(var0_56:Find("icon_bg"), typeof(Image), true)
	SetCompomentEnabled(var0_56:Find("icon_bg/frame"), typeof(Image), true)
	setActive(var0_56:Find("icon_bg/slv"), false)
	setActive(arg0_56.singleItemIntro, false)
	setText(arg0_56._singleItemSubIntroTF, "")

	for iter2_56 = 0, arg0_56._helpList.childCount - 1 do
		arg0_56._helpList:GetChild(iter2_56):Find("icon"):GetComponent(typeof(Image)).sprite = nil
	end

	for iter3_56, iter4_56 in pairs(arg0_56.pools) do
		if iter4_56 then
			PoolMgr.GetInstance():ReturnUI(iter4_56.name, iter4_56)
		end
	end

	arg0_56.pools = {}

	for iter5_56, iter6_56 in pairs(arg0_56.timers) do
		iter6_56:Stop()
	end

	arg0_56.timers = {}

	var0_0.DelegateInfo.Dispose(arg0_56)
	removeAllChildren(arg0_56._btnContainer)
	var0_0.UIMgr.GetInstance():UnOverlayPanel(arg0_56._tf, var0_0.UIMgr.GetInstance().OverlayMain)
	arg0_56.contentText:RemoveAllListeners()

	arg0_56.settings = nil
	arg0_56.enable = false
	arg0_56.locked = nil
end

function var1_0.ShowMsgBox(arg0_57, arg1_57)
	if arg0_57.locked then
		return
	end

	local var0_57 = arg1_57.type or MSGBOX_TYPE_NORMAL

	switch(var0_57, {
		[MSGBOX_TYPE_NORMAL] = function()
			var3_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_INPUT] = function()
			var4_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_SINGLE_ITEM] = function()
			var9_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_EXCHANGE] = function()
			var5_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_DROP_ITEM] = function()
			var8_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_ITEM_BOX] = function()
			var6_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_DROP_ITEM_ESKIN] = function()
			var7_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_HELP] = function()
			arg1_57.hideNo = defaultValue(arg1_57.hideNo, true)
			arg1_57.hideYes = defaultValue(arg1_57.hideYes, true)

			var10_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_SECONDPWD] = function()
			PoolMgr.GetInstance():GetUI("Msgbox4SECPWD", true, function(arg0_67)
				arg0_57.pools.SedondaryUI = arg0_67

				if arg1_57.onPreShow then
					arg1_57.onPreShow()
				end

				arg1_57.secondaryUI = arg0_67

				SetParent(arg0_67, arg0_57._otherPanel, false)
				var11_0(arg0_57, arg1_57)
			end)
		end,
		[MSGBOX_TYPE_WORLD_RESET] = function()
			var12_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_OBTAIN] = function()
			arg1_57.title = arg1_57.title or var1_0.TITLE_OBTAIN

			var16_0(arg0_57, arg1_57)
		end,
		[MSGBOX_TYPE_ITEMTIP] = function()
			arg0_57:GetPanel(ItemTipPanel).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_JUST_FOR_SHOW] = function()
			arg0_57:GetPanel(ItemShowPanel).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_MONTH_CARD_TIP] = function()
			arg0_57:GetPanel(MonthCardOutDateTipPanel).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_STORY_CANCEL_TIP] = function()
			arg0_57:GetPanel(StoryCancelTipPanel).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_META_SKILL_UNLOCK] = function()
			arg0_57:GetPanel(MetaSkillUnlockPanel).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_ACCOUNTDELETE] = function()
			arg0_57:GetPanel(AccountDeletePanel).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_STRENGTHEN_BACK] = function()
			arg0_57:GetPanel(StrengthenBackPanel).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_CONTENT_ITEMS] = function()
			arg0_57:GetPanel(Msgbox4ContentItems).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM] = function()
			arg0_57:GetPanel(Msgbox4BlueprintUnlockItem).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_CONFIRM_DELETE] = function()
			arg0_57:GetPanel(ConfirmEquipmentDeletePanel).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_CONFIRM_REFORGE_SPWEAPON] = function()
			arg0_57:GetPanel(Msgbox4SpweaponConfirm).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_SUBPATTERN] = function()
			arg0_57:GetPanel(arg1_57.patternClass).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_FILE_DOWNLOAD] = function()
			arg0_57:GetPanel(FileDownloadPanel).buffer:UpdateView(arg1_57)
		end,
		[MSGBOX_TYPE_LIKN_COLLECT_GUIDE] = function()
			arg0_57:GetPanel(Msgbox4LinkCollectGuide).buffer:UpdateView(arg1_57)
		end
	})
end

function var1_0.GetPanel(arg0_84, arg1_84)
	if not arg0_84.panelDict[arg1_84] then
		arg0_84.panelDict[arg1_84] = arg1_84.New(arg0_84)

		arg0_84.panelDict[arg1_84]:Load()
		arg0_84.panelDict[arg1_84].buffer:SetParent(arg0_84._window)
	end

	return arg0_84.panelDict[arg1_84]
end

function var1_0.CloseAndHide(arg0_85)
	if not arg0_85.enable then
		return
	end

	local var0_85 = arg0_85.settings
	local var1_85 = var0_85.onClose or not var0_85.hideNo and var0_85.onNo or nil

	existCall(var1_85)
	arg0_85:hide()
end

function var1_0.hide(arg0_86)
	if not arg0_86.enable then
		return
	end

	arg0_86._go:SetActive(false)
	arg0_86:Clear()
	var0_0.m02:sendNotification(GAME.CLOSE_MSGBOX_DONE)
end

function var1_0.emit(arg0_87, arg1_87, ...)
	if not arg0_87.analogyMediator then
		arg0_87.analogyMediator = {
			addSubLayers = function(arg0_88, arg1_88)
				var0_0.m02:sendNotification(GAME.LOAD_LAYERS, {
					parentContext = getProxy(ContextProxy):getCurrentContext(),
					context = arg1_88
				})
			end,
			sendNotification = function(arg0_89, ...)
				var0_0.m02:sendNotification(...)
			end,
			viewComponent = arg0_87
		}
	end

	return ContextMediator.CommonBindDic[arg1_87](arg0_87.analogyMediator, arg1_87, ...)
end

function var1_0.closeView(arg0_90)
	arg0_90:hide()
end

return var1_0
