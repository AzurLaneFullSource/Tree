pg = pg or {}

local var0 = pg
local var1 = singletonClass("MsgboxMgr")

var0.MsgboxMgr = var1
var1.BUTTON_BLUE = 1
var1.BUTTON_GRAY = 2
var1.BUTTON_RED = 3
var1.BUTTON_MEDAL = 4
var1.BUTTON_RETREAT = 5
var1.BUTTON_PREPAGE = 6
var1.BUTTON_NEXTPAGE = 7
var1.BUTTON_BLUE_WITH_ICON = 8
var1.TITLE_INFORMATION = "infomation"
var1.TITLE_SETTING = "setting"
var1.TITLE_WARNING = "warning"
var1.TITLE_OBTAIN = "obtain"
var1.TITLE_CADPA = "cadpa"
var1.TEXT_CANCEL = "text_cancel"
var1.TEXT_CONFIRM = "text_confirm"
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
var1.enable = false

local var2 = require("Mgr.const.MsgboxBtnNameMap")

function var1.Init(arg0, arg1)
	print("initializing msgbox manager...")
	PoolMgr.GetInstance():GetUI("MsgBox", true, function(arg0)
		arg0._go = arg0

		arg0._go:SetActive(false)

		arg0._tf = arg0._go.transform

		arg0._tf:SetParent(var0.UIMgr.GetInstance().OverlayMain, false)

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

		arg1()
	end)
end

function var1.getMsgBoxOb(arg0)
	return arg0._go
end

local function var3(arg0, arg1)
	arg0:commonSetting(arg1)
	SetActive(arg0._msgPanel, true)

	arg0.contentText.alignment = arg0.settings.alignment or TextAnchor.MiddleCenter
	arg0.contentText.fontSize = arg0.settings.fontSize or 36
	arg0.contentText.text = arg0.settings.content or ""

	arg0:Loaded(arg1)
end

local function var4(arg0, arg1)
	arg0:commonSetting(arg1)
	setActive(arg0._inputPanel, true)
	setActive(arg0._btnContainer, false)

	arg0._inputTitle.text = arg1.title or ""
	arg0._placeholderTF.text = arg1.placeholder or ""
	arg0._inputField.characterLimit = arg1.limit or 0

	setActive(arg0._inputCancelBtn, not arg1.hideNo)
	arg0:updateButton(arg0._inputCancelBtn, arg1.noText or var1.TEXT_CANCEL)
	arg0:updateButton(arg0._inputConfirmBtn, arg1.yesText or var1.TEXT_CONFIRM)
	onButton(arg0, arg0._inputCancelBtn, function()
		arg0:hide()
	end, SFX_CANCEL)
	onButton(arg0, arg0._inputConfirmBtn, function()
		if arg1.onYes then
			arg1.onYes(arg0._inputField.text)
		end

		arg0:hide()
	end, SFX_CONFIRM)
	arg0:Loaded(arg1)
end

