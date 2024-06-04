local var0 = class("CommanderDetailPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderDetailUI"
end

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2, arg3)
	arg0:Load()
end

function var0.RegisterEvent(arg0)
	arg0:bind(CommanderCatScene.EVENT_CLOSE_DESC, function(arg0)
		triggerToggle(arg0.skillBtn, false)
		triggerToggle(arg0.additionBtn, false)
		triggerToggle(arg0.otherBtn, false)
	end)
	arg0:bind(CommanderCatScene.EVENT_FOLD, function(arg0, arg1)
		triggerToggle(arg0.skillBtn, false)
		triggerToggle(arg0.additionBtn, false)
		triggerToggle(arg0.otherBtn, false)

		if arg1 then
			LeanTween.moveY(rtf(arg0.commanderInfo), -400, 0.5)
		else
			LeanTween.moveY(rtf(arg0.commanderInfo), 71, 0.5)
		end
	end)
	arg0:bind(CommanderCatScene.EVENT_PREVIEW, function(arg0, arg1)
		arg0:UpdatePreView(arg1)
	end)
	arg0:bind(CommanderCatScene.EVENT_PREVIEW_PLAY, function(arg0, arg1, arg2)
		triggerToggle(arg0.skillBtn, true)

		local var0 = not arg1 or #arg1 <= 0 or arg2

		triggerToggle(arg0.otherBtn, not var0)
		triggerToggle(arg0.additionBtn, false)
		setToggleEnabled(arg0.additionBtn, false)
		arg0:UpdatePreViewWithOther(arg1)
	end)
	arg0:bind(CommanderCatScene.EVENT_PREVIEW_ADDITION, function(arg0, arg1)
		triggerToggle(arg0.skillBtn, true)
		triggerToggle(arg0.additionBtn, true)
		arg0:UpdatePreviewAddition(arg1)
	end)
	arg0:bind(CommanderCatDockPage.ON_SORT, function(arg0, arg1)
		arg0:OnSort(arg1)
	end)
end

function var0.OnLoaded(arg0)
	arg0.statement = arg0:findTF("detail/statement")
	arg0.statement.localScale = Vector3(1, 0, 1)
	arg0.talentSkill = arg0:findTF("detail/talent_skill")

	local var0 = arg0:findTF("talent/content", arg0.talentSkill)

	arg0.talentList = UIItemList.New(var0, var0:GetChild(0))
	arg0.abilityAdditionTF = arg0:findTF("atttrs/content", arg0.statement)
	arg0.talentAdditionTF = arg0:findTF("talents/scroll/content", arg0.statement)
	arg0.talentAdditionList = UIItemList.New(arg0.talentAdditionTF, arg0.talentAdditionTF:GetChild(0))
	arg0.skillIcon = arg0:findTF("skill/icon/Image", arg0.talentSkill)
	arg0.lockTF = arg0:findTF("info/lock")
	arg0.commanderInfo = arg0:findTF("info")
	arg0.expPanel = arg0:findTF("exp", arg0.commanderInfo)
	arg0.commanderLevelTxt = arg0:findTF("exp/level", arg0.commanderInfo):GetComponent(typeof(Text))
	arg0.commanderExpImg = arg0:findTF("exp/Image", arg0.commanderInfo):GetComponent(typeof(Image))
	arg0.commanderNameTxt = arg0:findTF("name_bg/mask/Text", arg0.commanderInfo):GetComponent("ScrollText")
	arg0.modifyNameBtn = arg0:findTF("name_bg/modify", arg0.commanderInfo)

	local var1 = pg.gameset.commander_rename_open.key_value == 1

	setActive(arg0.modifyNameBtn, var1)

	arg0.line = arg0:findTF("line", arg0.commanderInfo)
	arg0.fleetnums = arg0:findTF("line/numbers", arg0.commanderInfo)
	arg0.fleetTF = arg0:findTF("line/fleet", arg0.commanderInfo)
	arg0.subTF = arg0:findTF("line/sub_fleet", arg0.commanderInfo)
	arg0.leisureTF = arg0:findTF("line/leisure", arg0.commanderInfo)
	arg0.labelInBattleTF = arg0:findTF("line/inbattle", arg0.commanderInfo)
	arg0.rarityImg = arg0:findTF("rarity", arg0.commanderInfo):GetComponent(typeof(Image))
	arg0.abilityTF = arg0:findTF("ablitys", arg0.commanderInfo)
	arg0.skillBtn = arg0:findTF("skill_btn", arg0.commanderInfo)
	arg0.additionBtn = arg0:findTF("addition_btn", arg0.commanderInfo)
	arg0.otherBtn = arg0:findTF("other_btn", arg0.commanderInfo)
	arg0.otherCommanderNameTxt = arg0:findTF("detail/other/name/Text"):GetComponent(typeof(Text))
	arg0.otherCommanderSkillImg = arg0:findTF("detail/other/skill/Image")
	arg0.otherCommanderTalentList = UIItemList.New(arg0:findTF("detail/other/talent"), arg0:findTF("detail/other/talent/tpl"))
	arg0.otherCommanderDescTxt = arg0:findTF("detail/other/desc/mask/Text"):GetComponent(typeof(ScrollText))
	arg0.blurPanel = arg0._parentTf.parent
	arg0.blurPanelParent = arg0.blurPanel.parent
	arg0.renamePanel = CommanderRenamePage.New(pg.UIMgr.GetInstance().OverlayMain, arg0.event)

	setText(arg0:findTF("detail/statement/atttrs/title/Text"), i18n("commander_subtile_ablity"))
	setText(arg0:findTF("detail/statement/talents/title/Text"), i18n("commander_subtile_talent"))
