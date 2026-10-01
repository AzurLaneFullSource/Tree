local var0_0 = class("PrayPoolSelectShipView", import("..base.BaseSubView"))

var0_0.WIDTH_MIN = 328
var0_0.WIDTH_MAX = 438
var0_0.FONT_SIZE_MIN = 55
var0_0.FONT_SIZE_MID = 44
var0_0.FONT_SIZE_MAX = 34

function var0_0.getResource(arg0_1)
	local var0_1 = {
		"weaponframes"
	}

	for iter0_1, iter1_1 in ipairs(pg.activity_ship_create.all) do
		local var1_1 = pg.activity_ship_create[iter1_1]

		for iter2_1, iter3_1 in ipairs(var1_1.pickup_list or {}) do
			table.insertto(var0_1, ResPathSupport.GetPaintingSquareIconListByPaintingName(Ship.getPaintingName(iter3_1)))
		end
	end

	local var2_1 = getProxy(PrayProxy)

	for iter4_1, iter5_1 in ipairs(var2_1:getSelectedShipIDList() or {}) do
		local var3_1 = Ship.getPaintingName(iter5_1)

		table.insertto(var0_1, ResPathSupport.GetPaintingListByPaintingName(var3_1))
		table.insertto(var0_1, ResPathSupport.GetPaintingHeroHrzIconListByPaintingName(var3_1))
	end

	return table.insertto(var0_1, var0_0.super.getResource(arg0_1))
end

function var0_0.getUIName(arg0_2)
	return "PrayPoolSelectShipView"
end

var0_0.ShipIndex = {
	typeIndex = ShipIndexConst.TypeAll,
	campIndex = ShipIndexConst.CampAll,
	rarityIndex = ShipIndexConst.RarityAll
}
var0_0.ShipIndexData = {
	customPanels = {
		typeIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.TypeIndexs,
			names = ShipIndexConst.TypeNames
		},
		campIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.CampIndexs,
			names = ShipIndexConst.CampNames
		},
		rarityIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.RarityIndexs,
			names = ShipIndexConst.RarityNames
		}
	},
	groupList = {
		{
			dropdown = false,
			titleTxt = "indexsort_index",
			titleENTxt = "indexsort_indexeng",
			tags = {
				"typeIndex"
			}
		},
		{
			dropdown = false,
			titleTxt = "indexsort_camp",
			titleENTxt = "indexsort_campeng",
			tags = {
				"campIndex"
			}
		},
		{
			dropdown = false,
			titleTxt = "indexsort_rarity",
			titleENTxt = "indexsort_rarityeng",
			tags = {
				"rarityIndex"
			}
		}
	}
}

function var0_0.OnInit(arg0_3)
	arg0_3:initData()
	arg0_3:initUI()
	arg0_3:updateUI()
	arg0_3:Show()
end

function var0_0.OnDestroy(arg0_4)
	return
end

function var0_0.OnBackPress(arg0_5)
	return
end

function var0_0.initData(arg0_6)
	arg0_6.prayProxy = getProxy(PrayProxy)
	arg0_6.poolType = arg0_6.prayProxy:getSelectedPoolType()
	arg0_6.selectedCount = arg0_6.prayProxy:getSelectedShipCount()
	arg0_6.pickUpNum = pg.activity_ship_create[arg0_6.poolType].pickup_num
	arg0_6.fliteList = Clone(pg.activity_ship_create[arg0_6.poolType].pickup_list)

	arg0_6:orderIDListByRarity(arg0_6.fliteList)

	arg0_6.orderFullList = Clone(arg0_6.fliteList)
end

