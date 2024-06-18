local var0_0 = class("TerminalPersonalPage", import("view.base.BaseSubView"))
local var1_0 = "otherworld_personal_name"

var0_0.BIND_EVENT_ACT_ID = ActivityConst.OTHER_WORLD_TERMINAL_EVENT_ID
var0_0.config = pg.roll_attr
var0_0.NAME_ID = 1001
var0_0.LV_ID = 1002
var0_0.JOB_ID = 1003
var0_0.GUARDIAN_ID = 1004

local function var2_0(arg0_1)
	local var0_1 = {}

	for iter0_1 = arg0_1[1], arg0_1[2] do
		if var0_0.config[iter0_1] then
			table.insert(var0_1, iter0_1)
		end
	end

	return var0_1
end

var0_0.PROPERTY_IDS = var2_0({
	2001,
	2006
})
var0_0.ABILITY_IDS = var2_0({
	3000,
	3193
})
var0_0.RANDOM_ABILITY_CNT = 8

function var0_0.getUIName(arg0_2)
	return "TerminalPersonalPage"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3._tf.name = tostring(OtherworldTerminalLayer.PAGE_PERSONAL)
	arg0_3.infoTF = arg0_3:findTF("frame/info")

	setText(arg0_3:findTF("title/content/Text", arg0_3.infoTF), i18n("personal_info_title"))

	arg0_3.nameTitle = arg0_3:findTF("infos/name/title", arg0_3.infoTF)
	arg0_3.nameInput = arg0_3:findTF("infos/name/box/InputField", arg0_3.infoTF)
	arg0_3.jobTitle = arg0_3:findTF("infos/job/title", arg0_3.infoTF)
	arg0_3.jobValue = arg0_3:findTF("infos/job/value", arg0_3.infoTF)
	arg0_3.guardianTitle = arg0_3:findTF("infos/guardian/title", arg0_3.infoTF)
	arg0_3.guardianValue = arg0_3:findTF("infos/guardian/value", arg0_3.infoTF)
	arg0_3.lvTitle = arg0_3:findTF("level/lv/title", arg0_3.infoTF)
	arg0_3.lvValue = arg0_3:findTF("level/lv/value", arg0_3.infoTF)
	arg0_3.lvSlider = arg0_3:findTF("level/slider", arg0_3.infoTF)
	arg0_3.lvUpgradeTF = arg0_3:findTF("level/slider/upgrade", arg0_3.infoTF)

	setActive(arg0_3.lvUpgradeTF, false)

	arg0_3.propertyTF = arg0_3:findTF("frame/property")

	setText(arg0_3:findTF("title/content/Text", arg0_3.propertyTF), i18n("personal_property_title"))

	arg0_3.propertyContent = arg0_3:findTF("content", arg0_3.propertyTF)
	arg0_3.propertyTpl = arg0_3:findTF("tpl", arg0_3.propertyTF)

	setActive(arg0_3.propertyTpl, false)
	setActive(arg0_3:findTF("upgrade", arg0_3.propertyTpl), false)

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_CHT then
		arg0_3.abilityTF = arg0_3:findTF("frame/ability")

		setActive(arg0_3:findTF("frame/ability_2"), false)
	else
		arg0_3.abilityTF = arg0_3:findTF("frame/ability_2")

		setActive(arg0_3:findTF("frame/ability"), false)
	end

	setActive(arg0_3.abilityTF, true)
	setText(arg0_3:findTF("title/content/Text", arg0_3.abilityTF), i18n("personal_ability_title"))

	arg0_3.abilityContent = arg0_3:findTF("content", arg0_3.abilityTF)
	arg0_3.abilityTpl = arg0_3:findTF("tpl", arg0_3.abilityTF)

	setActive(arg0_3.abilityTpl, false)

	arg0_3.randomBtn = arg0_3:findTF("frame/random_btn")

	setText(arg0_3:findTF("Text", arg0_3.randomBtn), i18n("personal_random"))

	arg0_3.randomGreyBtn = arg0_3:findTF("frame/random_btn_grey")

	setText(arg0_3:findTF("Text", arg0_3.randomGreyBtn), i18n("personal_random"))

	arg0_3.effectTF = arg0_3:findTF("effect")

	setActive(arg0_3.effectTF, false)

	arg0_3.playerId = getProxy(PlayerProxy):getRawData().id
	arg0_3.showName = getProxy(PlayerProxy):getRawData().name
