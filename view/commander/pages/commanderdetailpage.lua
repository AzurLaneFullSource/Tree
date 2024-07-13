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
	arg0_3:bind(CommanderCatScene.EVENT_PREVIEW_PLAY, function(arg0_7, arg1_7, arg2_7)
		triggerToggle(arg0_3.skillBtn, true)

		local var0_7 = not arg1_7 or #arg1_7 <= 0 or arg2_7

		triggerToggle(arg0_3.otherBtn, not var0_7)
		triggerToggle(arg0_3.additionBtn, false)
		setToggleEnabled(arg0_3.additionBtn, false)
		arg0_3:UpdatePreViewWithOther(arg1_7)
	end)
	arg0_3:bind(CommanderCatScene.EVENT_PREVIEW_ADDITION, function(arg0_8, arg1_8)
		triggerToggle(arg0_3.skillBtn, true)
		triggerToggle(arg0_3.additionBtn, true)
		arg0_3:UpdatePreviewAddition(arg1_8)
	end)
	arg0_3:bind(CommanderCatDockPage.ON_SORT, function(arg0_9, arg1_9)
		arg0_3:OnSort(arg1_9)
	end)
end

function var0_0.OnLoaded(arg0_10)
	arg0_10.statement = arg0_10:findTF("detail/statement")
	arg0_10.statement.localScale = Vector3(1, 0, 1)
	arg0_10.talentSkill = arg0_10:findTF("detail/talent_skill")

	local var0_10 = arg0_10:findTF("talent/content", arg0_10.talentSkill)

	arg0_10.talentList = UIItemList.New(var0_10, var0_10:GetChild(0))
	arg0_10.abilityAdditionTF = arg0_10:findTF("atttrs/content", arg0_10.statement)
	arg0_10.talentAdditionTF = arg0_10:findTF("talents/scroll/content", arg0_10.statement)
	arg0_10.talentAdditionList = UIItemList.New(arg0_10.talentAdditionTF, arg0_10.talentAdditionTF:GetChild(0))
	arg0_10.skillIcon = arg0_10:findTF("skill/icon/Image", arg0_10.talentSkill)
	arg0_10.lockTF = arg0_10:findTF("info/lock")
	arg0_10.commanderInfo = arg0_10:findTF("info")
	arg0_10.expPanel = arg0_10:findTF("exp", arg0_10.commanderInfo)
	arg0_10.commanderLevelTxt = arg0_10:findTF("exp/level", arg0_10.commanderInfo):GetComponent(typeof(Text))
	arg0_10.commanderExpImg = arg0_10:findTF("exp/Image", arg0_10.commanderInfo):GetComponent(typeof(Image))
	arg0_10.commanderNameTxt = arg0_10:findTF("name_bg/mask/Text", arg0_10.commanderInfo):GetComponent("ScrollText")
	arg0_10.modifyNameBtn = arg0_10:findTF("name_bg/modify", arg0_10.commanderInfo)

	local var1_10 = pg.gameset.commander_rename_open.key_value == 1

	setActive(arg0_10.modifyNameBtn, var1_10)

	arg0_10.line = arg0_10:findTF("line", arg0_10.commanderInfo)
	arg0_10.fleetnums = arg0_10:findTF("line/numbers", arg0_10.commanderInfo)
	arg0_10.fleetTF = arg0_10:findTF("line/fleet", arg0_10.commanderInfo)
	arg0_10.subTF = arg0_10:findTF("line/sub_fleet", arg0_10.commanderInfo)
	arg0_10.leisureTF = arg0_10:findTF("line/leisure", arg0_10.commanderInfo)
	arg0_10.labelInBattleTF = arg0_10:findTF("line/inbattle", arg0_10.commanderInfo)
	arg0_10.rarityImg = arg0_10:findTF("rarity", arg0_10.commanderInfo):GetComponent(typeof(Image))
	arg0_10.abilityTF = arg0_10:findTF("ablitys", arg0_10.commanderInfo)
	arg0_10.skillBtn = arg0_10:findTF("skill_btn", arg0_10.commanderInfo)
	arg0_10.additionBtn = arg0_10:findTF("addition_btn", arg0_10.commanderInfo)
	arg0_10.otherBtn = arg0_10:findTF("other_btn", arg0_10.commanderInfo)
	arg0_10.otherCommanderNameTxt = arg0_10:findTF("detail/other/name/Text"):GetComponent(typeof(Text))
	arg0_10.otherCommanderSkillImg = arg0_10:findTF("detail/other/skill/Image")
	arg0_10.otherCommanderTalentList = UIItemList.New(arg0_10:findTF("detail/other/talent"), arg0_10:findTF("detail/other/talent/tpl"))
	arg0_10.otherCommanderDescTxt = arg0_10:findTF("detail/other/desc/mask/Text"):GetComponent(typeof(ScrollText))
	arg0_10.blurPanel = arg0_10._parentTf.parent
	arg0_10.blurPanelParent = arg0_10.blurPanel.parent
	arg0_10.renamePanel = CommanderRenamePage.New(pg.UIMgr.GetInstance().OverlayMain, arg0_10.event)

	setText(arg0_10:findTF("detail/statement/atttrs/title/Text"), i18n("commander_subtile_ablity"))
	setText(arg0_10:findTF("detail/statement/talents/title/Text"), i18n("commander_subtile_talent"))