function var0_0.initUI(arg0_7)
	arg0_7.minRaritySpriteMap = {}
	arg0_7.maxRaritySpriteMap = {}
	arg0_7.ratioSpriteMap = {}

	local var0_7 = arg0_7._tf:Find("MiniRarity")
	local var1_7 = arg0_7._tf:Find("MaxRarity")
	local var2_7 = arg0_7._tf:Find("Ratio")

	for iter0_7 = 2, 6 do
		local var3_7 = getImageSprite(var0_7:Find(tostring(iter0_7)))
		local var4_7 = getImageSprite(var1_7:Find(tostring(iter0_7)))
		local var5_7 = getImageSprite(var2_7:Find(tostring(iter0_7)))

		arg0_7.minRaritySpriteMap[iter0_7] = var3_7
		arg0_7.maxRaritySpriteMap[iter0_7] = var4_7
		arg0_7.ratioSpriteMap[iter0_7] = var5_7
	end

	arg0_7.poolSpriteMap = {}

	local var6_7 = arg0_7._tf:Find("Pool")

	for iter1_7 = 1, 3 do
		local var7_7 = getImageSprite(var6_7:Find(tostring(iter1_7)))

		arg0_7.poolSpriteMap[iter1_7] = var7_7
	end

	arg0_7.poolNameImg = arg0_7._tf:Find("PoolNameImg")
	arg0_7.shipCardTpl = arg0_7._tf:Find("ShipCardTpl")

	local var8_7 = arg0_7._tf:Find("SelectedShipMax")
	local var9_7 = var8_7:Find("Light")
	local var10_7 = var8_7:Find("Ship1")
	local var11_7 = var8_7:Find("Ship2")
	local var12_7 = arg0_7._tf:Find("SelectedShipMini")
	local var13_7 = var12_7:Find("Light")
	local var14_7 = var12_7:Find("Ship1")
	local var15_7 = var12_7:Find("Ship2")

	arg0_7.selectedShipTFMap = {}
	arg0_7.selectedShipTFMap.Max = {
		lightTF = var9_7,
		var10_7,
		var11_7
	}
	arg0_7.selectedShipTFMap.Min = {
		lightTF = var13_7,
		var14_7,
		var15_7
	}

	local var16_7 = arg0_7:isMinPrefs()

	setActive(var8_7, not var16_7)
	setActive(var12_7, var16_7)

	arg0_7.shipListArea = arg0_7._tf:Find("ShipListArea")
	arg0_7.shipListContainer = arg0_7.shipListArea:Find("Viewport/Content")
	arg0_7.shipListSC = GetComponent(arg0_7.shipListArea, "LScrollRect")

	setLocalPosition(arg0_7.shipListArea, {
		x = 0,
		y = var16_7 and -40 or -120
	})

	arg0_7.bg2 = arg0_7._tf:Find("BG2")

	setLocalPosition(arg0_7.bg2, {
		x = 0,
		y = var16_7 and -62.5 or -174
	})

	arg0_7.indexBtn = arg0_7._tf:Find("IndexBtn")
	arg0_7.preBtn = arg0_7._tf:Find("PreBtn")
	arg0_7.nextBtn = arg0_7._tf:Find("NextBtn")
	arg0_7.nextBtnCom = GetComponent(arg0_7.nextBtn, "Button")

	arg0_7.indexBtn:GetComponent(typeof(Image)):SetNativeSize()

	for iter2_7, iter3_7 in ipairs(arg0_7.selectedShipTFMap.Max) do
		iter3_7:Find("Tip/Tip"):GetComponent(typeof(Image)):SetNativeSize()
	end

	for iter4_7, iter5_7 in ipairs(arg0_7.selectedShipTFMap.Min) do
		iter5_7:Find("Tip/Tip"):GetComponent(typeof(Image)):SetNativeSize()
	end

	arg0_7.nextBtnCom.interactable = false

	local var17_7 = arg0_7._tf:Find("InstructionText")

	setText(var17_7, i18n("pray_build_select_ship_instruction"))
	onButton(arg0_7, arg0_7.preBtn, function()
		arg0_7.prayProxy:updatePageState(PrayProxy.STATE_SELECT_POOL)
		arg0_7:emit(PrayPoolConst.SWITCH_TO_SELECT_POOL_PAGE, PrayProxy.STATE_SELECT_POOL)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.nextBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("warning_pray_build_pool"),
			onYes = function()
				local function var0_10()
					arg0_7:emit(PrayPoolConst.CLICK_BUILD_BTN, {
						pooltype = arg0_7.prayProxy:getSelectedPoolType(),
						shipIDList = arg0_7.prayProxy:getSelectedShipIDList()
					})
				end

				if not arg0_7:isMinPrefs() then
					var0_10()
				else
					local var1_10 = {}
					local var2_10 = arg0_7.prayProxy:getSelectedShipIDList()

					for iter0_10, iter1_10 in ipairs(var2_10) do
						PaintingGroupConst.AddPaintingNameByShipConfigID(var1_10, iter1_10)
					end

					local var3_10 = {
						isShowBox = true,
						paintingNameList = var1_10,
						finishFunc = var0_10
					}

					PaintingGroupConst.PaintingDownload(var3_10)
				end
			end
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.indexBtn, function()
		local var0_12 = Clone(var0_0.ShipIndexData)

		var0_12.indexDatas = Clone(var0_0.ShipIndex)

		function var0_12.callback(arg0_13)
			var0_0.ShipIndex.typeIndex = arg0_13.typeIndex
			var0_0.ShipIndex.rarityIndex = arg0_13.rarityIndex

			if arg0_13.campIndex then
				var0_0.ShipIndex.campIndex = arg0_13.campIndex
			end

			arg0_7:fliteShipIDList()
			arg0_7:updateShipList(arg0_7.fliteList)
		end

		arg0_7:emit(PrayPoolConst.CLICK_INDEX_BTN, var0_12)
	end)