end

function var0_0.OnInit(arg0_4)
	arg0_4.activity = getProxy(ActivityProxy):getActivityById(var0_0.BIND_EVENT_ACT_ID)

	assert(arg0_4.activity, "not exist bind event act, id" .. var0_0.BIND_EVENT_ACT_ID)
	arg0_4.nameInput:GetComponent(typeof(InputField)).onValueChanged:AddListener(function()
		if not arg0_4.unlockRandom or not nameValidityCheck(getInputText(arg0_4.nameInput), 4, 14, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"login_newPlayerScene_invalideName"
		}) then
			arg0_4:SetDefaultName()
		else
			arg0_4.showName = getInputText(arg0_4.nameInput)

			setInputText(arg0_4.nameInput, arg0_4.showName)
			arg0_4:SetLocalName(arg0_4.showName)
		end
	end)
	onButton(arg0_4, arg0_4.randomBtn, function()
		setActive(arg0_4.effectTF, false)
		setActive(arg0_4.effectTF, true)
		setActive(arg0_4.randomBtn, false)
		setActive(arg0_4.randomGreyBtn, false)
		arg0_4:managedTween(LeanTween.delayedCall, function()
			OtherworldMapScene.personalRandomData = {}

			arg0_4:UpdateView(true)
			setActive(arg0_4.effectTF, false)
			setActive(arg0_4.randomBtn, arg0_4.unlockRandom)
			setActive(arg0_4.randomGreyBtn, not arg0_4.unlockRandom)
		end, var0_0.RANDOM_CHANGE_TIME, nil)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.randomGreyBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("personal_random_tip"))
	end, SFX_PANEL)

	arg0_4.unlockRandom = arg0_4.activity:IsFinishAllMain()

	setActive(arg0_4.randomBtn, arg0_4.unlockRandom)
	setActive(arg0_4.randomGreyBtn, not arg0_4.unlockRandom)
	setActive(arg0_4:findTF("infos/name/box/edit", arg0_4.infoTF), arg0_4.unlockRandom)

	if arg0_4.unlockRandom and arg0_4:GetLocalName() ~= "" then
		arg0_4.showName = arg0_4:GetLocalName()
	end

	arg0_4.nameInput:GetComponent(typeof(InputField)).interactable = arg0_4.unlockRandom

	arg0_4:UpdateView()
end

function var0_0.UpdateView(arg0_9, arg1_9)
	local var0_9 = arg0_9.contextData.upgrade and arg0_9.activity:GetLastShowConfig() or arg0_9.activity:GetShowConfig()

	arg0_9.showCfg = {}

	for iter0_9, iter1_9 in ipairs(var0_9) do
		arg0_9.showCfg[iter1_9[1]] = iter1_9[2]
	end

	arg0_9:UpdateInfo(arg1_9)
	arg0_9:UpdateProperty(arg1_9)
	arg0_9:UpdateAbility(arg1_9)

	if arg0_9.contextData.upgrade then
		arg0_9.upgradeCfg = {}

		for iter2_9, iter3_9 in ipairs(arg0_9.activity:GetShowConfig()) do
			arg0_9.upgradeCfg[iter3_9[1]] = iter3_9[2]
		end

		arg0_9:PlayUpgradeAnims()
	end
end

function var0_0.SetDefaultName(arg0_10)
	setInputText(arg0_10.nameInput, arg0_10.showName)
end