local function var5(arg0, arg1)
	arg0:commonSetting(arg1)
	SetActive(arg0._exchangeShipPanel, true)
	setActive(findTF(arg0._exchangeShipPanel, "icon_bg/own"), false)
	updateDrop(arg0._exchangeShipPanel, arg1.drop)

	local var0 = arg0._exchangeShipPanel:Find("intro_view/Viewport/intro")

	SetActive(var0, arg1.drop.type == DROP_TYPE_SHIP or arg1.drop.type == DROP_TYPE_RESOURCE or arg1.drop.type == DROP_TYPE_ITEM or arg1.drop.type == DROP_TYPE_FURNITURE or arg1.drop.type == DROP_TYPE_STRATEGY or arg1.drop.type == DROP_TYPE_SKIN or arg1.drop.type == DROP_TYPE_SKIN_TIMELIMIT)

	local var1 = arg0.settings.numUpdate

	setActive(arg0.singleItemIntro, var1 == nil)
	setActive(arg0._countDescTxt, var1 ~= nil)
	setText(arg0._exchangeShipPanel:Find("name_mode/name"), arg1.name or arg1.drop:getConfig("name") or "")
	setText(arg0._exchangeShipPanel:Find("name_mode/name/name"), getText(arg0._exchangeShipPanel:Find("name_mode/name")))

	local var2 = var0.ship_data_statistics[arg1.drop.id].skin_id
	local var3, var4, var5 = ShipWordHelper.GetWordAndCV(var2, ShipWordHelper.WORD_TYPE_DROP, nil, PLATFORM_CODE ~= PLATFORM_US)

	setText(var0, var5 or i18n("ship_drop_desc_default"))

	if arg1.intro then
		setText(var0, arg1.intro)
	end

	if arg1.enabelYesBtn ~= nil then
		local var6 = arg0._btnContainer:GetChild(1)

		setButtonEnabled(var6, arg1.enabelYesBtn)
		eachChild(var6, function(arg0)
			local var0 = arg1.enabelYesBtn and 1 or 0.3

			GetOrAddComponent(arg0, typeof(CanvasGroup)).alpha = var0
		end)
	end

	if arg1.show_medal then
		arg0:createBtn({
			sibling = 0,
			hideEvent = true,
			text = arg1.show_medal.desc,
			btnType = var1.BUTTON_MEDAL,
			sound = SFX_UI_BUILDING_EXCHANGE
		})
	end

	arg0:Loaded(arg1)
end

local function var6(arg0, arg1)
	arg0:commonSetting(arg1)
	SetActive(arg0._itemPanel, true)
	setActive(arg0._itemText, arg1.content)

	arg0._itemText.text = arg1.content or ""

	local var0 = arg1.items
	local var1 = arg1.itemFunc

	UIItemList.StaticAlign(arg0._itemListItemContainer, arg0._itemListItemTpl, #var0, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1]

			updateDrop(arg2:Find("IconTpl"), var0, {
				anonymous = var0.anonymous,
				hideName = var0.hideName
			})

			local var1 = arg2:Find("IconTpl/name")

			setText(var1, shortenString(getText(var1), 5))
			onButton(arg0, arg2, function()
				if var0.anonymous then
					return
				elseif var1 then
					var1(var0)
				end
			end, SFX_UI_CLICK)
		end
	end)
	arg0:Loaded(arg1)
end

local function var7(arg0, arg1)
	arg0:commonSetting(arg1)
	SetActive(arg0._eskinPanel, true)
	setActive(arg0._eskinText, arg1.content)

	arg0._eskinText.text = arg1.content or ""

	local var0 = arg1.items
	local var1 = arg1.itemFunc

	UIItemList.StaticAlign(arg0._eskinListItemContainer, arg0._eskinListItemTpl, #var0, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1]

			updateDrop(arg2:Find("IconTpl"), var0, {
				anonymous = var0.anonymous,
				hideName = var0.hideName
			})
			setText(arg2:Find("own/Text"), i18n("equip_skin_detail_count") .. var0:getOwnedCount())
			onButton(arg0, arg2, function()
				if var0.anonymous then
					return
				elseif var1 then
					var1(var0)
				end
			end, SFX_UI_CLICK)
		end
	end)
	arg0:Loaded(arg1)
end

local function var8(arg0, arg1)
	arg0:commonSetting(arg1)
	SetActive(arg0._sigleItemPanel, true)
	SetActive(arg0._sigleItemPanel:Find("ship_group"), false)
	SetActive(arg0._singleItemshipTypeTF, false)
	SetActive(arg0._sigleItemPanel:Find("left/detail"), false)

	local var0 = arg0.singleItemIntro

	SetActive(var0, true)
	setText(var0, arg1.content or "")

	local var1 = arg0._sigleItemPanel:Find("left/IconTpl")

	setText(var1:Find("icon_bg/count"), "")
	SetActive(var1:Find("icon_bg/startpl"), false)
	SetCompomentEnabled(var1:Find("icon_bg"), typeof(Image), not arg1.hideIconBG)
	SetCompomentEnabled(var1:Find("icon_bg/frame"), typeof(Image), not arg1.hideIconBG)

	local var2 = var1:Find("icon_bg/frame")

	setFrame(var2, arg1.frame or 1)
	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg1.frame or 1), var1:Find("icon_bg"))
	GetImageSpriteFromAtlasAsync(arg1.iconPath[1], arg1.iconPath[2] or "", var1:Find("icon_bg/icon"))
	setText(arg0._sigleItemPanel:Find("display_panel/name_container/name/Text"), arg1.name or "")
	arg0:Loaded(arg1)
