local var0_0 = class("CommanderFormationPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderFormationUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"attricon",
		"weaponframes"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.getCommanderResList(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}

	local function var1_3(arg0_4)
		if arg0_4 then
			local var0_4 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.Commander.CommanderHrz, arg0_4:getPainting())

			table.insert(var0_3, var0_4)

			local var1_4 = arg0_4:getSkills()[1]

			if var1_4 then
				local var2_4 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.Commander.CommanderSkillIcon, var1_4:getConfig("icon"))

				table.insert(var0_3, var2_4)
			end
		end
	end

	if arg1_3 then
		_.each(arg1_3:getCommanders(), function(arg0_5)
			var1_3(arg0_5)
		end)
	end

	_.each(arg2_3 or {}, function(arg0_6)
		for iter0_6 = 1, CommanderConst.MAX_FORMATION_POS do
			var1_3(arg0_6:getCommanderByPos(iter0_6))
		end
	end)

	return var0_3
end

function var0_0.OnInit(arg0_7)
	setActive(arg0_7.samllTF, true)

	arg0_7.pos1 = arg0_7.samllTF:Find("commander1")
	arg0_7.pos2 = arg0_7.samllTF:Find("commander2")

	setActive(arg0_7.descPanel, false)

	arg0_7.descFrameTF = arg0_7.descPanel:Find("frame")
	arg0_7.descPos1 = arg0_7.descFrameTF:Find("commander1/frame/info")
	arg0_7.descPos2 = arg0_7.descFrameTF:Find("commander2/frame/info")
	arg0_7.skillTFPos1 = arg0_7.descFrameTF:Find("commander1/skill_info")
	arg0_7.skillTFPos2 = arg0_7.descFrameTF:Find("commander2/skill_info")
	arg0_7.abilitysTF = UIItemList.New(arg0_7.descFrameTF:Find("atttr_panel/abilitys/mask/content"), arg0_7.descFrameTF:Find("atttr_panel/abilitys/mask/content/attr"))
	arg0_7.talentsTF = UIItemList.New(arg0_7.descFrameTF:Find("atttr_panel/talents/mask/content"), arg0_7.descFrameTF:Find("atttr_panel/talents/mask/content/attr"))
	arg0_7.abilityArr = arg0_7.descPanel:Find("frame/atttr_panel/abilitys/arr")
	arg0_7.talentsArr = arg0_7.descPanel:Find("frame/atttr_panel/talents/arr")
	arg0_7.restAllBtn = arg0_7.descFrameTF:Find("rest_all")
	arg0_7.quickBtn = arg0_7.descFrameTF:Find("quick_btn")
	arg0_7.recordCommanders = {
		arg0_7.recordPanel:Find("current/commanders/commander1/frame/info"),
		arg0_7.recordPanel:Find("current/commanders/commander2/frame/info")
	}
	arg0_7.reocrdSkills = {
		arg0_7.recordPanel:Find("current/commanders/commander1/skill_info"),
		arg0_7.recordPanel:Find("current/commanders/commander2/skill_info")
	}
	arg0_7.recordList = UIItemList.New(arg0_7.recordPanel:Find("record/content"), arg0_7.recordPanel:Find("record/content/commanders"))

	onButton(arg0_7, arg0_7.samllTF, function()
		arg0_7:openDescPanel()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.quickBtn, function()
		arg0_7:OpenRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf:Find("bg"), function()
		if isActive(arg0_7.recordPanel) then
			arg0_7:CloseRecordPanel()
		elseif isActive(arg0_7.descPanel) then
			arg0_7:closeDescPanel()
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.restAllBtn, function()
		arg0_7:emit(FormationMediator.COMMANDER_FORMATION_OP, {
			FleetType = LevelUIConst.FLEET_TYPE_SELECT,
			data = {
				type = LevelUIConst.COMMANDER_OP_REST_ALL
			},
			fleetId = arg0_7.fleet.id
		})
	end, SFX_PANEL)
	setText(arg0_7.descPanel:Find("frame/atttr_panel/abilitys/title/Text"), i18n("commander_subtile_ablity"))
	setText(arg0_7.descPanel:Find("frame/atttr_panel/talents/title/Text"), i18n("commander_subtile_talent"))
	setText(arg0_7.recordPanel:Find("current/title/Text"), i18n("commander_formation_prefab_fleet"))
end

function var0_0.Update(arg0_12, arg1_12, arg2_12)
	arg0_12.fleet = arg1_12
	arg0_12.prefabFleets = arg2_12

	local var0_12 = arg0_12:getCommanderResList(arg1_12, arg2_12)

	SplitPackConst.DownloadByLuaArr(var0_12, function()
		if arg0_12._state == var0_0.STATES.DESTROY then
			return
		end

		arg0_12:updateAfterResDownload()
	end)
