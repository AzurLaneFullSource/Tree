local var0 = class("TerminalPersonalPage", import("view.base.BaseSubView"))
local var1 = "otherworld_personal_name"

var0.BIND_EVENT_ACT_ID = ActivityConst.OTHER_WORLD_TERMINAL_EVENT_ID
var0.config = pg.roll_attr
var0.NAME_ID = 1001
var0.LV_ID = 1002
var0.JOB_ID = 1003
var0.GUARDIAN_ID = 1004

local function var2(arg0)
	local var0 = {}

	for iter0 = arg0[1], arg0[2] do
		if var0.config[iter0] then
			table.insert(var0, iter0)
		end
	end

	return var0
end

var0.PROPERTY_IDS = var2({
	2001,
	2006
})
var0.ABILITY_IDS = var2({
	3000,
	3193
})
var0.RANDOM_ABILITY_CNT = 8

function var0.getUIName(arg0)
	return "TerminalPersonalPage"
end

function var0.OnLoaded(arg0)
	arg0._tf.name = tostring(OtherworldTerminalLayer.PAGE_PERSONAL)
	arg0.infoTF = arg0:findTF("frame/info")

	setText(arg0:findTF("title/content/Text", arg0.infoTF), i18n("personal_info_title"))

	arg0.nameTitle = arg0:findTF("infos/name/title", arg0.infoTF)
	arg0.nameInput = arg0:findTF("infos/name/box/InputField", arg0.infoTF)
	arg0.jobTitle = arg0:findTF("infos/job/title", arg0.infoTF)
	arg0.jobValue = arg0:findTF("infos/job/value", arg0.infoTF)
	arg0.guardianTitle = arg0:findTF("infos/guardian/title", arg0.infoTF)
	arg0.guardianValue = arg0:findTF("infos/guardian/value", arg0.infoTF)
	arg0.lvTitle = arg0:findTF("level/lv/title", arg0.infoTF)
	arg0.lvValue = arg0:findTF("level/lv/value", arg0.infoTF)
	arg0.lvSlider = arg0:findTF("level/slider", arg0.infoTF)
	arg0.lvUpgradeTF = arg0:findTF("level/slider/upgrade", arg0.infoTF)

	setActive(arg0.lvUpgradeTF, false)

	arg0.propertyTF = arg0:findTF("frame/property")

	setText(arg0:findTF("title/content/Text", arg0.propertyTF), i18n("personal_property_title"))

	arg0.propertyContent = arg0:findTF("content", arg0.propertyTF)
	arg0.propertyTpl = arg0:findTF("tpl", arg0.propertyTF)

	setActive(arg0.propertyTpl, false)
	setActive(arg0:findTF("upgrade", arg0.propertyTpl), false)

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_CHT then
		arg0.abilityTF = arg0:findTF("frame/ability")

		setActive(arg0:findTF("frame/ability_2"), false)
	else
		arg0.abilityTF = arg0:findTF("frame/ability_2")

		setActive(arg0:findTF("frame/ability"), false)
	end

	setActive(arg0.abilityTF, true)
	setText(arg0:findTF("title/content/Text", arg0.abilityTF), i18n("personal_ability_title"))

	arg0.abilityContent = arg0:findTF("content", arg0.abilityTF)
	arg0.abilityTpl = arg0:findTF("tpl", arg0.abilityTF)

	setActive(arg0.abilityTpl, false)

	arg0.randomBtn = arg0:findTF("frame/random_btn")

	setText(arg0:findTF("Text", arg0.randomBtn), i18n("personal_random"))

	arg0.randomGreyBtn = arg0:findTF("frame/random_btn_grey")

	setText(arg0:findTF("Text", arg0.randomGreyBtn), i18n("personal_random"))

	arg0.effectTF = arg0:findTF("effect")

	setActive(arg0.effectTF, false)

	arg0.playerId = getProxy(PlayerProxy):getRawData().id
	arg0.showName = getProxy(PlayerProxy):getRawData().name
end

