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

function var0_0.init(arg0_2)
	arg0_2.eventTriggers = {}
	arg0_2.characters = arg0_2:findTF("select_character/characters")
	arg0_2.propPanel = arg0_2:findTF("prop_panel")
	arg0_2.selectPanel = arg0_2:findTF("select_character")

	setActive(arg0_2.propPanel, false)
	setActive(arg0_2.selectPanel, true)

	arg0_2.confirmBtn = arg0_2:findTF("bg/qr_btn", arg0_2.propPanel)
	arg0_2.tip = arg0_2:findTF("select_character/tip")
	arg0_2.skillPanel = arg0_2:findTF("bg/skill_panel", arg0_2.propPanel)
	arg0_2.skillTpl = arg0_2:getTpl("bg/skill_panel/frame/skilltpl", arg0_2.propPanel)
	arg0_2.skillContainer = arg0_2:findTF("bg/skill_panel/frame", arg0_2.propPanel)
	arg0_2.namedPanel = arg0_2:findTF("named_panel")

	setActive(arg0_2.namedPanel, false)

	arg0_2.info = arg0_2.namedPanel:Find("info")
	arg0_2.nickname = arg0_2.info:Find("nickname")
	arg0_2.qChar = arg0_2.propPanel:Find("q_char")
	arg0_2.chat = arg0_2:findTF("info/tip/chatbgtop0/Text", arg0_2.namedPanel)
	arg0_2.propertyPanel = PropertyPanel.New(arg0_2.propPanel:Find("bg/property_panel/frame"))
	arg0_2.paintTF = arg0_2:findTF("prop_panel/bg/paint")
	arg0_2.nameTF = arg0_2:findTF("prop_panel/bg/name")
	arg0_2.nameEnTF = arg0_2:findTF("prop_panel/bg/english_name_bg")
	arg0_2.titleShipinfoTF = arg0_2:findTF("lines/hori/shipinfo_text")
	arg0_2.titleShipchooseTF = arg0_2:findTF("lines/hori/shipchoose_text")

	setImageAlpha(arg0_2.titleShipinfoTF, 1)
	setImageAlpha(arg0_2.titleShipchooseTF, 0)

	arg0_2.randBtn = findTF(arg0_2.info, "random_button")

	setActive(arg0_2.randBtn, PLATFORM_CODE == PLATFORM_CH)
end

function var0_0.onBackPressed(arg0_3)
	if LeanTween.isTweening(go(arg0_3.propPanel)) then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_3.namedPanel) then
		arg0_3:closeNamedPanel()

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
end

function var0_0.switchPanel(arg0_4)
	setActive(arg0_4.propPanel, true)

	local var0_4 = arg0_4.propPanel:GetComponent(typeof(CanvasGroup))
	local var1_4 = arg0_4.selectPanel:GetComponent(typeof(CanvasGroup))

	LeanTween.value(go(arg0_4.propPanel), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_5)
		var0_4.alpha = arg0_5
		var1_4.alpha = 1 - arg0_5
	end)):setOnComplete(System.Action(function()
		setActive(arg0_4.selectPanel, false)
	end))

	arg0_4.skillPanel.localPosition = Vector3.New(-1000, arg0_4.skillPanel.localPosition.y, arg0_4.skillPanel.localPosition.z)

	LeanTween.moveX(arg0_4.skillPanel, 339, 0.2)

	local var2_4 = arg0_4:findTF("lines/line")
	local var3_4 = arg0_4:findTF("lines/hori")

	LeanTween.moveY(var2_4, -328, 0.2)
	LeanTween.moveX(var3_4, -820, 0.2)

	for iter0_4 = 1, 3 do
		local var4_4 = arg0_4:findTF("character_" .. iter0_4, arg0_4.characters)
		local var5_4 = arg0_4:findTF("bg/characters/character_" .. iter0_4, arg0_4.propPanel)

		setImageAlpha(var4_4, 1)
		LeanTween.alpha(var4_4, 0, 0.25)
		LeanTween.move(go(var4_4), var5_4.position, 0.3)
		setImageAlpha(arg0_4.titleShipinfoTF, 0)
		setImageAlpha(arg0_4.titleShipchooseTF, 1)
		LeanTween.alpha(arg0_4.titleShipinfoTF, 1, 0.25)
		LeanTween.alpha(arg0_4.titleShipchooseTF, 0, 0.25)
	end
end