end

local function var9(arg0, arg1)
	arg0:commonSetting(arg1)
	SetActive(arg0._sigleItemPanel, true)

	local var0 = arg0._sigleItemPanel:Find("left/IconTpl")

	setActive(var0:Find("timelimit"), arg1.drop.type == DROP_TYPE_SKIN_TIMELIMIT)
	updateDrop(var0, arg1.drop)
	setActive(arg0._singleItemshipTypeTF, arg1.drop.type == DROP_TYPE_SHIP)

	if arg1.drop.type == DROP_TYPE_SHIP then
		GetImageSpriteFromAtlasAsync("shiptype", shipType2print(arg1.drop:getConfig("type")), arg0._singleItemshipTypeTF, false)
	end

	local var1 = arg1.drop.type == DROP_TYPE_SHIP
	local var2 = arg0._sigleItemPanel:Find("ship_group")

	SetActive(var2, var1)

	if var1 then
		local var3 = tobool(getProxy(CollectionProxy):getShipGroup(var0.ship_data_template[arg1.drop.id].group_type))

		SetActive(var2:Find("unlocked"), var3)
		SetActive(var2:Find("locked"), not var3)
	end

	if arg1.windowSize then
		arg0._window.sizeDelta = Vector2(arg1.windowSize.x or arg0._defaultSize.x, arg1.windowSize.y or arg0._defaultSize.y)
	end

	local var4 = arg0.singleItemIntro
	local var5 = arg0._singleItemSubIntroTF
	local var6 = arg0.settings.numUpdate

	setActive(arg0._countDescTxt, var6 ~= nil)
	SetActive(var4, var6 == nil)

	local var7 = arg1.name or arg1.drop:getConfig("name") or ""

	setText(arg0._sigleItemPanel:Find("display_panel/name_container/name/Text"), var7)
	UpdateOwnDisplay(arg0._sigleItemPanel:Find("left/own"), arg1.drop)
	RegisterDetailButton(arg0, arg0._sigleItemPanel:Find("left/detail"), arg1.drop)

	if arg1.iconPreservedAspect then
		local var8 = var0:Find("icon_bg/icon")
		local var9 = var8:GetComponent(typeof(Image))

		var8.pivot = Vector2(0.5, 1)

		local var10 = var8.rect.width
		local var11 = var9.preferredHeight / var9.preferredWidth * var10

		var8.sizeDelta = Vector2(-4, var11 - var10 - 4)
		var8.anchoredPosition = Vector2(0, -2)
	end

	if arg1.content and arg1.content ~= "" then
		setText(var4, arg1.content)
	elseif arg1.drop.type == DROP_TYPE_WORLD_COLLECTION then
		arg1.drop:MsgboxIntroSet(arg1, var4, arg0._sigleItemPanel:Find("name_mode/name_mask/name"))
	else
		arg1.drop:MsgboxIntroSet(arg1, var4)
	end

	if arg1.intro then
		setText(var4, arg1.intro)
	end

	setText(var5, arg1.subIntro or arg1.extendDesc or "")

	if arg1.enabelYesBtn ~= nil then
		local var12 = arg0._btnContainer:GetChild(1)

		setButtonEnabled(var12, arg1.enabelYesBtn)
		eachChild(var12, function(arg0)
			local var0 = arg1.enabelYesBtn and 1 or 0.3

			GetOrAddComponent(arg0, typeof(CanvasGroup)).alpha = var0
		end)
	end

	if arg1.show_medal then
		arg0:createBtn({
			sibling = 0,
			hideEvent = true,
			text = arg1.show_medal.desc,
			btnType = var1.BUTTON_MEDAL,
			sound = SFX_UI_BUILDING_EXCHANGE
		})
	end

	arg0:Loaded(arg1)
