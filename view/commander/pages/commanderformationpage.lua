local var0_0 = class("CommanderFormationPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderFormationUI"
end

function var0_0.OnInit(arg0_2)
	setActive(arg0_2.samllTF, true)

	arg0_2.pos1 = arg0_2.samllTF:Find("commander1")
	arg0_2.pos2 = arg0_2.samllTF:Find("commander2")

	setActive(arg0_2.descPanel, false)

	arg0_2.descFrameTF = arg0_2.descPanel:Find("frame")
	arg0_2.descPos1 = arg0_2.descFrameTF:Find("commander1/frame/info")
	arg0_2.descPos2 = arg0_2.descFrameTF:Find("commander2/frame/info")
	arg0_2.skillTFPos1 = arg0_2.descFrameTF:Find("commander1/skill_info")
	arg0_2.skillTFPos2 = arg0_2.descFrameTF:Find("commander2/skill_info")
	arg0_2.abilitysTF = UIItemList.New(arg0_2.descFrameTF:Find("atttr_panel/abilitys/mask/content"), arg0_2.descFrameTF:Find("atttr_panel/abilitys/mask/content/attr"))
	arg0_2.talentsTF = UIItemList.New(arg0_2.descFrameTF:Find("atttr_panel/talents/mask/content"), arg0_2.descFrameTF:Find("atttr_panel/talents/mask/content/attr"))
	arg0_2.abilityArr = arg0_2.descPanel:Find("frame/atttr_panel/abilitys/arr")
	arg0_2.talentsArr = arg0_2.descPanel:Find("frame/atttr_panel/talents/arr")
	arg0_2.restAllBtn = arg0_2.descFrameTF:Find("rest_all")
	arg0_2.quickBtn = arg0_2.descFrameTF:Find("quick_btn")
	arg0_2.recordCommanders = {
		arg0_2.recordPanel:Find("current/commanders/commander1/frame/info"),
		arg0_2.recordPanel:Find("current/commanders/commander2/frame/info")
	}
	arg0_2.reocrdSkills = {
		arg0_2.recordPanel:Find("current/commanders/commander1/skill_info"),
		arg0_2.recordPanel:Find("current/commanders/commander2/skill_info")
	}
	arg0_2.recordList = UIItemList.New(arg0_2.recordPanel:Find("record/content"), arg0_2.recordPanel:Find("record/content/commanders"))

	onButton(arg0_2, arg0_2.samllTF, function()
		arg0_2:openDescPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.quickBtn, function()
		arg0_2:OpenRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		if isActive(arg0_2.recordPanel) then
			arg0_2:CloseRecordPanel()
		elseif isActive(arg0_2.descPanel) then
			arg0_2:closeDescPanel()
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.restAllBtn, function()
		arg0_2:emit(FormationMediator.COMMANDER_FORMATION_OP, {
			FleetType = LevelUIConst.FLEET_TYPE_SELECT,
			data = {
				type = LevelUIConst.COMMANDER_OP_REST_ALL
			},
			fleetId = arg0_2.fleet.id
		})
	end, SFX_PANEL)
	setText(arg0_2.descPanel:Find("frame/atttr_panel/abilitys/title/Text"), i18n("commander_subtile_ablity"))
	setText(arg0_2.descPanel:Find("frame/atttr_panel/talents/title/Text"), i18n("commander_subtile_talent"))
	setText(arg0_2.recordPanel:Find("current/title/Text"), i18n("commander_formation_prefab_fleet"))
end

function var0_0.Update(arg0_7, arg1_7, arg2_7)
	arg0_7.fleet = arg1_7
	arg0_7.prefabFleets = arg2_7

	local var0_7 = arg0_7.fleet:getCommanders()

	for iter0_7 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_7 = var0_7[iter0_7]

		assert(arg0_7["pos" .. iter0_7], "pos tf can not nil")
		arg0_7:updateCommander(arg0_7["pos" .. iter0_7], iter0_7, var1_7)
	end

	arg0_7:updateDesc()
	arg0_7:updateRecordPanel()
end

function var0_0.openDescPanel(arg0_8, arg1_8)
	local var0_8 = arg1_8 or 0.2

	if LeanTween.isTweening(go(arg0_8.samllTF)) or LeanTween.isTweening(go(arg0_8.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0_8.samllTF, {
		x = 0
	})
	LeanTween.moveX(arg0_8.samllTF, 800, var0_8):setOnComplete(System.Action(function()
		setActive(arg0_8.descPanel, true)
		setActive(arg0_8.descBg, true)
		pg.UIMgr.GetInstance():OverlayPanel(arg0_8._tf)
		setAnchoredPosition(arg0_8.descFrameTF, {
			x = 800
		})
		LeanTween.moveX(arg0_8.descFrameTF, 0, var0_8)
	end))

	arg0_8.contextData.inDescPage = true
end

function var0_0.closeDescPanel(arg0_10, arg1_10)
	local var0_10 = arg1_10 or 0.2

	if LeanTween.isTweening(go(arg0_10.samllTF)) or LeanTween.isTweening(go(arg0_10.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0_10.descFrameTF, {
		x = 0
	})
	LeanTween.moveX(arg0_10.descFrameTF, 800, var0_10):setOnComplete(System.Action(function()
		setActive(arg0_10.descPanel, false)
		setActive(arg0_10.descBg, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10._tf, arg0_10._parentTf)
		setAnchoredPosition(arg0_10.samllTF, {
			x = 800
		})
		LeanTween.moveX(arg0_10.samllTF, 0, var0_10)
	end))

	arg0_10.contextData.inDescPage = false
end

function var0_0.updateDesc(arg0_12)
	local var0_12 = arg0_12.fleet:getCommanders()

	for iter0_12 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_12 = var0_12[iter0_12]

		assert(arg0_12["pos" .. iter0_12], "pos tf can not nil")
		arg0_12:updateCommander(arg0_12["descPos" .. iter0_12], iter0_12, var1_12, true)
		arg0_12:updateSkillTF(var1_12, arg0_12["skillTFPos" .. iter0_12])
	end

	arg0_12:updateAdditions()
end

function var0_0.updateAdditions(arg0_13)
	local var0_13 = arg0_13.fleet
	local var1_13 = _.values(var0_13:getCommandersTalentDesc())
	local var2_13, var3_13 = var0_13:getCommandersAddition()

	arg0_13.abilitysTF:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var2_13[arg1_14 + 1]

			setText(arg2_14:Find("name"), AttributeType.Type2Name(var0_14.attrName))
			setText(arg2_14:Find("Text"), ("+" .. math.floor(var0_14.value * 1000) / 1000) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0_14.attrName, arg2_14:Find("icon"), false)
			setImageAlpha(arg2_14:Find("bg"), arg1_14 % 2)
		end
	end)
	arg0_13.abilitysTF:align(#var2_13)
	setActive(arg0_13.abilityArr, #var2_13 > 4)
	arg0_13.talentsTF:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = var1_13[arg1_15 + 1]

			setScrollText(findTF(arg2_15, "name_mask/name"), var0_15.name)

			local var1_15 = var0_15.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_15:Find("Text"), (var0_15.value > 0 and "+" or "") .. var0_15.value .. var1_15)
			setImageAlpha(arg2_15:Find("bg"), arg1_15 % 2)
		end
	end)
	arg0_13.talentsTF:align(#var1_13)
	setActive(arg0_13.talentsArr, #var1_13 > 4)
	Canvas.ForceUpdateCanvases()
end

function var0_0.updateSkillTF(arg0_16, arg1_16, arg2_16)
	setActive(arg2_16, arg1_16)

	if arg1_16 then
		local var0_16 = arg1_16:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0_16:getConfig("icon"), "", arg2_16:Find("icon"))
		setText(arg2_16:Find("level"), "Lv." .. var0_16:getLevel())
		onButton(arg0_16, arg2_16, function()
			arg0_16:emit(FormationMediator.ON_CMD_SKILL, var0_16)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_16)
	end
end

function var0_0.updateCommander(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	local var0_18 = arg1_18:Find("add")
	local var1_18 = arg1_18:Find("info")

	if arg3_18 then
		local var2_18 = arg1_18:Find("info/mask/icon")
		local var3_18 = arg1_18:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. arg3_18:getPainting(), "", var2_18)

		local var4_18 = arg1_18:Find("info/name")

		if var4_18 then
			setText(var4_18, arg3_18:getName())
		end

		local var5_18 = Commander.rarity2Frame(arg3_18:getRarity())

		setImageSprite(var3_18, GetSpriteFromAtlas("weaponframes", "commander_" .. var5_18))
	end

	if arg4_18 then
		onButton(arg0_18, var1_18, function()
			arg0_18:emit(FormationMediator.ON_SELECT_COMMANDER, arg2_18, arg0_18.fleet.id)
		end, SFX_PANEL)
		onButton(arg0_18, var0_18, function()
			arg0_18:emit(FormationMediator.ON_SELECT_COMMANDER, arg2_18, arg0_18.fleet.id)
		end, SFX_PANEL)
	end

	setActive(var0_18, not arg3_18)
	setActive(var1_18, arg3_18)
end

function var0_0.OpenRecordPanel(arg0_21)
	setActive(arg0_21.descFrameTF, false)
	setActive(arg0_21.recordPanel, true)
end

function var0_0.updateRecordPanel(arg0_22)
	local var0_22 = arg0_22.fleet:getCommanders()

	for iter0_22, iter1_22 in ipairs(arg0_22.recordCommanders) do
		local var1_22 = var0_22[iter0_22]

		arg0_22:updateCommander(iter1_22, iter0_22, var1_22)
		arg0_22:updateSkillTF(var1_22, arg0_22.reocrdSkills[iter0_22])
	end

	arg0_22.recordList:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = arg0_22.prefabFleets[arg1_23 + 1]

			arg0_22:UpdatePrefabFleet(var0_23, arg2_23, var0_22)
		end
	end)
	arg0_22.recordList:align(#arg0_22.prefabFleets)
end

function var0_0.UpdatePrefabFleet(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = arg2_24:Find("fleet_name")
	local var1_24 = arg1_24:getName()

	onInputEndEdit(arg0_24, var0_24, function()
		local var0_25 = getInputText(var0_24)

		arg0_24:emit(FormationMediator.COMMANDER_FORMATION_OP, {
			FleetType = LevelUIConst.FLEET_TYPE_SELECT,
			data = {
				type = LevelUIConst.COMMANDER_OP_RENAME,
				id = arg1_24.id,
				str = var0_25,
				onFailed = function()
					setInputText(var0_24, var1_24)
				end
			},
			fleetId = arg0_24.fleet.id
		})
	end)
	setInputText(var0_24, var1_24)
	onButton(arg0_24, arg2_24:Find("use_btn"), function()
		arg0_24:emit(FormationMediator.COMMANDER_FORMATION_OP, {
			FleetType = LevelUIConst.FLEET_TYPE_SELECT,
			data = {
				type = LevelUIConst.COMMANDER_OP_USE_PREFAB,
				id = arg1_24.id
			},
			fleetId = arg0_24.fleet.id
		})
		arg0_24:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_24, arg2_24:Find("record_btn"), function()
		arg0_24:emit(FormationMediator.COMMANDER_FORMATION_OP, {
			FleetType = LevelUIConst.FLEET_TYPE_SELECT,
			data = {
				type = LevelUIConst.COMMANDER_OP_RECORD_PREFAB,
				id = arg1_24.id
			},
			fleetId = arg0_24.fleet.id
		})
	end, SFX_PANEL)

	local var2_24 = {
		arg2_24:Find("commander1/frame/info"),
		arg2_24:Find("commander2/frame/info")
	}
	local var3_24 = {
		arg2_24:Find("commander1/skill_info"),
		arg2_24:Find("commander2/skill_info")
	}

	for iter0_24, iter1_24 in ipairs(var2_24) do
		local var4_24 = arg1_24:getCommanderByPos(iter0_24)

		arg0_24:updateCommander(iter1_24, iter0_24, var4_24)
		arg0_24:updateSkillTF(var4_24, var3_24[iter0_24])
	end
end

function var0_0.CloseRecordPanel(arg0_29)
	setActive(arg0_29.descFrameTF, true)
	setActive(arg0_29.recordPanel, false)
end

function var0_0.OnDestroy(arg0_30)
	if arg0_30:isShowing() then
		LeanTween.cancel(go(arg0_30.samllTF))
		LeanTween.cancel(go(arg0_30.descFrameTF))

		if isActive(arg0_30.descPanel) then
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30._tf, arg0_30._parentTf)
		end
	end
end

return var0_0
