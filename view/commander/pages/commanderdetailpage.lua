local var0_0 = class("CommanderDetailPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderDetailUI"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
	var0_0.super.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2:Load()
end

function var0_0.RegisterEvent(arg0_3)
	arg0_3:bind(CommanderCatScene.EVENT_CLOSE_DESC, function(arg0_4)
		triggerToggle(arg0_3.skillBtn, false)
		triggerToggle(arg0_3.additionBtn, false)
		triggerToggle(arg0_3.otherBtn, false)
	end)
	arg0_3:bind(CommanderCatScene.EVENT_FOLD, function(arg0_5, arg1_5)
		triggerToggle(arg0_3.skillBtn, false)
		triggerToggle(arg0_3.additionBtn, false)
		triggerToggle(arg0_3.otherBtn, false)

		if arg1_5 then
			LeanTween.moveY(rtf(arg0_3.commanderInfo), -400, 0.5)
		else
			LeanTween.moveY(rtf(arg0_3.commanderInfo), 71, 0.5)
		end
	end)
	arg0_3:bind(CommanderCatScene.EVENT_PREVIEW, function(arg0_6, arg1_6)
		arg0_3:UpdatePreView(arg1_6)
	end)
	arg0_3:bind(CommanderCatScene.EVENT_PREVIEW_REVERSE, function(arg0_7, arg1_7, arg2_7)
		arg0_3:UpdateReversePreView(arg1_7, arg2_7)
	end)
	arg0_3:bind(CommanderCatScene.EVENT_PREVIEW_PLAY, function(arg0_8, arg1_8, arg2_8)
		triggerToggle(arg0_3.skillBtn, true)

		local var0_8 = not arg1_8 or #arg1_8 <= 0 or arg2_8

		triggerToggle(arg0_3.otherBtn, not var0_8)
		triggerToggle(arg0_3.additionBtn, false)
		setToggleEnabled(arg0_3.additionBtn, false)
		arg0_3:UpdatePreViewWithOther(arg1_8)
	end)
	arg0_3:bind(CommanderCatScene.EVENT_PREVIEW_ADDITION, function(arg0_9, arg1_9)
		triggerToggle(arg0_3.skillBtn, true)
		triggerToggle(arg0_3.additionBtn, true)
		arg0_3:UpdatePreviewAddition(arg1_9)
	end)
	arg0_3:bind(CommanderCatDockPage.ON_SORT, function(arg0_10, arg1_10)
		arg0_3:OnSort(arg1_10)
	end)
end

function var0_0.OnLoaded(arg0_11)
	arg0_11.statement = arg0_11:findTF("detail/statement")
	arg0_11.statement.localScale = Vector3(1, 0, 1)
	arg0_11.talentSkill = arg0_11:findTF("detail/talent_skill")

	local var0_11 = arg0_11:findTF("talent/content", arg0_11.talentSkill)

	arg0_11.talentList = UIItemList.New(var0_11, var0_11:GetChild(0))
	arg0_11.abilityAdditionTF = arg0_11:findTF("atttrs/content", arg0_11.statement)
	arg0_11.talentAdditionTF = arg0_11:findTF("talents/scroll/content", arg0_11.statement)
	arg0_11.talentAdditionList = UIItemList.New(arg0_11.talentAdditionTF, arg0_11.talentAdditionTF:GetChild(0))
	arg0_11.skillIcon = arg0_11:findTF("skill/icon/Image", arg0_11.talentSkill)
	arg0_11.lockTF = arg0_11:findTF("info/lock")
	arg0_11.commanderInfo = arg0_11:findTF("info")
	arg0_11.expPanel = arg0_11:findTF("exp", arg0_11.commanderInfo)
	arg0_11.commanderLevelTxt = arg0_11:findTF("exp/level", arg0_11.commanderInfo):GetComponent(typeof(Text))
	arg0_11.commanderExpImg = arg0_11:findTF("exp/Image", arg0_11.commanderInfo):GetComponent(typeof(Image))
	arg0_11.commanderNameTxt = arg0_11:findTF("name_bg/mask/Text", arg0_11.commanderInfo):GetComponent("ScrollText")
	arg0_11.modifyNameBtn = arg0_11:findTF("name_bg/modify", arg0_11.commanderInfo)

	local var1_11 = pg.gameset.commander_rename_open.key_value == 1

	setActive(arg0_11.modifyNameBtn, var1_11)

	arg0_11.line = arg0_11:findTF("line", arg0_11.commanderInfo)
	arg0_11.fleetnums = arg0_11:findTF("line/numbers", arg0_11.commanderInfo)
	arg0_11.fleetTF = arg0_11:findTF("line/fleet", arg0_11.commanderInfo)
	arg0_11.subTF = arg0_11:findTF("line/sub_fleet", arg0_11.commanderInfo)
	arg0_11.leisureTF = arg0_11:findTF("line/leisure", arg0_11.commanderInfo)
	arg0_11.labelInBattleTF = arg0_11:findTF("line/inbattle", arg0_11.commanderInfo)
	arg0_11.rarityImg = arg0_11:findTF("rarity", arg0_11.commanderInfo):GetComponent(typeof(Image))
	arg0_11.abilityTF = arg0_11:findTF("ablitys", arg0_11.commanderInfo)
	arg0_11.skillBtn = arg0_11:findTF("skill_btn", arg0_11.commanderInfo)
	arg0_11.additionBtn = arg0_11:findTF("addition_btn", arg0_11.commanderInfo)
	arg0_11.otherBtn = arg0_11:findTF("other_btn", arg0_11.commanderInfo)
	arg0_11.otherCommanderNameTxt = arg0_11:findTF("detail/other/name/Text"):GetComponent(typeof(Text))
	arg0_11.otherCommanderSkillImg = arg0_11:findTF("detail/other/skill/Image")
	arg0_11.otherCommanderTalentList = UIItemList.New(arg0_11:findTF("detail/other/talent"), arg0_11:findTF("detail/other/talent/tpl"))
	arg0_11.otherCommanderDescTxt = arg0_11:findTF("detail/other/desc/mask/Text"):GetComponent(typeof(ScrollText))
	arg0_11.blurPanel = arg0_11._parentTf.parent
	arg0_11.blurPanelParent = arg0_11.blurPanel.parent
	arg0_11.renamePanel = CommanderRenamePage.New(pg.UIMgr.GetInstance().OverlayMain, arg0_11.event)

	setText(arg0_11:findTF("detail/statement/atttrs/title/Text"), i18n("commander_subtile_ablity"))
	setText(arg0_11:findTF("detail/statement/talents/title/Text"), i18n("commander_subtile_talent"))
end

function var0_0.OnInit(arg0_12)
	arg0_12:RegisterEvent()

	arg0_12.isOnAddition = false
	arg0_12.isOnSkill = false

	onToggle(arg0_12, arg0_12.skillBtn, function(arg0_13)
		arg0_12.isOnSkill = arg0_13

		arg0_12:Blur()

		if arg0_13 then
			arg0_12:emit(CommanderCatScene.EVENT_OPEN_DESC)
		end
	end, SFX_PANEL)
	onToggle(arg0_12, arg0_12.additionBtn, function(arg0_14)
		arg0_12.isOnAddition = arg0_14
		arg0_12.statement.localScale = arg0_14 and Vector3(1, 1, 1) or Vector3(1, 0, 1)

		arg0_12:Blur()

		if arg0_14 then
			arg0_12:emit(CommanderCatScene.EVENT_OPEN_DESC)
		end
	end, SFX_PANEL)
	onToggle(arg0_12, arg0_12.otherBtn, function(arg0_15)
		arg0_12.isOnOther = arg0_15

		arg0_12:Blur()

		if arg0_15 then
			arg0_12:emit(CommanderCatScene.EVENT_OPEN_DESC)
		end
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.modifyNameBtn, function()
		local var0_16 = arg0_12.commanderVO

		if not var0_16:canModifyName() then
			local var1_16 = var0_16:getRenameTimeDesc()

			arg0_12.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_rename_coldtime_tip", var1_16)
			})
		else
			arg0_12.renamePanel:ExecuteAction("Show", var0_16)
		end
	end, SFX_PANEL)