end

local function var10(arg0, arg1)
	arg0:commonSetting(arg1)
	setActive(findTF(arg0._helpPanel, "bg"), not arg1.helps.pageMode)
	setActive(arg0._helpBgTF, arg1.helps.pageMode)
	setActive(arg0._helpPanel:Find("btn_blueprint"), arg1.show_blueprint)

	if arg1.show_blueprint then
		onButton(arg0, arg0._helpPanel:Find("btn_blueprint"), function()
			arg0:hide()
			var0.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT, {
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

local function var11(arg0, arg1)
	arg0:commonSetting(arg1)
	setActive(arg0._otherPanel, true)

	local var0 = tf(arg1.secondaryUI)

	arg0._window.sizeDelta = Vector2(960, arg0._defaultSize.y)

	setActive(var0, true)

	local var1 = arg1.mode
	local var2 = getProxy(SecondaryPWDProxy):getRawData()
	local var3 = var0:Find("showresttime")
	local var4 = var0:Find("settips")

	if var1 == "showresttime" then
		setActive(var3, true)
		setActive(var4, false)

		local var5 = var3:Find("desc"):GetComponent(typeof(Text))

		if arg0.timers.secondaryUItimer then
			arg0.timers.secondaryUItimer:Stop()
		end

		local function var6()
			local var0 = var0.TimeMgr.GetInstance():GetServerTime()
			local var1 = var2.fail_cd and var2.fail_cd - var0 or 0

			var1 = var1 < 0 and 0 or var1

			local var2 = math.floor(var1 / 86400)

			if var2 > 0 then
				var5.text = string.format(i18n("tips_fail_secondarypwd_much_times"), var2 .. i18n("word_date"))
			else
				local var3 = math.floor(var1 / 3600)

				if var3 > 0 then
					var5.text = string.format(i18n("tips_fail_secondarypwd_much_times"), var3 .. i18n("word_hour"))
				else
					local var4 = ""
					local var5 = math.floor(var1 / 60)

					if var5 > 0 then
						var4 = var4 .. var5 .. i18n("word_minute")
					end

					local var6 = math.max(var1 - var5 * 60, 0)

					var5.text = string.format(i18n("tips_fail_secondarypwd_much_times"), var4 .. var6 .. i18n("word_second"))
				end
			end
		end

		var6()

		local var7 = Timer.New(var6, 1, -1)

		var7:Start()

		arg0.timers.secondaryUItimer = var7
	elseif var1 == "settips" then
		setActive(var3, false)
		setActive(var4, true)

		local var8 = var4:Find("InputField"):GetComponent(typeof(InputField))

		arg1.references.inputfield = var8
		var8.text = arg1.references.lasttext or ""

		local var9 = 20

		var8.onValueChanged:AddListener(function()
			local var0, var1 = utf8_to_unicode(var8.text)

			if var1 > var9 then
				var8.text = SecondaryPasswordMediator.ClipUnicodeStr(var8.text, var9)
			end
		end)

		local function var10()
			if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
				return false
			end

			local var0 = var8.text
			local var1, var2 = wordVer(var0, {
				isReplace = true
			})

			if var1 > 0 or var2 ~= var0 then
				var0.TipsMgr.GetInstance():ShowTips(i18n("secondarypassword_illegal_tip"))

				var8.text = var2

				return true
			else
				return false
			end
		end

		arg0:createBtn({
			text = var1.TEXT_CONFIRM,
			btnType = var1.BUTTON_BLUE,
			onCallback = arg0.settings.onYes,
			sound = SFX_CONFIRM,
			noQuit = var10
		})
	end

	arg0:Loaded(arg1)
end

local function var12(arg0, arg1)
	arg0:commonSetting(arg1)
	setActive(arg0._worldResetPanel, true)
	setActive(arg0._worldShopBtn, false)
	setText(arg0._worldResetPanel:Find("content/Text"), arg1.tipWord)

	local var0 = arg0._worldResetPanel:Find("IconTpl")

	setActive(var0, false)

	local var1 = arg0._worldResetPanel:Find("content/item_list")

	removeAllChildren(var1)

	for iter0, iter1 in ipairs(arg1.drops) do
		local var2 = cloneTplTo(var0, var1)

		updateDrop(var2, iter1)

		local var3 = findTF(var2, "name")

		changeToScrollText(var3, getText(var3))

		if arg1.itemFunc then
			onButton(arg0, var2, function()
				arg1.itemFunc(iter1)
			end, SFX_PANEL)
		end
	end

	onButton(arg0, arg0._worldShopBtn, function()
		arg0:hide()

		return existCall(arg1.goShop)
	end, SFX_MAIN)
	arg0:Loaded(arg1)
end

local function var13(arg0, arg1)
	arg0:commonSetting(arg1)

	arg0._window.sizeDelta = Vector2(arg0._defaultSize.x, 520)

	setActive(arg0._obtainPanel, true)
	setActive(arg0._btnContainer, false)

	local var0 = {
		type = DROP_TYPE_SHIP,
		id = arg1.shipId
	}

	updateDrop(arg0._obtainPanel, var0, arg1)

	local var1
	local var4

	if Ship.isMetaShipByConfigID(arg1.shipId) then
		local var2 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg1.shipId)
		local var3 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var2)

		if var3 and (var3:isInAct() or var3:isInArchive()) then
			var4 = true
		else
			var4 = false
		end
	else
		var4 = true
	end

	arg0.obtainSkipList = arg0.obtainSkipList or UIItemList.New(arg0._obtainPanel:Find("skipable_list"), arg0._obtainPanel:Find("skipable_list/tpl"))

	arg0.obtainSkipList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1.list[arg1 + 1]
			local var1 = var0[1]
			local var2 = var0[2]
			local var3 = var0[3]
			local var4 = HXSet.hxLan(var1)

			arg2:Find("mask/title"):GetComponent("ScrollText"):SetText(var4)
			setActive(arg2:Find("skip_btn"), var4 and var2[1] ~= "" and var2[1] ~= "COLLECTSHIP")

			if var2[1] ~= "" then
				onButton(arg0, arg2:Find("skip_btn"), function()
					if var3 and var3 ~= 0 then
						local var0 = getProxy(ActivityProxy):getActivityById(var3)

						if not var0 or var0:isEnd() then
							var0.TipsMgr.GetInstance():ShowTips(i18n("collection_way_is_unopen"))

							return
						end
					elseif var2[1] == "SHOP" and var2[2].warp == NewShopsScene.TYPE_MILITARY_SHOP and not var0.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "MilitaryExerciseMediator") then
						var0.TipsMgr.GetInstance():ShowTips(i18n("military_shop_no_open_tip"))

						return
					elseif var2[1] == "LEVEL" and var2[2] then
						local var1 = var2[2].chapterid
						local var2 = getProxy(ChapterProxy)
						local var3 = var2:getChapterById(var1)

						if var3:isUnlock() then
							local var4 = var2:getActiveChapter()

							if var4 and var4.id ~= var1 then
								arg0:ShowMsgBox({
									content = i18n("collect_chapter_is_activation"),
									onYes = function()
										var0.m02:sendNotification(GAME.CHAPTER_OP, {
											type = ChapterConst.OpRetreat
										})
									end
								})

								return
							else
								local var5 = {
									mapIdx = var3:getConfig("map")
								}

								if var3.active then
									var5.chapterId = var3.id
								else
									var5.openChapterId = var1
								end

								var0.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, var5)
							end
						else
							var0.TipsMgr.GetInstance():ShowTips(i18n("acquisitionmode_is_not_open"))

							return
						end
					elseif var2[1] == "COLLECTSHIP" then
						if arg1.mediatorName == CollectionMediator.__cname then
							var0.m02:sendNotification(CollectionMediator.EVENT_OBTAIN_SKIP, {
								toggle = 2,
								displayGroupId = var2[2].shipGroupId
							})
						else
							var0.m02:sendNotification(GAME.GO_SCENE, SCENE.COLLECTSHIP, {
								toggle = 2,
								displayGroupId = var2[2].shipGroupId
							})
						end
					elseif var2[1] == "SHOP" then
						var0.m02:sendNotification(GAME.GO_SCENE, SCENE[var2[1]], var2[2])
					else
						var0.m02:sendNotification(GAME.GO_SCENE, SCENE[var2[1]], var2[2])
					end

					arg0:hide()
				end, SFX_PANEL)
			end
		end
	end)
	arg0.obtainSkipList:align(#arg1.list)
	arg0:Loaded(arg1)
end

function var1.nextPage(arg0)
	arg0.helpPage = arg0.helpPage + 1

	if arg0.helpPage < 1 then
		arg0.helpPage = 1
	end

	if arg0.helpPage > arg0._helpList.childCount then
		arg0.helpPage = 1
	end

	arg0:switchHelpPage(arg0.helpPage)
end

function var1.prePage(arg0)
	arg0.helpPage = arg0.helpPage - 1

	if arg0.helpPage < 1 then
		arg0.helpPage = arg0._helpList.childCount
	end

	if arg0.helpPage > arg0._helpList.childCount then
		arg0.helpPage = arg0._helpList.childCount
	end

	arg0:switchHelpPage(arg0.helpPage)
end

function var1.switchHelpPage(arg0, arg1)
	for iter0 = 1, arg0._helpList.childCount do
		local var0 = arg0._helpList:GetChild(iter0 - 1)

		setActive(var0, arg1 == iter0)
		setText(var0:Find("icon/corner/Text"), iter0)
	end
end

function var1.commonSetting(arg0, arg1)
	rtf(arg0._window).sizeDelta = arg0._defaultSize
	rtf(arg0._helpPanel).sizeDelta = arg0._defaultHelpSize
	arg0.enable = true

	var0.DelegateInfo.New(arg0)
	setActive(arg0._msgPanel, false)
	setActive(arg0._exchangeShipPanel, false)
	setActive(arg0._itemPanel, false)
	setActive(arg0._eskinPanel, false)
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
			text = arg0.settings.noText or var1.TEXT_CANCEL,
			btnType = arg0.settings.noBtnType or var1.BUTTON_GRAY,
			onCallback = var10,
			sound = arg1.noSound or SFX_CANCEL
		})
	end

	if not var7 then
		var12 = arg0:createBtn({
			text = arg0.settings.yesText or var1.TEXT_CONFIRM,
			btnType = arg0.settings.yesBtnType or var1.BUTTON_BLUE,
			onCallback = var9,
			sound = arg1.yesSound or SFX_CONFIRM,
			alignment = arg0.settings.yesSize and TextAnchor.MiddleCenter,
			gray = arg0.settings.yesGray,
			delayButton = arg0.settings.delayConfirm
		})

		if arg0.settings.yesSize then
			var12.sizeDelta = arg0.settings.yesSize
		end
	end

	if arg0.settings.yseBtnLetf then
		var12:SetAsFirstSibling()
	end

	local var14

	if arg0.settings.type == MSGBOX_TYPE_HELP and arg0.settings.helps.pageMode and #arg0.settings.helps > 1 then
		arg0:createBtn({
			noQuit = true,
			btnType = var1.BUTTON_PREPAGE,
			onCallback = function()
				arg0:prePage()
			end,
			sound = SFX_CANCEL
		})

		var14 = #arg0.settings.helps
	end

	if arg0.settings.custom ~= nil then
		for iter2, iter3 in ipairs(arg0.settings.custom) do
			arg0:createBtn(iter3)
		end
	end

	if not var14 then
		-- block empty
	elseif var14 > 1 then
		arg0:createBtn({
			noQuit = true,
			btnType = var1.BUTTON_NEXTPAGE,
			onCallback = function()
				arg0:nextPage()
			end,
			sound = SFX_CONFIRM
		})
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

	local var15 = arg0.settings.title or var1.TITLE_INFORMATION
	local var16 = 0
	local var17 = arg0._titleList.transform.childCount

	while var16 < var17 do
		local var18 = arg0._titleList.transform:GetChild(var16)

		SetActive(var18, var18.name == var15)

		var16 = var16 + 1
	end

	local var19 = arg0._go.transform.localPosition

	arg0._go.transform.localPosition = Vector3(var19.x, var19.y, arg0.settings.zIndex or 0)
	arg0.locked = arg0.settings.locked or false