function var0_0.initCharacters(arg0_7)
	arg0_7.charInitPos = {}

	for iter0_7 = 1, 3 do
		local var0_7 = arg0_7:findTF("prop_panel/bg/characters/character_" .. iter0_7)

		onToggle(arg0_7, var0_7, function(arg0_8)
			if arg0_8 then
				arg0_7:selectCharacterByIdx(var0_7, var5_0[iter0_7])
				setActive(arg0_7:findTF("selected", var0_7), true)

				var0_7:GetComponent(typeof(RectTransform)).sizeDelta = Vector2(196, 196)
			else
				setActive(arg0_7:findTF("selected", var0_7), false)

				var0_7:GetComponent(typeof(RectTransform)).sizeDelta = Vector2(140, 140)
			end
		end)
	end

	local var1_7 = {
		0.2,
		0.3,
		0.1
	}

	for iter1_7 = 1, 3 do
		local var2_7 = arg0_7:findTF("character_" .. iter1_7, arg0_7.characters)

		onButton(arg0_7, var2_7, function()
			arg0_7:switchPanel()
			triggerToggle(arg0_7:findTF("prop_panel/bg/characters/character_" .. iter1_7), true)
		end)

		var2_7.localPosition = Vector3.New(var2_7.localPosition.x, 912, var2_7.localPosition.z)

		setImageAlpha(var2_7, 0)
		LeanTween.alpha(var2_7, 1, 0.3):setDelay(var1_7[iter1_7])
		LeanTween.moveY(var2_7, 0, 0.2):setDelay(var1_7[iter1_7])
	end
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.confirmBtn, function()
		arg0_10:showNamedPanel()
	end, SFX_PANEL)
	onButton(arg0_10, findTF(arg0_10.info, "random_button"), function()
		local var0_12 = require("GameCfg.names")
		local var1_12 = var0_12[1][math.random(#var0_12[1])]
		local var2_12 = var0_12[2][math.random(#var0_12[2])]
		local var3_12 = var0_12[3][math.random(#var0_12[3])]
		local var4_12 = var0_12[4][math.random(#var0_12[4])]

		setInputText(arg0_10.nickname, var1_12 .. var2_12 .. var3_12 .. var4_12)
	end, SFX_MAIN)
	onButton(arg0_10, findTF(arg0_10.info, "btn_container/enter_button"), function()
		if not arg0_10.contextData.configId then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_newPlayerScene_error_notChoiseShip"))

			return
		end

		local var0_13 = getInputText(arg0_10.nickname)

		if var0_13 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_newPlayerScene_inputName"))

			return
		end

		if not nameValidityCheck(var0_13, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			return
		end

		arg0_10.event:emit(NewPlayerMediator.ON_CREATE, var0_13, arg0_10.contextData.configId)
	end, SFX_CONFIRM)
	onButton(arg0_10, findTF(arg0_10.info, "btn_container/cancel_button"), function()
		arg0_10:closeNamedPanel()
	end)
	arg0_10:initCharacters()
end

local var8_0 = 0.3
local var9_0 = -47

function var0_0.selectCharacterByIdx(arg0_15, arg1_15, arg2_15)
	arg0_15.inProp = true
	arg0_15.contextData.configId = arg2_15

	arg0_15.propertyPanel:initProperty(arg2_15)
	arg0_15:initSkills()

	local var0_15 = pg.ship_data_statistics[arg2_15]

	setPaintingPrefab(arg0_15.paintTF, var6_0[arg2_15], "chuanwu")
	setText(arg0_15:findTF("name_mask/Text", arg0_15.nameTF), var0_15.name)
	setText(arg0_15:findTF("english_name", arg0_15.nameTF), var0_15.english_name)
	setText(arg0_15.nameEnTF, string.upper(var0_15.english_name))

	local var1_15 = Ship.New({
		configId = arg0_15.contextData.configId
	}):getPrefab()

	if var1_15 == arg0_15.shipPrefab then
		return
	end

	arg0_15:recycleSpineChar()
	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var1_15, true, function(arg0_16)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_15.shipPrefab = var1_15
		arg0_15.shipModel = arg0_16

		arg0_16:GetComponent("SpineAnimUI"):SetAction("stand", 0)

		tf(arg0_16).localScale = Vector3(0.5, 0.5, 1)
		tf(arg0_16).localPosition = Vector3(15, -95, 0)

		pg.ViewUtils.SetLayer(tf(arg0_16), Layer.UI)
		removeAllChildren(arg0_15.qChar)
		SetParent(arg0_16, arg0_15.qChar, false)
	end)
end

function var0_0.initSkills(arg0_17)
	local var0_17 = pg.ship_data_template[arg0_17.contextData.configId]

	removeAllChildren(arg0_17.skillContainer)

	for iter0_17, iter1_17 in ipairs(var0_17.buff_list_display) do
		local var1_17 = getSkillConfig(iter1_17)
		local var2_17 = table.contains(var0_17.buff_list, iter1_17)
		local var3_17 = cloneTplTo(arg0_17.skillTpl, arg0_17.skillContainer)

		setActive(var3_17:Find("mask"), not var2_17)
		onButton(arg0_17, var3_17, function()
			arg0_17:emit(NewPlayerMediator.ON_SKILLINFO, var1_17.id)
		end, SFX_PANEL)
		LoadImageSpriteAsync("skillicon/" .. var1_17.icon, findTF(var3_17, "icon"))
	end
end

function var0_0.showNamedPanel(arg0_19)
	arg0_19.qChar:SetParent(arg0_19.info)
	pg.UIMgr.GetInstance():BlurPanel(arg0_19.namedPanel)
	setActive(arg0_19.namedPanel, true)
	setInputText(arg0_19.nickname, "")
	setText(arg0_19.chat, var7_0[arg0_19.contextData.configId])
end

function var0_0.closeNamedPanel(arg0_20)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_20.namedPanel, arg0_20._tf)
	setActive(arg0_20.namedPanel, false)
	arg0_20.qChar:SetParent(arg0_20.propPanel)
end

function var0_0.recycleSpineChar(arg0_21)
	if arg0_21.shipPrefab and arg0_21.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_21.shipPrefab, arg0_21.shipModel)

		arg0_21.shipPrefab = nil
		arg0_21.shipModel = nil
	end
end

function var0_0.willExit(arg0_22)
	if arg0_22.eventTriggers then
		for iter0_22, iter1_22 in pairs(arg0_22.eventTriggers) do
			ClearEventTrigger(iter0_22)
		end

		arg0_22.eventTriggers = nil
	end

	arg0_22:closeNamedPanel()
end

return var0_0