end

function var0_0.Update(arg0_17, arg1_17, arg2_17)
	arg0_17.commanderVO = arg1_17

	arg0_17:UpdateInfo()
	arg0_17:UpdateTalents()
	arg0_17:UpdateSkills()
	arg0_17:UpdateAbilityAddition()
	arg0_17:UpdateTalentAddition()
	arg0_17:UpdateAbilitys()
	arg0_17:UpdateLockState()
	arg0_17:UpdateLevel()
	arg0_17:UpdateStyle(arg2_17)
	arg0_17._tf:SetAsFirstSibling()
	arg0_17:Show()
end

function var0_0.UpdateLockState(arg0_18)
	local var0_18 = arg0_18.commanderVO:getLock()

	setActive(arg0_18.lockTF:Find("image"), var0_18 == 0)
	onButton(arg0_18, arg0_18.lockTF, function()
		local var0_19 = 1 - var0_18

		arg0_18:emit(CommanderCatMediator.LOCK, arg0_18.commanderVO.id, var0_19)
	end, SFX_PANEL)
end

function var0_0.UpdateStyle(arg0_20, arg1_20)
	if arg1_20 then
		triggerToggle(arg0_20.skillBtn, true)
		triggerToggle(arg0_20.additionBtn, true)
		setActive(arg0_20.lockTF, false)
	end

	setButtonEnabled(arg0_20.modifyNameBtn, not arg1_20)