end

function var1.createBtn(arg0, arg1)
	local var0 = arg1.btnType or var1.BUTTON_BLUE
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

	local var6

	if var0 == var1.BUTTON_MEDAL then
		setText(var3:Find("text"), arg1.text)

		var6 = var3:Find("text")
	elseif var0 ~= var1.BUTTON_RETREAT and var0 ~= var1.BUTTON_PREPAGE and var0 ~= var1.BUTTON_NEXTPAGE then
		arg0:updateButton(var3, arg1.text, arg1.alignment)

		var6 = var3:Find("pic")
	end

	if var0 == var1.BUTTON_BLUE_WITH_ICON and arg1.iconName then
		local var7 = var3:Find("ticket/icon")

		setImageSprite(var7, LoadSprite(arg1.iconName[1], arg1.iconName[2]))
	end

	local var8

	if arg1.delayButton then
		local var9 = arg1.delayButton
		local var10 = getText(var6)

		var8 = Timer.New(function()
			var9 = var9 - 1

			if var9 > 0 then
				setText(var6, var10 .. string.format("(%d)", var9))
			else
				setText(var6, var10)
				setGray(var3, arg1.gray, true)

				var8 = nil
			end
		end, 1, var9)
		arg0.timers.delayTimer = var8

		var8:Start()
		setText(var6, var10 .. string.format("(%d)", var9))
		setGray(var3, true, true)
	else
		setGray(var3, arg1.gray, true)
	end

	if not arg1.hideEvent then
		onButton(arg0, var3, function()
			if var8 then
				return
			end

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

function var1.updateButton(arg0, arg1, arg2, arg3)
	local var0 = var2[arg2]
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

function var1.Loaded(arg0, arg1)
	var0.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		groupName = arg1.groupName,
		weight = arg1.weight or LayerWeightConst.SECOND_LAYER,
		blurLevelCamera = arg1.blurLevelCamera,
		parent = arg1.parent
	})
	var0.m02:sendNotification(GAME.OPEN_MSGBOX_DONE)