function var0.OnInit(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityById(var0.BIND_EVENT_ACT_ID)

	assert(arg0.activity, "not exist bind event act, id" .. var0.BIND_EVENT_ACT_ID)
	arg0.nameInput:GetComponent(typeof(InputField)).onValueChanged:AddListener(function()
		if not arg0.unlockRandom or not nameValidityCheck(getInputText(arg0.nameInput), 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			arg0:SetDefaultName()
		else
			arg0.showName = getInputText(arg0.nameInput)

			setInputText(arg0.nameInput, arg0.showName)
			arg0:SetLocalName(arg0.showName)
		end
	end)
	onButton(arg0, arg0.randomBtn, function()
		setActive(arg0.effectTF, false)
		setActive(arg0.effectTF, true)
		setActive(arg0.randomBtn, false)
		setActive(arg0.randomGreyBtn, false)
		arg0:managedTween(LeanTween.delayedCall, function()
			OtherworldMapScene.personalRandomData = {}

			arg0:UpdateView(true)
			setActive(arg0.effectTF, false)
			setActive(arg0.randomBtn, arg0.unlockRandom)
			setActive(arg0.randomGreyBtn, not arg0.unlockRandom)
		end, var0.RANDOM_CHANGE_TIME, nil)
	end, SFX_PANEL)
	onButton(arg0, arg0.randomGreyBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("personal_random_tip"))
	end, SFX_PANEL)

	arg0.unlockRandom = arg0.activity:IsFinishAllMain()

	setActive(arg0.randomBtn, arg0.unlockRandom)
	setActive(arg0.randomGreyBtn, not arg0.unlockRandom)
	setActive(arg0:findTF("infos/name/box/edit", arg0.infoTF), arg0.unlockRandom)

	if arg0.unlockRandom and arg0:GetLocalName() ~= "" then
		arg0.showName = arg0:GetLocalName()
	end

	arg0.nameInput:GetComponent(typeof(InputField)).interactable = arg0.unlockRandom

	arg0:UpdateView()
end

function var0.UpdateView(arg0, arg1)
	local var0 = arg0.contextData.upgrade and arg0.activity:GetLastShowConfig() or arg0.activity:GetShowConfig()

	arg0.showCfg = {}

	for iter0, iter1 in ipairs(var0) do
		arg0.showCfg[iter1[1]] = iter1[2]
	end

	arg0:UpdateInfo(arg1)
	arg0:UpdateProperty(arg1)
	arg0:UpdateAbility(arg1)

	if arg0.contextData.upgrade then
		arg0.upgradeCfg = {}

		for iter2, iter3 in ipairs(arg0.activity:GetShowConfig()) do
			arg0.upgradeCfg[iter3[1]] = iter3[2]
		end

		arg0:PlayUpgradeAnims()
	end
end

function var0.SetDefaultName(arg0)
	setInputText(arg0.nameInput, arg0.showName)
end

function var0.UpdateInfo(arg0, arg1)
	arg0:SetDefaultName()

	local var0 = arg0:GetRollAttrInfoById(var0.NAME_ID, arg1)

	setText(arg0.nameTitle, var0 .. "：")

	local var1, var2 = arg0:GetRollAttrInfoById(var0.JOB_ID, arg1)

	setText(arg0.jobTitle, var1 .. "：")
	setText(arg0.jobValue, var2)

	local var3, var4 = arg0:GetRollAttrInfoById(var0.GUARDIAN_ID, arg1)

	setText(arg0.guardianTitle, var3 .. "：")
	setText(arg0.guardianValue, var4)

	local var5, var6 = arg0:GetRollAttrInfoById(var0.LV_ID, arg1)

	setText(arg0.lvTitle, var5 .. "：")
	setText(arg0.lvValue, var6)
	setSlider(arg0.lvSlider, 0, 1, tonumber(var6) / var0.config[var0.LV_ID].random_value[2])

	if arg1 then
		OtherworldMapScene.personalRandomData[var0.JOB_ID] = var2
		OtherworldMapScene.personalRandomData[var0.GUARDIAN_ID] = var4
		OtherworldMapScene.personalRandomData[var0.LV_ID] = var6
	end
end

function var0.UpdateProperty(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(var0.PROPERTY_IDS) do
		var0 = var0 + 1

		local var1 = var0 > arg0.propertyContent.childCount and cloneTplTo(arg0.propertyTpl, arg0.propertyContent) or arg0.propertyContent:GetChild(var0 - 1)

		var1.name = iter1

		local var2, var3 = arg0:GetRollAttrInfoById(iter1, arg1)

		setText(arg0:findTF("name", var1), var2)
		setText(arg0:findTF("value/Text", var1), var3)

		if arg1 then
			OtherworldMapScene.personalRandomData[iter1] = var3
		end
	end

	for iter2 = 1, arg0.propertyContent.childCount - 1 do
		if var0 < iter2 then
			setActive(arg0.propertyContent:GetChild(iter2 - 1), false)
		end
	end
end

function var0.UpdateAbility(arg0, arg1)
	local var0 = {}

	if arg1 then
		var0 = arg0:GetRandomAbilityIds()
	elseif OtherworldMapScene.personalRandomData then
		for iter0, iter1 in pairs(OtherworldMapScene.personalRandomData) do
			if table.contains(var0.ABILITY_IDS, iter0) then
				table.insert(var0, iter0)
			end
		end
	else
		for iter2, iter3 in pairs(arg0.showCfg) do
			if table.contains(var0.ABILITY_IDS, iter2) then
				table.insert(var0, iter2)
			end
		end
	end

	table.sort(var0)

	for iter4, iter5 in ipairs(var0) do
		local var1 = iter4 > arg0.abilityContent.childCount and cloneTplTo(arg0.abilityTpl, arg0.abilityContent) or arg0.abilityContent:GetChild(iter4 - 1)

		var1.name = iter4

		local var2, var3 = arg0:GetRollAttrInfoById(iter5, arg1)

		setText(arg0:findTF("name", var1), var2)
		setText(arg0:findTF("value/Text", var1), var3)

		if arg1 then
			OtherworldMapScene.personalRandomData[iter5] = var3
		end
	end

	for iter6 = 1, arg0.abilityContent.childCount do
		if iter6 > #var0 then
			setActive(arg0.abilityContent:GetChild(iter6 - 1), false)
		end
	end
end

function var0.GetRollAttrInfoById(arg0, arg1, arg2)
	local var0 = ""

	if arg2 then
		local var1 = var0.config[arg1].random_value

		if table.contains(var0.PROPERTY_IDS, arg1) or arg1 == var0.LV_ID then
			var0 = math.random(var1[1], var1[2])
		else
			var0 = var1[math.random(#var1)]
		end
	else
		var0 = arg0.showCfg[arg1] or var0.config[arg1].default_value

		if OtherworldMapScene.personalRandomData then
			var0 = OtherworldMapScene.personalRandomData[arg1]
		end
	end

	return var0.config[arg1].name, tostring(var0)
end

function var0.GetRandomAbilityIds(arg0)
	local var0 = {}

	for iter0 = 1, #var0.ABILITY_IDS do
		table.insert(var0, iter0)
	end

	shuffle(var0)

	local var1 = {}

	for iter1 = 1, var0.RANDOM_ABILITY_CNT do
		table.insert(var1, var0.ABILITY_IDS[var0[iter1]])
	end

	return var1
end

var0.UPGRADE_TAG_SHOW_TIME = 2
var0.LV_ANIM_TIME = 0.5
var0.PROPERTY_TPL_ANIM_TIME = 0.5
var0.ABILITY_TPL_ANIM_TIME = 0.5
var0.RANDOM_CHANGE_TIME = 0.8

function var0.PlayUpgradeAnims(arg0)
	seriesAsync({
		function(arg0)
			arg0:PlayLevelAnim(arg0)
		end,
		function(arg0)
			arg0:PlayPropertyAnim(arg0)
		end,
		function(arg0)
			arg0:PlayAbilityAnim(arg0)
		end
	}, function()
		arg0.contextData.upgrade = nil
	end)
end

function var0.GetStaticInfo(arg0, arg1)
	local var0 = tonumber(arg0.showCfg[arg1] or var0.config[arg1].default_value)
	local var1 = tonumber(arg0.upgradeCfg[arg1] or var0)

	return var0, var1, var1 - var0 ~= 0
end

function var0.PlayLevelAnim(arg0, arg1)
	local var0, var1, var2 = arg0:GetStaticInfo(var0.LV_ID)

	setActive(arg0.lvUpgradeTF, var2)

	if var2 then
		arg0:managedTween(LeanTween.delayedCall, function()
			setActive(arg0.lvUpgradeTF, false)
		end, var0.UPGRADE_TAG_SHOW_TIME, nil)
		arg0:managedTween(LeanTween.value, nil, go(arg0.lvValue), var0, var1, var0.LV_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0)
			setText(arg0.lvValue, math.floor(arg0))
		end)):setOnComplete(System.Action(function()
			arg1()
		end))

		local var3 = var0.config[var0.LV_ID].random_value[2]

		arg0:managedTween(LeanTween.value, nil, go(arg0.lvSlider), var0 / var3, var1 / var3, var0.LV_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0)
			setSlider(arg0.lvSlider, 0, 1, arg0)
		end))
	else
		arg1()
	end