end

function var0_0.UpdateInfo(arg0_21)
	local var0_21 = arg0_21.commanderVO
	local var1_21 = Commander.rarity2Print(var0_21:getRarity())

	if arg0_21.rarityPrint ~= var1_21 then
		LoadImageSpriteAsync("CommanderRarity/" .. var1_21, arg0_21.rarityImg, true)

		arg0_21.rarityPrint = var1_21
	end

	eachChild(arg0_21.fleetnums, function(arg0_22)
		setActive(arg0_22, go(arg0_22).name == tostring(var0_21.fleetId or ""))
	end)

	local var2_21 = var0_21.fleetId and not var0_21.inBattle and var0_21.sub
	local var3_21 = var2_21 and 260 or 200

	arg0_21.line.sizeDelta = Vector2(var3_21, arg0_21.line.sizeDelta.y)

	setActive(arg0_21.subTF, var2_21)
	setActive(arg0_21.fleetTF, var0_21.fleetId and not var0_21.inBattle and not var0_21.sub)
	setActive(arg0_21.leisureTF, not var0_21.inFleet and not var0_21.inBattle)
	setActive(arg0_21.labelInBattleTF, var0_21.inBattle)

	local var4_21 = arg0_21.commanderVO
	local var5_21 = defaultValue(arg0_21.forceDefaultName, false)

	arg0_21.commanderNameTxt:SetText(var4_21:getName(var5_21))
end

function var0_0.OnSort(arg0_23, arg1_23)
	local var0_23 = arg0_23.commanderVO
	local var1_23 = not arg1_23

	arg0_23.forceDefaultName = var1_23

	arg0_23.commanderNameTxt:SetText(var0_23:getName(var1_23))
end

function var0_0.UpdatePreView(arg0_24, arg1_24)
	arg0_24:UpdateAbilitys(arg1_24)
	arg0_24:UpdatePreviewAddition(arg1_24)
	arg0_24:UpdateLevel(arg1_24)
end

function var0_0.UpdateReversePreView(arg0_25, arg1_25, arg2_25)
	arg0_25:_UpdateAbilitys(arg2_25, arg1_25)
	arg0_25:_UpdateAbilityAddition(arg2_25, arg1_25)
	arg0_25:_UpdateTalentAddition(arg2_25)
	arg0_25:UpdateLevel(arg2_25)
end