function var0_0.UpdateInfo(arg0_11, arg1_11)
	arg0_11:SetDefaultName()

	local var0_11 = arg0_11:GetRollAttrInfoById(var0_0.NAME_ID, arg1_11)

	setText(arg0_11.nameTitle, var0_11 .. "：")

	local var1_11, var2_11 = arg0_11:GetRollAttrInfoById(var0_0.JOB_ID, arg1_11)

	setText(arg0_11.jobTitle, var1_11 .. "：")
	setText(arg0_11.jobValue, var2_11)

	local var3_11, var4_11 = arg0_11:GetRollAttrInfoById(var0_0.GUARDIAN_ID, arg1_11)

	setText(arg0_11.guardianTitle, var3_11 .. "：")
	setText(arg0_11.guardianValue, var4_11)

	local var5_11, var6_11 = arg0_11:GetRollAttrInfoById(var0_0.LV_ID, arg1_11)

	setText(arg0_11.lvTitle, var5_11 .. "：")
	setText(arg0_11.lvValue, var6_11)
	setSlider(arg0_11.lvSlider, 0, 1, tonumber(var6_11) / var0_0.config[var0_0.LV_ID].random_value[2])

	if arg1_11 then
		OtherworldMapScene.personalRandomData[var0_0.JOB_ID] = var2_11
		OtherworldMapScene.personalRandomData[var0_0.GUARDIAN_ID] = var4_11
		OtherworldMapScene.personalRandomData[var0_0.LV_ID] = var6_11
	end
end

function var0_0.UpdateProperty(arg0_12, arg1_12)
	local var0_12 = 0

	for iter0_12, iter1_12 in ipairs(var0_0.PROPERTY_IDS) do
		var0_12 = var0_12 + 1

		local var1_12 = var0_12 > arg0_12.propertyContent.childCount and cloneTplTo(arg0_12.propertyTpl, arg0_12.propertyContent) or arg0_12.propertyContent:GetChild(var0_12 - 1)

		var1_12.name = iter1_12

		local var2_12, var3_12 = arg0_12:GetRollAttrInfoById(iter1_12, arg1_12)

		setText(arg0_12:findTF("name", var1_12), var2_12)
		setText(arg0_12:findTF("value/Text", var1_12), var3_12)

		if arg1_12 then
			OtherworldMapScene.personalRandomData[iter1_12] = var3_12
		end
	end

	for iter2_12 = 1, arg0_12.propertyContent.childCount - 1 do
		if var0_12 < iter2_12 then
			setActive(arg0_12.propertyContent:GetChild(iter2_12 - 1), false)
		end
	end
end

function var0_0.UpdateAbility(arg0_13, arg1_13)
	local var0_13 = {}

	if arg1_13 then
		var0_13 = arg0_13:GetRandomAbilityIds()
	elseif OtherworldMapScene.personalRandomData then
		for iter0_13, iter1_13 in pairs(OtherworldMapScene.personalRandomData) do
			if table.contains(var0_0.ABILITY_IDS, iter0_13) then
				table.insert(var0_13, iter0_13)
			end
		end
	else
		for iter2_13, iter3_13 in pairs(arg0_13.showCfg) do
			if table.contains(var0_0.ABILITY_IDS, iter2_13) then
				table.insert(var0_13, iter2_13)
			end
		end
	end

	table.sort(var0_13)

	for iter4_13, iter5_13 in ipairs(var0_13) do
		local var1_13 = iter4_13 > arg0_13.abilityContent.childCount and cloneTplTo(arg0_13.abilityTpl, arg0_13.abilityContent) or arg0_13.abilityContent:GetChild(iter4_13 - 1)

		var1_13.name = iter4_13

		local var2_13, var3_13 = arg0_13:GetRollAttrInfoById(iter5_13, arg1_13)

		setText(arg0_13:findTF("name", var1_13), var2_13)
		setText(arg0_13:findTF("value/Text", var1_13), var3_13)

		if arg1_13 then
			OtherworldMapScene.personalRandomData[iter5_13] = var3_13
		end
	end

	for iter6_13 = 1, arg0_13.abilityContent.childCount do
		if iter6_13 > #var0_13 then
			setActive(arg0_13.abilityContent:GetChild(iter6_13 - 1), false)
		end
	end
end

