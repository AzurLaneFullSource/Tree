local var0_0 = class("PrayPoolSelectShipView", import("..base.BaseSubView"))

var0_0.WIDTH_MIN = 328
var0_0.WIDTH_MAX = 438
var0_0.FONT_SIZE_MIN = 55
var0_0.FONT_SIZE_MID = 44
var0_0.FONT_SIZE_MAX = 34

function var0_0.getUIName(arg0_1)
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

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateUI()
	arg0_2:Show()
end

function var0_0.OnDestroy(arg0_3)
	return
end

function var0_0.OnBackPress(arg0_4)
	return
end

function var0_0.initData(arg0_5)
	arg0_5.prayProxy = getProxy(PrayProxy)
	arg0_5.poolType = arg0_5.prayProxy:getSelectedPoolType()
	arg0_5.selectedCount = arg0_5.prayProxy:getSelectedShipCount()
	arg0_5.pickUpNum = pg.activity_ship_create[arg0_5.poolType].pickup_num
	arg0_5.fliteList = Clone(pg.activity_ship_create[arg0_5.poolType].pickup_list)

	arg0_5:orderIDListByRarity(arg0_5.fliteList)

	arg0_5.orderFullList = Clone(arg0_5.fliteList)
end

function var0_0.initUI(arg0_6)
	arg0_6.minRaritySpriteMap = {}
	arg0_6.maxRaritySpriteMap = {}
	arg0_6.ratioSpriteMap = {}

	local var0_6 = arg0_6:findTF("MiniRarity")
	local var1_6 = arg0_6:findTF("MaxRarity")
	local var2_6 = arg0_6:findTF("Ratio")

	for iter0_6 = 2, 6 do
		local var3_6 = getImageSprite(arg0_6:findTF(tostring(iter0_6), var0_6))
		local var4_6 = getImageSprite(arg0_6:findTF(tostring(iter0_6), var1_6))
		local var5_6 = getImageSprite(arg0_6:findTF(tostring(iter0_6), var2_6))

		arg0_6.minRaritySpriteMap[iter0_6] = var3_6
		arg0_6.maxRaritySpriteMap[iter0_6] = var4_6
		arg0_6.ratioSpriteMap[iter0_6] = var5_6
	end

	arg0_6.poolSpriteMap = {}

	local var6_6 = arg0_6:findTF("Pool")

	for iter1_6 = 1, 3 do
		local var7_6 = getImageSprite(arg0_6:findTF(tostring(iter1_6), var6_6))

		arg0_6.poolSpriteMap[iter1_6] = var7_6
	end

	arg0_6.poolNameImg = arg0_6:findTF("PoolNameImg")
	arg0_6.shipCardTpl = arg0_6:findTF("ShipCardTpl")

	local var8_6 = arg0_6:findTF("SelectedShipMax")
	local var9_6 = arg0_6:findTF("Light", var8_6)
	local var10_6 = arg0_6:findTF("Ship1", var8_6)
	local var11_6 = arg0_6:findTF("Ship2", var8_6)
	local var12_6 = arg0_6:findTF("SelectedShipMini")
	local var13_6 = arg0_6:findTF("Light", var12_6)
	local var14_6 = arg0_6:findTF("Ship1", var12_6)
	local var15_6 = arg0_6:findTF("Ship2", var12_6)

	arg0_6.selectedShipTFMap = {}
	arg0_6.selectedShipTFMap.Max = {
		lightTF = var9_6,
		var10_6,
		var11_6
	}
	arg0_6.selectedShipTFMap.Min = {
		lightTF = var13_6,
		var14_6,
		var15_6
	}

	local var16_6 = arg0_6:isMinPrefs()

	setActive(var8_6, not var16_6)
	setActive(var12_6, var16_6)

	arg0_6.shipListArea = arg0_6:findTF("ShipListArea")
	arg0_6.shipListContainer = arg0_6:findTF("Viewport/Content", arg0_6.shipListArea)
	arg0_6.shipListSC = GetComponent(arg0_6.shipListArea, "LScrollRect")

	setLocalPosition(arg0_6.shipListArea, {
		x = 0,
		y = var16_6 and -40 or -120
	})

	arg0_6.bg2 = arg0_6:findTF("BG2")

	setLocalPosition(arg0_6.bg2, {
		x = 0,
		y = var16_6 and -62.5 or -174
	})

	arg0_6.indexBtn = arg0_6:findTF("IndexBtn")
	arg0_6.preBtn = arg0_6:findTF("PreBtn")
	arg0_6.nextBtn = arg0_6:findTF("NextBtn")
	arg0_6.nextBtnCom = GetComponent(arg0_6.nextBtn, "Button")

	arg0_6.indexBtn:GetComponent(typeof(Image)):SetNativeSize()

	for iter2_6, iter3_6 in ipairs(arg0_6.selectedShipTFMap.Max) do
		arg0_6:findTF("Tip/Tip", iter3_6):GetComponent(typeof(Image)):SetNativeSize()
	end

	for iter4_6, iter5_6 in ipairs(arg0_6.selectedShipTFMap.Min) do
		arg0_6:findTF("Tip/Tip", iter5_6):GetComponent(typeof(Image)):SetNativeSize()
	end

	arg0_6.nextBtnCom.interactable = false

	local var17_6 = arg0_6:findTF("InstructionText")

	setText(var17_6, i18n("pray_build_select_ship_instruction"))
	onButton(arg0_6, arg0_6.preBtn, function()
		arg0_6.prayProxy:updatePageState(PrayProxy.STATE_SELECT_POOL)
		arg0_6:emit(PrayPoolConst.SWITCH_TO_SELECT_POOL_PAGE, PrayProxy.STATE_SELECT_POOL)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.nextBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("warning_pray_build_pool"),
			onYes = function()
				local function var0_9()
					arg0_6:emit(PrayPoolConst.CLICK_BUILD_BTN, {
						pooltype = arg0_6.prayProxy:getSelectedPoolType(),
						shipIDList = arg0_6.prayProxy:getSelectedShipIDList()
					})
				end

				if not arg0_6:isMinPrefs() then
					var0_9()
				else
					local var1_9 = {}
					local var2_9 = arg0_6.prayProxy:getSelectedShipIDList()

					for iter0_9, iter1_9 in ipairs(var2_9) do
						PaintingGroupConst.AddPaintingNameByShipConfigID(var1_9, iter1_9)
					end

					local var3_9 = {
						isShowBox = true,
						paintingNameList = var1_9,
						finishFunc = var0_9
					}

					PaintingGroupConst.PaintingDownload(var3_9)
				end
			end
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.indexBtn, function()
		local var0_11 = Clone(var0_0.ShipIndexData)

		var0_11.indexDatas = Clone(var0_0.ShipIndex)

		function var0_11.callback(arg0_12)
			var0_0.ShipIndex.typeIndex = arg0_12.typeIndex
			var0_0.ShipIndex.rarityIndex = arg0_12.rarityIndex

			if arg0_12.campIndex then
				var0_0.ShipIndex.campIndex = arg0_12.campIndex
			end

			arg0_6:fliteShipIDList()
			arg0_6:updateShipList(arg0_6.fliteList)
		end

		arg0_6:emit(PrayPoolConst.CLICK_INDEX_BTN, var0_11)
	end)