end

function var0_0.updateAfterResDownload(arg0_14)
	local var0_14 = arg0_14.fleet:getCommanders()

	for iter0_14 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_14 = var0_14[iter0_14]

		assert(arg0_14["pos" .. iter0_14], "pos tf can not nil")
		arg0_14:updateCommander(arg0_14["pos" .. iter0_14], iter0_14, var1_14)
	end

	arg0_14:updateDesc()
	arg0_14:updateRecordPanel()
end

function var0_0.openDescPanel(arg0_15, arg1_15)
	local var0_15 = arg1_15 or 0.2

	if LeanTween.isTweening(go(arg0_15.samllTF)) or LeanTween.isTweening(go(arg0_15.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0_15.samllTF, {
		x = 0
	})
	LeanTween.moveX(arg0_15.samllTF, 800, var0_15):setOnComplete(System.Action(function()
		setActive(arg0_15.descPanel, true)
		setActive(arg0_15.descBg, true)
		pg.UIMgr.GetInstance():OverlayPanel(arg0_15._tf)
		setAnchoredPosition(arg0_15.descFrameTF, {
			x = 800
		})
		LeanTween.moveX(arg0_15.descFrameTF, 0, var0_15)
	end))

	arg0_15.contextData.inDescPage = true
end

function var0_0.closeDescPanel(arg0_17, arg1_17)
	local var0_17 = arg1_17 or 0.2

	if LeanTween.isTweening(go(arg0_17.samllTF)) or LeanTween.isTweening(go(arg0_17.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0_17.descFrameTF, {
		x = 0
	})
	LeanTween.moveX(arg0_17.descFrameTF, 800, var0_17):setOnComplete(System.Action(function()
		setActive(arg0_17.descPanel, false)
		setActive(arg0_17.descBg, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_17._tf, arg0_17._parentTf)
		setAnchoredPosition(arg0_17.samllTF, {
			x = 800
		})
		LeanTween.moveX(arg0_17.samllTF, 0, var0_17)
	end))

	arg0_17.contextData.inDescPage = false
end

function var0_0.updateDesc(arg0_19)
	local var0_19 = arg0_19.fleet:getCommanders()

	for iter0_19 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_19 = var0_19[iter0_19]

		assert(arg0_19["pos" .. iter0_19], "pos tf can not nil")
		arg0_19:updateCommander(arg0_19["descPos" .. iter0_19], iter0_19, var1_19, true)
		arg0_19:updateSkillTF(var1_19, arg0_19["skillTFPos" .. iter0_19])
	end

	arg0_19:updateAdditions()
end

function var0_0.updateAdditions(arg0_20)
	local var0_20 = arg0_20.fleet
	local var1_20 = _.values(var0_20:getCommandersTalentDesc())
	local var2_20, var3_20 = var0_20:getCommandersAddition()

	arg0_20.abilitysTF:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = var2_20[arg1_21 + 1]

			setText(arg2_21:Find("name"), AttributeType.Type2Name(var0_21.attrName))
			setText(arg2_21:Find("Text"), ("+" .. math.floor(var0_21.value * 1000) / 1000) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0_21.attrName, arg2_21:Find("icon"), false)
			setImageAlpha(arg2_21:Find("bg"), arg1_21 % 2)
		end
	end)
	arg0_20.abilitysTF:align(#var2_20)
	setActive(arg0_20.abilityArr, #var2_20 > 4)
	arg0_20.talentsTF:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var1_20[arg1_22 + 1]

			setScrollText(findTF(arg2_22, "name_mask/name"), var0_22.name)

			local var1_22 = var0_22.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_22:Find("Text"), (var0_22.value > 0 and "+" or "") .. var0_22.value .. var1_22)
			setImageAlpha(arg2_22:Find("bg"), arg1_22 % 2)
		end
	end)
	arg0_20.talentsTF:align(#var1_20)
	setActive(arg0_20.talentsArr, #var1_20 > 4)
	Canvas.ForceUpdateCanvases()
end

function var0_0.updateSkillTF(arg0_23, arg1_23, arg2_23)
	setActive(arg2_23, arg1_23)

	if arg1_23 then
		local var0_23 = arg1_23:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0_23:getConfig("icon"), "", arg2_23:Find("icon"))
		setText(arg2_23:Find("level"), "Lv." .. var0_23:getLevel())
		onButton(arg0_23, arg2_23, function()
			arg0_23:emit(FormationMediator.ON_CMD_SKILL, var0_23)
		end, SFX_PANEL)
	else
		removeOnButton(arg2_23)
	end
end

function var0_0.updateCommander(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	local var0_25 = arg1_25:Find("add")
	local var1_25 = arg1_25:Find("info")

	if arg3_25 then
		local var2_25 = arg1_25:Find("info/mask/icon")
		local var3_25 = arg1_25:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. arg3_25:getPainting(), "", var2_25)

		local var4_25 = arg1_25:Find("info/name")

		if var4_25 then
			setText(var4_25, arg3_25:getName())
		end

		local var5_25 = Commander.rarity2Frame(arg3_25:getRarity())

		setImageSprite(var3_25, GetSpriteFromAtlas("weaponframes", "commander_" .. var5_25))
	end

	if arg4_25 then
		onButton(arg0_25, var1_25, function()
			arg0_25:emit(FormationMediator.ON_SELECT_COMMANDER, arg2_25, arg0_25.fleet.id)
		end, SFX_PANEL)
		onButton(arg0_25, var0_25, function()
			arg0_25:emit(FormationMediator.ON_SELECT_COMMANDER, arg2_25, arg0_25.fleet.id)
		end, SFX_PANEL)
	end

	setActive(var0_25, not arg3_25)
	setActive(var1_25, arg3_25)
end

function var0_0.OpenRecordPanel(arg0_28)
	setActive(arg0_28.descFrameTF, false)
	setActive(arg0_28.recordPanel, true)
end

function var0_0.updateRecordPanel(arg0_29)
	local var0_29 = arg0_29.fleet:getCommanders()

	for iter0_29, iter1_29 in ipairs(arg0_29.recordCommanders) do
		local var1_29 = var0_29[iter0_29]

		arg0_29:updateCommander(iter1_29, iter0_29, var1_29)
		arg0_29:updateSkillTF(var1_29, arg0_29.reocrdSkills[iter0_29])
	end

	arg0_29.recordList:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			local var0_30 = arg0_29.prefabFleets[arg1_30 + 1]

			arg0_29:UpdatePrefabFleet(var0_30, arg2_30, var0_29)
		end
	end)
	arg0_29.recordList:align(#arg0_29.prefabFleets)
end

function var0_0.UpdatePrefabFleet(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = arg2_31:Find("fleet_name")
	local var1_31 = arg1_31:getName()

	onInputEndEdit(arg0_31, var0_31, function()
		local var0_32 = getInputText(var0_31)

		arg0_31:emit(FormationMediator.COMMANDER_FORMATION_OP, {
			FleetType = LevelUIConst.FLEET_TYPE_SELECT,
			data = {
				type = LevelUIConst.COMMANDER_OP_RENAME,
				id = arg1_31.id,
				str = var0_32,
				onFailed = function()
					setInputText(var0_31, var1_31)
				end
			},
			fleetId = arg0_31.fleet.id
		})
	end)
	setInputText(var0_31, var1_31)
	onButton(arg0_31, arg2_31:Find("use_btn"), function()
		arg0_31:emit(FormationMediator.COMMANDER_FORMATION_OP, {
			FleetType = LevelUIConst.FLEET_TYPE_SELECT,
			data = {
				type = LevelUIConst.COMMANDER_OP_USE_PREFAB,
				id = arg1_31.id
			},
			fleetId = arg0_31.fleet.id
		})
		arg0_31:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_31, arg2_31:Find("record_btn"), function()
		arg0_31:emit(FormationMediator.COMMANDER_FORMATION_OP, {
			FleetType = LevelUIConst.FLEET_TYPE_SELECT,
			data = {
				type = LevelUIConst.COMMANDER_OP_RECORD_PREFAB,
				id = arg1_31.id
			},
			fleetId = arg0_31.fleet.id
		})
	end, SFX_PANEL)

	local var2_31 = {
		arg2_31:Find("commander1/frame/info"),
		arg2_31:Find("commander2/frame/info")
	}
	local var3_31 = {
		arg2_31:Find("commander1/skill_info"),
		arg2_31:Find("commander2/skill_info")
	}

	for iter0_31, iter1_31 in ipairs(var2_31) do
		local var4_31 = arg1_31:getCommanderByPos(iter0_31)

		arg0_31:updateCommander(iter1_31, iter0_31, var4_31)
		arg0_31:updateSkillTF(var4_31, var3_31[iter0_31])
	end
end

function var0_0.CloseRecordPanel(arg0_36)
	setActive(arg0_36.descFrameTF, true)
	setActive(arg0_36.recordPanel, false)
end

function var0_0.OnDestroy(arg0_37)
	if arg0_37:isShowing() then
		LeanTween.cancel(go(arg0_37.samllTF))
		LeanTween.cancel(go(arg0_37.descFrameTF))

		if isActive(arg0_37.descPanel) then
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_37._tf, arg0_37._parentTf)
		end
	end
end

return var0_0
