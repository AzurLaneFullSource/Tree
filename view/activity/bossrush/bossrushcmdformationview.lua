local var0_0 = class("LevelCMDFormationView", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "LevelCommanderView"
end

function var0_0.init(arg0_2)
	arg0_2.descFrameTF = arg0_2:findTF("frame")
	arg0_2.descPos1 = arg0_2:findTF("commander1/frame/info", arg0_2.descFrameTF)
	arg0_2.descPos2 = arg0_2:findTF("commander2/frame/info", arg0_2.descFrameTF)
	arg0_2.skillTFPos1 = arg0_2:findTF("commander1/skill_info", arg0_2.descFrameTF)
	arg0_2.skillTFPos2 = arg0_2:findTF("commander2/skill_info", arg0_2.descFrameTF)
	arg0_2.abilitysTF = UIItemList.New(arg0_2:findTF("atttr_panel/abilitys/mask/content", arg0_2.descFrameTF), arg0_2:findTF("atttr_panel/abilitys/mask/content/attr", arg0_2.descFrameTF))
	arg0_2.talentsTF = UIItemList.New(arg0_2:findTF("atttr_panel/talents/mask/content", arg0_2.descFrameTF), arg0_2:findTF("atttr_panel/talents/mask/content/attr", arg0_2.descFrameTF))
	arg0_2.abilityArr = arg0_2:findTF("frame/atttr_panel/abilitys/arr")
	arg0_2.talentsArr = arg0_2:findTF("frame/atttr_panel/talents/arr")
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

	onButton(arg0_2, arg0_2.restAllBtn, function()
		arg0_2.callback({
			type = LevelUIConst.COMMANDER_OP_REST_ALL
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.quickBtn, function()
		arg0_2:OpenRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.recordPanel:Find("back"), function()
		arg0_2:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:onBackPressed()
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
end

function var0_0.willExit(arg0_8)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf)
end

function var0_0.setCallback(arg0_9, arg1_9)
	arg0_9.callback = arg1_9
end

function var0_0.updateFleet(arg0_10, arg1_10)
	arg0_10.fleet = arg1_10

	arg0_10:updateDesc()
	arg0_10:updateRecordFleet()
end

function var0_0.setCommanderPrefabs(arg0_11, arg1_11)
	arg0_11.prefabFleets = arg1_11

	arg0_11:updateRecordPanel()
end

function var0_0.updateRecordFleet(arg0_12)
	local var0_12 = arg0_12.fleet:getCommanders()

	for iter0_12, iter1_12 in ipairs(arg0_12.recordCommanders) do
		local var1_12 = var0_12[iter0_12]

		arg0_12:updateCommander(iter1_12, iter0_12, var1_12)
		arg0_12:updateSkillTF(var1_12, arg0_12.reocrdSkills[iter0_12])
	end
end

function var0_0.updateRecordPanel(arg0_13)
	local var0_13 = arg0_13.fleet:getCommanders()

	arg0_13.recordList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg0_13.prefabFleets[arg1_14 + 1]

			arg0_13:UpdatePrefabFleet(var0_14, arg2_14, var0_13)
		end
	end)
	arg0_13.recordList:align(#arg0_13.prefabFleets)
end

function var0_0.UpdatePrefabFleet(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = arg2_15:Find("fleet_name")
	local var1_15 = arg1_15:getName()

	onInputEndEdit(arg0_15, var0_15, function()
		local var0_16 = getInputText(var0_15)

		arg0_15.callback({
			type = LevelUIConst.COMMANDER_OP_RENAME,
			id = arg1_15.id,
			str = var0_16,
			onFailed = function()
				setInputText(var0_15, var1_15)
			end
		})
	end)
	setInputText(var0_15, var1_15)
	onButton(arg0_15, arg2_15:Find("use_btn"), function()
		arg0_15.callback({
			type = LevelUIConst.COMMANDER_OP_USE_PREFAB,
			id = arg1_15.id
		})
		arg0_15:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_15, arg2_15:Find("record_btn"), function()
		arg0_15.callback({
			type = LevelUIConst.COMMANDER_OP_RECORD_PREFAB,
			id = arg1_15.id
		})
	end, SFX_PANEL)

	local var2_15 = {
		arg2_15:Find("commander1/frame/info"),
		arg2_15:Find("commander2/frame/info")
	}
	local var3_15 = {
		arg2_15:Find("commander1/skill_info"),
		arg2_15:Find("commander2/skill_info")
	}

	for iter0_15, iter1_15 in ipairs(var2_15) do
		local var4_15 = arg1_15:getCommanderByPos(iter0_15)

		arg0_15:updateCommander(iter1_15, iter0_15, var4_15)
		arg0_15:updateSkillTF(var4_15, var3_15[iter0_15])
	end
end

function var0_0.updateDesc(arg0_20)
	local var0_20 = arg0_20.fleet:getCommanders()

	for iter0_20 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_20 = var0_20[iter0_20]

		arg0_20:updateCommander(arg0_20["descPos" .. iter0_20], iter0_20, var1_20, true)
		arg0_20:updateSkillTF(var1_20, arg0_20["skillTFPos" .. iter0_20])
	end

	arg0_20:updateAdditions()
end

function var0_0.updateAdditions(arg0_21)
	local var0_21 = arg0_21.fleet
	local var1_21 = _.values(var0_21:getCommandersTalentDesc())
	local var2_21, var3_21 = var0_21:getCommandersAddition()

	arg0_21.abilitysTF:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var2_21[arg1_22 + 1]

			setText(arg2_22:Find("name"), AttributeType.Type2Name(var0_22.attrName))
			setText(arg2_22:Find("Text"), string.format("%0.3f", var0_22.value) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0_22.attrName, arg2_22:Find("icon"), false)
			setImageAlpha(arg2_22:Find("bg"), arg1_22 % 2)
		end
	end)
	arg0_21.abilitysTF:align(#var2_21)
	setActive(arg0_21.abilityArr, #var2_21 > 4)
	arg0_21.talentsTF:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = var1_21[arg1_23 + 1]

			setScrollText(findTF(arg2_23, "name_mask/name"), var0_23.name)

			local var1_23 = var0_23.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_23:Find("Text"), var0_23.value .. var1_23)
			setImageAlpha(arg2_23:Find("bg"), arg1_23 % 2)
		end
	end)
	arg0_21.talentsTF:align(#var1_21)
	setActive(arg0_21.talentsArr, #var1_21 > 4)
end

function var0_0.updateSkillTF(arg0_24, arg1_24, arg2_24)
	setActive(arg2_24, arg1_24)

	if arg1_24 then
		local var0_24 = arg1_24:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0_24:getConfig("icon"), "", arg2_24:Find("icon"))
		setText(arg2_24:Find("level"), "Lv." .. var0_24:getLevel())
		onButton(arg0_24, arg2_24, function()
			arg0_24.callback({
				type = LevelUIConst.COMMANDER_OP_SHOW_SKILL,
				skill = var0_24
			})
		end, SFX_PANEL)
	else
		removeOnButton(arg2_24)
	end
end

function var0_0.updateCommander(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	local var0_26 = arg1_26:Find("add")
	local var1_26 = arg1_26:Find("info")

	if arg3_26 then
		local var2_26 = arg1_26:Find("info/mask/icon")
		local var3_26 = arg1_26:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. arg3_26:getPainting(), "", var2_26)

		local var4_26 = arg1_26:Find("info/name")

		if var4_26 then
			setText(var4_26, arg3_26:getName())
		end

		local var5_26 = Commander.rarity2Frame(arg3_26:getRarity())

		setImageSprite(var3_26, GetSpriteFromAtlas("weaponframes", "commander_" .. var5_26))
	end

	if arg4_26 then
		onButton(arg0_26, var1_26, function()
			arg0_26.callback({
				type = LevelUIConst.COMMANDER_OP_ADD,
				pos = arg2_26
			})
		end, SFX_PANEL)
		onButton(arg0_26, var0_26, function()
			arg0_26.callback({
				type = LevelUIConst.COMMANDER_OP_ADD,
				pos = arg2_26
			})
		end, SFX_PANEL)
	end

	setActive(var0_26, not arg3_26)
	setActive(var1_26, arg3_26)
end

function var0_0.OpenRecordPanel(arg0_29)
	setActive(arg0_29.descFrameTF, false)
	setActive(arg0_29.recordPanel, true)
end

function var0_0.CloseRecordPanel(arg0_30)
	setActive(arg0_30.descFrameTF, true)
	setActive(arg0_30.recordPanel, false)
end

return var0_0
