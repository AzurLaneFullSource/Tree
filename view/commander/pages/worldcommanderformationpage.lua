local var0 = class("WorldCommanderFormationPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "WorldCommanderFormationUI"
end

function var0.OnInit(arg0)
	arg0.samllTF = arg0:findTF("small")

	setActive(arg0.samllTF, true)

	arg0.pos1 = arg0.samllTF:Find("commander1")
	arg0.pos2 = arg0.samllTF:Find("commander2")
	arg0.smallSalvageMask = arg0.samllTF:Find("salvage_mask")

	setText(arg0.smallSalvageMask:Find("text_bg/Text"), i18n("world_catsearch_help_4"))

	arg0.descPanel = arg0:findTF("desc")

	setActive(arg0.descPanel, false)

	arg0.descFrameTF = arg0:findTF("desc/frame")
	arg0.descSalvageMask = arg0.descFrameTF:Find("salvage_mask")

	setText(arg0.descSalvageMask:Find("text_bg/Text"), i18n("world_catsearch_help_5"))

	arg0.descPos1 = arg0:findTF("commander1/frame/info", arg0.descFrameTF)
	arg0.descPos2 = arg0:findTF("commander2/frame/info", arg0.descFrameTF)
	arg0.skillTFPos1 = arg0:findTF("commander1/skill_info", arg0.descFrameTF)
	arg0.skillTFPos2 = arg0:findTF("commander2/skill_info", arg0.descFrameTF)
	arg0.abilitysTF = UIItemList.New(arg0:findTF("atttr_panel/abilitys/mask/content", arg0.descFrameTF), arg0:findTF("atttr_panel/abilitys/mask/content/attr", arg0.descFrameTF))
	arg0.talentsTF = UIItemList.New(arg0:findTF("atttr_panel/talents/mask/content", arg0.descFrameTF), arg0:findTF("atttr_panel/talents/mask/content/attr", arg0.descFrameTF))
	arg0.abilityArr = arg0:findTF("desc/frame/atttr_panel/abilitys/arr")
	arg0.talentsArr = arg0:findTF("desc/frame/atttr_panel/talents/arr")
	arg0.restAllBtn = arg0:findTF("rest_all", arg0.descFrameTF)

	setActive(arg0.restAllBtn, false)

	arg0.quickBtn = arg0:findTF("quick_btn", arg0.descFrameTF)

	setActive(arg0.quickBtn, false)
	onButton(arg0, arg0.samllTF, function()
		arg0:openDescPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.descPanel, function()
		arg0:closeDescPanel()
	end, SFX_PANEL)
	setText(arg0:findTF("desc/frame/atttr_panel/abilitys/title/Text"), i18n("commander_subtile_ablity"))
	setText(arg0:findTF("desc/frame/atttr_panel/talents/title/Text"), i18n("commander_subtile_talent"))
end

function var0.Update(arg0, arg1)
	arg0.fleet = arg1

	local var0 = arg0.fleet:getCommanders()

	for iter0 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1 = var0[iter0]

		assert(arg0["pos" .. iter0], "pos tf can not nil")
		arg0:updateCommander(arg0["pos" .. iter0], iter0, var1)
	end

	arg0:updateDesc()
	setActive(arg0.smallSalvageMask, arg0.fleet:IsCatSalvage())
	setActive(arg0.descSalvageMask, arg0.fleet:IsCatSalvage())
end

function var0.openDescPanel(arg0, arg1)
	local var0 = arg1 or 0.2

	if LeanTween.isTweening(go(arg0.samllTF)) or LeanTween.isTweening(go(arg0.descFrameTF)) then
		return
	end

	setAnchoredPosition(arg0.samllTF, {
		x = 0
	})
	LeanTween.moveX(arg0.samllTF, 800, var0):setOnComplete(System.Action(function()
		setActive(arg0.descPanel, true)
		pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
		setAnchoredPosition(arg0.descFrameTF, {
			x = 800
		})
		LeanTween.moveX(arg0.descFrameTF, 0, var0)
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
		x = 0
	})
	LeanTween.moveX(arg0.descFrameTF, 800, var0):setOnComplete(System.Action(function()
		setActive(arg0.descPanel, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)
		setAnchoredPosition(arg0.samllTF, {
			x = 800
		})
		LeanTween.moveX(arg0.samllTF, 0, var0)
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
end

function var0.updateSkillTF(arg0, arg1, arg2)
	setActive(arg2, arg1)

	if arg1 then
		local var0 = arg1:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0:getConfig("icon"), "", arg2:Find("icon"))
		setText(arg2:Find("level"), "Lv." .. var0:getLevel())
		onButton(arg0, arg2, function()
			arg0:emit(WorldDetailMediator.OnCmdSkill, var0)
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

	setActive(var0, not arg3)
	setActive(var1, arg3)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		LeanTween.cancel(go(arg0.samllTF))
		LeanTween.cancel(go(arg0.descFrameTF))

		if isActive(arg0.descPanel) then
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)
		end
	end
end

return var0