end

function var0_0.OnInit(arg0_11)
	arg0_11:RegisterEvent()

	arg0_11.isOnAddition = false
	arg0_11.isOnSkill = false

	onToggle(arg0_11, arg0_11.skillBtn, function(arg0_12)
		arg0_11.isOnSkill = arg0_12

		arg0_11:Blur()

		if arg0_12 then
			arg0_11:emit(CommanderCatScene.EVENT_OPEN_DESC)
		end
	end, SFX_PANEL)
	onToggle(arg0_11, arg0_11.additionBtn, function(arg0_13)
		arg0_11.isOnAddition = arg0_13
		arg0_11.statement.localScale = arg0_13 and Vector3(1, 1, 1) or Vector3(1, 0, 1)

		arg0_11:Blur()

		if arg0_13 then
			arg0_11:emit(CommanderCatScene.EVENT_OPEN_DESC)
		end
	end, SFX_PANEL)
	onToggle(arg0_11, arg0_11.otherBtn, function(arg0_14)
		arg0_11.isOnOther = arg0_14

		arg0_11:Blur()

		if arg0_14 then
			arg0_11:emit(CommanderCatScene.EVENT_OPEN_DESC)
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.modifyNameBtn, function()
		local var0_15 = arg0_11.commanderVO

		if not var0_15:canModifyName() then
			local var1_15 = var0_15:getRenameTimeDesc()

			arg0_11.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_rename_coldtime_tip", var1_15)
			})
		else
			arg0_11.renamePanel:ExecuteAction("Show", var0_15)
		end
	end, SFX_PANEL)
end

function var0_0.Update(arg0_16, arg1_16, arg2_16)
	arg0_16.commanderVO = arg1_16

	arg0_16:UpdateInfo()
	arg0_16:UpdateTalents()
	arg0_16:UpdateSkills()
	arg0_16:UpdateAbilityAddition()
	arg0_16:UpdateTalentAddition()
	arg0_16:UpdateAbilitys()
	arg0_16:UpdateLockState()
	arg0_16:UpdateLevel()
	arg0_16:UpdateStyle(arg2_16)
	arg0_16._tf:SetAsFirstSibling()
	arg0_16:Show()
end

function var0_0.UpdateLockState(arg0_17)
	local var0_17 = arg0_17.commanderVO:getLock()

	setActive(arg0_17.lockTF:Find("image"), var0_17 == 0)
	onButton(arg0_17, arg0_17.lockTF, function()
		local var0_18 = 1 - var0_17

		arg0_17:emit(CommanderCatMediator.LOCK, arg0_17.commanderVO.id, var0_18)
	end, SFX_PANEL)
end

function var0_0.UpdateStyle(arg0_19, arg1_19)
	if arg1_19 then
		triggerToggle(arg0_19.skillBtn, true)
		triggerToggle(arg0_19.additionBtn, true)
		setActive(arg0_19.lockTF, false)
	end

	setButtonEnabled(arg0_19.modifyNameBtn, not arg1_19)
end

function var0_0.UpdateInfo(arg0_20)
	local var0_20 = arg0_20.commanderVO
	local var1_20 = Commander.rarity2Print(var0_20:getRarity())

	if arg0_20.rarityPrint ~= var1_20 then
		LoadImageSpriteAsync("CommanderRarity/" .. var1_20, arg0_20.rarityImg, true)

		arg0_20.rarityPrint = var1_20
	end

	eachChild(arg0_20.fleetnums, function(arg0_21)
		setActive(arg0_21, go(arg0_21).name == tostring(var0_20.fleetId or ""))
	end)

	local var2_20 = var0_20.fleetId and not var0_20.inBattle and var0_20.sub
	local var3_20 = var2_20 and 260 or 200

	arg0_20.line.sizeDelta = Vector2(var3_20, arg0_20.line.sizeDelta.y)

	setActive(arg0_20.subTF, var2_20)
	setActive(arg0_20.fleetTF, var0_20.fleetId and not var0_20.inBattle and not var0_20.sub)
	setActive(arg0_20.leisureTF, not var0_20.inFleet and not var0_20.inBattle)
	setActive(arg0_20.labelInBattleTF, var0_20.inBattle)

	local var4_20 = arg0_20.commanderVO
	local var5_20 = defaultValue(arg0_20.forceDefaultName, false)

	arg0_20.commanderNameTxt:SetText(var4_20:getName(var5_20))