end

function var0_0.updateUI(arg0_14)
	setImageSprite(arg0_14.poolNameImg, arg0_14.poolSpriteMap[arg0_14.poolType], true)
	arg0_14:updateSelectedShipList()
	arg0_14:updateShipList(arg0_14.fliteList)
end

function var0_0.updateSelectedShipList(arg0_15)
	local var0_15 = arg0_15.prayProxy:getSelectedShipIDList()
	local var1_15 = {}

	for iter0_15, iter1_15 in ipairs(var0_15 or {}) do
		local var2_15 = Ship.getPaintingName(iter1_15)

		table.insertto(var1_15, ResPathSupport.GetPaintingListByPaintingName(var2_15))
		table.insertto(var1_15, ResPathSupport.GetPaintingHeroHrzIconListByPaintingName(var2_15))
	end

	SplitPackConst.DownloadByLuaArr(var1_15, function()
		if arg0_15:isMinPrefs() then
			arg0_15:updateMin()
		else
			arg0_15:updateMax()
		end
	end)
end

function var0_0.updateMax(arg0_17)
	local var0_17 = arg0_17.prayProxy:getSelectedShipIDList()
	local var1_17 = arg0_17.selectedShipTFMap.Max

	for iter0_17 = 1, 2 do
		local var2_17 = var0_17[iter0_17]
		local var3_17 = var1_17[iter0_17]
		local var4_17 = var3_17:Find("Paint")
		local var5_17 = var3_17:Find("Tip")
		local var6_17 = var3_17:Find("Info")
		local var7_17 = var3_17:Find("Btn")
		local var8_17 = var6_17:Find("Name/Text")
		local var9_17 = var3_17:Find("RarityBG")
		local var10_17 = var6_17:Find("Ratio/NumImg")

		if var2_17 then
			setActive(var4_17, true)
			setPaintingPrefabAsync(var4_17, Ship.getPaintingName(var2_17), "biandui")

			if iter0_17 == 2 then
				setLocalRotation(var4_17, {
					z = 180
				})
			end

			setActive(var5_17, false)
			setActive(var6_17, true)

			local var11_17 = pg.ship_data_statistics[var2_17].name

			setText(var8_17, var11_17)

			local var12_17 = var8_17.localPosition
			local var13_17 = #var11_17

			if var13_17 <= 6 then
				var6_17.sizeDelta = Vector2(var0_0.WIDTH_MIN, var6_17.sizeDelta.y)
				GetComponent(var8_17, "Text").fontSize = var0_0.FONT_SIZE_MIN

				setAnchoredPosition(var8_17, {
					y = 14
				})
			elseif var13_17 <= 21 then
				var6_17.sizeDelta = Vector2(var0_0.WIDTH_MAX, var6_17.sizeDelta.y)
				GetComponent(var8_17, "Text").fontSize = var0_0.FONT_SIZE_MID

				setAnchoredPosition(var8_17, {
					y = 19
				})
			else
				var6_17.sizeDelta = Vector2(var0_0.WIDTH_MAX, var6_17.sizeDelta.y)
				GetComponent(var8_17, "Text").fontSize = var0_0.FONT_SIZE_MAX

				setAnchoredPosition(var8_17, {
					y = 25
				})
			end

			local var14_17 = pg.ship_data_statistics[var2_17].rarity

			setImageSprite(var10_17, arg0_17.ratioSpriteMap[var14_17], true)
			setActive(var9_17, true)
			setImageSprite(var9_17, arg0_17.maxRaritySpriteMap[var14_17])
		else
			setActive(var4_17, false)
			setActive(var5_17, true)
			setActive(var6_17, false)
			setActive(var9_17, false)
		end

		onButton(arg0_17, var7_17, function()
			if isActive(var4_17) then
				arg0_17.prayProxy:removeSelectedShipIDList(var2_17)

				arg0_17.selectedCount = arg0_17.selectedCount - 1

				arg0_17:updateSelectedShipList()
				arg0_17:updateShipList(arg0_17.fliteList)
			end
		end, SFX_PANEL)
	end

	local var15_17 = var1_17.lightTF

	if #var0_17 == arg0_17.pickUpNum then
		arg0_17.nextBtnCom.interactable = true

		setActive(var15_17, true)
	elseif #var0_17 < arg0_17.pickUpNum then
		arg0_17.nextBtnCom.interactable = false

		setActive(var15_17, false)
	end
