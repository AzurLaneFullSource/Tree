local var0_0 = class("LevelCMDFormationView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "LevelCommanderView"
end

function var0_0.OnInit(arg0_2)
	arg0_2:InitUI()
end

function var0_0.OnDestroy(arg0_3)
	if arg0_3:isShowing() then
		arg0_3:Hide()
	end

	arg0_3.callback = nil
end

function var0_0.Show(arg0_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
	setActive(arg0_4._tf, true)
end

function var0_0.Hide(arg0_5)
	setActive(arg0_5._go, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_5._tf, arg0_5._parentTf)
end

function var0_0.InitUI(arg0_6)
	arg0_6.descFrameTF = arg0_6:findTF("frame")
	arg0_6.descPos1 = arg0_6:findTF("commander1/frame/info", arg0_6.descFrameTF)
	arg0_6.descPos2 = arg0_6:findTF("commander2/frame/info", arg0_6.descFrameTF)
	arg0_6.skillTFPos1 = arg0_6:findTF("commander1/skill_info", arg0_6.descFrameTF)
	arg0_6.skillTFPos2 = arg0_6:findTF("commander2/skill_info", arg0_6.descFrameTF)
	arg0_6.abilitysTF = UIItemList.New(arg0_6:findTF("atttr_panel/abilitys/mask/content", arg0_6.descFrameTF), arg0_6:findTF("atttr_panel/abilitys/mask/content/attr", arg0_6.descFrameTF))
	arg0_6.talentsTF = UIItemList.New(arg0_6:findTF("atttr_panel/talents/mask/content", arg0_6.descFrameTF), arg0_6:findTF("atttr_panel/talents/mask/content/attr", arg0_6.descFrameTF))
	arg0_6.abilityArr = arg0_6:findTF("frame/atttr_panel/abilitys/arr")
	arg0_6.talentsArr = arg0_6:findTF("frame/atttr_panel/talents/arr")
	arg0_6.restAllBtn = arg0_6:findTF("rest_all", arg0_6.descFrameTF)
	arg0_6.quickBtn = arg0_6:findTF("quick_btn", arg0_6.descFrameTF)
	arg0_6.recordPanel = arg0_6:findTF("record_panel")
	arg0_6.recordCommanders = {
		arg0_6.recordPanel:Find("current/commanders/commander1/frame/info"),
		arg0_6.recordPanel:Find("current/commanders/commander2/frame/info")
	}
	arg0_6.reocrdSkills = {
		arg0_6.recordPanel:Find("current/commanders/commander1/skill_info"),
		arg0_6.recordPanel:Find("current/commanders/commander2/skill_info")
	}
	arg0_6.recordList = UIItemList.New(arg0_6.recordPanel:Find("record/content"), arg0_6.recordPanel:Find("record/content/commanders"))

	onButton(arg0_6, arg0_6.restAllBtn, function()
		arg0_6.callback({
			type = LevelUIConst.COMMANDER_OP_REST_ALL
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.quickBtn, function()
		arg0_6:OpenRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.recordPanel:Find("back"), function()
		arg0_6:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._tf:Find("bg"), function()
		arg0_6:Hide()
	end, SFX_PANEL)
end

function var0_0.setCallback(arg0_11, arg1_11)
	arg0_11.callback = arg1_11
end

function var0_0.update(arg0_12, arg1_12, arg2_12)
	arg0_12:updateFleet(arg1_12)
	arg0_12:updatePrefabs(arg2_12)
end

function var0_0.updateFleet(arg0_13, arg1_13)
	arg0_13.fleet = arg1_13

	arg0_13:updateDesc()
	arg0_13:updateRecordFleet()
end

function var0_0.updatePrefabs(arg0_14, arg1_14)
	arg0_14.prefabFleets = arg1_14

	arg0_14:updateRecordPanel()
end

function var0_0.updateRecordFleet(arg0_15)
	local var0_15 = arg0_15.fleet:getCommanders()

	for iter0_15, iter1_15 in ipairs(arg0_15.recordCommanders) do
		local var1_15 = var0_15[iter0_15]

		arg0_15:updateCommander(iter1_15, iter0_15, var1_15)
		arg0_15:updateSkillTF(var1_15, arg0_15.reocrdSkills[iter0_15])
	end
end

function var0_0.updateRecordPanel(arg0_16)
	local var0_16 = arg0_16.fleet:getCommanders()

	arg0_16.recordList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg0_16.prefabFleets[arg1_17 + 1]

			arg0_16:UpdatePrefabFleet(var0_17, arg2_17, var0_16)
		end
	end)
	arg0_16.recordList:align(#arg0_16.prefabFleets)
end

function var0_0.UpdatePrefabFleet(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg2_18:Find("fleet_name")
	local var1_18 = arg1_18:getName()

	onInputEndEdit(arg0_18, var0_18, function()
		local var0_19 = getInputText(var0_18)

		arg0_18.callback({
			type = LevelUIConst.COMMANDER_OP_RENAME,
			id = arg1_18.id,
			str = var0_19,
			onFailed = function()
				setInputText(var0_18, var1_18)
			end
		})
	end)
	setInputText(var0_18, var1_18)
	onButton(arg0_18, arg2_18:Find("use_btn"), function()
		arg0_18.callback({
			type = LevelUIConst.COMMANDER_OP_USE_PREFAB,
			id = arg1_18.id
		})
		arg0_18:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(arg0_18, arg2_18:Find("record_btn"), function()
		arg0_18.callback({
			type = LevelUIConst.COMMANDER_OP_RECORD_PREFAB,
			id = arg1_18.id
		})
	end, SFX_PANEL)

	local var2_18 = {
		arg2_18:Find("commander1/frame/info"),
		arg2_18:Find("commander2/frame/info")
	}
	local var3_18 = {
		arg2_18:Find("commander1/skill_info"),
		arg2_18:Find("commander2/skill_info")
	}

	for iter0_18, iter1_18 in ipairs(var2_18) do
		local var4_18 = arg1_18:getCommanderByPos(iter0_18)

		arg0_18:updateCommander(iter1_18, iter0_18, var4_18)
		arg0_18:updateSkillTF(var4_18, var3_18[iter0_18])
	end
end

function var0_0.updateDesc(arg0_23)
	local var0_23 = arg0_23.fleet:getCommanders()

	for iter0_23 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_23 = var0_23[iter0_23]

		arg0_23:updateCommander(arg0_23["descPos" .. iter0_23], iter0_23, var1_23, true)
		arg0_23:updateSkillTF(var1_23, arg0_23["skillTFPos" .. iter0_23])
	end

	arg0_23:updateAdditions()
end

function var0_0.updateAdditions(arg0_24)
	local var0_24 = arg0_24.fleet
	local var1_24 = _.values(var0_24:getCommandersTalentDesc())
	local var2_24, var3_24 = var0_24:getCommandersAddition()

	arg0_24.abilitysTF:make(function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			local var0_25 = var2_24[arg1_25 + 1]

			setText(arg2_25:Find("name"), AttributeType.Type2Name(var0_25.attrName))
			setText(arg2_25:Find("Text"), string.format("%0.3f", var0_25.value) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0_25.attrName, arg2_25:Find("icon"), false)
			setImageAlpha(arg2_25:Find("bg"), arg1_25 % 2)
		end
	end)
	arg0_24.abilitysTF:align(#var2_24)
	setActive(arg0_24.abilityArr, #var2_24 > 4)
	arg0_24.talentsTF:make(function(arg0_26, arg1_26, arg2_26)
		if arg0_26 == UIItemList.EventUpdate then
			local var0_26 = var1_24[arg1_26 + 1]

			setScrollText(findTF(arg2_26, "name_mask/name"), var0_26.name)

			local var1_26 = var0_26.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_26:Find("Text"), var0_26.value .. var1_26)
			setImageAlpha(arg2_26:Find("bg"), arg1_26 % 2)
		end
	end)
	arg0_24.talentsTF:align(#var1_24)
	setActive(arg0_24.talentsArr, #var1_24 > 4)
end

function var0_0.updateSkillTF(arg0_27, arg1_27, arg2_27)
	setActive(arg2_27, arg1_27)

	if arg1_27 then
		local var0_27 = arg1_27:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0_27:getConfig("icon"), "", arg2_27:Find("icon"))
		setText(arg2_27:Find("level"), "Lv." .. var0_27:getLevel())
		onButton(arg0_27, arg2_27, function()
			arg0_27.callback({
				type = LevelUIConst.COMMANDER_OP_SHOW_SKILL,
				skill = var0_27
			})
		end, SFX_PANEL)
	else
		removeOnButton(arg2_27)
	end
end

function var0_0.updateCommander(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29)
	local var0_29 = arg1_29:Find("add")
	local var1_29 = arg1_29:Find("info")

	if arg3_29 then
		local var2_29 = arg1_29:Find("info/mask/icon")
		local var3_29 = arg1_29:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. arg3_29:getPainting(), "", var2_29)

		local var4_29 = arg1_29:Find("info/name")

		if var4_29 then
			setText(var4_29, arg3_29:getName())
		end

		local var5_29 = Commander.rarity2Frame(arg3_29:getRarity())

		setImageSprite(var3_29, GetSpriteFromAtlas("weaponframes", "commander_" .. var5_29))
	end

	if arg4_29 then
		onButton(arg0_29, var1_29, function()
			arg0_29.callback({
				type = LevelUIConst.COMMANDER_OP_ADD,
				pos = arg2_29
			})
		end, SFX_PANEL)
		onButton(arg0_29, var0_29, function()
			arg0_29.callback({
				type = LevelUIConst.COMMANDER_OP_ADD,
				pos = arg2_29
			})
		end, SFX_PANEL)
	end

	setActive(var0_29, not arg3_29)
	setActive(var1_29, arg3_29)
end

function var0_0.OpenRecordPanel(arg0_32)
	setActive(arg0_32.descFrameTF, false)
	setActive(arg0_32.recordPanel, true)
end

function var0_0.CloseRecordPanel(arg0_33)
	setActive(arg0_33.descFrameTF, true)
	setActive(arg0_33.recordPanel, false)
end

return var0_0