function var0_0.GetRollAttrInfoById(arg0_14, arg1_14, arg2_14)
	local var0_14 = ""

	if arg2_14 then
		local var1_14 = var0_0.config[arg1_14].random_value

		if table.contains(var0_0.PROPERTY_IDS, arg1_14) or arg1_14 == var0_0.LV_ID then
			var0_14 = math.random(var1_14[1], var1_14[2])
		else
			var0_14 = var1_14[math.random(#var1_14)]
		end
	else
		var0_14 = arg0_14.showCfg[arg1_14] or var0_0.config[arg1_14].default_value

		if OtherworldMapScene.personalRandomData then
			var0_14 = OtherworldMapScene.personalRandomData[arg1_14]
		end
	end

	return var0_0.config[arg1_14].name, tostring(var0_14)
end

function var0_0.GetRandomAbilityIds(arg0_15)
	local var0_15 = {}

	for iter0_15 = 1, #var0_0.ABILITY_IDS do
		table.insert(var0_15, iter0_15)
	end

	shuffle(var0_15)

	local var1_15 = {}

	for iter1_15 = 1, var0_0.RANDOM_ABILITY_CNT do
		table.insert(var1_15, var0_0.ABILITY_IDS[var0_15[iter1_15]])
	end

	return var1_15
end

var0_0.UPGRADE_TAG_SHOW_TIME = 2
var0_0.LV_ANIM_TIME = 0.5
var0_0.PROPERTY_TPL_ANIM_TIME = 0.5
var0_0.ABILITY_TPL_ANIM_TIME = 0.5
var0_0.RANDOM_CHANGE_TIME = 0.8

function var0_0.PlayUpgradeAnims(arg0_16)
	seriesAsync({
		function(arg0_17)
			arg0_16:PlayLevelAnim(arg0_17)
		end,
		function(arg0_18)
			arg0_16:PlayPropertyAnim(arg0_18)
		end,
		function(arg0_19)
			arg0_16:PlayAbilityAnim(arg0_19)
		end
	}, function()
		arg0_16.contextData.upgrade = nil
	end)
end

function var0_0.GetStaticInfo(arg0_21, arg1_21)
	local var0_21 = tonumber(arg0_21.showCfg[arg1_21] or var0_0.config[arg1_21].default_value)
	local var1_21 = tonumber(arg0_21.upgradeCfg[arg1_21] or var0_21)

	return var0_21, var1_21, var1_21 - var0_21 ~= 0
end

function var0_0.PlayLevelAnim(arg0_22, arg1_22)
	local var0_22, var1_22, var2_22 = arg0_22:GetStaticInfo(var0_0.LV_ID)

	setActive(arg0_22.lvUpgradeTF, var2_22)

	if var2_22 then
		arg0_22:managedTween(LeanTween.delayedCall, function()
			setActive(arg0_22.lvUpgradeTF, false)
		end, var0_0.UPGRADE_TAG_SHOW_TIME, nil)
		arg0_22:managedTween(LeanTween.value, nil, go(arg0_22.lvValue), var0_22, var1_22, var0_0.LV_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0_24)
			setText(arg0_22.lvValue, math.floor(arg0_24))
		end)):setOnComplete(System.Action(function()
			arg1_22()
		end))

		local var3_22 = var0_0.config[var0_0.LV_ID].random_value[2]

		arg0_22:managedTween(LeanTween.value, nil, go(arg0_22.lvSlider), var0_22 / var3_22, var1_22 / var3_22, var0_0.LV_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0_26)
			setSlider(arg0_22.lvSlider, 0, 1, arg0_26)
		end))
	else
		arg1_22()
	end
end

function var0_0.PlayPropertyAnim(arg0_27, arg1_27)
	local var0_27 = {}

	for iter0_27 = 1, #var0_0.PROPERTY_IDS do
		local var1_27 = iter0_27 > arg0_27.propertyContent.childCount
		local var2_27 = var1_27 and cloneTplTo(arg0_27.propertyTpl, arg0_27.propertyContent) or arg0_27.propertyContent:GetChild(iter0_27 - 1)
		local var3_27 = var0_0.PROPERTY_IDS[iter0_27]
		local var4_27, var5_27, var6_27 = arg0_27:GetStaticInfo(var3_27)

		if var1_27 then
			setText(arg0_27:findTF("name", var2_27), var0_0.config[var3_27].name)
			setText(arg0_27:findTF("value/Text", var2_27), var4_27)
		end

		if var6_27 then
			table.insert(var0_27, function(arg0_28)
				setActive(arg0_27:findTF("upgrade", var2_27), var6_27)
				arg0_27:managedTween(LeanTween.delayedCall, function()
					setActive(arg0_27:findTF("upgrade", var2_27), false)
				end, var0_0.UPGRADE_TAG_SHOW_TIME, nil)
				arg0_27:managedTween(LeanTween.value, nil, go(var2_27), var4_27, var5_27, var0_0.PROPERTY_TPL_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0_30)
					setText(arg0_27:findTF("value/Text", var2_27), math.floor(arg0_30))
				end)):setOnComplete(System.Action(function()
					arg0_28()
				end))
			end)
		end
	end

	seriesAsync(var0_27, function()
		arg1_27()
	end)
