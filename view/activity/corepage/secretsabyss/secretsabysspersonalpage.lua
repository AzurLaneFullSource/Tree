local var0_0 = class("SecretsAbyssPersonalPage", import("view.activity.BackHills.OtherWorld.TerminalPersonalPage"))
local var1_0 = "otherworld_personal_name"

var0_0.BIND_EVENT_ACT_ID = 50094
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
var0_0.personalRandomData = nil

function var0_0.getUIName(arg0_2)
	return "SecretsAbyssPersonalPage"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.infoTF = arg0_3._tf:Find("frame/info")
	arg0_3.nameTitle = arg0_3.infoTF:Find("infos/name/title")
	arg0_3.nameInput = arg0_3.infoTF:Find("infos/name/box/InputField")
	arg0_3.jobTitle = arg0_3.infoTF:Find("infos/job/title")
	arg0_3.jobValue = arg0_3.infoTF:Find("infos/job/value")
	arg0_3.guardianTitle = arg0_3.infoTF:Find("infos/guardian/title")
	arg0_3.guardianValue = arg0_3.infoTF:Find("infos/guardian/value")
	arg0_3.lvTitle = arg0_3.infoTF:Find("level/lv/title")
	arg0_3.lvValue = arg0_3.infoTF:Find("level/lv/value")
	arg0_3.lvSlider = arg0_3.infoTF:Find("level/slider/slider")
	arg0_3.lvSliderImage = arg0_3.lvSlider:GetComponent(typeof(Image))
	arg0_3.lvUpgradeTF = arg0_3.infoTF:Find("level/slider/upgrade")

	setActive(arg0_3.lvUpgradeTF, false)

	arg0_3.propertyTF = arg0_3._tf:Find("frame/property")
	arg0_3.propertyContent = arg0_3.propertyTF:Find("content")
	arg0_3.propertyTpl = arg0_3.propertyTF:Find("tpl")

	setActive(arg0_3.propertyTpl, false)
	setActive(arg0_3.propertyTpl:Find("upgrade"), false)

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_CHT then
		arg0_3.abilityTF = arg0_3._tf:Find("frame/ability")

		setActive(arg0_3._tf:Find("frame/ability_2"), false)
	else
		arg0_3.abilityTF = arg0_3._tf:Find("frame/ability_2")

		setActive(arg0_3._tf:Find("frame/ability"), false)
	end

	setActive(arg0_3.abilityTF, true)

	arg0_3.abilityContent = arg0_3.abilityTF:Find("content")
	arg0_3.abilityTpl = arg0_3.abilityTF:Find("tpl")

	setActive(arg0_3.abilityTpl, false)

	arg0_3.randomBtn = arg0_3._tf:Find("frame/random_btn")
	arg0_3.helpBtn = arg0_3._tf:Find("frame/help_tips")
	arg0_3.effectTF = arg0_3._tf:Find("effect")

	setActive(arg0_3.effectTF, false)

	arg0_3.quitBtn = arg0_3._tf:Find("frame/close_btn")
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
		arg0_4:managedTween(LeanTween.delayedCall, function()
			var0_0.personalRandomData = {}

			arg0_4:UpdateView(true)
			setActive(arg0_4.effectTF, false)
			setActive(arg0_4.randomBtn, arg0_4.unlockRandom)
		end, var0_0.RANDOM_CHANGE_TIME, nil)

		if arg0_4.randomCallback then
			arg0_4:randomCallback()
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("personal_random_tip"))
	end, SFX_PANEL)
	setActive(arg0_4.randomBtn, arg0_4.unlockRandom)
	setActive(arg0_4.helpBtn, not arg0_4.unlockRandom)
	setActive(arg0_4.infoTF:Find("infos/name/box/edit"), arg0_4.unlockRandom)

	if arg0_4.unlockRandom and arg0_4:GetLocalName() ~= "" then
		arg0_4.showName = arg0_4:GetLocalName()
	end

	arg0_4.nameInput:GetComponent(typeof(InputField)).interactable = arg0_4.unlockRandom

	onButton(arg0_4, arg0_4.quitBtn, function()
		arg0_4:Hide()
	end)
	onButton(arg0_4, arg0_4._tf:Find("mask"), function()
		arg0_4:Hide()
	end)
	arg0_4:UpdateView()