end

function var0.PlayPropertyAnim(arg0, arg1)
	local var0 = {}

	for iter0 = 1, #var0.PROPERTY_IDS do
		local var1 = iter0 > arg0.propertyContent.childCount
		local var2 = var1 and cloneTplTo(arg0.propertyTpl, arg0.propertyContent) or arg0.propertyContent:GetChild(iter0 - 1)
		local var3 = var0.PROPERTY_IDS[iter0]
		local var4, var5, var6 = arg0:GetStaticInfo(var3)

		if var1 then
			setText(arg0:findTF("name", var2), var0.config[var3].name)
			setText(arg0:findTF("value/Text", var2), var4)
		end

		if var6 then
			table.insert(var0, function(arg0)
				setActive(arg0:findTF("upgrade", var2), var6)
				arg0:managedTween(LeanTween.delayedCall, function()
					setActive(arg0:findTF("upgrade", var2), false)
				end, var0.UPGRADE_TAG_SHOW_TIME, nil)
				arg0:managedTween(LeanTween.value, nil, go(var2), var4, var5, var0.PROPERTY_TPL_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0)
					setText(arg0:findTF("value/Text", var2), math.floor(arg0))
				end)):setOnComplete(System.Action(function()
					arg0()
				end))
			end)
		end
	end

	seriesAsync(var0, function()
		arg1()
	end)
