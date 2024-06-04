local var0 = class("ShipProfileDetailPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShipProfileDetailPage"
end

function var0.OnLoaded(arg0)
	arg0.detailRightBlurRect = arg0:findTF("bg")
	arg0.propertyTF = arg0:findTF("bg/property_panel/frame")
	arg0.skillRect = arg0:findTF("bg/skill_panel/frame/skills_rect")
	arg0.skillPanel = arg0:findTF("skills", arg0.skillRect)
	arg0.skillTpl = arg0:findTF("skilltpl", arg0.skillRect)
	arg0.skillArrLeft = arg0:findTF("bg/skill_panel/frame/arrow1")
	arg0.skillArrRight = arg0:findTF("bg/skill_panel/frame/arrow2")
end

function var0.OnInit(arg0)
	return
end

function var0.EnterAnim(arg0, arg1, arg2)
	LeanTween.moveX(rtf(arg0._tf), 0, arg1):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		if arg2 then
			arg2()
		end
	end))
end

function var0.ExistAnim(arg0, arg1, arg2)
	LeanTween.moveX(rtf(arg0._tf), 1000, arg1):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		if arg2 then
			arg2()
		end

		arg0:Hide()
	end))
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0:Show()

	arg0.shipGroup = arg1
	arg0.showTrans = arg2

	arg0:InitSkills()
	arg0:InitProperty()

	if arg3 then
		arg3()
	end
end

function var0.InitProperty(arg0)
	arg0.propertyPanel = PropertyPanel.New(arg0.propertyTF)

	arg0.propertyPanel:initProperty(arg0.shipGroup.shipConfig.id)

	if arg0.showTrans and arg0.shipGroup.trans then
		arg0.propertyPanel:initRadar(arg0.shipGroup.groupConfig.trans_radar_chart)
	end
end

function var0.InitSkills(arg0)
	local var0 = pg.ship_data_template[arg0.shipGroup:getShipConfigId(arg0.showTrans)]
	local var1 = 0
	local var2 = Clone(var0.buff_list_display)

	if not arg0.showTrans then
		_.each(arg0.shipGroup.groupConfig.trans_skill, function(arg0)
			table.removebyvalue(var2, arg0)
		end)
	end

	local var3 = arg0.skillPanel.childCount
	local var4 = #var2 < 3 and 3 or #var2

	for iter0 = var3 + 1, var4 do
		cloneTplTo(arg0.skillTpl, arg0.skillPanel)
	end

	local var5 = arg0.skillPanel.childCount

	for iter1 = 1, var5 do
		local var6 = arg0.skillPanel:GetChild(iter1 - 1)

		if iter1 <= #var2 then
			local var7 = var2[iter1]

			arg0:UpdateSkill(var6, var7)
		else
			setActive(arg0:findTF("icon", var6), false)
			setActive(arg0:findTF("add", var6), true)
		end

		setActive(var6, iter1 <= var4)
	end

	setActive(arg0.skillArrLeft, #var2 > 3)
	setActive(arg0.skillArrRight, #var2 > 3)

	if #var2 > 3 then
		onScroll(arg0, arg0.skillRect, function(arg0)
			setActive(arg0.skillArrLeft, arg0.x > 0.01)
			setActive(arg0.skillArrRight, arg0.x < 0.99)
		end)
	else
		GetComponent(arg0.skillRect, typeof(ScrollRect)).onValueChanged:RemoveAllListeners()
	end

	setAnchoredPosition(arg0.skillPanel, {
		x = 0
	})
end

function var0.UpdateSkill(arg0, arg1, arg2)
	if arg0.shipGroup:isBluePrintGroup() then
		for iter0, iter1 in ipairs(arg0.shipGroup:getBluePrintChangeSkillList()) do
			if iter1[1] == arg2 then
				arg2 = iter1[2]

				break
			end
		end
	end

	local var0 = findTF(arg1, "icon")
	local var1 = getSkillConfig(arg2)

	LoadImageSpriteAsync("skillicon/" .. var1.icon, var0)
	setActive(arg0:findTF("icon", arg1), true)
	setActive(arg0:findTF("add", arg1), false)
	onButton(arg0, arg1, function()
		arg0:emit(ShipProfileScene.SHOW_SKILL_INFO, var1.id, {
			id = var1.id,
			level = pg.skill_data_template[var1.id].max_level
		})
	end, SFX_PANEL)
end

function var0.OnDestroy(arg0)
	return
end

return var0