end

function var0.OnInit(arg0)
	arg0:RegisterEvent()

	arg0.isOnAddition = false
	arg0.isOnSkill = false

	onToggle(arg0, arg0.skillBtn, function(arg0)
		arg0.isOnSkill = arg0

		arg0:Blur()

		if arg0 then
			arg0:emit(CommanderCatScene.EVENT_OPEN_DESC)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.additionBtn, function(arg0)
		arg0.isOnAddition = arg0
		arg0.statement.localScale = arg0 and Vector3(1, 1, 1) or Vector3(1, 0, 1)

		arg0:Blur()

		if arg0 then
			arg0:emit(CommanderCatScene.EVENT_OPEN_DESC)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.otherBtn, function(arg0)
		arg0.isOnOther = arg0

		arg0:Blur()

		if arg0 then
			arg0:emit(CommanderCatScene.EVENT_OPEN_DESC)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.modifyNameBtn, function()
		local var0 = arg0.commanderVO

		if not var0:canModifyName() then
			local var1 = var0:getRenameTimeDesc()

			arg0.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_rename_coldtime_tip", var1)
			})
		else
			arg0.renamePanel:ExecuteAction("Show", var0)
		end
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1, arg2)
	arg0.commanderVO = arg1

	arg0:UpdateInfo()
	arg0:UpdateTalents()
	arg0:UpdateSkills()
	arg0:UpdateAbilityAddition()
	arg0:UpdateTalentAddition()
	arg0:UpdateAbilitys()
	arg0:UpdateLockState()
	arg0:UpdateLevel()
	arg0:UpdateStyle(arg2)
	arg0._tf:SetAsFirstSibling()
	arg0:Show()
end

function var0.UpdateLockState(arg0)
	local var0 = arg0.commanderVO:getLock()

	setActive(arg0.lockTF:Find("image"), var0 == 0)
	onButton(arg0, arg0.lockTF, function()
		local var0 = 1 - var0

		arg0:emit(CommanderCatMediator.LOCK, arg0.commanderVO.id, var0)
	end, SFX_PANEL)
end

function var0.UpdateStyle(arg0, arg1)
	if arg1 then
		triggerToggle(arg0.skillBtn, true)
		triggerToggle(arg0.additionBtn, true)
		setActive(arg0.lockTF, false)
	end

	setButtonEnabled(arg0.modifyNameBtn, not arg1)
end

