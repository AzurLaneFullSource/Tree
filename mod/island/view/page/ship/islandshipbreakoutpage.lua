local var0_0 = class("IslandShipBreakoutPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipBreakoutUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiStarPreList = UIItemList.New(arg0_2:findTF("frame_1/star/prev"), arg0_2:findTF("frame_1/star/prev/tpl"))
	arg0_2.uiStarNextList = UIItemList.New(arg0_2:findTF("frame_1/star/now"), arg0_2:findTF("frame_1/star/now/tpl"))
	arg0_2.prevLevelTxt = arg0_2:findTF("frame_1/level/prev"):GetComponent(typeof(Text))
	arg0_2.nextLevelTxt = arg0_2:findTF("frame_1/level/now"):GetComponent(typeof(Text))
	arg0_2.skillTxt = arg0_2:findTF("frame_1/skill/Text"):GetComponent(typeof(Text))
	arg0_2.skillLabelTxt = arg0_2:findTF("frame_1/skill/now"):GetComponent(typeof(Text))
	arg0_2.uiAttrList = UIItemList.New(arg0_2:findTF("frame_3/attrs"), arg0_2:findTF("frame_3/attrs/tpl"))
	arg0_2.uiConsumeList = UIItemList.New(arg0_2:findTF("frame_2/comsume"), arg0_2:findTF("frame_2/comsume/tpl"))
	arg0_2.upgradeBtn = arg0_2:findTF("btn_confirm")
	arg0_2.closeBtn = arg0_2:findTF("frame_1/close")

	setText(arg0_2:findTF("frame_1/title"), i18n("island_ship_breakout"))
	setText(arg0_2:findTF("frame_2/consume_title/Text"), i18n("island_ship_breakout_consume"))
	setText(arg0_2.upgradeBtn:Find("Text"), i18n("island_chara_breakout_button"))
end

function var0_0.AddListeners(arg0_3)
	arg0_3:AddListener(GAME.ISLAND_SHIP_BREAKOUT_DONE, arg0_3.OnBreakOutDone)
end

function var0_0.RemoveListeners(arg0_4)
	arg0_4:RemoveListener(GAME.ISLAND_SHIP_BREAKOUT_DONE, arg0_4.OnBreakOutDone)
end

function var0_0.OnBreakOutDone(arg0_5)
	arg0_5:Hide()
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.closeBtn, function()
		arg0_6:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_9, arg1_9)
	local var0_9 = Clone(arg1_9)

	var0_9:UpgradeBreakOut()
	arg0_9:BlurPanel(var0_9, arg1_9)
	arg0_9:UpdateBreakOutLevel(var0_9, arg1_9)
	arg0_9:UpdateLevel(var0_9, arg1_9)
	arg0_9:UpdateSkill(var0_9, arg1_9)
	arg0_9:UpdateAttrs(var0_9, arg1_9)
	arg0_9:UpdateConsume(var0_9, arg1_9)
	arg0_9:UpdateUpgradeBtn(arg1_9)
end

function var0_0.UpdateBreakOutLevel(arg0_10, arg1_10, arg2_10)
	arg0_10.uiStarPreList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			setActive(arg2_11:Find("Image"), arg1_11 + 1 <= arg2_10:GetBreakLevel())
		end
	end)
	arg0_10.uiStarPreList:align(arg2_10:GetBreakMaxLevel())
	arg0_10.uiStarNextList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			setActive(arg2_12:Find("Image"), arg1_12 + 1 <= arg1_10:GetBreakLevel())
		end
	end)
	arg0_10.uiStarNextList:align(arg1_10:GetBreakMaxLevel())
end

function var0_0.UpdateLevel(arg0_13, arg1_13, arg2_13)
	arg0_13.prevLevelTxt.text = "Lv." .. arg2_13:GetMaxLevel()
	arg0_13.nextLevelTxt.text = "Lv." .. arg1_13:GetMaxLevel()
end

function var0_0.UpdateSkill(arg0_14, arg1_14, arg2_14)
	local var0_14 = not arg2_14:GetSkill():IsUnlock()

	if arg1_14:GetSkill():IsUnlock() and var0_14 then
		local var1_14 = arg2_14:GetSkill():GetName()

		arg0_14.skillTxt.text = var1_14
		arg0_14.skillLabelTxt.text = i18n("island_ship_newskill_unlock")
	else
		arg0_14.skillTxt.text = ""
		arg0_14.skillLabelTxt.text = ""
	end
end

function var0_0.UpdateAttrs(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg1_15:GetGrowthAtt()
	local var1_15 = arg2_15:GetGrowthAtt()

	arg0_15.uiAttrList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = IslandShipAttr.ATTRS[arg1_16 + 1]
			local var1_16 = arg2_15:GetAttrGrade(var0_16)
			local var2_16 = IslandShipAttr.Grade2Img(var1_16)

			arg2_16:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var2_16[2])

			setText(arg2_16:Find("name"), IslandShipAttr.ToChinese(var0_16))
			setText(arg2_16:Find("value"), "+" .. (var1_15[var0_16] or 0) .. "  >>>  +" .. (var0_15[var0_16] or 0))
		end
	end)
	arg0_15.uiAttrList:align(#IslandShipAttr.ATTRS)
end

function var0_0.UpdateConsume(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg2_17:GetBreakoutMatrials()
	local var1_17 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	arg0_17.uiConsumeList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var0_17[arg1_18 + 1]

			updateCustomDrop(arg2_18, var0_18)

			local var1_18 = var1_17:GetOwnCount(var0_18.id)
			local var2_18 = setColorStr(var1_18, var1_18 >= var0_18.count and COLOR_GREEN or COLOR_RED)

			setText(arg2_18:Find("icon_bg/count_bg/count"), var2_18 .. "/" .. var0_18.count)
		end
	end)
	arg0_17.uiConsumeList:align(#var0_17)
end

function var0_0.UpdateUpgradeBtn(arg0_19, arg1_19)
	local var0_19 = arg1_19:GetBreakoutMatrials()
	local var1_19 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var2_19 = _.all(var0_19, function(arg0_20)
		return var1_19:GetOwnCount(arg0_20.id) >= arg0_20.count
	end)

	setGray(arg0_19.upgradeBtn, not var2_19, true)
	onButton(arg0_19, arg0_19.upgradeBtn, function()
		if not var2_19 then
			return
		end

		arg0_19:emit(IslandMediator.SHIP_BREAKOUT, arg1_19.id)
	end, SFX_PANEL)
end

function var0_0.OnHide(arg0_22)
	arg0_22:UnBlurPanel()
end

return var0_0
