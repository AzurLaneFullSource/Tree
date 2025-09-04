local var0_0 = class("IslandShoppingCartLayer", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShoppingCartUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.panel = arg0_2._tf:Find("panel")
	arg0_2.closeBtn = arg0_2.panel:Find("closeBtn")
	arg0_2.commodityList = arg0_2.panel:Find("commodityList/Viewport/Content")
	arg0_2.cancelBtn = arg0_2.panel:Find("cancelBtn")
	arg0_2.buyBtn = arg0_2.panel:Find("buyBtn")
	arg0_2.consumeIcon = arg0_2.buyBtn:Find("consume/icon")
	arg0_2.consumeCount = arg0_2.buyBtn:Find("consume/count")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_7, arg1_7)
	local var0_7
	local var1_7
	local var2_7 = 0

	for iter0_7 = 1, 3 do
		local var3_7 = arg0_7.commodityList:Find("commodity" .. iter0_7)

		setActive(var3_7:Find("normal"), iter0_7 <= #arg1_7)
		setActive(var3_7:Find("nothing"), iter0_7 > #arg1_7)

		if iter0_7 <= #arg1_7 then
			local var4_7 = arg1_7[iter0_7]

			GetImageSpriteFromAtlasAsync(var4_7:GetIcon(), "", var3_7:Find("normal/IslandItemTpl/icon_bg/icon"))
			setText(var3_7:Find("normal/name"), var4_7:GetName())
			setActive(var3_7:Find("normal/count"), false)

			if #var4_7:GetItems() == 1 then
				local var5_7 = 0

				if var4_7:GetItems()[1][1] == DROP_TYPE_ISLAND_FURNITURE then
					local var6_7 = getProxy(IslandProxy):GetIsland():GetAgoraAgency():GetFurnitures()

					for iter1_7, iter2_7 in ipairs(var6_7) do
						if iter2_7.id == var4_7:GetItems()[1][2] then
							var5_7 = iter2_7.count

							break
						end
					end

					setActive(var3_7:Find("normal/count"), true)
					setText(var3_7:Find("normal/count"), "拥有数量(" .. var5_7 .. ")")
				elseif var4_7:GetItems()[1][1] == DROP_TYPE_ISLAND_DRESS then
					local var7_7 = var4_7:GetItems()[1][2]

					if pg.island_dress_template[var7_7].belongto == 2 then
						local var8_7 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetOwnDressCountByDressId(var7_7)

						setActive(var3_7:Find("normal/count"), true)
						setText(var3_7:Find("normal/count"), "拥有数量(" .. var8_7 .. ")")
					end
				end
			end

			local var9_7 = var4_7:GetResourceConsume()

			GetImageSpriteFromAtlasAsync(Drop.New({
				type = var9_7[1],
				id = var9_7[2]
			}):getIcon(), "", var3_7:Find("normal/consumeIcon"))
			setText(var3_7:Find("normal/consumeNum"), var9_7[3])

			var0_7 = var9_7[1]
			var1_7 = var9_7[2]
			var2_7 = var2_7 + var9_7[3]
		end
	end

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var0_7,
		id = var1_7
	}):getIcon(), "", arg0_7.consumeIcon)
	setText(arg0_7.consumeCount, var2_7)
	onButton(arg0_7, arg0_7.buyBtn, function()
		local var0_8 = {}

		for iter0_8, iter1_8 in ipairs(arg1_7) do
			table.insert(var0_8, {
				value2 = 1,
				key = iter1_8.shopId,
				value1 = iter1_8.id
			})
		end

		arg0_7:emit(IslandMediator.BUY_COMMODITY, var0_8)
	end, SFX_PANEL)
end

function var0_0.Refresh(arg0_9)
	arg0_9:SetUp(arg0_9.commodities)
end

function var0_0.OnShow(arg0_10, arg1_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf, false, {
		groupName = "IslandShop"
	})

	arg0_10.commodities = arg1_10

	arg0_10:SetUp(arg0_10.commodities)
end

function var0_0.OnHide(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, arg0_11._parentTf)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
