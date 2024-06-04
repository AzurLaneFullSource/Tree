local var0 = class("NewPlayerScene", import("..base.BaseUI"))
local var1 = 0.5
local var2 = -300
local var3 = Vector3(-380, 265, 0)
local var4 = 19
local var5 = {
	101171,
	201211,
	401231
}
local var6 = {
	[401231] = "z23",
	[101171] = "lafei",
	[301051] = "lingbo",
	[201211] = "biaoqiang"
}
local var7 = {
	[101171] = i18n("login_newPlayerScene_word_laFei"),
	[201211] = i18n("login_newPlayerScene_word_biaoqiang"),
	[401231] = i18n("login_newPlayerScene_word_z23")
}

function var0.getUIName(arg0)
	return "NewPlayerUI"
end

function var0.init(arg0)
	arg0.eventTriggers = {}
	arg0.characters = arg0:findTF("select_character/characters")
	arg0.propPanel = arg0:findTF("prop_panel")
	arg0.selectPanel = arg0:findTF("select_character")

	setActive(arg0.propPanel, false)
	setActive(arg0.selectPanel, true)

	arg0.confirmBtn = arg0:findTF("bg/qr_btn", arg0.propPanel)
	arg0.tip = arg0:findTF("select_character/tip")
	arg0.skillPanel = arg0:findTF("bg/skill_panel", arg0.propPanel)
	arg0.skillTpl = arg0:getTpl("bg/skill_panel/frame/skilltpl", arg0.propPanel)
	arg0.skillContainer = arg0:findTF("bg/skill_panel/frame", arg0.propPanel)
	arg0.namedPanel = arg0:findTF("named_panel")

	setActive(arg0.namedPanel, false)

	arg0.info = arg0.namedPanel:Find("info")
	arg0.nickname = arg0.info:Find("nickname")
	arg0.qChar = arg0.propPanel:Find("q_char")
	arg0.chat = arg0:findTF("info/tip/chatbgtop0/Text", arg0.namedPanel)
	arg0.propertyPanel = PropertyPanel.New(arg0.propPanel:Find("bg/property_panel/frame"))
	arg0.paintTF = arg0:findTF("prop_panel/bg/paint")
	arg0.nameTF = arg0:findTF("prop_panel/bg/name")
	arg0.nameEnTF = arg0:findTF("prop_panel/bg/english_name_bg")
	arg0.titleShipinfoTF = arg0:findTF("lines/hori/shipinfo_text")
	arg0.titleShipchooseTF = arg0:findTF("lines/hori/shipchoose_text")

	setImageAlpha(arg0.titleShipinfoTF, 1)
	setImageAlpha(arg0.titleShipchooseTF, 0)

	arg0.randBtn = findTF(arg0.info, "random_button")

	setActive(arg0.randBtn, PLATFORM_CODE == PLATFORM_CH)
end

function var0.onBackPressed(arg0)
	if LeanTween.isTweening(go(arg0.propPanel)) then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0.namedPanel) then
		arg0:closeNamedPanel()

		return
	end

	pg.SdkMgr.GetInstance():OnAndoridBackPress()
end

function var0.switchPanel(arg0)
	setActive(arg0.propPanel, true)

	local var0 = arg0.propPanel:GetComponent(typeof(CanvasGroup))
	local var1 = arg0.selectPanel:GetComponent(typeof(CanvasGroup))

	LeanTween.value(go(arg0.propPanel), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0)
		var0.alpha = arg0
		var1.alpha = 1 - arg0
	end)):setOnComplete(System.Action(function()
		setActive(arg0.selectPanel, false)
	end))

	arg0.skillPanel.localPosition = Vector3.New(-1000, arg0.skillPanel.localPosition.y, arg0.skillPanel.localPosition.z)

	LeanTween.moveX(arg0.skillPanel, 339, 0.2)

	local var2 = arg0:findTF("lines/line")
	local var3 = arg0:findTF("lines/hori")

	LeanTween.moveY(var2, -328, 0.2)
	LeanTween.moveX(var3, -820, 0.2)

	for iter0 = 1, 3 do
		local var4 = arg0:findTF("character_" .. iter0, arg0.characters)
		local var5 = arg0:findTF("bg/characters/character_" .. iter0, arg0.propPanel)

		setImageAlpha(var4, 1)
		LeanTween.alpha(var4, 0, 0.25)
		LeanTween.move(go(var4), var5.position, 0.3)
		setImageAlpha(arg0.titleShipinfoTF, 0)
		setImageAlpha(arg0.titleShipchooseTF, 1)
		LeanTween.alpha(arg0.titleShipinfoTF, 1, 0.25)
		LeanTween.alpha(arg0.titleShipchooseTF, 0, 0.25)
	end
end

