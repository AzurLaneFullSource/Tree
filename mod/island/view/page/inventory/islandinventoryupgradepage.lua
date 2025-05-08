local var0_0 = class("IslandInventoryUpgradePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandInventoryUpgradeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.consumeList = UIItemList.New(arg0_2:findTF("frame/bottom/consume/list"), arg0_2:findTF("frame/bottom/consume/list/tpl"))
	arg0_2.maxLevelTip = arg0_2:findTF("frame/bottom/bg/max_level")
	arg0_2.capacityTxt = arg0_2:findTF("frame/bottom/capacity/Text"):GetComponent(typeof(Text))
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm")
	arg0_2.levelTxt = arg0_2:findTF("frame/top/level"):GetComponent(typeof(Text))
	arg0_2.nextLevelTxt = arg0_2:findTF("frame/top/level/next"):GetComponent(typeof(Text))
	arg0_2.maxLevelTxt = arg0_2:findTF("frame/top/max_level"):GetComponent(typeof(Text))
	arg0_2.closeBtn = arg0_2:findTF("frame/top/close")

	setText(arg0_2:findTF("frame/top/title"), i18n1("仓库升级"))
	setText(arg0_2:findTF("frame/bottom/Text"), i18n1("升级需求"))
	setText(arg0_2:findTF("frame/bottom/bg/max_level"), i18n1("已经达到满级"))
	setText(arg0_2:findTF("frame/bottom/capacity/label"), i18n1("仓库容量"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if not getProxy(IslandProxy):GetIsland():GetInventoryAgency():CanUpgrade() then
			return
		end

		arg0_3:emit(IslandMediator.ON_UPGRADE_INVENTORY)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7)
	var0_0.super.Show(arg0_7)

	local var0_7 = getProxy(IslandProxy):GetIsland()

	arg0_7:UpdateConsume(var0_7)
	arg0_7:UpdateAddition(var0_7)
	arg0_7:UpdateStyle(var0_7)
end

function var0_0.UpdateStyle(arg0_8, arg1_8)
	local var0_8 = arg1_8:GetInventoryAgency()
	local var1_8 = var0_8:IsMaxLevel()

	setActive(arg0_8.confirmBtn, not var1_8)
	setActive(arg0_8.maxLevelTxt.gameObject, var1_8)
	setActive(arg0_8.levelTxt.gameObject, not var1_8)

	if var1_8 then
		arg0_8.maxLevelTxt.text = "Lv." .. var0_8:GetLevel()
	end

	setActive(arg0_8.maxLevelTip, var1_8)
	setGray(arg0_8.confirmBtn, not var0_8:CanUpgrade(), true)
end

function var0_0.UpdateAddition(arg0_9, arg1_9)
	local var0_9 = arg1_9:GetInventoryAgency()
	local var1_9 = var0_9:GetCapacity()
	local var2_9 = var0_9:GetLevel()
	local var3_9 = var0_9:StaticGetCapacity(var2_9 + 1) - var1_9

	arg0_9.capacityTxt.text = "<color=#393a3c>" .. var1_9 .. "</color><color=#39bfff> + " .. var3_9 .. "</color>"
	arg0_9.levelTxt.text = "Lv." .. var2_9
	arg0_9.nextLevelTxt.text = "Lv." .. var2_9 + 1
end

function var0_0.UpdateConsume(arg0_10, arg1_10)
	local var0_10 = arg1_10:GetInventoryAgency():GetUpgradeConsume()

	arg0_10.consumeList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = var0_10[arg1_11 + 1]
			local var1_11 = Drop.Create(var0_11)

			updateDrop(arg2_11, var1_11)

			local var2_11 = var1_11:getOwnedCount()
			local var3_11 = setColorStr(var2_11, var2_11 >= var1_11.count and COLOR_GREEN or COLOR_RED)

			setText(arg2_11:Find("icon_bg/count_bg/count"), var3_11 .. "/" .. var1_11.count)
		end
	end)
	arg0_10.consumeList:align(#var0_10)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