function var0_0.UpdatePreViewWithOther(arg0_26, arg1_26)
	if not arg1_26 or #arg1_26 <= 0 then
		return
	end

	local var0_26 = Clone(arg0_26.commanderVO)
	local var1_26 = CommanderCatUtil.GetSkillExpAndCommanderExp(var0_26, arg1_26)

	var0_26:addExp(var1_26)

	local var2_26 = arg1_26[#arg1_26]
	local var3_26 = getProxy(CommanderProxy):getCommanderById(var2_26)

	arg0_26:UpdateOtherCommander(var3_26)
	arg0_26:UpdateLevel(var0_26)
	arg0_26:UpdateAbilitys(var0_26)
end

function var0_0.UpdatePreviewAddition(arg0_27, arg1_27)
	arg0_27:UpdateAbilityAddition(arg1_27)
	arg0_27:UpdateTalentAddition()
end

function var0_0.UpdateOtherCommander(arg0_28, arg1_28)
	arg0_28.otherCommanderNameTxt.text = arg1_28:getName()

	local var0_28 = arg1_28:getSkills()[1]
	local var1_28 = arg1_28:GetDisplayTalents()

	GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0_28:getConfig("icon"), "", arg0_28.otherCommanderSkillImg)
	arg0_28.otherCommanderTalentList:make(function(arg0_29, arg1_29, arg2_29)
		if arg0_29 == UIItemList.EventUpdate then
			setText(arg2_29:Find("Text"), "")

			local var0_29 = var1_28[arg1_29 + 1]

			if var0_29 then
				arg0_28:UpdateTalent(arg1_28, var0_29, arg2_29)
				onToggle(arg0_28, arg2_29, function(arg0_30)
					if arg0_30 then
						arg0_28.otherCommanderDescTxt:SetText(var0_29:getConfig("desc"))
					end
				end, SFX_PANEL)

				if arg1_29 == 0 then
					triggerToggle(arg2_29, true)
				end
			end

			setActive(arg2_29:Find("empty"), var0_29 == nil)

			arg2_29:GetComponent(typeof(Image)).enabled = var0_29 ~= nil

			setActive(arg2_29:Find("lock"), var0_29 and not arg1_28:IsLearnedTalent(var0_29.id))
		end
	end)
	arg0_28.otherCommanderTalentList:align(5)
end

function var0_0.UpdateLevel(arg0_31, arg1_31)
	local var0_31 = arg1_31 or arg0_31.commanderVO
	local var1_31 = arg1_31 and arg1_31.level > arg0_31.commanderVO.level and COLOR_GREEN or COLOR_WHITE
	local var2_31 = setColorStr("LV." .. var0_31.level, var1_31)

	arg0_31.commanderLevelTxt.text = var2_31

	if var0_31:isMaxLevel() then
		arg0_31.commanderExpImg.fillAmount = 1
	else
		arg0_31.commanderExpImg.fillAmount = var0_31.exp / var0_31:getNextLevelExp()
	end
end

function var0_0.UpdateAbilitys(arg0_32, arg1_32)
	local var0_32 = arg0_32.commanderVO

	arg0_32:_UpdateAbilitys(var0_32, arg1_32)
end

