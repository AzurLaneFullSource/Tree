local var0 = class("GuildCommanderFormationPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "GuildCommanderFormationUI"
end

function var0.OnInit(arg0)
	arg0.samllTF = arg0:findTF("small")

	setActive(arg0.samllTF, true)

	arg0.pos1 = arg0:findTF("small/commander1", arg0.topPanel)
	arg0.pos2 = arg0:findTF("small/commander2", arg0.topPanel)
	arg0.descPanel = arg0:findTF("desc")

	setActive(arg0.descPanel, false)

	arg0.descFrameTF = arg0:findTF("desc/frame")
	arg0.descPos1 = arg0:findTF("commander1/frame/info", arg0.descFrameTF)
	arg0.descPos2 = arg0:findTF("commander2/frame/info", arg0.descFrameTF)
	arg0.skillTFPos1 = arg0:findTF("commander1/skill_info", arg0.descFrameTF)
	arg0.skillTFPos2 = arg0:findTF("commander2/skill_info", arg0.descFrameTF)
	arg0.abilitysTF = UIItemList.New(arg0:findTF("atttr_panel/abilitys/mask/content", arg0.descFrameTF), arg0:findTF("atttr_panel/abilitys/mask/content/attr", arg0.descFrameTF))
	arg0.talentsTF = UIItemList.New(arg0:findTF("atttr_panel/talents/mask/content", arg0.descFrameTF), arg0:findTF("atttr_panel/talents/mask/content/attr", arg0.descFrameTF))
	arg0.abilityArr = arg0:findTF("desc/frame/atttr_panel/abilitys/arr")
	arg0.talentsArr = arg0:findTF("desc/frame/atttr_panel/talents/arr")
	arg0.restAllBtn = arg0:findTF("rest_all", arg0.descFrameTF)
	arg0.quickBtn = arg0:findTF("quick_btn", arg0.descFrameTF)
	arg0.recordPanel = arg0:findTF("record_panel")
	arg0.recordCommanders = {
		arg0.recordPanel:Find("current/commanders/commander1/frame/info"),
		arg0.recordPanel:Find("current/commanders/commander2/frame/info")
	}
	arg0.reocrdSkills = {
		arg0.recordPanel:Find("current/commanders/commander1/skill_info"),
		arg0.recordPanel:Find("current/commanders/commander2/skill_info")
	}
	arg0.recordList = UIItemList.New(arg0.recordPanel:Find("record/content"), arg0.recordPanel:Find("record/content/commanders"))

	onButton(arg0, arg0.samllTF, function()
		arg0:openDescPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.descPanel, function()
		arg0:closeDescPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.restAllBtn, function()
		if not arg0.fleet:ExistAnyCommander() then
			return
		end

		arg0:emit(GuildEventMediator.COMMANDER_FORMATION_OP, {
			data = {
				fleet = arg0.fleet,
				type = LevelUIConst.COMMANDER_OP_REST_ALL
			},
			fleetId = arg0.fleet.id
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.quickBtn, function()
		arg0:OpenRecordPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.recordPanel:Find("back"), function()
		arg0:CloseRecordPanel()
	end, SFX_PANEL)
	arg0:Show()
end

function var0.Update(arg0, arg1, arg2)
	arg0.fleet = arg1
	arg0.prefabFleets = arg2

	local var0 = arg0.fleet:getCommanders()

	for iter0 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1 = var0[iter0]

		assert(arg0["pos" .. iter0], "pos tf can not nil")
		arg0:updateCommander(arg0["pos" .. iter0], iter0, var1)
	end

	arg0:updateDesc()
	arg0:updateRecordPanel()
end

function var0.openDescPanel(arg0, arg1)
	local var0 = arg1 or 0.2

	if LeanTween.isTweening(go(arg0.samllTF)) or LeanTween.isTweening(go(arg0.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0.samllTF, {
		x = -108
	})
	LeanTween.moveX(arg0.samllTF, 1500, var0):setOnComplete(System.Action(function()
		setActive(arg0.descPanel, true)
		setAnchoredPosition(arg0.descFrameTF, {
			x = 1500
		})
		LeanTween.moveX(arg0.descFrameTF, -108, var0)
	end))

	arg0.contextData.inDescPage = true

	arg0._tf:SetAsLastSibling()
end

function var0.closeDescPanel(arg0, arg1)
	local var0 = arg1 or 0.2

	if LeanTween.isTweening(go(arg0.samllTF)) or LeanTween.isTweening(go(arg0.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0.descFrameTF, {
		x = -108
	})
	LeanTween.moveX(arg0.descFrameTF, 1500, var0):setOnComplete(System.Action(function()
		setActive(arg0.descPanel, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)
		setAnchoredPosition(arg0.samllTF, {
			x = 1500
		})
		LeanTween.moveX(arg0.samllTF, -108, var0)
	end))

	arg0.contextData.inDescPage = false
end

function var0.updateDesc(arg0)
	local var0 = arg0.fleet:getCommanders()

	for iter0 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1 = var0[iter0]

		assert(arg0["pos" .. iter0], "pos tf can not nil")
		arg0:updateCommander(arg0["descPos" .. iter0], iter0, var1, true)
		arg0:updateSkillTF(var1, arg0["skillTFPos" .. iter0])
	end

	arg0:updateAdditions()
end

function var0.updateAdditions(arg0)
	local var0 = arg0.fleet
	local var1 = _.values(var0:getCommandersTalentDesc())
	local var2, var3 = var0:getCommandersAddition()

	arg0.abilitysTF:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1 + 1]

			setText(arg2:Find("name"), AttributeType.Type2Name(var0.attrName))
			setText(arg2:Find("Text"), ("+" .. math.floor(var0.value * 1000) / 1000) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0.attrName, arg2:Find("icon"), false)
			setImageAlpha(arg2:Find("bg"), arg1 % 2)
		end
	end)
	arg0.abilitysTF:align(#var2)
	setActive(arg0.abilityArr, #var2 > 4)
	arg0.talentsTF:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]

			setScrollText(findTF(arg2, "name_mask/name"), var0.name)

			local var1 = var0.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2:Find("Text"), (var0.value > 0 and "+" or "") .. var0.value .. var1)
			setImageAlpha(arg2:Find("bg"), arg1 % 2)
		end
	end)
	arg0.talentsTF:align(#var1)
	setActive(arg0.talentsArr, #var1 > 4)
	Canvas.ForceUpdateCanvases()
end

function var0.updateSkillTF(arg0, arg1, arg2)
	setActive(arg2, arg1)

	if arg1 then
		local var0 = arg1:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0:getConfig("icon"), "", arg2:Find("icon"))
		setText(arg2:Find("level"), "Lv." .. var0:getLevel())
		onButton(arg0, arg2, function()
			arg0:emit(GuildEventMediator.ON_CMD_SKILL, var0)
		end, SFX_PANEL)
	else
		removeOnButton(arg2)
	end
end

function var0.updateCommander(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:Find("add")
	local var1 = arg1:Find("info")

	if arg3 then
		local var2 = arg1:Find("info/mask/icon")
		local var3 = arg1:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. arg3:getPainting(), "", var2)

		local var4 = arg1:Find("info/name")

		if var4 then
			setText(var4, arg3:getName())
		end

		local var5 = Commander.rarity2Frame(arg3:getRarity())

		setImageSprite(var3, GetSpriteFromAtlas("weaponframes", "commander_" .. var5))
	end

	if arg4 then
		onButton(arg0, var1, function()
			arg0:emit(GuildEventMediator.ON_SELECT_COMMANDER, arg0.fleet.id, arg2, arg3)
		end, SFX_PANEL)
		onButton(arg0, var0, function()
			arg0:emit(GuildEventMediator.ON_SELECT_COMMANDER, arg0.fleet.id, arg2, arg3)
		end, SFX_PANEL)
	end

	setActive(var0, not arg3)
	setActive(var1, arg3)
end

function var0.OpenRecordPanel(arg0)
	setActive(arg0.descFrameTF, false)
	setActive(arg0.recordPanel, true)
end

function var0.updateRecordPanel(arg0)
	local var0 = arg0.fleet:getCommanders()

	for iter0, iter1 in ipairs(arg0.recordCommanders) do
		local var1 = var0[iter0]

		arg0:updateCommander(iter1, iter0, var1)
		arg0:updateSkillTF(var1, arg0.reocrdSkills[iter0])
	end

	arg0.recordList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.prefabFleets[arg1 + 1]

			arg0:UpdatePrefabFleet(var0, arg2, var0)
		end
	end)
	arg0.recordList:align(#arg0.prefabFleets)
end

function var0.UpdatePrefabFleet(arg0, arg1, arg2, arg3)
	local var0 = arg2:Find("fleet_name")
	local var1 = arg1:getName()

	onInputEndEdit(arg0, var0, function()
		local var0 = getInputText(var0)

		arg0:emit(GuildEventMediator.COMMANDER_FORMATION_OP, {
			data = {
				fleet = arg0.fleet,
				type = LevelUIConst.COMMANDER_OP_RENAME,
				id = arg1.id,
				str = var0,
				onFailed = function()
					setInputText(var0, var1)
				end
			},
			fleetId = arg0.fleet.id
		})
	end)
	setInputText(var0, var1)
	onButton(arg0, arg2:Find("use_btn"), function()
		arg0:emit(GuildEventMediator.COMMANDER_FORMATION_OP, {
			data = {
				fleet = arg0.fleet,
				type = LevelUIConst.COMMANDER_OP_USE_PREFAB,
				id = arg1.id
			},
			fleetId = arg0.fleet.id
		})
		arg0:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0, arg2:Find("record_btn"), function()
		arg0:emit(GuildEventMediator.COMMANDER_FORMATION_OP, {
			data = {
				fleet = arg0.fleet,
				type = LevelUIConst.COMMANDER_OP_RECORD_PREFAB,
				id = arg1.id
			},
			fleetId = arg0.fleet.id
		})
	end, SFX_PANEL)

	local var2 = {
		arg2:Find("commander1/frame/info"),
		arg2:Find("commander2/frame/info")
	}
	local var3 = {
		arg2:Find("commander1/skill_info"),
		arg2:Find("commander2/skill_info")
	}

	for iter0, iter1 in ipairs(var2) do
		local var4 = arg1:getCommanderByPos(iter0)

		arg0:updateCommander(iter1, iter0, var4)
		arg0:updateSkillTF(var4, var3[iter0])
	end
end

function var0.CloseRecordPanel(arg0)
	setActive(arg0.descFrameTF, true)
	setActive(arg0.recordPanel, false)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		LeanTween.cancel(go(arg0.samllTF))
		LeanTween.cancel(go(arg0.descFrameTF))
	end
end

return var0