end

function var0_0.updateMin(arg0_19)
	local var0_19 = arg0_19.prayProxy:getSelectedShipIDList()
	local var1_19 = arg0_19.selectedShipTFMap.Min

	for iter0_19 = 1, 2 do
		local var2_19 = var0_19[iter0_19]
		local var3_19 = var1_19[iter0_19]
		local var4_19 = var3_19:Find("Mask/Paint")
		local var5_19 = var3_19:Find("Tip")
		local var6_19 = var3_19:Find("Info")
		local var7_19 = var3_19:Find("Btn")
		local var8_19 = var6_19:Find("Name/Text")
		local var9_19 = var3_19:Find("Mask/RarityBG")
		local var10_19 = var6_19:Find("Ratio/NumImg")

		if var2_19 then
			setActive(var4_19, true)
			setImageSprite(var4_19, LoadSprite("herohrzicon/" .. Ship.getPaintingName(var2_19)))
			setActive(var5_19, false)
			setActive(var6_19, true)

			local var11_19 = pg.ship_data_statistics[var2_19].name

			setText(var8_19, var11_19)

			local var12_19 = var8_19.localPosition
			local var13_19 = #var11_19

			if var13_19 <= 6 then
				var6_19.sizeDelta = Vector2(var0_0.WIDTH_MIN, var6_19.sizeDelta.y)
				GetComponent(var8_19, "Text").fontSize = var0_0.FONT_SIZE_MIN

				setAnchoredPosition(var8_19, {
					y = 0
				})
			elseif var13_19 <= 21 then
				var6_19.sizeDelta = Vector2(var0_0.WIDTH_MAX, var6_19.sizeDelta.y)
				GetComponent(var8_19, "Text").fontSize = var0_0.FONT_SIZE_MID

				setAnchoredPosition(var8_19, {
					y = 5
				})
			else
				var6_19.sizeDelta = Vector2(var0_0.WIDTH_MAX, var6_19.sizeDelta.y)
				GetComponent(var8_19, "Text").fontSize = var0_0.FONT_SIZE_MAX

				setAnchoredPosition(var8_19, {
					y = 11
				})
			end

			Canvas.ForceUpdateCanvases()

			local var14_19 = pg.ship_data_statistics[var2_19].rarity

			setImageSprite(var10_19, arg0_19.ratioSpriteMap[var14_19], true)
			setActive(var9_19, true)
			setImageSprite(var9_19, arg0_19.minRaritySpriteMap[var14_19])
		else
			setActive(var4_19, false)
			setActive(var5_19, true)
			setActive(var6_19, false)
			setActive(var9_19, false)
		end

		onButton(arg0_19, var7_19, function()
			if isActive(var4_19) then
				arg0_19.prayProxy:removeSelectedShipIDList(var2_19)

				arg0_19.selectedCount = arg0_19.selectedCount - 1

				arg0_19:updateSelectedShipList()
				arg0_19:updateShipList(arg0_19.fliteList)
			end
		end, SFX_PANEL)
	end

	local var15_19 = var1_19.lightTF

	if #var0_19 == arg0_19.pickUpNum then
		arg0_19.nextBtnCom.interactable = true

		setActive(var15_19, true)
	elseif #var0_19 < arg0_19.pickUpNum then
		arg0_19.nextBtnCom.interactable = false

		setActive(var15_19, false)
	end
end

