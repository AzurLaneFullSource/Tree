local var0_0 = class("NewPlayerScene", import("..base.BaseUI"))
local var1_0 = 0.5
local var2_0 = -300
local var3_0 = Vector3(-380, 265, 0)
local var4_0 = 19
local var5_0 = {
	101171,
	201211,
	401231
}
local var6_0 = {
	[401231] = "z23",
	[101171] = "lafei",
	[301051] = "lingbo",
	[201211] = "biaoqiang"
}
local var7_0 = {
	[101171] = i18n("login_newPlayerScene_word_laFei"),
	[201211] = i18n("login_newPlayerScene_word_biaoqiang"),
	[401231] = i18n("login_newPlayerScene_word_z23")
}

function var0_0.getUIName(arg0_1)
	return "NewPlayerUI"
end

function var0_0.getResource(arg0_2)
	local var0_2 = {}
	local var1_2 = {}
	local var2_2 = {}

	for iter0_2, iter1_2 in pairs(var6_0) do
		local var3_2 = ResPathSupport.GetPaintingListByPaintingName(iter1_2)

		table.insertto(var0_2, var3_2)

		local var4_2 = ResPathSupport.GetSkillIconList(iter0_2)

		table.insertto(var1_2, var4_2)

		local var5_2 = Ship.New({
			configId = iter0_2
		})
		local var6_2 = var5_2:getPrefab()
		local var7_2 = ResPathSupport.GetSpineCharListByPrefabName(var6_2)

		table.insertto(var2_2, var7_2)

		local var8_2 = var5_2:getSkinId()
		local var9_2 = ResPathSupport.GetShipSkinLive2DList(var8_2)

		table.insertto(var2_2, var9_2)
	end

	local var10_2 = ResPathSupport.MergeLuaArr(var0_2, var1_2, var2_2)

	return table.insertto(var10_2, var0_0.super.getResource(arg0_2))
end

function var0_0.init(arg0_3)
	arg0_3.eventTriggers = {}
	arg0_3.characters = arg0_3._tf:Find("select_character/characters")
	arg0_3.propPanel = arg0_3._tf:Find("prop_panel")
	arg0_3.selectPanel = arg0_3._tf:Find("select_character")

	setActive(arg0_3.propPanel, false)
	setActive(arg0_3.selectPanel, true)

	arg0_3.confirmBtn = arg0_3.propPanel:Find("bg/qr_btn")
	arg0_3.tip = arg0_3._tf:Find("select_character/tip")
	arg0_3.skillPanel = arg0_3.propPanel:Find("bg/skill_panel")
	arg0_3.skillTpl = arg0_3:getTpl("bg/skill_panel/frame/skilltpl", arg0_3.propPanel)
	arg0_3.skillContainer = arg0_3.propPanel:Find("bg/skill_panel/frame")
	arg0_3.namedPanel = arg0_3._tf:Find("named_panel")

	setActive(arg0_3.namedPanel, false)

	arg0_3.info = arg0_3.namedPanel:Find("info")
	arg0_3.nickname = arg0_3.info:Find("nickname")
	arg0_3.qChar = arg0_3.propPanel:Find("q_char")
	arg0_3.chat = arg0_3.namedPanel:Find("info/tip/chatbgtop0/Text")
	arg0_3.propertyPanel = PropertyPanel.New(arg0_3.propPanel:Find("bg/property_panel/frame"))
	arg0_3.paintTF = arg0_3._tf:Find("prop_panel/bg/paint")
	arg0_3.nameTF = arg0_3._tf:Find("prop_panel/bg/name")
	arg0_3.nameEnTF = arg0_3._tf:Find("prop_panel/bg/english_name_bg")
	arg0_3.titleShipinfoTF = arg0_3._tf:Find("lines/hori/shipinfo_text")
	arg0_3.titleShipchooseTF = arg0_3._tf:Find("lines/hori/shipchoose_text")

	setImageAlpha(arg0_3.titleShipinfoTF, 1)
	setImageAlpha(arg0_3.titleShipchooseTF, 0)

	arg0_3.randBtn = findTF(arg0_3.info, "random_button")

	setActive(arg0_3.randBtn, PLATFORM_CODE == PLATFORM_CH)
end

