local var0_0 = class("LevelCMDFormationView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LevelCommanderView"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"attricon",
		"weaponframes"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.getLevelCMDFormationViewResList(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}

	local function var1_3(arg0_4)
		if not arg0_4 then
			return
		end

		local var0_4 = arg0_4:getPainting()

		if noEmptyStr(var0_4) then
			local var1_4 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.Commander.CommanderHrz, var0_4)

			table.insert(var0_3, var1_4)
		end

		local var2_4 = arg0_4:getSkills()[1]
		local var3_4 = var2_4 and var2_4:getConfig("icon")

		if noEmptyStr(var3_4) then
			local var4_4 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.Commander.CommanderSkillIcon, var3_4)

			table.insert(var0_3, var4_4)
		end
	end

	if arg1_3 then
		_.each(arg1_3:getCommanders(), var1_3)
	end

	_.each(arg2_3 or {}, function(arg0_5)
		if arg0_5 then
			for iter0_5 = 1, CommanderConst.MAX_FORMATION_POS do
				var1_3(arg0_5:getCommanderByPos(iter0_5))
			end
		end
	end)

	return var0_3
end

function var0_0.downloadLevelCMDFormationViewResList(arg0_6, arg1_6, arg2_6, arg3_6)
	SplitPackConst.DownloadByLuaArr(arg0_6:getLevelCMDFormationViewResList(arg1_6, arg2_6), function()
		if arg0_6._state == var0_0.STATES.DESTROY then
			return
		end

		arg3_6()
	end)
end

function var0_0.OnInit(arg0_8)
	arg0_8:InitUI()
end

function var0_0.OnDestroy(arg0_9)
	if arg0_9:isShowing() then
		arg0_9:Hide()
	end

	arg0_9.callback = nil
end

function var0_0.Show(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)
	setActive(arg0_10._tf, true)
end

function var0_0.Hide(arg0_11)
	setActive(arg0_11._go, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11._tf, arg0_11._parentTf)
end