function var0_0.updateShipList(arg0_21, arg1_21)
	local var0_21 = arg0_21.prayProxy:getSelectedShipIDList()

	function arg0_21.shipListSC.onUpdateItem(arg0_22, arg1_22)
		local var0_22 = arg1_21[arg0_22 + 1]

		arg1_22 = tf(arg1_22)

		local var1_22 = arg1_22:Find("BG/Icon")

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. Ship.getPaintingName(var0_22), "", var1_22)

		local var2_22 = arg1_22:Find("BG/GroupLocked")
		local var3_22 = pg.ship_data_template[var0_22].group_type

		if var3_22 and var3_22 > 0 then
			setActive(var2_22, not getProxy(CollectionProxy):getShipGroup(var3_22))
		else
			setActive(var2_22, false)
		end

		local var4_22 = arg1_22:Find("BG/icon_bg/frame")
		local var5_22 = pg.ship_data_statistics[var0_22].rarity
		local var6_22 = ShipRarity.Rarity2Print(var5_22)

		setFrame(var4_22, var6_22)
		setIconColorful(arg1_22:Find("BG"), var5_22 - 1, {})

		local var7_22 = arg1_22:Find("BG")

		setImageSprite(var7_22, GetSpriteFromAtlas("weaponframes", "bg" .. var6_22))

		local var8_22 = pg.ship_data_statistics[var0_22].name
		local var9_22 = arg1_22:Find("NameBG/NameText")

		setText(var9_22, shortenString(var8_22, 6))

		local var10_22 = arg1_22:Find("BG/SelectedImg")

		if table.indexof(var0_21, var0_22, 1) then
			SetActive(var10_22, true)
		else
			SetActive(var10_22, false)
		end

		setBlackMask(tf(arg1_22), var5_22 == ShipRarity.SSR and arg0_21:isSelectedSSR() and not isActive(var10_22), {
			recursive = true,
			color = Color(0, 0, 0, 0.6)
		})
		onButton(arg0_21, arg1_22, function()
			if arg0_21.selectedCount < arg0_21.pickUpNum then
				if isActive(var10_22) then
					arg0_21.prayProxy:removeSelectedShipIDList(var0_22)

					arg0_21.selectedCount = arg0_21.selectedCount - 1

					SetActive(var10_22, false)
					arg0_21:updateSelectedShipList()
					arg0_21:updateShipList(arg0_21.fliteList)
				elseif var5_22 == ShipRarity.SSR and arg0_21:isSelectedSSR() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("pray_build_UR_warning"))
				else
					arg0_21.prayProxy:insertSelectedShipIDList(var0_22)

					arg0_21.selectedCount = arg0_21.selectedCount + 1

					SetActive(var10_22, true)
					arg0_21:updateSelectedShipList()
					arg0_21:updateShipList(arg0_21.fliteList)
				end
			elseif arg0_21.selectedCount == arg0_21.pickUpNum then
				if isActive(var10_22) then
					arg0_21.prayProxy:removeSelectedShipIDList(var0_22)

					arg0_21.selectedCount = arg0_21.selectedCount - 1

					SetActive(var10_22, false)
					arg0_21:updateSelectedShipList()
					arg0_21:updateShipList(arg0_21.fliteList)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("error_pray_select_ship_max"))
				end
			end
		end, SFX_PANEL)
	end

	function arg0_21.shipListSC.onReturnItem(arg0_24, arg1_24)
		return
	end

	arg0_21.shipListSC:SetTotalCount(#arg1_21)
end

function var0_0.orderIDListByRarity(arg0_25, arg1_25)
	local var0_25 = getProxy(CollectionProxy)

	local function var1_25(arg0_26, arg1_26)
		local var0_26 = pg.ship_data_statistics[arg0_26].rarity
		local var1_26 = pg.ship_data_statistics[arg1_26].rarity
		local var2_26 = var0_25:getShipGroup(pg.ship_data_template[arg0_26].group_type) and 1 or 0
		local var3_26 = var0_25:getShipGroup(pg.ship_data_template[arg1_26].group_type) and 1 or 0

		if var2_26 == var3_26 then
			return var1_26 < var0_26
		else
			return var2_26 < var3_26
		end
	end

	table.sort(arg1_25, var1_25)
end

function var0_0.fliteShipIDList(arg0_27)
	local var0_27 = {}
	local var1_27 = arg0_27.prayProxy:getSelectedShipIDList()

	if var1_27 and #var1_27 > 0 then
		for iter0_27, iter1_27 in ipairs(var1_27) do
			table.insert(var0_27, 1, iter1_27)
		end
	end

	for iter2_27, iter3_27 in ipairs(arg0_27.orderFullList) do
		if not table.indexof(var1_27, iter3_27, 1) then
			local var2_27 = math.modf(iter3_27 / 10)
			local var3_27 = ShipGroup.New({
				id = var2_27
			})

			if ShipIndexConst.filterByType(var3_27, var0_0.ShipIndex.typeIndex) and ShipIndexConst.filterByRarity(var3_27, var0_0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCamp(var3_27, var0_0.ShipIndex.campIndex) then
				var0_27[#var0_27 + 1] = iter3_27
			end
		end
	end

	arg0_27.fliteList = var0_27
end

function var0_0.isMinPrefs(arg0_28)
	return GroupHelper.GetGroupPrefsByName("PAINTING") == DMFileChecker.Prefs.Min
end

function var0_0.isSelectedSSR(arg0_29)
	local var0_29 = false
	local var1_29 = arg0_29.prayProxy:getSelectedShipIDList()

	if var1_29 and #var1_29 > 0 then
		for iter0_29, iter1_29 in ipairs(var1_29) do
			if pg.ship_data_statistics[iter1_29].rarity == ShipRarity.SSR then
				var0_29 = true

				break
			end
		end
	end

	return var0_29
end

return var0_0