end

function var1.Clear(arg0)
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

	var0.DelegateInfo.Dispose(arg0)
	removeAllChildren(arg0._btnContainer)
	var0.UIMgr.GetInstance():UnblurPanel(arg0._tf, var0.UIMgr.GetInstance().OverlayMain)
	arg0.contentText:RemoveAllListeners()

	arg0.settings = nil
	arg0.enable = false
	arg0.locked = nil
end

function var1.ShowMsgBox(arg0, arg1)
	if arg0.locked then
		return
	end

	local var0 = arg1.type or MSGBOX_TYPE_NORMAL

	switch(var0, {
		[MSGBOX_TYPE_NORMAL] = function()
			var3(arg0, arg1)
		end,
		[MSGBOX_TYPE_INPUT] = function()
			var4(arg0, arg1)
		end,
		[MSGBOX_TYPE_SINGLE_ITEM] = function()
			var9(arg0, arg1)
		end,
		[MSGBOX_TYPE_EXCHANGE] = function()
			var5(arg0, arg1)
		end,
		[MSGBOX_TYPE_DROP_ITEM] = function()
			var8(arg0, arg1)
		end,
		[MSGBOX_TYPE_ITEM_BOX] = function()
			var6(arg0, arg1)
		end,
		[MSGBOX_TYPE_DROP_ITEM_ESKIN] = function()
			var7(arg0, arg1)
		end,
		[MSGBOX_TYPE_HELP] = function()
			arg1.hideNo = defaultValue(arg1.hideNo, true)
			arg1.hideYes = defaultValue(arg1.hideYes, true)

			var10(arg0, arg1)
		end,
		[MSGBOX_TYPE_SECONDPWD] = function()
			PoolMgr.GetInstance():GetUI("Msgbox4SECPWD", true, function(arg0)
				arg0.pools.SedondaryUI = arg0

				if arg1.onPreShow then
					arg1.onPreShow()
				end

				arg1.secondaryUI = arg0

				SetParent(arg0, arg0._otherPanel, false)
				var11(arg0, arg1)
			end)
		end,
		[MSGBOX_TYPE_WORLD_RESET] = function()
			var12(arg0, arg1)
		end,
		[MSGBOX_TYPE_OBTAIN] = function()
			arg1.title = arg1.title or var1.TITLE_OBTAIN

			var13(arg0, arg1)
		end,
		[MSGBOX_TYPE_ITEMTIP] = function()
			arg0:GetPanel(ItemTipPanel).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_JUST_FOR_SHOW] = function()
			arg0:GetPanel(ItemShowPanel).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_MONTH_CARD_TIP] = function()
			arg0:GetPanel(MonthCardOutDateTipPanel).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_STORY_CANCEL_TIP] = function()
			arg0:GetPanel(StoryCancelTipPanel).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_META_SKILL_UNLOCK] = function()
			arg0:GetPanel(MetaSkillUnlockPanel).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_ACCOUNTDELETE] = function()
			arg0:GetPanel(AccountDeletePanel).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_STRENGTHEN_BACK] = function()
			arg0:GetPanel(StrengthenBackPanel).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_CONTENT_ITEMS] = function()
			arg0:GetPanel(Msgbox4ContentItems).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_BLUEPRINT_UNLOCK_ITEM] = function()
			arg0:GetPanel(Msgbox4BlueprintUnlockItem).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_CONFIRM_DELETE] = function()
			arg0:GetPanel(ConfirmEquipmentDeletePanel).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_CONFIRM_REFORGE_SPWEAPON] = function()
			arg0:GetPanel(Msgbox4SpweaponConfirm).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_SUBPATTERN] = function()
			arg0:GetPanel(arg1.patternClass).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_FILE_DOWNLOAD] = function()
			arg0:GetPanel(FileDownloadPanel).buffer:UpdateView(arg1)
		end,
		[MSGBOX_TYPE_LIKN_COLLECT_GUIDE] = function()
			arg0:GetPanel(Msgbox4LinkCollectGuide).buffer:UpdateView(arg1)
		end
	})