end

function var0_0.updateUI(arg0_13)
	setImageSprite(arg0_13.poolNameImg, arg0_13.poolSpriteMap[arg0_13.poolType], true)
	arg0_13:updateSelectedShipList()
	arg0_13:updateShipList(arg0_13.fliteList)
end

function var0_0.updateSelectedShipList(arg0_14)
	if arg0_14:isMinPrefs() then
		arg0_14:updateMin()
	else
		arg0_14:updateMax()
	end
end

function var0_0.updateMax(arg0_15)
	local var0_15 = arg0_15.prayProxy:getSelectedShipIDList()
	local var1_15 = arg0_15.selectedShipTFMap.Max

	for iter0_15 = 1, 2 do
		local var2_15 = var0_15[iter0_15]
		local var3_15 = var1_15[iter0_15]
		local var4_15 = arg0_15:findTF("Paint", var3_15)
		local var5_15 = arg0_15:findTF("Tip", var3_15)
		local var6_15 = arg0_15:findTF("Info", var3_15)
		local var7_15 = arg0_15:findTF("Btn", var3_15)
		local var8_15 = arg0_15:findTF("Name/Text", var6_15)
		local var9_15 = arg0_15:findTF("RarityBG", var3_15)
		local var10_15 = arg0_15:findTF("Ratio/NumImg", var6_15)

		if var2_15 then
			setActive(var4_15, true)
			setPaintingPrefabAsync(var4_15, Ship.getPaintingName(var2_15), "biandui")
			setActive(var5_15, false)
			setActive(var6_15, true)

			local var11_15 = pg.ship_data_statistics[var2_15].name

			setText(var8_15, var11_15)

			local var12_15 = var8_15.localPosition
			local var13_15 = #var11_15

			if var13_15 <= 6 then
				var6_15.sizeDelta = Vector2(var0_0.WIDTH_MIN, var6_15.sizeDelta.y)
				GetComponent(var8_15, "Text").fontSize = var0_0.FONT_SIZE_MIN

				setAnchoredPosition(var8_15, {
					y = 14
				})
			elseif var13_15 <= 21 then
				var6_15.sizeDelta = Vector2(var0_0.WIDTH_MAX, var6_15.sizeDelta.y)
				GetComponent(var8_15, "Text").fontSize = var0_0.FONT_SIZE_MID

				setAnchoredPosition(var8_15, {
					y = 19
				})
			else
				var6_15.sizeDelta = Vector2(var0_0.WIDTH_MAX, var6_15.sizeDelta.y)
				GetComponent(var8_15, "Text").fontSize = var0_0.FONT_SIZE_MAX

				setAnchoredPosition(var8_15, {
					y = 25
				})
			end

			local var14_15 = pg.ship_data_statistics[var2_15].rarity

			setImageSprite(var10_15, arg0_15.ratioSpriteMap[var14_15], true)
			setActive(var9_15, true)
			setImageSprite(var9_15, arg0_15.maxRaritySpriteMap[var14_15])
		else
			setActive(var4_15, false)
			setActive(var5_15, true)
			setActive(var6_15, false)
			setActive(var9_15, false)
		end

		onButton(arg0_15, var7_15, function()
			if isActive(var4_15) then
				arg0_15.prayProxy:removeSelectedShipIDList(var2_15)

				arg0_15.selectedCount = arg0_15.selectedCount - 1

				arg0_15:updateSelectedShipList()
				arg0_15:updateShipList(arg0_15.fliteList)
			end
		end, SFX_PANEL)
	end

	local var15_15 = var1_15.lightTF

	if #var0_15 == arg0_15.pickUpNum then
		arg0_15.nextBtnCom.interactable = true

		setActive(var15_15, true)
	elseif #var0_15 < arg0_15.pickUpNum then
		arg0_15.nextBtnCom.interactable = false

		setActive(var15_15, false)
	end