function var0.UpdateInfo(arg0)
	local var0 = arg0.commanderVO
	local var1 = Commander.rarity2Print(var0:getRarity())

	if arg0.rarityPrint ~= var1 then
		LoadImageSpriteAsync("CommanderRarity/" .. var1, arg0.rarityImg, true)

		arg0.rarityPrint = var1
	end

	eachChild(arg0.fleetnums, function(arg0)
		setActive(arg0, go(arg0).name == tostring(var0.fleetId or ""))
	end)

	local var2 = var0.fleetId and not var0.inBattle and var0.sub
	local var3 = var2 and 260 or 200

	arg0.line.sizeDelta = Vector2(var3, arg0.line.sizeDelta.y)

	setActive(arg0.subTF, var2)
	setActive(arg0.fleetTF, var0.fleetId and not var0.inBattle and not var0.sub)
	setActive(arg0.leisureTF, not var0.inFleet and not var0.inBattle)
	setActive(arg0.labelInBattleTF, var0.inBattle)

	local var4 = arg0.commanderVO
	local var5 = defaultValue(arg0.forceDefaultName, false)

	arg0.commanderNameTxt:SetText(var4:getName(var5))
end

function var0.OnSort(arg0, arg1)
	local var0 = arg0.commanderVO
	local var1 = not arg1

	arg0.forceDefaultName = var1

	arg0.commanderNameTxt:SetText(var0:getName(var1))
end

function var0.UpdatePreView(arg0, arg1)
	arg0:UpdateAbilitys(arg1)
	arg0:UpdatePreviewAddition(arg1)
	arg0:UpdateLevel(arg1)
end

function var0.UpdatePreViewWithOther(arg0, arg1)
	if not arg1 or #arg1 <= 0 then
		return
	end

	local var0 = Clone(arg0.commanderVO)
	local var1 = CommanderCatUtil.GetSkillExpAndCommanderExp(var0, arg1)

	var0:addExp(var1)

	local var2 = arg1[#arg1]
	local var3 = getProxy(CommanderProxy):getCommanderById(var2)

	arg0:UpdateOtherCommander(var3)
	arg0:UpdateLevel(var0)
	arg0:UpdateAbilitys(var0)
end

function var0.UpdatePreviewAddition(arg0, arg1)
	arg0:UpdateAbilityAddition(arg1)
	arg0:UpdateTalentAddition()
end

function var0.UpdateOtherCommander(arg0, arg1)
	arg0.otherCommanderNameTxt.text = arg1:getName()

	local var0 = arg1:getSkills()[1]
	local var1 = arg1:GetDisplayTalents()

	GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0:getConfig("icon"), "", arg0.otherCommanderSkillImg)
	arg0.otherCommanderTalentList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setText(arg2:Find("Text"), "")

			local var0 = var1[arg1 + 1]

			if var0 then
				arg0:UpdateTalent(arg1, var0, arg2)
				onToggle(arg0, arg2, function(arg0)
					if arg0 then
						arg0.otherCommanderDescTxt:SetText(var0:getConfig("desc"))
					end
				end, SFX_PANEL)

				if arg1 == 0 then
					triggerToggle(arg2, true)
				end
			end

			setActive(arg2:Find("empty"), var0 == nil)

			arg2:GetComponent(typeof(Image)).enabled = var0 ~= nil

			setActive(arg2:Find("lock"), var0 and not arg1:IsLearnedTalent(var0.id))
		end
	end)
	arg0.otherCommanderTalentList:align(5)
end

function var0.UpdateLevel(arg0, arg1)
	local var0 = arg1 or arg0.commanderVO
	local var1 = arg1 and arg1.level > arg0.commanderVO.level and COLOR_GREEN or COLOR_WHITE
	local var2 = setColorStr("LV." .. var0.level, var1)

	arg0.commanderLevelTxt.text = var2

	if var0:isMaxLevel() then
		arg0.commanderExpImg.fillAmount = 1
	else
		arg0.commanderExpImg.fillAmount = var0.exp / var0:getNextLevelExp()
	end
end

function var0.UpdateAbilitys(arg0, arg1)
	local var0 = arg0.commanderVO:getAbilitys()
	local var1

	if arg1 then
		var1 = arg1:getAbilitys()
	end

	for iter0, iter1 in pairs(var0) do
		local var2 = arg0.abilityTF:Find(iter0)
		local var3

		if var1 then
			var3 = var1[iter0].value - iter1.value

			if var3 <= 0 then
				var3 = nil
			end
		end

		local var4 = var3 and setColorStr("+" .. var3, COLOR_GREEN) or " "
		local var5 = var2:Find("add/base")

		setText(var5, iter1.value)

		local var6 = var2:Find("add")

		setText(var6, var4)
	end
