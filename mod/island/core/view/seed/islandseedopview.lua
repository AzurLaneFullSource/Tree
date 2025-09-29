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

function var0_0.ActiveSeedDetals(arg0_4, arg1_4)
	setActive(arg0_4.seed_detals, arg1_4)
end

function var0_0.ActiveSeedSelect(arg0_5, arg1_5)
	if arg1_5 then
		local var0_5 = arg0_5:GetView():GetSubView(IslandOpView):GetSeedBtnWorldPos()
		local var1_5 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_5 = var1_5:WorldToScreenPoint(var0_5)
		local var3_5 = LuaHelper.ScreenToLocal(arg0_5._tf, var2_5, var1_5)

		arg0_5.seedSelectPlane.localPosition = var3_5

		arg0_5._tf:SetAsLastSibling()
	end

	setActive(arg0_5.seedSelectPlane, arg1_5)
	setActive(arg0_5._tf, arg1_5)
end

function var0_0.RefreshSeedPlane(arg0_6, arg1_6)
	local var0_6 = arg1_6:GetDataVO().slotData.configId
	local var1_6 = pg.island_production_slot[var0_6].place
	local var2_6 = pg.island_production_place[var1_6].seed_list
	local var3_6 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var4_6 = {}

	for iter0_6, iter1_6 in ipairs(var2_6) do
		local var5_6 = pg.island_farm_seed[iter1_6].itemid

		if var3_6:GetItemById(var5_6) then
			table.insert(var4_6, iter1_6)
		end
	end

	local var6_6 = #var4_6
	local var7_6 = 30
	local var8_6 = 40
	local var9_6 = arg0_6.seedSelectPlane:Find("content"):GetComponent(typeof(GridLayoutGroup))
	local var10_6 = var9_6.cellSize.x
	local var11_6 = var9_6.cellSize.y
	local var12_6 = math.min(var6_6, 7)
	local var13_6 = math.ceil(var6_6 / 7)
	local var14_6 = var10_6 * var12_6 + var9_6.spacing.x * (var12_6 - 1) + var9_6.padding.right + var8_6
	local var15_6 = var11_6 * var13_6 + var9_6.spacing.y * (var13_6 - 1) + var9_6.padding.bottom + var7_6

	arg0_6.seedSelectPlane:Find("content").sizeDelta = Vector2(var14_6, var15_6)

	arg0_6.uiSeedItemList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = var4_6[arg1_7 + 1]

			setActive(arg2_7:Find("select"), arg0_6.selectseedItemId == var0_7)

			local var1_7 = pg.island_farm_seed[var0_7].itemid
			local var2_7 = var3_6:GetItemById(var1_7)

			updateCustomDrop(arg2_7, Drop.New({
				type = DROP_TYPE_ISLAND_ITEM,
				id = var2_7.id,
				count = var2_7:GetCount()
			}))

			local var3_7

			onButton(arg0_6, arg2_7, function()
				if var3_7 then
					var3_7 = false

					return
				end

				arg0_6.selectseedItemId = var0_7

				PlayerPrefs.SetInt("island_last_selectItemId" .. var1_6, arg0_6.selectseedItemId)
				arg0_6.uiSeedItemList:align(var6_6)
				arg0_6:GetView():GetSubView(IslandOpView):RefreshCurrentSlectSeed()
				arg0_6:ActiveSeedSelect(false)
				setActive(arg0_6.seed_detals, false)
			end, SFX_PANEL)
			GetOrAddComponent(arg2_7, typeof(UILongPressTrigger)).onLongPressed:AddListener(function()
				var3_7 = true

				setActive(arg0_6.seed_detals, true)

				arg0_6.seed_detals.position = arg2_7.position

				setText(arg0_6.seed_detals:Find("bg/itemSeed/icon_bg/count_bg/count"), var2_7:GetCount())

				local var0_9 = var2_7:GetIcon()

				GetImageSpriteFromAtlasAsync("island/" .. var0_9, "", arg0_6.seed_detals:Find("bg/itemSeed/icon_bg/icon"))

				local var1_9 = arg0_6.seed_detals:Find("bg/detaiView/Viewport/detaiViewText")

				setText(var1_9, var2_7:GetDesc())
				setText(arg0_6.seed_detals:Find("bg/seedName"), var2_7:GetName())
			end)
		end
	end)
	arg0_6.uiSeedItemList:align(var6_6)
end

function var0_0.CheckSeedEmpty(arg0_10, arg1_10)
	local var0_10 = arg1_10:GetDataVO().slotData.configId
	local var1_10 = pg.island_production_slot[var0_10].place
	local var2_10 = pg.island_production_place[var1_10].seed_list
	local var3_10 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	arg0_10.selectseedItemId = nil

	local var4_10 = PlayerPrefs.GetInt("island_last_selectItemId" .. var1_10, 0)

	if var4_10 ~= 0 then
		local var5_10 = pg.island_farm_seed[var4_10].itemid

		if var3_10:GetOwnCount(var5_10) > 0 then
			arg0_10.selectseedItemId = var4_10

			return false
		end
	end

	for iter0_10, iter1_10 in ipairs(var2_10) do
		local var6_10 = pg.island_farm_seed[iter1_10].itemid
		local var7_10 = var3_10:GetItemById(var6_10)

		if var7_10 and var7_10:GetCount() ~= 0 then
			arg0_10.selectseedItemId = iter1_10

			return false
		end
	end

	return true
end

return var0_0