end

function var0_0.updateMin(arg0_17)
	local var0_17 = arg0_17.prayProxy:getSelectedShipIDList()
	local var1_17 = arg0_17.selectedShipTFMap.Min

	for iter0_17 = 1, 2 do
		local var2_17 = var0_17[iter0_17]
		local var3_17 = var1_17[iter0_17]
		local var4_17 = arg0_17:findTF("Mask/Paint", var3_17)
		local var5_17 = arg0_17:findTF("Tip", var3_17)
		local var6_17 = arg0_17:findTF("Info", var3_17)
		local var7_17 = arg0_17:findTF("Btn", var3_17)
		local var8_17 = arg0_17:findTF("Name/Text", var6_17)
		local var9_17 = arg0_17:findTF("Mask/RarityBG", var3_17)
		local var10_17 = arg0_17:findTF("Ratio/NumImg", var6_17)

		if var2_17 then
			setActive(var4_17, true)
			setImageSprite(var4_17, LoadSprite("herohrzicon/" .. Ship.getPaintingName(var2_17)))
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
					y = 0
				})
			elseif var13_17 <= 21 then
				var6_17.sizeDelta = Vector2(var0_0.WIDTH_MAX, var6_17.sizeDelta.y)
				GetComponent(var8_17, "Text").fontSize = var0_0.FONT_SIZE_MID

				setAnchoredPosition(var8_17, {
					y = 5
				})
			else
				var6_17.sizeDelta = Vector2(var0_0.WIDTH_MAX, var6_17.sizeDelta.y)
				GetComponent(var8_17, "Text").fontSize = var0_0.FONT_SIZE_MAX

				setAnchoredPosition(var8_17, {
					y = 11
				})
			end

			Canvas.ForceUpdateCanvases()

			local var14_17 = pg.ship_data_statistics[var2_17].rarity

			setImageSprite(var10_17, arg0_17.ratioSpriteMap[var14_17], true)
			setActive(var9_17, true)
			setImageSprite(var9_17, arg0_17.minRaritySpriteMap[var14_17])
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

