local var0_0 = class("IslandAwardDisplay4ShipBreakWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplay4ShipBreakUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.title = arg0_2:findTF("frame/Board/Top/text/text"):GetComponent("Text")
	arg0_2.uiNewStart = UIItemList.New(arg0_2:findTF("frame/bg/starts"), arg0_2:findTF("frame/bg/starts/tpl"))
	arg0_2.oldLevelTxt = arg0_2:findTF("frame/bg/item/level/Text_1"):GetComponent("Text")
	arg0_2.newLevelTxt = arg0_2:findTF("frame/bg/item/level/Text_2"):GetComponent("Text")
	arg0_2.oldEnergyTxt = arg0_2:findTF("frame/bg/item/energy/Text_1"):GetComponent("Text")
	arg0_2.newEnergyTxt = arg0_2:findTF("frame/bg/item/energy/Text_2"):GetComponent("Text")

	setText(arg0_2:findTF("frame/bg/item/energy/Text"), i18n("island_ship_level_limit"))
	setText(arg0_2:findTF("frame/bg/item/level/Text"), i18n("island_ship_energy_limit"))
	setText(arg0_2:findTF("frame/tip"), i18n("island_click_close"))

	arg0_2.frameTr = arg0_2:findTF("frame")
	arg0_2.animator = arg0_2.frameTr:GetComponent(typeof(Animation))
	arg0_2.aniDft = arg0_2.frameTr:GetComponent(typeof(DftAniEvent))
end

function var0_0.Show(arg0_3, arg1_3)
	arg0_3.title.text = i18n("island_break_finish")

	local var0_3 = arg1_3.oldShip
	local var1_3 = arg1_3.newShip

	arg0_3:UpdateBreakLevel(var0_3, var1_3)
	arg0_3:UpdateLevel(var0_3, var1_3)
	arg0_3:UpdateEnergy(var0_3, var1_3)
end

function var0_0.PlayExitAniamtion(arg0_4, arg1_4)
	arg0_4.aniDft:SetEndEvent(function()
		arg0_4.aniDft:SetEndEvent(nil)
		arg1_4()
	end)
	arg0_4.animator:Play("anim_Island_commonget_single_out")
end

function var0_0.UpdateBreakLevel(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg2_6:GetBreakMaxLevel()

	arg0_6.uiNewStart:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			setActive(arg2_7:Find("Image"), arg1_7 < arg2_6:GetBreakLevel())
		end
	end)
	arg0_6.uiNewStart:align(var0_6)
end

function var0_0.UpdateLevel(arg0_8, arg1_8, arg2_8)
	arg0_8.oldLevelTxt.text = "Lv." .. arg1_8:GetMaxLevel()
	arg0_8.newLevelTxt.text = "Lv." .. arg2_8:GetMaxLevel()
end

function var0_0.UpdateEnergy(arg0_9, arg1_9, arg2_9)
	arg0_9.oldEnergyTxt.text = arg1_9:GetMaxEnergy()
	arg0_9.newEnergyTxt.text = arg2_9:GetMaxEnergy()
end

function var0_0.OnDestroy(arg0_10)
	arg0_10.aniDft:SetEndEvent(nil)
end

return var0_0