end

function var0_0.OnSort(arg0_22, arg1_22)
	local var0_22 = arg0_22.commanderVO
	local var1_22 = not arg1_22

	arg0_22.forceDefaultName = var1_22

	arg0_22.commanderNameTxt:SetText(var0_22:getName(var1_22))
end

function var0_0.UpdatePreView(arg0_23, arg1_23)
	arg0_23:UpdateAbilitys(arg1_23)
	arg0_23:UpdatePreviewAddition(arg1_23)
	arg0_23:UpdateLevel(arg1_23)
end

function var0_0.UpdatePreViewWithOther(arg0_24, arg1_24)
	if not arg1_24 or #arg1_24 <= 0 then
		return
	end

	local var0_24 = Clone(arg0_24.commanderVO)
	local var1_24 = CommanderCatUtil.GetSkillExpAndCommanderExp(var0_24, arg1_24)

	var0_24:addExp(var1_24)

	local var2_24 = arg1_24[#arg1_24]
	local var3_24 = getProxy(CommanderProxy):getCommanderById(var2_24)

	arg0_24:UpdateOtherCommander(var3_24)
	arg0_24:UpdateLevel(var0_24)
	arg0_24:UpdateAbilitys(var0_24)
end

function var0_0.UpdatePreviewAddition(arg0_25, arg1_25)
	arg0_25:UpdateAbilityAddition(arg1_25)
	arg0_25:UpdateTalentAddition()
end

function var0_0.UpdateOtherCommander(arg0_26, arg1_26)
	arg0_26.otherCommanderNameTxt.text = arg1_26:getName()

	local var0_26 = arg1_26:getSkills()[1]
	local var1_26 = arg1_26:GetDisplayTalents()

	GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0_26:getConfig("icon"), "", arg0_26.otherCommanderSkillImg)
	arg0_26.otherCommanderTalentList:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			setText(arg2_27:Find("Text"), "")

			local var0_27 = var1_26[arg1_27 + 1]

			if var0_27 then
				arg0_26:UpdateTalent(arg1_26, var0_27, arg2_27)
				onToggle(arg0_26, arg2_27, function(arg0_28)
					if arg0_28 then
						arg0_26.otherCommanderDescTxt:SetText(var0_27:getConfig("desc"))
					end
				end, SFX_PANEL)

				if arg1_27 == 0 then
					triggerToggle(arg2_27, true)
				end
			end

			setActive(arg2_27:Find("empty"), var0_27 == nil)

			arg2_27:GetComponent(typeof(Image)).enabled = var0_27 ~= nil

			setActive(arg2_27:Find("lock"), var0_27 and not arg1_26:IsLearnedTalent(var0_27.id))
		end
	end)
	arg0_26.otherCommanderTalentList:align(5)
end

function var0_0.UpdateLevel(arg0_29, arg1_29)
	local var0_29 = arg1_29 or arg0_29.commanderVO
	local var1_29 = arg1_29 and arg1_29.level > arg0_29.commanderVO.level and COLOR_GREEN or COLOR_WHITE
	local var2_29 = setColorStr("LV." .. var0_29.level, var1_29)

	arg0_29.commanderLevelTxt.text = var2_29

	if var0_29:isMaxLevel() then
		arg0_29.commanderExpImg.fillAmount = 1
	else
		arg0_29.commanderExpImg.fillAmount = var0_29.exp / var0_29:getNextLevelExp()
	end
end

function var0_0.UpdateAbilitys(arg0_30, arg1_30)
	local var0_30 = arg0_30.commanderVO:getAbilitys()
	local var1_30

	if arg1_30 then
		var1_30 = arg1_30:getAbilitys()
	end

	for iter0_30, iter1_30 in pairs(var0_30) do
		local var2_30 = arg0_30.abilityTF:Find(iter0_30)
		local var3_30

		if var1_30 then
			var3_30 = var1_30[iter0_30].value - iter1_30.value

			if var3_30 <= 0 then
				var3_30 = nil
			end
		end

		local var4_30 = var3_30 and setColorStr("+" .. var3_30, COLOR_GREEN) or " "
		local var5_30 = var2_30:Find("add/base")

		setText(var5_30, iter1_30.value)

		local var6_30 = var2_30:Find("add")

		setText(var6_30, var4_30)
	end
