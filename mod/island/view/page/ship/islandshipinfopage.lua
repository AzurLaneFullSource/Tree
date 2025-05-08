local var0_0 = class("IslandShipInfoPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipInfoUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.skillUpgradeBtn = arg0_2:findTF("adapt/skill_status_panel/skill/upgrade")
	arg0_2.nameTxt = arg0_2:findTF("adapt/level_panel/name"):GetComponent(typeof(Text))
	arg0_2.nameEnTxt = arg0_2:findTF("adapt/level_panel/en"):GetComponent(typeof(Text))
	arg0_2.rarityImg = arg0_2:findTF("adapt/level_panel/rarity"):GetComponent(typeof(Image))
	arg0_2.levelTxt = arg0_2:findTF("adapt/level_panel/exp"):GetComponent(typeof(Text))
	arg0_2.uiAttrList = UIItemList.New(arg0_2:findTF("adapt/attr_panel/list"), arg0_2:findTF("adapt/attr_panel/list/tpl"))
	arg0_2.skillInfoFrame = arg0_2:findTF("adapt/skill_status_panel/skill/info")
	arg0_2.skillIconImg = arg0_2:findTF("adapt/skill_status_panel/skill/icon")
	arg0_2.skillName = arg0_2:findTF("adapt/skill_status_panel/skill/info/name"):GetComponent(typeof(Text))
	arg0_2.skillLevel = arg0_2:findTF("adapt/skill_status_panel/skill/info/level"):GetComponent(typeof(Text))
	arg0_2.skillDesc = arg0_2:findTF("adapt/skill_status_panel/skill/info/desc/Text"):GetComponent(typeof(Text))
	arg0_2.attrDescPanel = IslandShipAttrDescPanel.New(arg0_2:findTF("adapt/tip"))
	arg0_2.statusPanel = IslandShipStatusPanel.New(arg0_2:findTF("adapt/skill_status_panel/status"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.skillUpgradeBtn, function()
		arg0_3:emit(IslandShipMainPage.OPEN_PAGE, IslandShipMainPage.PAGE_SKILL)
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5, arg1_5)
	local var0_5 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipByConfigId(arg1_5)

	if var0_5 == nil then
		return
	end

	arg0_5:UpdateMainView(var0_5)
end

function var0_0.UpdateMainView(arg0_6, arg1_6)
	arg0_6:UpdateLevelAndExp(arg1_6)
	arg0_6:UpdateAttrs(arg1_6)
	arg0_6:UpdateSkill(arg1_6)
	arg0_6:UpdateStatus(arg1_6)
end

function var0_0.UpdateLevelAndExp(arg0_7, arg1_7)
	arg0_7.nameTxt.text = arg1_7:GetName()
	arg0_7.nameEnTxt.text = arg1_7:GetEnName()

	local var0_7 = arg1_7:GetRarity()

	arg0_7.rarityImg.sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", "rarity_" .. var0_7)

	if not arg1_7:IsMaxLevel() then
		local var1_7 = arg1_7:GetExp()
		local var2_7 = arg1_7:GetTargetExp()

		arg0_7.levelTxt.text = "Lv." .. arg1_7:GetLevel() .. " [" .. var1_7 .. "/" .. var2_7 .. "]"
	else
		arg0_7.levelTxt.text = "Lv." .. arg1_7:GetLevel() .. "[MAX]"
	end
end

function var0_0.UpdateAttrs(arg0_8, arg1_8)
	local var0_8 = IslandShipAttr.ATTRS

	arg0_8.uiAttrList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg1_9 + 1

			if var0_9 > #var0_8 then
				setText(arg2_9:Find("name"), i18n1("体力"))
				setText(arg2_9:Find("value"), arg1_8:GetEnergy() .. "/" .. arg1_8:GetMaxEnergy())

				arg2_9:Find("grade"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", "grade_E")
			else
				arg0_8:UpdateAttr(arg2_9, var0_8, var0_9, arg1_8)
			end
		end
	end)
	arg0_8.uiAttrList:align(#var0_8 + 1)
end

function var0_0.UpdateAttr(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	local var0_10 = arg2_10[arg3_10]
	local var1_10 = arg4_10:GetAttr(var0_10)

	setText(arg1_10:Find("name"), IslandShipAttr.ToChinese(var0_10))
	setText(arg1_10:Find("value"), var1_10)

	local var2_10 = arg4_10:GetAttrGrade(var0_10)

	arg1_10:Find("grade"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", "grade_" .. var2_10)

	local var3_10 = (var2_10 == "A" or var2_10 == "S") and var2_10 or "B"

	arg1_10:Find("bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var3_10 .. "_bg")

	onButton(arg0_10, arg1_10, function()
		local var0_11 = arg1_10.parent:TransformPoint(arg1_10.localPosition)
		local var1_11 = arg0_10._tf:InverseTransformPoint(var0_11)

		arg0_10.attrDescPanel:Show(arg4_10, var0_10, var1_11)
	end, SFX_PANEL)
end

function var0_0.UpdateSkill(arg0_12, arg1_12)
	local var0_12 = arg1_12:GetMainSkill()
	local var1_12 = pg.island_ship_skill[var0_12]

	assert(var1_12, var0_12)
	GetImageSpriteFromAtlasAsync("IslandSkillIcon/" .. var1_12.icon, "", arg0_12.skillIconImg)

	arg0_12.skillName.text = var1_12.name
	arg0_12.skillLevel.text = "[Lv." .. var1_12.level .. "]"
	arg0_12.skillDesc.text = var1_12.desc

	local var2_12 = arg1_12:CanUpgradeMainSkill()

	setActive(arg0_12.skillUpgradeBtn, var2_12)

	arg0_12.skillInfoFrame.sizeDelta = var2_12 and Vector2(380, 120) or Vector2(439, 120)
end

function var0_0.UpdateStatus(arg0_13, arg1_13)
	arg0_13.statusPanel:Flush(arg1_13)

	local var0_13 = arg1_13:GetValidStatus()

	onButton(arg0_13, arg0_13.statusPanel.viewBtn, function()
		arg0_13:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_STATUS,
			title = i18n1("详情"),
			statusList = var0_13
		})
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_15)
	arg0_15.shipTrs = nil

	arg0_15.attrDescPanel:Dispose()

	arg0_15.attrDescPanel = nil

	arg0_15.statusPanel:Dispose()

	arg0_15.statusPanel = nil
end

return var0_0