end

function var0.GetDynamicInfo(arg0, arg1)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in pairs(arg0.showCfg) do
		if table.contains(var0.ABILITY_IDS, iter0) then
			table.insert(var0, iter0)
		end
	end

	table.sort(var0)

	for iter2, iter3 in pairs(arg0.upgradeCfg) do
		if table.contains(var0.ABILITY_IDS, iter2) then
			table.insert(var1, iter2)
		end
	end

	table.sort(var1)

	local var2 = #var0 ~= #var1 or underscore.any(var1, function(arg0)
		return not table.contains(var0, arg0)
	end)

	return var0, var1, var2
end

function var0.PlayAbilityAnim(arg0, arg1)
	local var0, var1, var2 = arg0:GetDynamicInfo()

	if var2 then
		local var3 = {}

		for iter0 = 1, #var1 do
			local var4 = iter0 > #var0
			local var5 = var1[iter0]
			local var6 = var4 and cloneTplTo(arg0.abilityTpl, arg0.abilityContent) or arg0.abilityContent:GetChild(iter0 - 1)

			GetOrAddComponent(var6, typeof(CanvasGroup)).alpha = var4 and 0 or 1

			if var0[iter0] ~= var5 then
				if not var4 then
					table.insert(var3, function(arg0)
						arg0:managedTween(LeanTween.value, nil, go(var6), 1, 0, var0.ABILITY_TPL_ANIM_TIME):setEase(LeanTweenType.easeInBack):setOnUpdate(System.Action_float(function(arg0)
							GetOrAddComponent(var6, typeof(CanvasGroup)).alpha = arg0
						end)):setOnComplete(System.Action(function()
							setText(arg0:findTF("name", var6), var0.config[var5].name)
							setText(arg0:findTF("value/Text", var6), arg0.upgradeCfg[var5])
							arg0()
						end))
					end)
				end

				table.insert(var3, function(arg0)
					if var4 then
						setText(arg0:findTF("name", var6), var0.config[var5].name)
						setText(arg0:findTF("value/Text", var6), arg0.upgradeCfg[var5])
					end

					arg0:managedTween(LeanTween.value, nil, go(var6), 0, 1, var0.ABILITY_TPL_ANIM_TIME):setEase(LeanTweenType.easeOutBack):setOnUpdate(System.Action_float(function(arg0)
						GetOrAddComponent(var6, typeof(CanvasGroup)).alpha = arg0
					end)):setOnComplete(System.Action(function()
						arg0()
					end))
				end)
			end
		end

		seriesAsync(var3, function()
			arg1()
		end)
	else
		arg1()
	end
end

function var0.GetLocalName(arg0)
	if not arg0.unlockRandom then
		return ""
	end

	return PlayerPrefs.GetString(var1 .. arg0.playerId)
end

function var0.SetLocalName(arg0, arg1)
	if not arg0.unlockRandom then
		return
	end

	PlayerPrefs.SetString(var1 .. arg0.playerId, arg1)
	PlayerPrefs.Save()
end

function var0.OnDestroy(arg0)
	arg0:cleanManagedTween()
end

return var0
