local var0_0 = class("ShipProfileDetailPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShipProfileDetailPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.detailRightBlurRect = arg0_2:findTF("bg")
	arg0_2.propertyTF = arg0_2:findTF("bg/property_panel/frame")
	arg0_2.skillRect = arg0_2:findTF("bg/skill_panel/frame/skills_rect")
	arg0_2.skillPanel = arg0_2:findTF("skills", arg0_2.skillRect)
	arg0_2.skillTpl = arg0_2:findTF("skilltpl", arg0_2.skillRect)
	arg0_2.skillArrLeft = arg0_2:findTF("bg/skill_panel/frame/arrow1")
	arg0_2.skillArrRight = arg0_2:findTF("bg/skill_panel/frame/arrow2")
end

function var0_0.OnInit(arg0_3)
	return
end

function var0_0.EnterAnim(arg0_4, arg1_4, arg2_4)
	LeanTween.moveX(rtf(arg0_4._tf), 0, arg1_4):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		if arg2_4 then
			arg2_4()
		end
	end))
end

function var0_0.ExistAnim(arg0_6, arg1_6, arg2_6)
	LeanTween.moveX(rtf(arg0_6._tf), 1000, arg1_6):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		if arg2_6 then
			arg2_6()
		end

		arg0_6:Hide()
	end))
end

function var0_0.Update(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8:Show()

	arg0_8.shipGroup = arg1_8
	arg0_8.showTrans = arg2_8

	arg0_8:InitSkills()
	arg0_8:InitProperty()

	if arg3_8 then
		arg3_8()
	end
end

function var0_0.InitProperty(arg0_9)
	arg0_9.propertyPanel = PropertyPanel.New(arg0_9.propertyTF)

	arg0_9.propertyPanel:initProperty(arg0_9.shipGroup.shipConfig.id)

	if arg0_9.showTrans and arg0_9.shipGroup.trans then
		arg0_9.propertyPanel:initRadar(arg0_9.shipGroup.groupConfig.trans_radar_chart)
	end
end

function var0_0.InitSkills(arg0_10)
	local var0_10 = pg.ship_data_template[arg0_10.shipGroup:getShipConfigId(arg0_10.showTrans)]
	local var1_10 = 0
	local var2_10 = Clone(var0_10.buff_list_display)

	if not arg0_10.showTrans then
		_.each(arg0_10.shipGroup.groupConfig.trans_skill, function(arg0_11)
			table.removebyvalue(var2_10, arg0_11)
		end)
	end

	local var3_10 = arg0_10.skillPanel.childCount
	local var4_10 = #var2_10 < 3 and 3 or #var2_10

	for iter0_10 = var3_10 + 1, var4_10 do
		cloneTplTo(arg0_10.skillTpl, arg0_10.skillPanel)
	end

	local var5_10 = arg0_10.skillPanel.childCount

	for iter1_10 = 1, var5_10 do
		local var6_10 = arg0_10.skillPanel:GetChild(iter1_10 - 1)

		if iter1_10 <= #var2_10 then
			local var7_10 = var2_10[iter1_10]

			arg0_10:UpdateSkill(var6_10, var7_10)
		else
			setActive(arg0_10:findTF("icon", var6_10), false)
			setActive(arg0_10:findTF("add", var6_10), true)
		end

		setActive(var6_10, iter1_10 <= var4_10)
	end

	setActive(arg0_10.skillArrLeft, #var2_10 > 3)
	setActive(arg0_10.skillArrRight, #var2_10 > 3)

	if #var2_10 > 3 then
		onScroll(arg0_10, arg0_10.skillRect, function(arg0_12)
			setActive(arg0_10.skillArrLeft, arg0_12.x > 0.01)
			setActive(arg0_10.skillArrRight, arg0_12.x < 0.99)
		end)
	else
		GetComponent(arg0_10.skillRect, typeof(ScrollRect)).onValueChanged:RemoveAllListeners()
	end

	setAnchoredPosition(arg0_10.skillPanel, {
		x = 0
	})
end

function var0_0.UpdateSkill(arg0_13, arg1_13, arg2_13)
	if arg0_13.shipGroup:isBluePrintGroup() then
		for iter0_13, iter1_13 in ipairs(arg0_13.shipGroup:getBluePrintChangeSkillList()) do
			if iter1_13[1] == arg2_13 then
				arg2_13 = iter1_13[2]

				break
			end
		end
	end

	local var0_13 = findTF(arg1_13, "icon")
	local var1_13 = getSkillConfig(arg2_13)

	LoadImageSpriteAsync("skillicon/" .. var1_13.icon, var0_13)
	setActive(arg0_13:findTF("icon", arg1_13), true)
	setActive(arg0_13:findTF("add", arg1_13), false)
	onButton(arg0_13, arg1_13, function()
		arg0_13:emit(ShipProfileScene.SHOW_SKILL_INFO, var1_13.id, {
			id = var1_13.id,
			level = pg.skill_data_template[var1_13.id].max_level
		})
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