function var0_0.onBackPressed(arg0_4)
	if LeanTween.isTweening(go(arg0_4.propPanel)) then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_4.namedPanel) then
		arg0_4:closeNamedPanel()

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
end

function var0_0.switchPanel(arg0_5)
	setActive(arg0_5.propPanel, true)

	local var0_5 = arg0_5.propPanel:GetComponent(typeof(CanvasGroup))
	local var1_5 = arg0_5.selectPanel:GetComponent(typeof(CanvasGroup))

	LeanTween.value(go(arg0_5.propPanel), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_6)
		var0_5.alpha = arg0_6
		var1_5.alpha = 1 - arg0_6
	end)):setOnComplete(System.Action(function()
		setActive(arg0_5.selectPanel, false)
	end))

	arg0_5.skillPanel.localPosition = Vector3.New(-1000, arg0_5.skillPanel.localPosition.y, arg0_5.skillPanel.localPosition.z)

	LeanTween.moveX(arg0_5.skillPanel, 339, 0.2)

	local var2_5 = arg0_5._tf:Find("lines/line")
	local var3_5 = arg0_5._tf:Find("lines/hori")

	LeanTween.moveY(var2_5, -328, 0.2)
	LeanTween.moveX(var3_5, -820, 0.2)

	for iter0_5 = 1, 3 do
		local var4_5 = arg0_5.characters:Find("character_" .. iter0_5)
		local var5_5 = arg0_5.propPanel:Find("bg/characters/character_" .. iter0_5)

		setImageAlpha(var4_5, 1)
		LeanTween.alpha(var4_5, 0, 0.25)
		LeanTween.move(go(var4_5), var5_5.position, 0.3)
		setImageAlpha(arg0_5.titleShipinfoTF, 0)
		setImageAlpha(arg0_5.titleShipchooseTF, 1)
		LeanTween.alpha(arg0_5.titleShipinfoTF, 1, 0.25)
		LeanTween.alpha(arg0_5.titleShipchooseTF, 0, 0.25)
	end
end