function var0.initCharacters(arg0)
	arg0.charInitPos = {}

	for iter0 = 1, 3 do
		local var0 = arg0:findTF("prop_panel/bg/characters/character_" .. iter0)

		onToggle(arg0, var0, function(arg0)
			if arg0 then
				arg0:selectCharacterByIdx(var0, var5[iter0])
				setActive(arg0:findTF("selected", var0), true)

				var0:GetComponent(typeof(RectTransform)).sizeDelta = Vector2(196, 196)
			else
				setActive(arg0:findTF("selected", var0), false)

				var0:GetComponent(typeof(RectTransform)).sizeDelta = Vector2(140, 140)
			end
		end)
	end

	local var1 = {
		0.2,
		0.3,
		0.1
	}

	for iter1 = 1, 3 do
		local var2 = arg0:findTF("character_" .. iter1, arg0.characters)

		onButton(arg0, var2, function()
			arg0:switchPanel()
			triggerToggle(arg0:findTF("prop_panel/bg/characters/character_" .. iter1), true)
		end)

		var2.localPosition = Vector3.New(var2.localPosition.x, 912, var2.localPosition.z)

		setImageAlpha(var2, 0)
		LeanTween.alpha(var2, 1, 0.3):setDelay(var1[iter1])
		LeanTween.moveY(var2, 0, 0.2):setDelay(var1[iter1])
	end
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:showNamedPanel()
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0.info, "random_button"), function()
		local var0 = require("GameCfg.names")
		local var1 = var0[1][math.random(#var0[1])]
		local var2 = var0[2][math.random(#var0[2])]
		local var3 = var0[3][math.random(#var0[3])]
		local var4 = var0[4][math.random(#var0[4])]

		setInputText(arg0.nickname, var1 .. var2 .. var3 .. var4)
	end, SFX_MAIN)
	onButton(arg0, findTF(arg0.info, "btn_container/enter_button"), function()
		if not arg0.contextData.configId then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_newPlayerScene_error_notChoiseShip"))

			return
		end

		local var0 = getInputText(arg0.nickname)

		if var0 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_newPlayerScene_inputName"))

			return
		end

		if not nameValidityCheck(var0, 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			return
		end

		arg0.event:emit(NewPlayerMediator.ON_CREATE, var0, arg0.contextData.configId)
	end, SFX_CONFIRM)
	onButton(arg0, findTF(arg0.info, "btn_container/cancel_button"), function()
		arg0:closeNamedPanel()
	end)
	arg0:initCharacters()
end

local var8 = 0.3
local var9 = -47

function var0.selectCharacterByIdx(arg0, arg1, arg2)
	arg0.inProp = true
	arg0.contextData.configId = arg2

	arg0.propertyPanel:initProperty(arg2)
	arg0:initSkills()

	local var0 = pg.ship_data_statistics[arg2]

	setPaintingPrefab(arg0.paintTF, var6[arg2], "chuanwu")
	setText(arg0:findTF("name_mask/Text", arg0.nameTF), var0.name)
	setText(arg0:findTF("english_name", arg0.nameTF), var0.english_name)
	setText(arg0.nameEnTF, string.upper(var0.english_name))

	local var1 = Ship.New({
		configId = arg0.contextData.configId
	}):getPrefab()

	if var1 == arg0.shipPrefab then
		return
	end

	arg0:recycleSpineChar()
	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var1, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.shipPrefab = var1
		arg0.shipModel = arg0

		arg0:GetComponent("SpineAnimUI"):SetAction("stand", 0)

		tf(arg0).localScale = Vector3(0.5, 0.5, 1)
		tf(arg0).localPosition = Vector3(15, -95, 0)

		pg.ViewUtils.SetLayer(tf(arg0), Layer.UI)
		removeAllChildren(arg0.qChar)
		SetParent(arg0, arg0.qChar, false)
	end)
end

function var0.initSkills(arg0)
	local var0 = pg.ship_data_template[arg0.contextData.configId]

	removeAllChildren(arg0.skillContainer)

	for iter0, iter1 in ipairs(var0.buff_list_display) do
		local var1 = getSkillConfig(iter1)
		local var2 = table.contains(var0.buff_list, iter1)
		local var3 = cloneTplTo(arg0.skillTpl, arg0.skillContainer)

		setActive(var3:Find("mask"), not var2)
		onButton(arg0, var3, function()
			arg0:emit(NewPlayerMediator.ON_SKILLINFO, var1.id)
		end, SFX_PANEL)
		LoadImageSpriteAsync("skillicon/" .. var1.icon, findTF(var3, "icon"))
	end
end

function var0.showNamedPanel(arg0)
	arg0.qChar:SetParent(arg0.info)
	pg.UIMgr.GetInstance():BlurPanel(arg0.namedPanel)
	setActive(arg0.namedPanel, true)
	setInputText(arg0.nickname, "")
	setText(arg0.chat, var7[arg0.contextData.configId])
end

function var0.closeNamedPanel(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.namedPanel, arg0._tf)
	setActive(arg0.namedPanel, false)
	arg0.qChar:SetParent(arg0.propPanel)
end

function var0.recycleSpineChar(arg0)
	if arg0.shipPrefab and arg0.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.shipPrefab, arg0.shipModel)

		arg0.shipPrefab = nil
		arg0.shipModel = nil
	end
end

function var0.willExit(arg0)
	if arg0.eventTriggers then
		for iter0, iter1 in pairs(arg0.eventTriggers) do
			ClearEventTrigger(iter0)
		end

		arg0.eventTriggers = nil
	end

	arg0:closeNamedPanel()
end

return var0