end

function var0_0.UpdateAbilityAddition(arg0_31, arg1_31)
	local var0_31 = arg0_31.commanderVO:getAbilitysAddition()
	local var1_31

	if arg1_31 then
		var1_31 = arg1_31:getAbilitysAddition()
	end

	local var2_31 = 0

	for iter0_31, iter1_31 in pairs(var0_31) do
		if iter1_31 > 0 then
			local var3_31 = arg0_31.abilityAdditionTF:GetChild(var2_31)

			GetImageSpriteFromAtlasAsync("attricon", iter0_31, var3_31:Find("bg/icon"), false)
			setText(var3_31:Find("bg/name"), AttributeType.Type2Name(iter0_31))

			local var4_31 = string.format("%0.3f", iter1_31)

			setText(var3_31:Find("bg/value"), ("+" .. math.floor(iter1_31 * 1000) / 1000) .. "%")

			local var5_31 = var1_31 and var1_31[iter0_31] or iter1_31

			setActive(var3_31:Find("up"), var5_31 < iter1_31)
			setActive(var3_31:Find("down"), iter1_31 < var5_31)

			var2_31 = var2_31 + 1
		end
	end
end

function var0_0.UpdateTalents(arg0_32)
	local var0_32 = arg0_32.commanderVO
	local var1_32 = var0_32:GetDisplayTalents()

	arg0_32.talentList:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = var1_32[arg1_33 + 1]

			arg0_32:UpdateTalent(var0_32, var0_33, arg2_33)
		end
	end)
	arg0_32.talentList:align(#var1_32)
end

function var0_0.UpdateTalent(arg0_34, arg1_34, arg2_34, arg3_34)
	setText(arg3_34:Find("Text"), arg2_34:getConfig("name"))
	GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2_34:getConfig("icon"), "", arg3_34)

	if arg3_34:GetComponent(typeof(Button)) then
		onButton(arg0_34, arg3_34, function()
			arg0_34.contextData.treePanel:ExecuteAction("Show", arg2_34)
		end, SFX_PANEL)
	end

	setActive(arg3_34:Find("lock"), not arg1_34:IsLearnedTalent(arg2_34.id))
end

function var0_0.UpdateTalentAddition(arg0_36)
	local var0_36 = arg0_36.commanderVO
	local var1_36
	local var2_36 = _.values(var0_36:getTalentsDesc())

	arg0_36.talentAdditionList:make(function(arg0_37, arg1_37, arg2_37)
		if arg0_37 == UIItemList.EventUpdate then
			local var0_37 = var2_36[arg1_37 + 1]

			setScrollText(findTF(arg2_37, "bg/name_mask/name"), var0_37.name)

			local var1_37 = var0_37.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_37:Find("bg/value"), (var0_37.value > 0 and "+" or "") .. var0_37.value .. var1_37)
			setActive(arg2_37:Find("up"), false)
			setActive(arg2_37:Find("down"), false)

			arg2_37:Find("bg"):GetComponent(typeof(Image)).enabled = arg1_37 % 2 ~= 0
		end
	end)
	arg0_36.talentAdditionList:align(#var2_36)
end

function var0_0.UpdateSkills(arg0_38)
	local var0_38 = arg0_38.commanderVO:getSkills()[1]

	GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0_38:getConfig("icon"), "", arg0_38.skillIcon)
	onButton(arg0_38, arg0_38.skillIcon, function()
		arg0_38:emit(CommanderCatMediator.SKILL_INFO, var0_38)
	end, SFX_PANEL)
end

function var0_0.CanBack(arg0_40)
	if arg0_40.renamePanel and arg0_40.renamePanel:GetLoaded() and arg0_40.renamePanel:isShowing() then
		arg0_40.renamePanel:Hide()

		return false
	end

	return true
end

function var0_0.OnDestroy(arg0_41)
	if arg0_41.isBlur then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_41.blurPanel, arg0_41.blurPanelParent)
	end

	if arg0_41.renamePanel then
		arg0_41.renamePanel:Destroy()

		arg0_41.renamePanel = nil
	end
end

function var0_0.Blur(arg0_42)
	if arg0_42.isOnAddition or arg0_42.isOnSkill or arg0_42.isOnOther then
		arg0_42.isBlur = true

		pg.UIMgr.GetInstance():BlurPanel(arg0_42.blurPanel)
	else
		arg0_42.isBlur = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0_42.blurPanel, arg0_42.blurPanelParent)
	end
end

return var0_0