end

function var0_0.GetDynamicInfo(arg0_33, arg1_33)
	local var0_33 = {}
	local var1_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33.showCfg) do
		if table.contains(var0_0.ABILITY_IDS, iter0_33) then
			table.insert(var0_33, iter0_33)
		end
	end

	table.sort(var0_33)

	for iter2_33, iter3_33 in pairs(arg0_33.upgradeCfg) do
		if table.contains(var0_0.ABILITY_IDS, iter2_33) then
			table.insert(var1_33, iter2_33)
		end
	end

	table.sort(var1_33)

	local var2_33 = #var0_33 ~= #var1_33 or underscore.any(var1_33, function(arg0_34)
		return not table.contains(var0_33, arg0_34)
	end)

	return var0_33, var1_33, var2_33
end

function var0_0.PlayAbilityAnim(arg0_35, arg1_35)
	local var0_35, var1_35, var2_35 = arg0_35:GetDynamicInfo()

	if var2_35 then
		local var3_35 = {}

		for iter0_35 = 1, #var1_35 do
			local var4_35 = iter0_35 > #var0_35
			local var5_35 = var1_35[iter0_35]
			local var6_35 = var4_35 and cloneTplTo(arg0_35.abilityTpl, arg0_35.abilityContent) or arg0_35.abilityContent:GetChild(iter0_35 - 1)

			GetOrAddComponent(var6_35, typeof(CanvasGroup)).alpha = var4_35 and 0 or 1

			if var0_35[iter0_35] ~= var5_35 then
				if not var4_35 then
					table.insert(var3_35, function(arg0_36)
						arg0_35:managedTween(LeanTween.value, nil, go(var6_35), 1, 0, var0_0.ABILITY_TPL_ANIM_TIME):setEase(LeanTweenType.easeInBack):setOnUpdate(System.Action_float(function(arg0_37)
							GetOrAddComponent(var6_35, typeof(CanvasGroup)).alpha = arg0_37
						end)):setOnComplete(System.Action(function()
							setText(arg0_35:findTF("name", var6_35), var0_0.config[var5_35].name)
							setText(arg0_35:findTF("value/Text", var6_35), arg0_35.upgradeCfg[var5_35])
							arg0_36()
						end))
					end)
				end

				table.insert(var3_35, function(arg0_39)
					if var4_35 then
						setText(arg0_35:findTF("name", var6_35), var0_0.config[var5_35].name)
						setText(arg0_35:findTF("value/Text", var6_35), arg0_35.upgradeCfg[var5_35])
					end

					arg0_35:managedTween(LeanTween.value, nil, go(var6_35), 0, 1, var0_0.ABILITY_TPL_ANIM_TIME):setEase(LeanTweenType.easeOutBack):setOnUpdate(System.Action_float(function(arg0_40)
						GetOrAddComponent(var6_35, typeof(CanvasGroup)).alpha = arg0_40
					end)):setOnComplete(System.Action(function()
						arg0_39()
					end))
				end)
			end
		end

		seriesAsync(var3_35, function()
			arg1_35()
		end)
	else
		arg1_35()
	end
end

function var0_0.GetLocalName(arg0_43)
	if not arg0_43.unlockRandom then
		return ""
	end

	return PlayerPrefs.GetString(var1_0 .. arg0_43.playerId)
end

function var0_0.SetLocalName(arg0_44, arg1_44)
	if not arg0_44.unlockRandom then
		return
	end

	PlayerPrefs.SetString(var1_0 .. arg0_44.playerId, arg1_44)
	PlayerPrefs.Save()
end

function var0_0.OnDestroy(arg0_45)
	arg0_45:cleanManagedTween()
end

return var0_0
