local var0_0 = class("IslandBuildingInfoPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandBuildingInfoTpl"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2:findTF("frame/tags/ship/Text"), i18n("island_ship_title_info"))
	setText(arg0_2:findTF("frame/tags/building/Text"), i18n("island_building_title_info"))

	arg0_2.shipPage = arg0_2:findTF("frame/shipPanel")
	arg0_2.shipUIList = UIItemList.New(arg0_2:findTF("list/content", arg0_2.shipPage), arg0_2:findTF("list/content/tpl", arg0_2.shipPage))

	setText(arg0_2:findTF("skill/title", arg0_2.shipPage), i18n("island_word_effect"))

	arg0_2.skillUIList = UIItemList.New(arg0_2:findTF("skill/list/content", arg0_2.shipPage), arg0_2:findTF("skill/list/content/tpl", arg0_2.shipPage))

	setText(arg0_2:findTF("ship_num/title", arg0_2.shipPage), i18n("island_word_dispatch"))

	arg0_2.shipNumTF = arg0_2:findTF("ship_num/num", arg0_2.shipPage)
	arg0_2.buildingPage = arg0_2:findTF("frame/buildingPanel")
	arg0_2.buildingNameTF = arg0_2:findTF("name", arg0_2.buildingPage)
end

function var0_0.OnInit(arg0_3)
	arg0_3.shipUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_3.shipList[arg1_4 + 1]

			setText(arg0_3:findTF("name", arg2_4), var0_4:GetName())

			local var1_4 = IslandShip.StaticGetPrefab(var0_4.id)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_4, "", arg0_3:findTF("icon", arg2_4))

			local var2_4 = var0_4:GetEnergy()
			local var3_4 = var0_4:GetMaxEnergy()

			setText(arg0_3:findTF("energy_bar/Text", arg2_4), var2_4 .. "/" .. var3_4)
			setSlider(arg0_3:findTF("energy_bar", arg2_4), 0, 1, var2_4 / var3_4)
			setText(arg0_3:findTF("status", arg2_4), var2_4 > 0 and i18n("island_word_working") or i18n("island_word_stop_work"))

			local var4_4 = var2_4 / 10

			setText(arg0_3:findTF("time", arg2_4), var4_4 .. "s")
		end
	end)
	arg0_3.skillUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_3.skillIdList[arg1_5 + 1]
			local var1_5 = pg.island_chara_skill[var0_5].desc

			setText(arg2_5, var1_5)
		end
	end)
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)

	arg0_6.building = arg1_6

	setText(arg0_6.buildingNameTF, arg0_6.building:GetName())

	arg0_6.shipList = {}
	arg0_6.skillIdList = {}

	local var0_6 = 0

	for iter0_6, iter1_6 in ipairs(arg0_6.building:GetCommissionList()) do
		if iter1_6:IsUnlock() then
			var0_6 = var0_6 + 1
		end

		if iter1_6:GetStatus() == IslandProductionCommission.STATUS_WORKING then
			local var1_6 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(iter1_6:GetShipId())

			table.insert(arg0_6.shipList, var1_6)
			table.insert(arg0_6.skillIdList, var1_6:GetMainSkill())
		end
	end

	arg0_6.shipUIList:align(#arg0_6.shipList)
	arg0_6.skillUIList:align(#arg0_6.skillIdList)
	setText(arg0_6.shipNumTF, #arg0_6.shipList .. "/" .. var0_6)
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