end

function var1.GetPanel(arg0, arg1)
	if not arg0.panelDict[arg1] then
		arg0.panelDict[arg1] = arg1.New(arg0)

		arg0.panelDict[arg1]:Load()
		arg0.panelDict[arg1].buffer:SetParent(arg0._window)
	end

	return arg0.panelDict[arg1]
end

function var1.CloseAndHide(arg0)
	if not arg0.enable then
		return
	end

	local var0 = arg0.settings
	local var1 = var0.onClose or not var0.hideNo and var0.onNo or nil

	existCall(var1)
	arg0:hide()
end

function var1.hide(arg0)
	if not arg0.enable then
		return
	end

	arg0._go:SetActive(false)
	arg0:Clear()
	var0.m02:sendNotification(GAME.CLOSE_MSGBOX_DONE)
end

function var1.emit(arg0, arg1, ...)
	if not arg0.analogyMediator then
		arg0.analogyMediator = {
			addSubLayers = function(arg0, arg1)
				var0.m02:sendNotification(GAME.LOAD_LAYERS, {
					parentContext = getProxy(ContextProxy):getCurrentContext(),
					context = arg1
				})
			end,
			sendNotification = function(arg0, ...)
				var0.m02:sendNotification(...)
			end,
			viewComponent = arg0
		}
	end

	return ContextMediator.CommonBindDic[arg1](arg0.analogyMediator, arg1, ...)
end

function var1.closeView(arg0)
	arg0:hide()
end
