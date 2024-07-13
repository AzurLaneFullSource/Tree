local var0_0 = class("LimitChallengeCommanderFormationPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderFormationUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.samllTF = arg0_2:findTF("small")

	setActive(arg0_2.samllTF, true)

	arg0_2.pos1 = arg0_2:findTF("small/commander1", arg0_2.topPanel)
	arg0_2.pos2 = arg0_2:findTF("small/commander2", arg0_2.topPanel)
	arg0_2.descPanel = arg0_2:findTF("desc")

	setActive(arg0_2.descPanel, false)

	arg0_2.descFrameTF = arg0_2:findTF("desc/frame")
	arg0_2.descPos1 = arg0_2:findTF("commander1/frame/info", arg0_2.descFrameTF)
	arg0_2.descPos2 = arg0_2:findTF("commander2/frame/info", arg0_2.descFrameTF)
	arg0_2.skillTFPos1 = arg0_2:findTF("commander1/skill_info", arg0_2.descFrameTF)
	arg0_2.skillTFPos2 = arg0_2:findTF("commander2/skill_info", arg0_2.descFrameTF)
	arg0_2.abilitysTF = UIItemList.New(arg0_2:findTF("atttr_panel/abilitys/mask/content", arg0_2.descFrameTF), arg0_2:findTF("atttr_panel/abilitys/mask/content/attr", arg0_2.descFrameTF))
	arg0_2.talentsTF = UIItemList.New(arg0_2:findTF("atttr_panel/talents/mask/content", arg0_2.descFrameTF), arg0_2:findTF("atttr_panel/talents/mask/content/attr", arg0_2.descFrameTF))
	arg0_2.abilityArr = arg0_2:findTF("desc/frame/atttr_panel/abilitys/arr")
	arg0_2.talentsArr = arg0_2:findTF("desc/frame/atttr_panel/talents/arr")
	arg0_2.restAllBtn = arg0_2:findTF("rest_all", arg0_2.descFrameTF)

	setActive(arg0_2.restAllBtn, false)

	arg0_2.quickBtn = arg0_2:findTF("quick_btn", arg0_2.descFrameTF)

	setActive(arg0_2.quickBtn, false)
	onButton(arg0_2, arg0_2.samllTF, function()
		arg0_2:openDescPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.descPanel, function()
		arg0_2:closeDescPanel()
	end, SFX_PANEL)
end

function var0_0.Update(arg0_5, arg1_5, arg2_5)
	arg0_5.fleet = arg1_5
	arg0_5.prefabFleets = arg2_5

	local var0_5 = arg0_5.fleet:getCommanders()

	for iter0_5 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_5 = var0_5[iter0_5]

		assert(arg0_5["pos" .. iter0_5], "pos tf can not nil")
		arg0_5:updateCommander(arg0_5["pos" .. iter0_5], iter0_5, var1_5)
	end

	arg0_5:updateDesc()
end

function var0_0.openDescPanel(arg0_6, arg1_6)
	local var0_6 = arg1_6 or 0.2

	if LeanTween.isTweening(go(arg0_6.samllTF)) or LeanTween.isTweening(go(arg0_6.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0_6.samllTF, {
		x = 0
	})
	LeanTween.moveX(arg0_6.samllTF, 800, var0_6):setOnComplete(System.Action(function()
		setActive(arg0_6.descPanel, true)
		pg.UIMgr.GetInstance():OverlayPanel(arg0_6._tf, {
			groupName = LayerWeightConst.GROUP_FORMATION_PAGE
		})
		setAnchoredPosition(arg0_6.descFrameTF, {
			x = 800
		})
		LeanTween.moveX(arg0_6.descFrameTF, 0, var0_6)
	end))

	arg0_6.contextData.inDescPage = true

	arg0_6._tf:SetAsLastSibling()
end

function var0_0.closeDescPanel(arg0_8, arg1_8)
	local var0_8 = arg1_8 or 0.2

	if LeanTween.isTweening(go(arg0_8.samllTF)) or LeanTween.isTweening(go(arg0_8.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0_8.descFrameTF, {
		x = 0
	})
	LeanTween.moveX(arg0_8.descFrameTF, 800, var0_8):setOnComplete(System.Action(function()
		setActive(arg0_8.descPanel, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf, arg0_8._parentTf)
		setAnchoredPosition(arg0_8.samllTF, {
			x = 800
		})
		LeanTween.moveX(arg0_8.samllTF, 0, var0_8)
	end))

	arg0_8.contextData.inDescPage = false
end

function var0_0.updateDesc(arg0_10)
	local var0_10 = arg0_10.fleet:getCommanders()

	for iter0_10 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_10 = var0_10[iter0_10]

		assert(arg0_10["pos" .. iter0_10], "pos tf can not nil")
		arg0_10:updateCommander(arg0_10["descPos" .. iter0_10], iter0_10, var1_10, true)
		arg0_10:updateSkillTF(var1_10, arg0_10["skillTFPos" .. iter0_10])
	end

	arg0_10:updateAdditions()
end

function var0_0.updateAdditions(arg0_11)
	local var0_11 = arg0_11.fleet
	local var1_11 = _.values(var0_11:getCommandersTalentDesc())
	local var2_11, var3_11 = var0_11:getCommandersAddition()

	arg0_11.abilitysTF:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var2_11[arg1_12 + 1]

			setText(arg2_12:Find("name"), AttributeType.Type2Name(var0_12.attrName))
			setText(arg2_12:Find("Text"), ("+" .. math.floor(var0_12.value * 1000) / 1000) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0_12.attrName, arg2_12:Find("icon"), false)
			setImageAlpha(arg2_12:Find("bg"), arg1_12 % 2)
		end
	end)
	arg0_11.abilitysTF:align(#var2_11)
	setActive(arg0_11.abilityArr, #var2_11 > 4)
	arg0_11.talentsTF:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var1_11[arg1_13 + 1]

			setScrollText(findTF(arg2_13, "name_mask/name"), var0_13.name)

			local var1_13 = var0_13.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_13:Find("Text"), (var0_13.value > 0 and "+" or "") .. var0_13.value .. var1_13)
			setImageAlpha(arg2_13:Find("bg"), arg1_13 % 2)
		end
	end)
	arg0_11.talentsTF:align(#var1_11)
	setActive(arg0_11.talentsArr, #var1_11 > 4)
end

function var0_0.updateSkillTF(arg0_14, arg1_14, arg2_14)
	setActive(arg2_14, arg1_14)

	if arg1_14 then
		local var0_14 = arg1_14:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0_14:getConfig("icon"), "", arg2_14:Find("icon"))
		setText(arg2_14:Find("level"), "Lv." .. var0_14:getLevel())
		onButton(arg0_14, arg2_14, function()
			arg0_14:emit(LimitChallengePreCombatMediator.ON_CMD_SKILL, var0_14)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_14)
	end
end

function var0_0.updateCommander(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	local var0_16 = arg1_16:Find("add")
	local var1_16 = arg1_16:Find("info")

	if arg3_16 then
		local var2_16 = arg1_16:Find("info/mask/icon")
		local var3_16 = arg1_16:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. arg3_16:getPainting(), "", var2_16)

		local var4_16 = arg1_16:Find("info/name")

		if var4_16 then
			setText(var4_16, arg3_16:getName())
		end

		local var5_16 = Commander.rarity2Frame(arg3_16:getRarity())

		setImageSprite(var3_16, GetSpriteFromAtlas("weaponframes", "commander_" .. var5_16))
	end

	if arg4_16 then
		onButton(arg0_16, var1_16, function()
			arg0_16:emit(LimitChallengePreCombatMediator.ON_SELECT_COMMANDER, arg2_16, arg0_16.fleet.id)
		end, SFX_PANEL)
		onButton(arg0_16, var0_16, function()
			arg0_16:emit(LimitChallengePreCombatMediator.ON_SELECT_COMMANDER, arg2_16, arg0_16.fleet.id)
		end, SFX_PANEL)
	end

	setActive(var0_16, not arg3_16)
	setActive(var1_16, arg3_16)
end

function var0_0.OnDestroy(arg0_19)
	if arg0_19:isShowing() then
		LeanTween.cancel(go(arg0_19.samllTF))
		LeanTween.cancel(go(arg0_19.descFrameTF))

		if isActive(arg0_19.descPanel) then
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19._tf, arg0_19._parentTf)
		end
	end
end

return var0_0
