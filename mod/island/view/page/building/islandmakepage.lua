local var0_0 = class("IslandMakePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandMakeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("top/back")
	arg0_2.title = arg0_2:findTF("top/title")
	arg0_2.uiList = UIItemList.New(arg0_2:findTF("frame/content"), arg0_2:findTF("frame/content/tpl"))
	arg0_2.infoPage = IslandBuildingInfoPage.New(arg0_2._tf, arg0_2.event)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.uiList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_5, arg2_5)
		end
	end)
end

function var0_0.UpdateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.list[arg1_6 + 1]

	arg2_6.name = tostring(var0_6.id)

	local var1_6 = var0_6:IsUnlock()

	setActive(arg0_6:findTF("unlock", arg2_6), var1_6)
	setActive(arg0_6:findTF("lock", arg2_6), not var1_6)

	if not var1_6 then
		setText(arg0_6:findTF("lock/Text", arg2_6), i18n1(arg0_6.building:GetName() .. var0_6:getConfig("unlock_place_level") .. "级解锁"))
	else
		local var2_6 = var0_6:GetShipId()
		local var3_6 = arg0_6:findTF("unlock/ship/icon", arg2_6)

		setActive(arg0_6:findTF("unlock/ship/empty", arg2_6), not var2_6)
		setActive(var3_6, var2_6)
		setActive(arg0_6:findTF("unlock/name", arg2_6), var2_6)
		setActive(arg0_6:findTF("unlock/energy_bar", arg2_6), var2_6)

		if var2_6 then
			local var4_6 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipByConfigId(var2_6)

			setText(arg0_6:findTF("unlock/name", arg2_6), var4_6:GetName())

			local var5_6 = var4_6:GetEnergy() / var4_6:GetMaxEnergy()

			setSlider(arg0_6:findTF("unlock/energy_bar", arg2_6), 0, 1, var5_6)

			local var6_6 = IslandShip.StaticGetPrefab(var2_6)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var6_6, "", var3_6)
		end

		onButton(arg0_6, arg0_6:findTF("unlock/ship", arg2_6), function()
			arg0_6:OpenPage(IslandShipSelectPage, var0_6)
		end, SFX_PANEL)

		local var7_6 = var0_6:GetFormulaId()
		local var8_6 = arg0_6:findTF("unlock/formula/progress/icon", arg2_6)

		setActive(arg0_6:findTF("unlock/formula/progress/empty", arg2_6), not var7_6)
		setActive(var8_6, var7_6)
		setText(arg0_6:findTF("unlock/capacity", arg2_6), var0_6:GetNum() .. "/" .. var0_6:GetCapacity())
		setActive(arg0_6:findTF("unlock/next_tip", arg2_6), var7_6)
		setActive(arg0_6:findTF("unlock/time", arg2_6), var7_6)
		setActive(arg0_6:findTF("unlock/get", arg2_6), false)

		if var7_6 then
			local var9_6 = IslandFormula.New(var7_6)
			local var10_6 = pg.island_item_data_template[var9_6:getConfig("item_id")].icon

			GetImageSpriteFromAtlasAsync(var10_6, "", var8_6)
			setSlider(arg0_6:findTF("unlock/formula/progress", arg2_6), 0, 1, var0_6:GetCurTime() / var0_6:GetOnceTime())
			setText(arg0_6:findTF("unlock/time", arg2_6), var0_6:GetNextRemainTime())
			onButton(arg0_6, arg0_6:findTF("unlock/time/quick", arg2_6), function()
				return
			end, SFX_PANEL)
			onButton(arg0_6, arg0_6:findTF("unlock/get", arg2_6), function()
				arg0_6:emit(IslandMediator.ON_GET_COMMISSION_AWARD, arg0_6.building.id, var0_6.id)
			end, SFX_PANEL)
		end

		onButton(arg0_6, arg0_6:findTF("unlock/formula", arg2_6), function()
			arg0_6:OpenPage(IslandFormulaSelectPage, arg0_6.building, var0_6)
		end, SFX_PANEL)
	end
end

function var0_0.Show(arg0_11, arg1_11)
	var0_0.super.Show(arg0_11)

	arg0_11.building = arg1_11

	setText(arg0_11.title, arg0_11.building:GetName())

	arg0_11.list = arg0_11.building:GetCommissionList()

	arg0_11.uiList:align(#arg0_11.list)
	arg0_11.infoPage:ExecuteAction("Show", arg0_11.building)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
