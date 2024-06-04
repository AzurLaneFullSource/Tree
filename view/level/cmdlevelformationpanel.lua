local var0 = class("CmdLevelFormationPanel", import("..base.BasePanel"))

function var0.init(arg0)
	arg0.descPanel = arg0:findTF("desc")
	arg0.descFrameTF = arg0:findTF("desc/frame")
	arg0.descPos1 = arg0:findTF("commander1/frame/info", arg0.descFrameTF)
	arg0.descPos2 = arg0:findTF("commander2/frame/info", arg0.descFrameTF)
	arg0.skillTFPos1 = arg0:findTF("commander1/skill_info", arg0.descFrameTF)
	arg0.skillTFPos2 = arg0:findTF("commander2/skill_info", arg0.descFrameTF)
	arg0.abilitysTF = UIItemList.New(arg0:findTF("atttr_panel/abilitys/mask/content", arg0.descFrameTF), arg0:findTF("atttr_panel/abilitys/mask/content/attr", arg0.descFrameTF))
	arg0.talentsTF = UIItemList.New(arg0:findTF("atttr_panel/talents/mask/content", arg0.descFrameTF), arg0:findTF("atttr_panel/talents/mask/content/attr", arg0.descFrameTF))
	arg0.abilityArr = arg0:findTF("desc/frame/atttr_panel/abilitys/arr")
	arg0.talentsArr = arg0:findTF("desc/frame/atttr_panel/talents/arr")
	arg0.animtion = arg0.descPanel:GetComponent("Animation")
	arg0.animtionEvent = arg0:findTF("desc"):GetComponent(typeof(DftAniEvent))
end

function var0.update(arg0, arg1, arg2)
	arg0.callback = arg2

	assert(arg1)

	arg0.fleet = arg1

	arg0:updateDesc()
end

function var0.attach(arg0, arg1)
	var0.super.attach(arg0, arg1)
	setActive(arg0._go, false)
	onButton(arg0, arg0._tf, function()
		arg0:close()
	end, SFX_PANEL)
end

function var0.playAnim(arg0, arg1)
	arg0.animtion:Play(arg1)
end

function var0.open(arg0)
	arg0:playAnim("cmdopen")
	setActive(arg0._go, true)
	setParent(arg0._go, pg.UIMgr.GetInstance().OverlayMain)
	arg0._tf:SetAsLastSibling()
end

function var0.close(arg0)
	arg0:playAnim("cmdclose")
	setActive(arg0._go, false)
end

function var0.updateDesc(arg0)
	local var0 = arg0.fleet:getCommanders()

	for iter0 = 1, CommanderConst.MAX_FORMATION_POS do
		local var1 = var0[iter0]

		arg0:updateCommander(arg0["descPos" .. iter0], iter0, var1)
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
			setText(arg2:Find("Text"), string.format("%0.3f", var0.value) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", var0.attrName, arg2:Find("icon"), false)
			setActive(arg2:Find("bg"), arg1 % 2 ~= 0)
		end
	end)
	arg0.abilitysTF:align(#var2)
	setActive(arg0.abilityArr, #var2 > 4)
	arg0.talentsTF:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]

			setScrollText(findTF(arg2, "name_mask/name"), var0.name)

			local var1 = var0.type == CommanderConst.TALENT_ADDITION_RATIO and "%" or ""

			setText(arg2:Find("Text"), var0.value .. var1)
			setActive(arg2:Find("bg"), arg1 % 2 ~= 0)
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
	end
end

function var0.updateCommander(arg0, arg1, arg2, arg3)
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

	onButton(arg0, var1, function()
		if arg0.callback then
			arg0.callback(arg2)
		end
	end, SFX_PANEL)
	onButton(arg0, var0, function()
		if arg0.callback then
			arg0.callback(arg2)
		end
	end, SFX_PANEL)
	setActive(var0, not arg3)
	setActive(var1, arg3)
end

function var0.enable(arg0, arg1)
	setActive(arg0._go, arg1)
end

function var0.clear(arg0)
	setActive(arg0._go, false)
	setParent(arg0._go, arg0.parent.topPanel)
end

return var0
