local var0_0 = class("IslandSeedOpView", import("..IslandBaseOpView"))

function var0_0.GetUIName(arg0_1)
	return "IslandSeedOpUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2.seedSelectPlane = arg0_2._tf:Find("seed_select")
	arg0_2.seed_detals = arg0_2._tf:Find("seed_detals")
	arg0_2.uiSeedItemList = UIItemList.New(arg0_2.seedSelectPlane:Find("content"), arg0_2.seedSelectPlane:Find("content/itemSeed"))

	onButton(arg0_2, arg0_2._tf, function()
		setActive(arg0_2.seed_detals, false)
		arg0_2:ActiveSeedSelect(false)
	end, SFX_PANEL)
	setActive(arg0_2.seed_detals, false)
	arg0_2:ActiveSeedSelect(false)
end

function var0_0.ActiveSeedSelect(arg0_4, arg1_4)
	if arg1_4 then
		local var0_4 = arg0_4:GetView():GetSubView(IslandOpView):GetSeedBtnWorldPos()
		local var1_4 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_4 = var1_4:WorldToScreenPoint(var0_4)
		local var3_4 = LuaHelper.ScreenToLocal(arg0_4._tf, var2_4, var1_4)

		arg0_4.seedSelectPlane.localPosition = var3_4

		arg0_4._tf:SetAsLastSibling()
	end

	setActive(arg0_4.seedSelectPlane, arg1_4)
	setActive(arg0_4._tf, arg1_4)
end

function var0_0.RefreshSeedPlane(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetDataVO().slotData.configId
	local var1_5 = pg.island_production_slot[var0_5].place
	local var2_5 = pg.island_production_place[var1_5].seed_list
	local var3_5 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var4_5 = {}

	for iter0_5, iter1_5 in ipairs(var2_5) do
		local var5_5 = pg.island_farm_seed[iter1_5].itemid

		if var3_5:GetItemById(var5_5) then
			table.insert(var4_5, iter1_5)
		end
	end

	local var6_5 = #var4_5
	local var7_5 = 30
	local var8_5 = 40
	local var9_5 = arg0_5.seedSelectPlane:Find("content"):GetComponent(typeof(GridLayoutGroup))
	local var10_5 = var9_5.cellSize.x
	local var11_5 = var9_5.cellSize.y
	local var12_5 = math.min(var6_5, 7)
	local var13_5 = math.ceil(var6_5 / 7)
	local var14_5 = var10_5 * var12_5 + var9_5.spacing.x * (var12_5 - 1) + var9_5.padding.right + var8_5
	local var15_5 = var11_5 * var13_5 + var9_5.spacing.y * (var13_5 - 1) + var9_5.padding.bottom + var7_5

	arg0_5.seedSelectPlane:Find("content").sizeDelta = Vector2(var14_5, var15_5)

	arg0_5.uiSeedItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var4_5[arg1_6 + 1]

			setActive(arg2_6:Find("select"), arg0_5.selectseedItemId == var0_6)

			local var1_6 = pg.island_farm_seed[var0_6].itemid
			local var2_6 = var3_5:GetItemById(var1_6)

			updateCustomDrop(arg2_6, Drop.New({
				type = DROP_TYPE_ISLAND_ITEM,
				id = var2_6.id,
				count = var2_6:GetCount()
			}))

			local var3_6

			onButton(arg0_5, arg2_6, function()
				if var3_6 then
					var3_6 = false

					return
				end

				arg0_5.selectseedItemId = var0_6

				PlayerPrefs.SetInt("island_last_selectItemId" .. var1_5, arg0_5.selectseedItemId)
				arg0_5.uiSeedItemList:align(var6_5)
				arg0_5:GetView():GetSubView(IslandOpView):RefreshCurrentSlectSeed()
				arg0_5:ActiveSeedSelect(false)
				setActive(arg0_5.seed_detals, false)
			end, SFX_PANEL)
			GetOrAddComponent(arg2_6, typeof(UILongPressTrigger)).onLongPressed:AddListener(function()
				var3_6 = true

				setActive(arg0_5.seed_detals, true)

				arg0_5.seed_detals.position = arg2_6.position

				setText(arg0_5.seed_detals:Find("bg/itemSeed/icon_bg/count_bg/count"), var2_6:GetCount())

				local var0_8 = var2_6:GetIcon()

				GetImageSpriteFromAtlasAsync(var0_8, "", arg0_5.seed_detals:Find("bg/itemSeed/icon_bg/icon"))

				local var1_8 = arg0_5.seed_detals:Find("bg/detaiView/Viewport/detaiViewText")

				setText(var1_8, var2_6:GetDesc())
				setText(arg0_5.seed_detals:Find("bg/seedName"), var2_6:GetName())
			end)
		end
	end)
	arg0_5.uiSeedItemList:align(var6_5)
end

function var0_0.CheckSeedEmpty(arg0_9, arg1_9)
	local var0_9 = arg1_9:GetDataVO().slotData.configId
	local var1_9 = pg.island_production_slot[var0_9].place
	local var2_9 = pg.island_production_place[var1_9].seed_list
	local var3_9 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	arg0_9.selectseedItemId = nil

	local var4_9 = PlayerPrefs.GetInt("island_last_selectItemId" .. var1_9, 0)

	if var4_9 ~= 0 then
		local var5_9 = pg.island_farm_seed[var4_9].itemid

		if var3_9:GetOwnCount(var5_9) > 0 then
			arg0_9.selectseedItemId = var4_9

			return false
		end
	end

	for iter0_9, iter1_9 in ipairs(var2_9) do
		local var6_9 = pg.island_farm_seed[iter1_9].itemid
		local var7_9 = var3_9:GetItemById(var6_9)

		if var7_9 and var7_9:GetCount() ~= 0 then
			arg0_9.selectseedItemId = iter1_9

			return false
		end
	end

	return true
end

return var0_0