function var0_0.initCharacters(arg0_8)
	arg0_8.charInitPos = {}

	for iter0_8 = 1, 3 do
		local var0_8 = arg0_8._tf:Find("prop_panel/bg/characters/character_" .. iter0_8)

		onToggle(arg0_8, var0_8, function(arg0_9)
			if arg0_9 then
				arg0_8:selectCharacterByIdx(var0_8, var5_0[iter0_8])
				setActive(var0_8:Find("selected"), true)

				var0_8:GetComponent(typeof(RectTransform)).sizeDelta = Vector2(196, 196)
			else
				setActive(var0_8:Find("selected"), false)

				var0_8:GetComponent(typeof(RectTransform)).sizeDelta = Vector2(140, 140)
			end
		end)
	end

	local var1_8 = {
		0.2,
		0.3,
		0.1
	}

	for iter1_8 = 1, 3 do
		local var2_8 = arg0_8.characters:Find("character_" .. iter1_8)

		onButton(arg0_8, var2_8, function()
			arg0_8:switchPanel()
			triggerToggle(arg0_8._tf:Find("prop_panel/bg/characters/character_" .. iter1_8), true)
		end)

		var2_8.localPosition = Vector3.New(var2_8.localPosition.x, 912, var2_8.localPosition.z)

		setImageAlpha(var2_8, 0)
		LeanTween.alpha(var2_8, 1, 0.3):setDelay(var1_8[iter1_8])
		LeanTween.moveY(var2_8, 0, 0.2):setDelay(var1_8[iter1_8])
	end
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11.confirmBtn, function()
		arg0_11:showNamedPanel()
	end, SFX_PANEL)
	onButton(arg0_11, findTF(arg0_11.info, "random_button"), function()
		local var0_13 = require("GameCfg.names")
		local var1_13 = var0_13[1][math.random(#var0_13[1])]
		local var2_13 = var0_13[2][math.random(#var0_13[2])]
		local var3_13 = var0_13[3][math.random(#var0_13[3])]
		local var4_13 = var0_13[4][math.random(#var0_13[4])]

		setInputText(arg0_11.nickname, var1_13 .. var2_13 .. var3_13 .. var4_13)
	end, SFX_MAIN)
	onButton(arg0_11, findTF(arg0_11.info, "btn_container/enter_button"), function()
		if not arg0_11.contextData.configId then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_newPlayerScene_error_notChoiseShip"))

			return
		end

		local var0_14 = getInputText(arg0_11.nickname)

		if var0_14 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_newPlayerScene_inputName"))

			return
		end

		if not nameValidityCheck(var0_14, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			return
		end

		arg0_11.event:emit(NewPlayerMediator.ON_CREATE, var0_14, arg0_11.contextData.configId)
	end, SFX_CONFIRM)
	onButton(arg0_11, findTF(arg0_11.info, "btn_container/cancel_button"), function()
		arg0_11:closeNamedPanel()
	end)
	arg0_11:initCharacters()
end

local var8_0 = 0.3
local var9_0 = -47

function var0_0.selectCharacterByIdx(arg0_16, arg1_16, arg2_16)
	arg0_16.inProp = true
	arg0_16.contextData.configId = arg2_16

	arg0_16.propertyPanel:initProperty(arg2_16)
	arg0_16:initSkills()

	local var0_16 = pg.ship_data_statistics[arg2_16]

	setPaintingPrefab(arg0_16.paintTF, var6_0[arg2_16], "chuanwu")
	setText(arg0_16.nameTF:Find("name_mask/Text"), var0_16.name)
	setText(arg0_16.nameTF:Find("english_name"), var0_16.english_name)
	setText(arg0_16.nameEnTF, string.upper(var0_16.english_name))

	local var1_16 = Ship.New({
		configId = arg0_16.contextData.configId
	}):getPrefab()

	if var1_16 == arg0_16.shipPrefab then
		return
	end

	arg0_16:recycleSpineChar()
	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var1_16, true, function(arg0_17)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_16.shipPrefab = var1_16
		arg0_16.shipModel = arg0_17

		arg0_17:GetComponent("SpineAnimUI"):SetAction("stand", 0)

		tf(arg0_17).localScale = Vector3(0.5, 0.5, 1)
		tf(arg0_17).localPosition = Vector3(15, -95, 0)

		pg.ViewUtils.SetLayer(tf(arg0_17), Layer.UI)
		removeAllChildren(arg0_16.qChar)
		SetParent(arg0_17, arg0_16.qChar, false)
	end)
end

function var0_0.initSkills(arg0_18)
	local var0_18 = pg.ship_data_template[arg0_18.contextData.configId]

	removeAllChildren(arg0_18.skillContainer)

	for iter0_18, iter1_18 in ipairs(var0_18.buff_list_display) do
		local var1_18 = getSkillConfig(iter1_18)
		local var2_18 = table.contains(var0_18.buff_list, iter1_18)
		local var3_18 = cloneTplTo(arg0_18.skillTpl, arg0_18.skillContainer)

		setActive(var3_18:Find("mask"), not var2_18)
		onButton(arg0_18, var3_18, function()
			arg0_18:emit(NewPlayerMediator.ON_SKILLINFO, var1_18.id)
		end, SFX_PANEL)
		LoadImageSpriteAsync("skillicon/" .. var1_18.icon, findTF(var3_18, "icon"))
	end
end

function var0_0.showNamedPanel(arg0_20)
	arg0_20.qChar:SetParent(arg0_20.info)
	pg.UIMgr.GetInstance():BlurPanel(arg0_20.namedPanel)
	setActive(arg0_20.namedPanel, true)
	setInputText(arg0_20.nickname, "")
	setText(arg0_20.chat, var7_0[arg0_20.contextData.configId])
end

function var0_0.closeNamedPanel(arg0_21)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21.namedPanel, arg0_21._tf)
	setActive(arg0_21.namedPanel, false)
	arg0_21.qChar:SetParent(arg0_21.propPanel)
end

function var0_0.recycleSpineChar(arg0_22)
	if arg0_22.shipPrefab and arg0_22.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_22.shipPrefab, arg0_22.shipModel)

		arg0_22.shipPrefab = nil
		arg0_22.shipModel = nil
	end
end

function var0_0.willExit(arg0_23)
	if arg0_23.eventTriggers then
		for iter0_23, iter1_23 in pairs(arg0_23.eventTriggers) do
			ClearEventTrigger(iter0_23)
		end

		arg0_23.eventTriggers = nil
	end

	arg0_23:closeNamedPanel()
end

return var0_0
