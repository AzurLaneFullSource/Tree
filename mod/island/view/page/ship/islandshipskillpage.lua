local var0_0 = class("IslandShipSkillPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipSkillUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.skillIcon = arg0_2:findTF("adapt/attr_panel/skill/icon")
	arg0_2.skillName = arg0_2:findTF("adapt/attr_panel/skill/name"):GetComponent(typeof(Text))
	arg0_2.skillLv = arg0_2:findTF("adapt/attr_panel/skill/level"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("adapt/attr_panel/desc/Text"):GetComponent(typeof(Text))
	arg0_2.descList = UIItemList.New(arg0_2:findTF("adapt/attr_panel/desc/list"), arg0_2:findTF("adapt/attr_panel/desc/list/tpl"))
	arg0_2.consumeList = UIItemList.New(arg0_2:findTF("adapt/attr_panel/consume/list"), arg0_2:findTF("adapt/attr_panel/consume/list/tpl"))
	arg0_2.upgradeBtn = arg0_2:findTF("adapt/attr_panel/consume/upgrade")
	arg0_2.tipTxt = arg0_2:findTF("adapt/attr_panel/consume/tip"):GetComponent(typeof(Text))
	arg0_2.goldTr = arg0_2:findTF("adapt/attr_panel/consume/label")
	arg0_2.goldTxt = arg0_2:findTF("adapt/attr_panel/consume/label/Text"):GetComponent(typeof(Text))
	arg0_2.goldIco = arg0_2:findTF("adapt/attr_panel/consume/label/icon")

	setText(arg0_2:findTF("adapt/attr_panel/consume/label/label1"), i18n1("消耗"))
end

function var0_0.OnInit(arg0_3)
	return
end

function var0_0.AddListeners(arg0_4)
	arg0_4:AddListener(GAME.ISLAND_UPGRADE_SKILL_DONE, arg0_4.OnSkillUpgrade)
end

function var0_0.RemoveListeners(arg0_5)
	arg0_5:RemoveListener(GAME.ISLAND_UPGRADE_SKILL_DONE, arg0_5.OnSkillUpgrade)
end

function var0_0.OnSkillUpgrade(arg0_6)
	arg0_6:Flush()
end

function var0_0.OnShow(arg0_7, arg1_7)
	arg0_7.selectedId = arg1_7

	arg0_7:Flush()
end

function var0_0.Flush(arg0_8)
	local var0_8 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipByConfigId(arg0_8.selectedId)

	if var0_8 == nil then
		return
	end

	arg0_8:UpdateMainView(var0_8)
end

function var0_0.UpdateMainView(arg0_9, arg1_9)
	local var0_9 = arg1_9:GetMainSkill()
	local var1_9 = arg1_9:GetNextLevelMainSkillId()

	arg0_9:FlushLevelAndIcon(arg1_9, var0_9, var1_9)
	arg0_9:FlushDesc(arg1_9, var0_9, var1_9)
	arg0_9:FlushConsume(arg1_9, var0_9, var1_9)
	arg0_9:FlushUpgradeBtn(arg1_9, var0_9, var1_9)
end

function var0_0.FlushLevelAndIcon(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = pg.island_ship_skill[arg2_10]

	GetImageSpriteFromAtlasAsync("IslandSkillIcon/" .. var0_10.icon, "", arg0_10.skillIcon)

	arg0_10.skillName.text = var0_10.name

	if arg3_10 then
		arg0_10.skillLv.text = "<color=#393a3c>[ Lv." .. var0_10.level .. " ]</color><color=#006cff>   >   [ Lv." .. var0_10.level + 1 .. " ]</color>"
	else
		arg0_10.skillLv.text = "<color=#393a3c>MAX</color>"
	end
end

function var0_0.FlushDesc(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg1_11:GetMainSkillUpgradeEffectDesc()

	arg0_11.descList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var0_11[arg1_12 + 1]
			local var1_12 = var0_12.level
			local var2_12 = var0_12.desc
			local var3_12 = pg.island_ship_skill[arg2_11].level
			local var4_12 = var3_12 + 1 == var1_12 and "#006cff" or "#393a3c"

			setText(arg2_12:Find("level"), "<color=" .. var4_12 .. ">[ Lv." .. var1_12 .. " ]</color>")
			setText(arg2_12:Find("Text"), "<color=" .. var4_12 .. ">" .. i18n1("解锁：") .. var2_12 .. "</color>")

			GetOrAddComponent(arg2_12, typeof(CanvasGroup)).alpha = var1_12 <= var3_12 + 1 and 1 or 0.4
		end
	end)
	arg0_11.descList:align(#var0_11)

	if arg3_11 then
		local var1_11 = pg.island_ship_skill[arg3_11]

		arg0_11.descTxt.text = var1_11.desc
	else
		local var2_11 = pg.island_ship_skill[arg2_11]

		arg0_11.descTxt.text = var2_11.desc
	end
end

function var0_0.FlushConsume(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg1_13:GetUpgradeSkillConsume()
	local var1_13 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	arg0_13.consumeList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14 + 2]
			local var1_14 = Drop.New({
				type = var0_14[1],
				id = var0_14[2],
				count = var0_14[3]
			})

			updateDrop(arg2_14, var1_14)

			local var2_14 = var1_13:GetOwnCount(var1_14.id)
			local var3_14 = var2_14 >= var1_14.count and "#FFFFFF" or "#ff7e7e"

			setText(arg2_14:Find("icon_bg/count"), setColorStr(var2_14, var3_14) .. "/" .. var1_14.count)
			onButton(arg0_13, arg2_14, function()
				arg0_13:ShowMsgBox({
					title = i18n1("详情"),
					type = IslandMsgBox.TYPE_ITEM_DESC,
					itemId = var1_14.id
				})
			end, SFX_PANEL)
		end
	end)
	arg0_13.consumeList:align(math.max(0, #var0_13 - 1))
end

function var0_0.FlushUpgradeBtn(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg1_16:GetUpgradeSkillConsume()
	local var1_16 = arg1_16:CanUpgradeMainSkill()

	arg0_16.upgradeBtn:GetComponent(typeof(Image)).color = var1_16 and Color.New(0.2235294, 0.7490196, 1, 1) or Color.New(0.6117647, 0.6117647, 0.6117647, 1)

	local var2_16 = true

	if arg3_16 then
		local var3_16 = pg.island_ship_skill[arg3_16].upgrade_unlock

		var2_16 = var3_16 <= arg1_16:GetLevel()
		arg0_16.tipTxt.text = i18n1("需要角色等级达到" .. var3_16)
	end

	local var4_16 = var0_16[1]

	if var4_16 then
		local var5_16 = Drop.New({
			type = var4_16[1],
			id = var4_16[2],
			count = var4_16[3]
		})
		local var6_16 = var5_16:getConfigTable()

		GetImageSpriteFromAtlasAsync(var6_16.icon, "", arg0_16.goldIco)

		arg0_16.goldTxt.text = var5_16.count
	end

	setActive(arg0_16.tipTxt.gameObject, not var2_16)
	setActive(arg0_16.goldTr, var2_16 and var4_16)
	setActive(arg0_16.upgradeBtn, not arg1_16:IsMaxMainSkillLevel())
	onButton(arg0_16, arg0_16.upgradeBtn, function()
		if not var1_16 then
			return
		end

		arg0_16:emit(IslandMediator.UPGRADE_SKILL, arg1_16.id)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_18)
	return
end

return var0_0