function var0_0.updateShipList(arg0_19, arg1_19)
	local var0_19 = arg0_19.prayProxy:getSelectedShipIDList()

	function arg0_19.shipListSC.onUpdateItem(arg0_20, arg1_20)
		local var0_20 = arg1_19[arg0_20 + 1]
		local var1_20 = arg0_19:findTF("BG/Icon", arg1_20)

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. Ship.getPaintingName(var0_20), "", var1_20)

		local var2_20 = arg0_19:findTF("BG/GroupLocked", arg1_20)
		local var3_20 = pg.ship_data_template[var0_20].group_type

		if var3_20 and var3_20 > 0 then
			setActive(var2_20, not getProxy(CollectionProxy):getShipGroup(var3_20))
		else
			setActive(var2_20, false)
		end

		local var4_20 = arg0_19:findTF("BG/icon_bg/frame", arg1_20)
		local var5_20 = pg.ship_data_statistics[var0_20].rarity
		local var6_20 = ShipRarity.Rarity2Print(var5_20)

		setFrame(var4_20, var6_20)
		setIconColorful(arg0_19:findTF("BG", arg1_20), var5_20 - 1, {})

		local var7_20 = arg0_19:findTF("BG", arg1_20)

		setImageSprite(var7_20, GetSpriteFromAtlas("weaponframes", "bg" .. var6_20))

		local var8_20 = pg.ship_data_statistics[var0_20].name
		local var9_20 = arg0_19:findTF("NameBG/NameText", arg1_20)

		setText(var9_20, shortenString(var8_20, 6))

		local var10_20 = arg0_19:findTF("BG/SelectedImg", arg1_20)

		if table.indexof(var0_19, var0_20, 1) then
			SetActive(var10_20, true)
		else
			SetActive(var10_20, false)
		end

		setBlackMask(tf(arg1_20), var5_20 == ShipRarity.SSR and arg0_19:isSelectedSSR() and not isActive(var10_20), {
			recursive = true,
			color = Color(0, 0, 0, 0.6)
		})
		onButton(arg0_19, arg1_20, function()
			if arg0_19.selectedCount < arg0_19.pickUpNum then
				if isActive(var10_20) then
					arg0_19.prayProxy:removeSelectedShipIDList(var0_20)

					arg0_19.selectedCount = arg0_19.selectedCount - 1

					SetActive(var10_20, false)
					arg0_19:updateSelectedShipList()
					arg0_19:updateShipList(arg0_19.fliteList)
				elseif var5_20 == ShipRarity.SSR and arg0_19:isSelectedSSR() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("pray_build_UR_warning"))
				else
					arg0_19.prayProxy:insertSelectedShipIDList(var0_20)

					arg0_19.selectedCount = arg0_19.selectedCount + 1

					SetActive(var10_20, true)
					arg0_19:updateSelectedShipList()
					arg0_19:updateShipList(arg0_19.fliteList)
				end
			elseif arg0_19.selectedCount == arg0_19.pickUpNum then
				if isActive(var10_20) then
					arg0_19.prayProxy:removeSelectedShipIDList(var0_20)

					arg0_19.selectedCount = arg0_19.selectedCount - 1

					SetActive(var10_20, false)
					arg0_19:updateSelectedShipList()
					arg0_19:updateShipList(arg0_19.fliteList)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("error_pray_select_ship_max"))
				end
			end
		end, SFX_PANEL)
	end

	function arg0_19.shipListSC.onReturnItem(arg0_22, arg1_22)
		return
	end

	arg0_19.shipListSC:SetTotalCount(#arg1_19)
end

function var0_0.orderIDListByRarity(arg0_23, arg1_23)
	local var0_23 = getProxy(CollectionProxy)

	local function var1_23(arg0_24, arg1_24)
		local var0_24 = pg.ship_data_statistics[arg0_24].rarity
		local var1_24 = pg.ship_data_statistics[arg1_24].rarity
		local var2_24 = var0_23:getShipGroup(pg.ship_data_template[arg0_24].group_type) and 1 or 0
		local var3_24 = var0_23:getShipGroup(pg.ship_data_template[arg1_24].group_type) and 1 or 0

		if var2_24 == var3_24 then
			return var1_24 < var0_24
		else
			return var2_24 < var3_24
		end
	end

	table.sort(arg1_23, var1_23)
end

function var0_0.fliteShipIDList(arg0_25)
	local var0_25 = {}
	local var1_25 = arg0_25.prayProxy:getSelectedShipIDList()

	if var1_25 and #var1_25 > 0 then
		for iter0_25, iter1_25 in ipairs(var1_25) do
			table.insert(var0_25, 1, iter1_25)
		end
	end

	for iter2_25, iter3_25 in ipairs(arg0_25.orderFullList) do
		if not table.indexof(var1_25, iter3_25, 1) then
			local var2_25 = math.modf(iter3_25 / 10)
			local var3_25 = ShipGroup.New({
				id = var2_25
			})

			if ShipIndexConst.filterByType(var3_25, var0_0.ShipIndex.typeIndex) and ShipIndexConst.filterByRarity(var3_25, var0_0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCamp(var3_25, var0_0.ShipIndex.campIndex) then
				var0_25[#var0_25 + 1] = iter3_25
			end
		end
	end

	arg0_25.fliteList = var0_25
end

function var0_0.isMinPrefs(arg0_26)
	return GroupHelper.GetGroupPrefsByName("PAINTING") == DMFileChecker.Prefs.Min
end

function var0_0.isSelectedSSR(arg0_27)
	local var0_27 = false
	local var1_27 = arg0_27.prayProxy:getSelectedShipIDList()

	if var1_27 and #var1_27 > 0 then
		for iter0_27, iter1_27 in ipairs(var1_27) do
			if pg.ship_data_statistics[iter1_27].rarity == ShipRarity.SSR then
				var0_27 = true

				break
			end
		end
	end

	return var0_27
end

return var0_0