end

function var0.UpdateAbilityAddition(arg0, arg1)
	local var0 = arg0.commanderVO:getAbilitysAddition()
	local var1

	if arg1 then
		var1 = arg1:getAbilitysAddition()
	end

	local var2 = 0

	for iter0, iter1 in pairs(var0) do
		if iter1 > 0 then
			local var3 = arg0.abilityAdditionTF:GetChild(var2)

			GetImageSpriteFromAtlasAsync("attricon", iter0, var3:Find("bg/icon"), false)
			setText(var3:Find("bg/name"), AttributeType.Type2Name(iter0))

			local var4 = string.format("%0.3f", iter1)

			setText(var3:Find("bg/value"), ("+" .. math.floor(iter1 * 1000) / 1000) .. "%")

			local var5 = var1 and var1[iter0] or iter1

			setActive(var3:Find("up"), var5 < iter1)
			setActive(var3:Find("down"), iter1 < var5)

			var2 = var2 + 1
		end
	end
end

function var0.UpdateTalents(arg0)
	local var0 = arg0.commanderVO
	local var1 = var0:GetDisplayTalents()

	arg0.talentList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]

			arg0:UpdateTalent(var0, var0, arg2)
		end
	end)
	arg0.talentList:align(#var1)
end

function var0.UpdateTalent(arg0, arg1, arg2, arg3)
	setText(arg3:Find("Text"), arg2:getConfig("name"))
	GetImageSpriteFromAtlasAsync("CommanderTalentIcon/" .. arg2:getConfig("icon"), "", arg3)

	if arg3:GetComponent(typeof(Button)) then
		onButton(arg0, arg3, function()
			arg0.contextData.treePanel:ExecuteAction("Show", arg2)
		end, SFX_PANEL)
	end

	setActive(arg3:Find("lock"), not arg1:IsLearnedTalent(arg2.id))
end

function var0.UpdateTalentAddition(arg0)
	local var0 = arg0.commanderVO
	local var1
	local var2 = _.values(var0:getTalentsDesc())

	arg0.talentAdditionList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1 + 1]

			setScrollText(findTF(arg2, "bg/name_mask/name"), var0.name)

			local var1 = var0.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2:Find("bg/value"), (var0.value > 0 and "+" or "") .. var0.value .. var1)
			setActive(arg2:Find("up"), false)
			setActive(arg2:Find("down"), false)

			arg2:Find("bg"):GetComponent(typeof(Image)).enabled = arg1 % 2 ~= 0
		end
	end)
	arg0.talentAdditionList:align(#var2)
end

function var0.UpdateSkills(arg0)
	local var0 = arg0.commanderVO:getSkills()[1]

	GetImageSpriteFromAtlasAsync("commanderskillicon/" .. var0:getConfig("icon"), "", arg0.skillIcon)
	onButton(arg0, arg0.skillIcon, function()
		arg0:emit(CommanderCatMediator.SKILL_INFO, var0)
	end, SFX_PANEL)
end

function var0.CanBack(arg0)
	if arg0.renamePanel and arg0.renamePanel:GetLoaded() and arg0.renamePanel:isShowing() then
		arg0.renamePanel:Hide()

		return false
	end

	return true
end

function var0.OnDestroy(arg0)
	if arg0.isBlur then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.blurPanel, arg0.blurPanelParent)
	end

	if arg0.renamePanel then
		arg0.renamePanel:Destroy()

		arg0.renamePanel = nil
	end
end

function var0.Blur(arg0)
	if arg0.isOnAddition or arg0.isOnSkill or arg0.isOnOther then
		arg0.isBlur = true

		pg.UIMgr.GetInstance():BlurPanel(arg0.blurPanel)
	else
		arg0.isBlur = false

		pg.UIMgr.GetInstance():UnblurPanel(arg0.blurPanel, arg0.blurPanelParent)
	end
end

return var0