function var0_0._UpdateAbilitys(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg1_33:getAbilitys()
	local var1_33

	if arg2_33 then
		var1_33 = arg2_33:getAbilitys()
	end

	for iter0_33, iter1_33 in pairs(var0_33) do
		local var2_33 = arg0_33.abilityTF:Find(iter0_33)
		local var3_33

		if var1_33 then
			var3_33 = var1_33[iter0_33].value - iter1_33.value

			if var3_33 <= 0 then
				var3_33 = nil
			end
		end

		local var4_33 = var3_33 and setColorStr("+" .. var3_33, COLOR_GREEN) or " "
		local var5_33 = var2_33:Find("add/base")

		setText(var5_33, iter1_33.value)

		local var6_33 = var2_33:Find("add")

		setText(var6_33, var4_33)
	end
end

function var0_0.UpdateAbilityAddition(arg0_34, arg1_34)
	local var0_34 = arg0_34.commanderVO

	arg0_34:_UpdateAbilityAddition(var0_34, arg1_34)
end

function var0_0._UpdateAbilityAddition(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg1_35:getAbilitysAddition()
	local var1_35

	if arg2_35 then
		var1_35 = arg2_35:getAbilitysAddition()
	end

	local var2_35 = 0

	for iter0_35, iter1_35 in pairs(var0_35) do
		if iter1_35 > 0 then
			local var3_35 = arg0_35.abilityAdditionTF:GetChild(var2_35)

			GetImageSpriteFromAtlasAsync("attricon", iter0_35, var3_35:Find("bg/icon"), false)
			setText(var3_35:Find("bg/name"), AttributeType.Type2Name(iter0_35))

			local var4_35 = string.format("%0.3f", iter1_35)

			setText(var3_35:Find("bg/value"), ("+" .. math.floor(iter1_35 * 1000) / 1000) .. "%")

			local var5_35 = var1_35 and var1_35[iter0_35] or iter1_35

			setActive(var3_35:Find("up"), var5_35 < iter1_35)
			setActive(var3_35:Find("down"), iter1_35 < var5_35)

			var2_35 = var2_35 + 1
		end
	end
end

function var0_0.UpdateTalents(arg0_36)
	local var0_36 = arg0_36.commanderVO
	local var1_36 = var0_36:GetDisplayTalents()

	arg0_36.talentList:make(function(arg0_37, arg1_37, arg2_37)
		if arg0_37 == UIItemList.EventUpdate then
			local var0_37 = var1_36[arg1_37 + 1]

			arg0_36:UpdateTalent(var0_36, var0_37, arg2_37)
		end
	end)
	arg0_36.talentList:align(#var1_36)
end

function var0_0.UpdateTalent(arg0_38, arg1_38, arg2_38, arg3_38)
	setText(arg3_38:Find("Text"), arg2_38:getConfig("name"))
	GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2_38:getConfig("icon"), "", arg3_38)

	if arg3_38:GetComponent(typeof(Button)) then
		onButton(arg0_38, arg3_38, function()
			arg0_38.contextData.treePanel:ExecuteAction("Show", arg2_38)
		end, SFX_PANEL)
	end

	setActive(arg3_38:Find("lock"), not arg1_38:IsLearnedTalent(arg2_38.id))
end

function var0_0.UpdateTalentAddition(arg0_40)
	local var0_40 = arg0_40.commanderVO

	arg0_40:_UpdateTalentAddition(var0_40)
end

function var0_0._UpdateTalentAddition(arg0_41, arg1_41)
	local var0_41
	local var1_41 = _.values(arg1_41:getTalentsDesc())

	arg0_41.talentAdditionList:make(function(arg0_42, arg1_42, arg2_42)
		if arg0_42 == UIItemList.EventUpdate then
			local var0_42 = var1_41[arg1_42 + 1]

			setScrollText(findTF(arg2_42, "bg/name_mask/name"), var0_42.name)

			local var1_42 = var0_42.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_42:Find("bg/value"), (var0_42.value > 0 and "+" or "") .. var0_42.value .. var1_42)
			setActive(arg2_42:Find("up"), false)
			setActive(arg2_42:Find("down"), false)

			arg2_42:Find("bg"):GetComponent(typeof(Image)).enabled = arg1_42 % 2 ~= 0
		end
	end)
	arg0_41.talentAdditionList:align(#var1_41)
end

function var0_0.UpdateSkills(arg0_43)
	local var0_43 = arg0_43.commanderVO:getSkills()[1]

	GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0_43:getConfig("icon"), "", arg0_43.skillIcon)
	onButton(arg0_43, arg0_43.skillIcon, function()
		arg0_43:emit(CommanderCatMediator.SKILL_INFO, var0_43)
	end, SFX_PANEL)
end

function var0_0.CanBack(arg0_45)
	if arg0_45.renamePanel and arg0_45.renamePanel:GetLoaded() and arg0_45.renamePanel:isShowing() then
		arg0_45.renamePanel:Hide()

		return false
	end

	return true
end

function var0_0.OnDestroy(arg0_46)
	if arg0_46.isBlur then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_46.blurPanel, arg0_46.blurPanelParent)
	end

	if arg0_46.renamePanel then
		arg0_46.renamePanel:Destroy()

		arg0_46.renamePanel = nil
	end
end

function var0_0.Blur(arg0_47)
	if arg0_47.isOnAddition or arg0_47.isOnSkill or arg0_47.isOnOther then
		arg0_47.isBlur = true

		pg.UIMgr.GetInstance():BlurPanel(arg0_47.blurPanel)
	else
		arg0_47.isBlur = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0_47.blurPanel, arg0_47.blurPanelParent)
	end
end

return var0_0