function var0_0.InitUI(arg0_12)
	arg0_12.descFrameTF = arg0_12._tf:Find("frame")
	arg0_12.descPos1 = arg0_12.descFrameTF:Find("commander1/frame/info")
	arg0_12.descPos2 = arg0_12.descFrameTF:Find("commander2/frame/info")
	arg0_12.skillTFPos1 = arg0_12.descFrameTF:Find("commander1/skill_info")
	arg0_12.skillTFPos2 = arg0_12.descFrameTF:Find("commander2/skill_info")
	arg0_12.abilitysTF = UIItemList.New(arg0_12.descFrameTF:Find("atttr_panel/abilitys/mask/content"), arg0_12.descFrameTF:Find("atttr_panel/abilitys/mask/content/attr"))
	arg0_12.talentsTF = UIItemList.New(arg0_12.descFrameTF:Find("atttr_panel/talents/mask/content"), arg0_12.descFrameTF:Find("atttr_panel/talents/mask/content/attr"))
	arg0_12.abilityArr = arg0_12._tf:Find("frame/atttr_panel/abilitys/arr")
	arg0_12.talentsArr = arg0_12._tf:Find("frame/atttr_panel/talents/arr")
	arg0_12.restAllBtn = arg0_12.descFrameTF:Find("rest_all")
	arg0_12.quickBtn = arg0_12.descFrameTF:Find("quick_btn")
	arg0_12.recordPanel = arg0_12._tf:Find("record_panel")
	arg0_12.recordCommanders = {
		arg0_12.recordPanel:Find("current/commanders/commander1/frame/info"),
		arg0_12.recordPanel:Find("current/commanders/commander2/frame/info")
	}
	arg0_12.reocrdSkills = {
		arg0_12.recordPanel:Find("current/commanders/commander1/skill_info"),
		arg0_12.recordPanel:Find("current/commanders/commander2/skill_info")
	}
	arg0_12.recordList = UIItemList.New(arg0_12.recordPanel:Find("record/content"), arg0_12.recordPanel:Find("record/content/commanders"))

	onButton(arg0_12, arg0_12.restAllBtn, function()
		arg0_12.callback({
			type = LevelUIConst.COMMANDER_OP_REST_ALL
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.quickBtn, function()
		arg0_12:OpenRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.recordPanel:Find("back"), function()
		arg0_12:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12._tf:Find("bg"), function()
		arg0_12:Hide()
	end, SFX_PANEL)
end

function var0_0.setCallback(arg0_17, arg1_17)
	arg0_17.callback = arg1_17
end

function var0_0.update(arg0_18, arg1_18, arg2_18)
	arg0_18:downloadLevelCMDFormationViewResList(arg1_18, arg2_18, function()
		arg0_18:updateFleet(arg1_18)
		arg0_18:updatePrefabs(arg2_18)
	end)
end

function var0_0.updateFleet(arg0_20, arg1_20)
	arg0_20.fleet = arg1_20

	arg0_20:updateDesc()
	arg0_20:updateRecordFleet()
end

function var0_0.updatePrefabs(arg0_21, arg1_21)
	arg0_21.prefabFleets = arg1_21

	arg0_21:updateRecordPanel()
end

function var0_0.updateRecordFleet(arg0_22)
	local var0_22 = arg0_22.fleet:getCommanders()

	for iter0_22, iter1_22 in ipairs(arg0_22.recordCommanders) do
		local var1_22 = var0_22[iter0_22]

		arg0_22:updateCommander(iter1_22, iter0_22, var1_22)
		arg0_22:updateSkillTF(var1_22, arg0_22.reocrdSkills[iter0_22])
	end
end

function var0_0.updateRecordPanel(arg0_23)
	local var0_23 = arg0_23.fleet:getCommanders()

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

		arg0_25.callback({
			type = LevelUIConst.COMMANDER_OP_RENAME,
			id = arg1_25.id,
			str = var0_26,
			onFailed = function()
				setInputText(var0_25, var1_25)
			end
		})
	end)
	setInputText(var0_25, var1_25)
	onButton(arg0_25, arg2_25:Find("use_btn"), function()
		arg0_25.callback({
			type = LevelUIConst.COMMANDER_OP_USE_PREFAB,
			id = arg1_25.id
		})
		arg0_25:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_25, arg2_25:Find("record_btn"), function()
		arg0_25.callback({
			type = LevelUIConst.COMMANDER_OP_RECORD_PREFAB,
			id = arg1_25.id
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

function var0_0.updateDesc(arg0_30)
	local var0_30 = arg0_30.fleet:getCommanders()

	for iter0_30 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_30 = var0_30[iter0_30]

		arg0_30:updateCommander(arg0_30["descPos" .. iter0_30], iter0_30, var1_30, true)
		arg0_30:updateSkillTF(var1_30, arg0_30["skillTFPos" .. iter0_30])
	end

	arg0_30:updateAdditions()
end

function var0_0.updateAdditions(arg0_31)
	local var0_31 = arg0_31.fleet
	local var1_31 = _.values(var0_31:getCommandersTalentDesc())
	local var2_31, var3_31 = var0_31:getCommandersAddition()

	arg0_31.abilitysTF:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = var2_31[arg1_32 + 1]

			setText(arg2_32:Find("name"), AttributeType.Type2Name(var0_32.attrName))
			setText(arg2_32:Find("Text"), string.format("%0.3f", var0_32.value) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0_32.attrName, arg2_32:Find("icon"), false)
			setImageAlpha(arg2_32:Find("bg"), arg1_32 % 2)
		end
	end)
	arg0_31.abilitysTF:align(#var2_31)
	setActive(arg0_31.abilityArr, #var2_31 > 4)
	arg0_31.talentsTF:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = var1_31[arg1_33 + 1]

			setScrollText(findTF(arg2_33, "name_mask/name"), var0_33.name)

			local var1_33 = var0_33.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_33:Find("Text"), var0_33.value .. var1_33)
			setImageAlpha(arg2_33:Find("bg"), arg1_33 % 2)
		end
	end)
	arg0_31.talentsTF:align(#var1_31)
	setActive(arg0_31.talentsArr, #var1_31 > 4)
end

function var0_0.updateSkillTF(arg0_34, arg1_34, arg2_34)
	setActive(arg2_34, arg1_34)

	if arg1_34 then
		local var0_34 = arg1_34:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0_34:getConfig("icon"), "", arg2_34:Find("icon"))
		setText(arg2_34:Find("level"), "Lv." .. var0_34:getLevel())
		onButton(arg0_34, arg2_34, function()
			arg0_34.callback({
				type = LevelUIConst.COMMANDER_OP_SHOW_SKILL,
				skill = var0_34
			})
		end, SFX_PANEL)
	else
		removeOnButton(arg2_34)
	end
end

function var0_0.updateCommander(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	local var0_36 = arg1_36:Find("add")
	local var1_36 = arg1_36:Find("info")

	if arg3_36 then
		local var2_36 = arg1_36:Find("info/mask/icon")
		local var3_36 = arg1_36:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. arg3_36:getPainting(), "", var2_36)

		local var4_36 = arg1_36:Find("info/name")

		if var4_36 then
			setText(var4_36, arg3_36:getName())
		end

		local var5_36 = Commander.rarity2Frame(arg3_36:getRarity())

		setImageSprite(var3_36, GetSpriteFromAtlas("weaponframes", "commander_" .. var5_36))
	end

	if arg4_36 then
		onButton(arg0_36, var1_36, function()
			arg0_36.callback({
				type = LevelUIConst.COMMANDER_OP_ADD,
				pos = arg2_36
			})
		end, SFX_PANEL)
		onButton(arg0_36, var0_36, function()
			arg0_36.callback({
				type = LevelUIConst.COMMANDER_OP_ADD,
				pos = arg2_36
			})
		end, SFX_PANEL)
	end

	setActive(var0_36, not arg3_36)
	setActive(var1_36, arg3_36)
end

function var0_0.OpenRecordPanel(arg0_39)
	setActive(arg0_39.descFrameTF, false)
	setActive(arg0_39.recordPanel, true)
end

function var0_0.CloseRecordPanel(arg0_40)
	setActive(arg0_40.descFrameTF, true)
	setActive(arg0_40.recordPanel, false)
end

return var0_0
