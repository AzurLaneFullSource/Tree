local var0_0 = class("GuildCommanderFormationPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GuildCommanderFormationUI"
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
	arg0_2.quickBtn = arg0_2:findTF("quick_btn", arg0_2.descFrameTF)
	arg0_2.recordPanel = arg0_2:findTF("record_panel")
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
	onButton(arg0_2, arg0_2.descPanel, function()
		arg0_2:closeDescPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.restAllBtn, function()
		if not arg0_2.fleet:ExistAnyCommander() then
			return
		end

		arg0_2:emit(GuildEventMediator.COMMANDER_FORMATION_OP, {
			data = {
				fleet = arg0_2.fleet,
				type = LevelUIConst.COMMANDER_OP_REST_ALL
			},
			fleetId = arg0_2.fleet.id
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.quickBtn, function()
		arg0_2:OpenRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.recordPanel:Find("back"), function()
		arg0_2:CloseRecordPanel()
	end, SFX_PANEL)
	arg0_2:Show()
end

function var0_0.Update(arg0_8, arg1_8, arg2_8)
	arg0_8.fleet = arg1_8
	arg0_8.prefabFleets = arg2_8

	local var0_8 = arg0_8.fleet:getCommanders()

	for iter0_8 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_8 = var0_8[iter0_8]

		assert(arg0_8["pos" .. iter0_8], "pos tf can not nil")
		arg0_8:updateCommander(arg0_8["pos" .. iter0_8], iter0_8, var1_8)
	end

	arg0_8:updateDesc()
	arg0_8:updateRecordPanel()
end

function var0_0.openDescPanel(arg0_9, arg1_9)
	local var0_9 = arg1_9 or 0.2

	if LeanTween.isTweening(go(arg0_9.samllTF)) or LeanTween.isTweening(go(arg0_9.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0_9.samllTF, {
		x = -108
	})
	LeanTween.moveX(arg0_9.samllTF, 1500, var0_9):setOnComplete(System.Action(function()
		setActive(arg0_9.descPanel, true)
		setAnchoredPosition(arg0_9.descFrameTF, {
			x = 1500
		})
		LeanTween.moveX(arg0_9.descFrameTF, -108, var0_9)
	end))

	arg0_9.contextData.inDescPage = true

	arg0_9._tf:SetAsLastSibling()
end

function var0_0.closeDescPanel(arg0_11, arg1_11)
	local var0_11 = arg1_11 or 0.2

	if LeanTween.isTweening(go(arg0_11.samllTF)) or LeanTween.isTweening(go(arg0_11.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0_11.descFrameTF, {
		x = -108
	})
	LeanTween.moveX(arg0_11.descFrameTF, 1500, var0_11):setOnComplete(System.Action(function()
		setActive(arg0_11.descPanel, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11._tf, arg0_11._parentTf)
		setAnchoredPosition(arg0_11.samllTF, {
			x = 1500
		})
		LeanTween.moveX(arg0_11.samllTF, -108, var0_11)
	end))

	arg0_11.contextData.inDescPage = false
end

function var0_0.updateDesc(arg0_13)
	local var0_13 = arg0_13.fleet:getCommanders()

	for iter0_13 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_13 = var0_13[iter0_13]

		assert(arg0_13["pos" .. iter0_13], "pos tf can not nil")
		arg0_13:updateCommander(arg0_13["descPos" .. iter0_13], iter0_13, var1_13, true)
		arg0_13:updateSkillTF(var1_13, arg0_13["skillTFPos" .. iter0_13])
	end

	arg0_13:updateAdditions()
end

function var0_0.updateAdditions(arg0_14)
	local var0_14 = arg0_14.fleet
	local var1_14 = _.values(var0_14:getCommandersTalentDesc())
	local var2_14, var3_14 = var0_14:getCommandersAddition()

	arg0_14.abilitysTF:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = var2_14[arg1_15 + 1]

			setText(arg2_15:Find("name"), AttributeType.Type2Name(var0_15.attrName))
			setText(arg2_15:Find("Text"), ("+" .. math.floor(var0_15.value * 1000) / 1000) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0_15.attrName, arg2_15:Find("icon"), false)
			setImageAlpha(arg2_15:Find("bg"), arg1_15 % 2)
		end
	end)
	arg0_14.abilitysTF:align(#var2_14)
	setActive(arg0_14.abilityArr, #var2_14 > 4)
	arg0_14.talentsTF:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var1_14[arg1_16 + 1]

			setScrollText(findTF(arg2_16, "name_mask/name"), var0_16.name)

			local var1_16 = var0_16.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_16:Find("Text"), (var0_16.value > 0 and "+" or "") .. var0_16.value .. var1_16)
			setImageAlpha(arg2_16:Find("bg"), arg1_16 % 2)
		end
	end)
	arg0_14.talentsTF:align(#var1_14)
	setActive(arg0_14.talentsArr, #var1_14 > 4)
	Canvas.ForceUpdateCanvases()
end

function var0_0.updateSkillTF(arg0_17, arg1_17, arg2_17)
	setActive(arg2_17, arg1_17)

	if arg1_17 then
		local var0_17 = arg1_17:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0_17:getConfig("icon"), "", arg2_17:Find("icon"))
		setText(arg2_17:Find("level"), "Lv." .. var0_17:getLevel())
		onButton(arg0_17, arg2_17, function()
			arg0_17:emit(GuildEventMediator.ON_CMD_SKILL, var0_17)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_17)
	end
end

function var0_0.updateCommander(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19 = arg1_19:Find("add")
	local var1_19 = arg1_19:Find("info")

	if arg3_19 then
		local var2_19 = arg1_19:Find("info/mask/icon")
		local var3_19 = arg1_19:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. arg3_19:getPainting(), "", var2_19)

		local var4_19 = arg1_19:Find("info/name")

		if var4_19 then
			setText(var4_19, arg3_19:getName())
		end

		local var5_19 = Commander.rarity2Frame(arg3_19:getRarity())

		setImageSprite(var3_19, GetSpriteFromAtlas("weaponframes", "commander_" .. var5_19))
	end

	if arg4_19 then
		onButton(arg0_19, var1_19, function()
			arg0_19:emit(GuildEventMediator.ON_SELECT_COMMANDER, arg0_19.fleet.id, arg2_19, arg3_19)
		end, SFX_PANEL)
		onButton(arg0_19, var0_19, function()
			arg0_19:emit(GuildEventMediator.ON_SELECT_COMMANDER, arg0_19.fleet.id, arg2_19, arg3_19)
		end, SFX_PANEL)
	end

	setActive(var0_19, not arg3_19)
	setActive(var1_19, arg3_19)
end

function var0_0.OpenRecordPanel(arg0_22)
	setActive(arg0_22.descFrameTF, false)
	setActive(arg0_22.recordPanel, true)
end

function var0_0.updateRecordPanel(arg0_23)
	local var0_23 = arg0_23.fleet:getCommanders()

	for iter0_23, iter1_23 in ipairs(arg0_23.recordCommanders) do
		local var1_23 = var0_23[iter0_23]

		arg0_23:updateCommander(iter1_23, iter0_23, var1_23)
		arg0_23:updateSkillTF(var1_23, arg0_23.reocrdSkills[iter0_23])
	end

	arg0_23.recordList:make(function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			local var0_24 = arg0_23.prefabFleets[arg1_24 + 1]

			arg0_23:UpdatePrefabFleet(var0_24, arg2_24, var0_23)
		end
	end)
	arg0_23.recordList:align(#arg0_23.prefabFleets)
end

function var0_0.UpdatePrefabFleet(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = arg2_25:Find("fleet_name")
	local var1_25 = arg1_25:getName()

	onInputEndEdit(arg0_25, var0_25, function()
		local var0_26 = getInputText(var0_25)

		arg0_25:emit(GuildEventMediator.COMMANDER_FORMATION_OP, {
			data = {
				fleet = arg0_25.fleet,
				type = LevelUIConst.COMMANDER_OP_RENAME,
				id = arg1_25.id,
				str = var0_26,
				onFailed = function()
					setInputText(var0_25, var1_25)
				end
			},
			fleetId = arg0_25.fleet.id
		})
	end)
	setInputText(var0_25, var1_25)
	onButton(arg0_25, arg2_25:Find("use_btn"), function()
		arg0_25:emit(GuildEventMediator.COMMANDER_FORMATION_OP, {
			data = {
				fleet = arg0_25.fleet,
				type = LevelUIConst.COMMANDER_OP_USE_PREFAB,
				id = arg1_25.id
			},
			fleetId = arg0_25.fleet.id
		})
		arg0_25:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_25, arg2_25:Find("record_btn"), function()
		arg0_25:emit(GuildEventMediator.COMMANDER_FORMATION_OP, {
			data = {
				fleet = arg0_25.fleet,
				type = LevelUIConst.COMMANDER_OP_RECORD_PREFAB,
				id = arg1_25.id
			},
			fleetId = arg0_25.fleet.id
		})
	end, SFX_PANEL)

	local var2_25 = {
		arg2_25:Find("commander1/frame/info"),
		arg2_25:Find("commander2/frame/info")
	}
	local var3_25 = {
		arg2_25:Find("commander1/skill_info"),
		arg2_25:Find("commander2/skill_info")
	}

	for iter0_25, iter1_25 in ipairs(var2_25) do
		local var4_25 = arg1_25:getCommanderByPos(iter0_25)

		arg0_25:updateCommander(iter1_25, iter0_25, var4_25)
		arg0_25:updateSkillTF(var4_25, var3_25[iter0_25])
	end
end

function var0_0.CloseRecordPanel(arg0_30)
	setActive(arg0_30.descFrameTF, true)
	setActive(arg0_30.recordPanel, false)
end

function var0_0.OnDestroy(arg0_31)
	if arg0_31:isShowing() then
		LeanTween.cancel(go(arg0_31.samllTF))
		LeanTween.cancel(go(arg0_31.descFrameTF))
	end
end

return var0_0
