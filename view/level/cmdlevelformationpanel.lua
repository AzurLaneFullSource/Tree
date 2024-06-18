local var0_0 = class("CmdLevelFormationPanel", import("..base.BasePanel"))

function var0_0.init(arg0_1)
	arg0_1.descPanel = arg0_1:findTF("desc")
	arg0_1.descFrameTF = arg0_1:findTF("desc/frame")
	arg0_1.descPos1 = arg0_1:findTF("commander1/frame/info", arg0_1.descFrameTF)
	arg0_1.descPos2 = arg0_1:findTF("commander2/frame/info", arg0_1.descFrameTF)
	arg0_1.skillTFPos1 = arg0_1:findTF("commander1/skill_info", arg0_1.descFrameTF)
	arg0_1.skillTFPos2 = arg0_1:findTF("commander2/skill_info", arg0_1.descFrameTF)
	arg0_1.abilitysTF = UIItemList.New(arg0_1:findTF("atttr_panel/abilitys/mask/content", arg0_1.descFrameTF), arg0_1:findTF("atttr_panel/abilitys/mask/content/attr", arg0_1.descFrameTF))
	arg0_1.talentsTF = UIItemList.New(arg0_1:findTF("atttr_panel/talents/mask/content", arg0_1.descFrameTF), arg0_1:findTF("atttr_panel/talents/mask/content/attr", arg0_1.descFrameTF))
	arg0_1.abilityArr = arg0_1:findTF("desc/frame/atttr_panel/abilitys/arr")
	arg0_1.talentsArr = arg0_1:findTF("desc/frame/atttr_panel/talents/arr")
	arg0_1.animtion = arg0_1.descPanel:GetComponent("Animation")
	arg0_1.animtionEvent = arg0_1:findTF("desc"):GetComponent(typeof(DftAniEvent))
end

function var0_0.update(arg0_2, arg1_2, arg2_2)
	arg0_2.callback = arg2_2

	assert(arg1_2)

	arg0_2.fleet = arg1_2

	arg0_2:updateDesc()
end

function var0_0.attach(arg0_3, arg1_3)
	var0_0.super.attach(arg0_3, arg1_3)
	setActive(arg0_3._go, false)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:close()
	end, SFX_PANEL)
end

function var0_0.playAnim(arg0_5, arg1_5)
	arg0_5.animtion:Play(arg1_5)
end

function var0_0.open(arg0_6)
	arg0_6:playAnim("cmdopen")
	setActive(arg0_6._go, true)
	setParent(arg0_6._go, pg.UIMgr.GetInstance().OverlayMain)
	arg0_6._tf:SetAsLastSibling()
end

function var0_0.close(arg0_7)
	arg0_7:playAnim("cmdclose")
	setActive(arg0_7._go, false)
end

function var0_0.updateDesc(arg0_8)
	local var0_8 = arg0_8.fleet:getCommanders()

	for iter0_8 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1_8 = var0_8[iter0_8]

		arg0_8:updateCommander(arg0_8["descPos" .. iter0_8], iter0_8, var1_8)
		arg0_8:updateSkillTF(var1_8, arg0_8["skillTFPos" .. iter0_8])
	end

	arg0_8:updateAdditions()
end

function var0_0.updateAdditions(arg0_9)
	local var0_9 = arg0_9.fleet
	local var1_9 = _.values(var0_9:getCommandersTalentDesc())
	local var2_9, var3_9 = var0_9:getCommandersAddition()

	arg0_9.abilitysTF:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var2_9[arg1_10 + 1]

			setText(arg2_10:Find("name"), AttributeType.Type2Name(var0_10.attrName))
			setText(arg2_10:Find("Text"), string.format("%0.3f", var0_10.value) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0_10.attrName, arg2_10:Find("icon"), false)
			setActive(arg2_10:Find("bg"), arg1_10 % 2 ~= 0)
		end
	end)
	arg0_9.abilitysTF:align(#var2_9)
	setActive(arg0_9.abilityArr, #var2_9 > 4)
	arg0_9.talentsTF:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = var1_9[arg1_11 + 1]

			setScrollText(findTF(arg2_11, "name_mask/name"), var0_11.name)

			local var1_11 = var0_11.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2_11:Find("Text"), var0_11.value .. var1_11)
			setActive(arg2_11:Find("bg"), arg1_11 % 2 ~= 0)
		end
	end)
	arg0_9.talentsTF:align(#var1_9)
	setActive(arg0_9.talentsArr, #var1_9 > 4)
end

function var0_0.updateSkillTF(arg0_12, arg1_12, arg2_12)
	setActive(arg2_12, arg1_12)

	if arg1_12 then
		local var0_12 = arg1_12:getSkills()[1]

		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var0_12:getConfig("icon"), "", arg2_12:Find("icon"))
		setText(arg2_12:Find("level"), "Lv." .. var0_12:getLevel())
	end
end

function var0_0.updateCommander(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg1_13:Find("add")
	local var1_13 = arg1_13:Find("info")

	if arg3_13 then
		local var2_13 = arg1_13:Find("info/mask/icon")
		local var3_13 = arg1_13:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. arg3_13:getPainting(), "", var2_13)

		local var4_13 = arg1_13:Find("info/name")

		if var4_13 then
			setText(var4_13, arg3_13:getName())
		end

		local var5_13 = Commander.rarity2Frame(arg3_13:getRarity())

		setImageSprite(var3_13, GetSpriteFromAtlas("weaponframes", "commander_" .. var5_13))
	end

	onButton(arg0_13, var1_13, function()
		if arg0_13.callback then
			arg0_13.callback(arg2_13)
		end
	end, SFX_PANEL)
	onButton(arg0_13, var0_13, function()
		if arg0_13.callback then
			arg0_13.callback(arg2_13)
		end
	end, SFX_PANEL)
	setActive(var0_13, not arg3_13)
	setActive(var1_13, arg3_13)
end

function var0_0.enable(arg0_16, arg1_16)
	setActive(arg0_16._go, arg1_16)
end

function var0_0.clear(arg0_17)
	setActive(arg0_17._go, false)
	setParent(arg0_17._go, arg0_17.parent.topPanel)
end

return var0_0