end

function var0_0.UnlockRandom(arg0_11)
	arg0_11.unlockRandom = true
end

function var0_0.SetUpgrade(arg0_12)
	arg0_12.upgradeFlag = true
end

function var0_0.SetBossRushNode(arg0_13, arg1_13, arg2_13)
	arg0_13.currentBossRushNode = arg1_13
	arg0_13.lastBossRushNode = arg2_13
end

function var0_0.GetActivitySingleEventOption(arg0_14, arg1_14)
	for iter0_14, iter1_14 in pairs(pg.activity_single_event) do
		if iter1_14.story == arg1_14:getConfig("story") then
			return iter1_14.options
		end
	end
end

function var0_0.GetCurrentEvent(arg0_15)
	return arg0_15.currentBossRushNode
end

function var0_0.RegisterRandomCallback(arg0_16, arg1_16)
	arg0_16.randomCallback = arg1_16
end

function var0_0.UpdateView(arg0_17, arg1_17)
	local var0_17

	if arg0_17.upgradeFlag or #arg0_17:GetActivitySingleEventOption(arg0_17.currentBossRushNode) == 0 then
		var0_17 = arg0_17:GetActivitySingleEventOption(arg0_17.lastBossRushNode)
	else
		var0_17 = arg0_17:GetActivitySingleEventOption(arg0_17.currentBossRushNode)
	end

	arg0_17.showCfg = {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		arg0_17.showCfg[iter1_17[1]] = iter1_17[2]
	end

	arg0_17:UpdateInfo(arg1_17)
	arg0_17:UpdateProperty(arg1_17)
	arg0_17:UpdateAbility(arg1_17)

	if arg0_17.upgradeFlag then
		arg0_17.upgradeCfg = {}

		for iter2_17, iter3_17 in ipairs(arg0_17:GetActivitySingleEventOption(arg0_17.currentBossRushNode)) do
			arg0_17.upgradeCfg[iter3_17[1]] = iter3_17[2]
		end

		arg0_17:PlayUpgradeAnims()
	end
end

function var0_0.UpdateInfo(arg0_18, arg1_18)
	arg0_18:SetDefaultName()

	local var0_18 = arg0_18:GetRollAttrInfoById(var0_0.NAME_ID, arg1_18)

	setText(arg0_18.nameTitle, var0_18 .. "：")

	local var1_18, var2_18 = arg0_18:GetRollAttrInfoById(var0_0.JOB_ID, arg1_18)

	setText(arg0_18.jobTitle, var1_18 .. "：")
	setText(arg0_18.jobValue, var2_18)

	local var3_18, var4_18 = arg0_18:GetRollAttrInfoById(var0_0.GUARDIAN_ID, arg1_18)

	setText(arg0_18.guardianTitle, var3_18 .. "：")
	setText(arg0_18.guardianValue, var4_18)

	local var5_18, var6_18 = arg0_18:GetRollAttrInfoById(var0_0.LV_ID, arg1_18)

	setText(arg0_18.lvTitle, var5_18 .. "：")
	setText(arg0_18.lvValue, var6_18)

	arg0_18.lvSliderImage.fillAmount = tonumber(var6_18) / var0_0.config[var0_0.LV_ID].random_value[2]

	if arg1_18 then
		var0_0.personalRandomData[var0_0.JOB_ID] = var2_18
		var0_0.personalRandomData[var0_0.GUARDIAN_ID] = var4_18
		var0_0.personalRandomData[var0_0.LV_ID] = var6_18
	end
end

function var0_0.UpdateProperty(arg0_19, arg1_19)
	local var0_19 = 0

	for iter0_19, iter1_19 in ipairs(var0_0.PROPERTY_IDS) do
		var0_19 = var0_19 + 1

		local var1_19 = var0_19 > arg0_19.propertyContent.childCount and cloneTplTo(arg0_19.propertyTpl, arg0_19.propertyContent) or arg0_19.propertyContent:GetChild(var0_19 - 1)

		var1_19.name = iter1_19

		local var2_19, var3_19 = arg0_19:GetRollAttrInfoById(iter1_19, arg1_19)

		setText(var1_19:Find("name"), var2_19)
		setText(var1_19:Find("value/Text"), var3_19)

		if arg1_19 then
			var0_0.personalRandomData[iter1_19] = var3_19
		end
	end

	for iter2_19 = 1, arg0_19.propertyContent.childCount - 1 do
		if var0_19 < iter2_19 then
			setActive(arg0_19.propertyContent:GetChild(iter2_19 - 1), false)
		end
	end
end

function var0_0.UpdateAbility(arg0_20, arg1_20)
	local var0_20 = {}

	if arg1_20 then
		var0_20 = arg0_20:GetRandomAbilityIds()
	elseif var0_0.personalRandomData then
		for iter0_20, iter1_20 in pairs(var0_0.personalRandomData) do
			if table.contains(var0_0.ABILITY_IDS, iter0_20) then
				table.insert(var0_20, iter0_20)
			end
		end
	else
		for iter2_20, iter3_20 in pairs(arg0_20.showCfg) do
			if table.contains(var0_0.ABILITY_IDS, iter2_20) then
				table.insert(var0_20, iter2_20)
			end
		end
	end

	table.sort(var0_20)

	for iter4_20, iter5_20 in ipairs(var0_20) do
		local var1_20 = iter4_20 > arg0_20.abilityContent.childCount and cloneTplTo(arg0_20.abilityTpl, arg0_20.abilityContent) or arg0_20.abilityContent:GetChild(iter4_20 - 1)

		var1_20.name = iter4_20

		local var2_20, var3_20 = arg0_20:GetRollAttrInfoById(iter5_20, arg1_20)

		setScrollText(var1_20:Find("name_mask/name"), var2_20)
		setText(var1_20:Find("value/Text"), var3_20)

		if arg1_20 then
			var0_0.personalRandomData[iter5_20] = var3_20
		end
	end

	for iter6_20 = 1, arg0_20.abilityContent.childCount do
		if iter6_20 > #var0_20 then
			setActive(arg0_20.abilityContent:GetChild(iter6_20 - 1), false)
		end
	end
end

function var0_0.GetRollAttrInfoById(arg0_21, arg1_21, arg2_21)
	local var0_21 = ""

	if arg2_21 then
		local var1_21 = var0_0.config[arg1_21].random_value

		if table.contains(var0_0.PROPERTY_IDS, arg1_21) or arg1_21 == var0_0.LV_ID then
			var0_21 = math.random(var1_21[1], var1_21[2])
		else
			var0_21 = var1_21[math.random(#var1_21)]
		end
	else
		var0_21 = arg0_21.showCfg[arg1_21] or var0_0.config[arg1_21].default_value

		if var0_0.personalRandomData then
			var0_21 = var0_0.personalRandomData[arg1_21]
		end
	end

	return var0_0.config[arg1_21].name, tostring(var0_21)
end

function var0_0.GetRandomAbilityIds(arg0_22)
	local var0_22 = {}

	for iter0_22 = 1, #var0_0.ABILITY_IDS do
		table.insert(var0_22, iter0_22)
	end

	shuffle(var0_22)

	local var1_22 = {}

	for iter1_22 = 1, var0_0.RANDOM_ABILITY_CNT do
		table.insert(var1_22, var0_0.ABILITY_IDS[var0_22[iter1_22]])
	end

	return var1_22
end

var0_0.UPGRADE_TAG_SHOW_TIME = 2
var0_0.LV_ANIM_TIME = 0.5
var0_0.PROPERTY_TPL_ANIM_TIME = 0.5
var0_0.ABILITY_TPL_ANIM_TIME = 0.5
var0_0.RANDOM_CHANGE_TIME = 0.8

function var0_0.PlayUpgradeAnims(arg0_23)
	seriesAsync({
		function(arg0_24)
			arg0_23:PlayLevelAnim(arg0_24)
		end,
		function(arg0_25)
			arg0_23:PlayPropertyAnim(arg0_25)
		end,
		function(arg0_26)
			arg0_23:PlayAbilityAnim(arg0_26)
		end
	}, function()
		arg0_23.upgradeFlag = nil
	end)
end

function var0_0.PlayLevelAnim(arg0_28, arg1_28)
	local var0_28, var1_28, var2_28 = arg0_28:GetStaticInfo(var0_0.LV_ID)

	setActive(arg0_28.lvUpgradeTF, var2_28)

	if var2_28 then
		arg0_28:managedTween(LeanTween.delayedCall, function()
			setActive(arg0_28.lvUpgradeTF, false)
		end, var0_0.UPGRADE_TAG_SHOW_TIME, nil)
		arg0_28:managedTween(LeanTween.value, nil, go(arg0_28.lvValue), var0_28, var1_28, var0_0.LV_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0_30)
			setText(arg0_28.lvValue, math.floor(arg0_30))
		end)):setOnComplete(System.Action(function()
			arg1_28()
		end))

		local var3_28 = var0_0.config[var0_0.LV_ID].random_value[2]

		arg0_28:managedTween(LeanTween.value, nil, go(arg0_28.lvSlider), var0_28 / var3_28, var1_28 / var3_28, var0_0.LV_ANIM_TIME):setOnUpdate(System.Action_float(function(arg0_32)
			arg0_28.lvSliderImage.fillAmount = arg0_32
		end))
	else
		arg1_28()
	end
end

function var0_0.PlayAbilityAnim(arg0_33, arg1_33)
	local var0_33, var1_33, var2_33 = arg0_33:GetDynamicInfo()

	if var2_33 then
		local var3_33 = {}

		for iter0_33 = 1, #var1_33 do
			local var4_33 = iter0_33 > #var0_33
			local var5_33 = var1_33[iter0_33]
			local var6_33 = var4_33 and cloneTplTo(arg0_33.abilityTpl, arg0_33.abilityContent) or arg0_33.abilityContent:GetChild(iter0_33 - 1)

			GetOrAddComponent(var6_33, typeof(CanvasGroup)).alpha = var4_33 and 0 or 1

			if var0_33[iter0_33] ~= var5_33 then
				if not var4_33 then
					table.insert(var3_33, function(arg0_34)
						arg0_33:managedTween(LeanTween.value, nil, go(var6_33), 1, 0, var0_0.ABILITY_TPL_ANIM_TIME):setEase(LeanTweenType.easeInBack):setOnUpdate(System.Action_float(function(arg0_35)
							GetOrAddComponent(var6_33, typeof(CanvasGroup)).alpha = arg0_35
						end)):setOnComplete(System.Action(function()
							setText(var6_33:Find("name"), var0_0.config[var5_33].name)
							setText(var6_33:Find("value/Text"), arg0_33.upgradeCfg[var5_33])
							arg0_34()
						end))
					end)
				end

				table.insert(var3_33, function(arg0_37)
					if var4_33 then
						setText(var6_33:Find("name"), var0_0.config[var5_33].name)
						setText(var6_33:Find("value/Text"), arg0_33.upgradeCfg[var5_33])
					end

					arg0_33:managedTween(LeanTween.value, nil, go(var6_33), 0, 1, var0_0.ABILITY_TPL_ANIM_TIME):setEase(LeanTweenType.easeOutBack):setOnUpdate(System.Action_float(function(arg0_38)
						GetOrAddComponent(var6_33, typeof(CanvasGroup)).alpha = arg0_38
					end)):setOnComplete(System.Action(function()
						arg0_37()
					end))
				end)
			end
		end

		seriesAsync(var3_33, function()
			arg1_33()
		end)
	else
		arg1_33()
	end
end

function var0_0.Show(arg0_41)
	var0_0.super.Show(arg0_41)

	arg0_41.isActive = true

	pg.UIMgr.GetInstance():BlurPanel(arg0_41._tf)
end

function var0_0.Hide(arg0_42)
	var0_0.super.Hide(arg0_42)

	arg0_42.isActive = false

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_42._tf)
end

function var0_0.IsActive(arg0_43)
	return arg0_43.isActive
end

function var0_0.OnDestroy(arg0_44)
	arg0_44:cleanManagedTween()
end

return var0_0
