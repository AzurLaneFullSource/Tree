local var0 = class("PrayPoolSelectShipView", import("..base.BaseSubView"))

var0.WIDTH_MIN = 328
var0.WIDTH_MAX = 438
var0.FONT_SIZE_MIN = 55
var0.FONT_SIZE_MID = 44
var0.FONT_SIZE_MAX = 34

function var0.getUIName(arg0)
	return "PrayPoolSelectShipView"
end

var0.ShipIndex = {
	typeIndex = ShipIndexConst.TypeAll,
	campIndex = ShipIndexConst.CampAll,
	rarityIndex = ShipIndexConst.RarityAll
}
var0.ShipIndexData = {
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

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateUI()
	arg0:Show()
end

function var0.OnDestroy(arg0)
	return
end

function var0.OnBackPress(arg0)
	return
end

function var0.initData(arg0)
	arg0.prayProxy = getProxy(PrayProxy)
	arg0.poolType = arg0.prayProxy:getSelectedPoolType()
	arg0.selectedCount = arg0.prayProxy:getSelectedShipCount()
	arg0.pickUpNum = pg.activity_ship_create[arg0.poolType].pickup_num
	arg0.fliteList = Clone(pg.activity_ship_create[arg0.poolType].pickup_list)

	arg0:orderIDListByRarity(arg0.fliteList)

	arg0.orderFullList = Clone(arg0.fliteList)
end

function var0.initUI(arg0)
	arg0.minRaritySpriteMap = {}
	arg0.maxRaritySpriteMap = {}
	arg0.ratioSpriteMap = {}

	local var0 = arg0:findTF("MiniRarity")
	local var1 = arg0:findTF("MaxRarity")
	local var2 = arg0:findTF("Ratio")

	for iter0 = 2, 6 do
		local var3 = getImageSprite(arg0:findTF(tostring(iter0), var0))
		local var4 = getImageSprite(arg0:findTF(tostring(iter0), var1))
		local var5 = getImageSprite(arg0:findTF(tostring(iter0), var2))

		arg0.minRaritySpriteMap[iter0] = var3
		arg0.maxRaritySpriteMap[iter0] = var4
		arg0.ratioSpriteMap[iter0] = var5
	end

	arg0.poolSpriteMap = {}

	local var6 = arg0:findTF("Pool")

	for iter1 = 1, 3 do
		local var7 = getImageSprite(arg0:findTF(tostring(iter1), var6))

		arg0.poolSpriteMap[iter1] = var7
	end

	arg0.poolNameImg = arg0:findTF("PoolNameImg")
	arg0.shipCardTpl = arg0:findTF("ShipCardTpl")

	local var8 = arg0:findTF("SelectedShipMax")
	local var9 = arg0:findTF("Light", var8)
	local var10 = arg0:findTF("Ship1", var8)
	local var11 = arg0:findTF("Ship2", var8)
	local var12 = arg0:findTF("SelectedShipMini")
	local var13 = arg0:findTF("Light", var12)
	local var14 = arg0:findTF("Ship1", var12)
	local var15 = arg0:findTF("Ship2", var12)

	arg0.selectedShipTFMap = {}
	arg0.selectedShipTFMap.Max = {
		lightTF = var9,
		var10,
		var11
	}
	arg0.selectedShipTFMap.Min = {
		lightTF = var13,
		var14,
		var15
	}

	local var16 = arg0:isMinPrefs()

	setActive(var8, not var16)
	setActive(var12, var16)

	arg0.shipListArea = arg0:findTF("ShipListArea")
	arg0.shipListContainer = arg0:findTF("Viewport/Content", arg0.shipListArea)
	arg0.shipListSC = GetComponent(arg0.shipListArea, "LScrollRect")

	setLocalPosition(arg0.shipListArea, {
		x = 0,
		y = var16 and -40 or -120
	})

	arg0.bg2 = arg0:findTF("BG2")

	setLocalPosition(arg0.bg2, {
		x = 0,
		y = var16 and -62.5 or -174
	})

	arg0.indexBtn = arg0:findTF("IndexBtn")
	arg0.preBtn = arg0:findTF("PreBtn")
	arg0.nextBtn = arg0:findTF("NextBtn")
	arg0.nextBtnCom = GetComponent(arg0.nextBtn, "Button")

	arg0.indexBtn:GetComponent(typeof(Image)):SetNativeSize()

	for iter2, iter3 in ipairs(arg0.selectedShipTFMap.Max) do
		arg0:findTF("Tip/Tip", iter3):GetComponent(typeof(Image)):SetNativeSize()
	end

	for iter4, iter5 in ipairs(arg0.selectedShipTFMap.Min) do
		arg0:findTF("Tip/Tip", iter5):GetComponent(typeof(Image)):SetNativeSize()
	end

	arg0.nextBtnCom.interactable = false

	local var17 = arg0:findTF("InstructionText")

	setText(var17, i18n("pray_build_select_ship_instruction"))
	onButton(arg0, arg0.preBtn, function()
		arg0.prayProxy:updatePageState(PrayProxy.STATE_SELECT_POOL)
		arg0:emit(PrayPoolConst.SWITCH_TO_SELECT_POOL_PAGE, PrayProxy.STATE_SELECT_POOL)
	end, SFX_PANEL)
	onButton(arg0, arg0.nextBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("warning_pray_build_pool"),
			onYes = function()
				local function var0()
					arg0:emit(PrayPoolConst.CLICK_BUILD_BTN, {
						pooltype = arg0.prayProxy:getSelectedPoolType(),
						shipIDList = arg0.prayProxy:getSelectedShipIDList()
					})
				end

				if not arg0:isMinPrefs() then
					var0()
				else
					local var1 = {}
					local var2 = arg0.prayProxy:getSelectedShipIDList()

					for iter0, iter1 in ipairs(var2) do
						PaintingGroupConst.AddPaintingNameByShipConfigID(var1, iter1)
					end

					local var3 = {
						isShowBox = true,
						paintingNameList = var1,
						finishFunc = var0
					}

					PaintingGroupConst.PaintingDownload(var3)
				end
			end
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.indexBtn, function()
		local var0 = Clone(var0.ShipIndexData)

		var0.indexDatas = Clone(var0.ShipIndex)

		function var0.callback(arg0)
			var0.ShipIndex.typeIndex = arg0.typeIndex
			var0.ShipIndex.rarityIndex = arg0.rarityIndex

			if arg0.campIndex then
				var0.ShipIndex.campIndex = arg0.campIndex
			end

			arg0:fliteShipIDList()
			arg0:updateShipList(arg0.fliteList)
		end

		arg0:emit(PrayPoolConst.CLICK_INDEX_BTN, var0)
	end)
end

function var0.updateUI(arg0)
	setImageSprite(arg0.poolNameImg, arg0.poolSpriteMap[arg0.poolType], true)
	arg0:updateSelectedShipList()
	arg0:updateShipList(arg0.fliteList)
end

function var0.updateSelectedShipList(arg0)
	if arg0:isMinPrefs() then
		arg0:updateMin()
	else
		arg0:updateMax()
	end
end

function var0.updateMax(arg0)
	local var0 = arg0.prayProxy:getSelectedShipIDList()
	local var1 = arg0.selectedShipTFMap.Max

	for iter0 = 1, 2 do
		local var2 = var0[iter0]
		local var3 = var1[iter0]
		local var4 = arg0:findTF("Paint", var3)
		local var5 = arg0:findTF("Tip", var3)
		local var6 = arg0:findTF("Info", var3)
		local var7 = arg0:findTF("Btn", var3)
		local var8 = arg0:findTF("Name/Text", var6)
		local var9 = arg0:findTF("RarityBG", var3)
		local var10 = arg0:findTF("Ratio/NumImg", var6)

		if var2 then
			setActive(var4, true)
			setPaintingPrefabAsync(var4, Ship.getPaintingName(var2), "biandui")
			setActive(var5, false)
			setActive(var6, true)

			local var11 = pg.ship_data_statistics[var2].name

			setText(var8, var11)

			local var12 = var8.localPosition
			local var13 = #var11

			if var13 <= 6 then
				var6.sizeDelta = Vector2(var0.WIDTH_MIN, var6.sizeDelta.y)
				GetComponent(var8, "Text").fontSize = var0.FONT_SIZE_MIN

				setAnchoredPosition(var8, {
					y = 14
				})
			elseif var13 <= 21 then
				var6.sizeDelta = Vector2(var0.WIDTH_MAX, var6.sizeDelta.y)
				GetComponent(var8, "Text").fontSize = var0.FONT_SIZE_MID

				setAnchoredPosition(var8, {
					y = 19
				})
			else
				var6.sizeDelta = Vector2(var0.WIDTH_MAX, var6.sizeDelta.y)
				GetComponent(var8, "Text").fontSize = var0.FONT_SIZE_MAX

				setAnchoredPosition(var8, {
					y = 25
				})
			end

			local var14 = pg.ship_data_statistics[var2].rarity

			setImageSprite(var10, arg0.ratioSpriteMap[var14], true)
			setActive(var9, true)
			setImageSprite(var9, arg0.maxRaritySpriteMap[var14])
		else
			setActive(var4, false)
			setActive(var5, true)
			setActive(var6, false)
			setActive(var9, false)
		end

		onButton(arg0, var7, function()
			if isActive(var4) then
				arg0.prayProxy:removeSelectedShipIDList(var2)

				arg0.selectedCount = arg0.selectedCount - 1

				arg0:updateSelectedShipList()
				arg0:updateShipList(arg0.fliteList)
			end
		end, SFX_PANEL)
	end

	local var15 = var1.lightTF

	if #var0 == arg0.pickUpNum then
		arg0.nextBtnCom.interactable = true

		setActive(var15, true)
	elseif #var0 < arg0.pickUpNum then
		arg0.nextBtnCom.interactable = false

		setActive(var15, false)
	end
end

function var0.updateMin(arg0)
	local var0 = arg0.prayProxy:getSelectedShipIDList()
	local var1 = arg0.selectedShipTFMap.Min

	for iter0 = 1, 2 do
		local var2 = var0[iter0]
		local var3 = var1[iter0]
		local var4 = arg0:findTF("Mask/Paint", var3)
		local var5 = arg0:findTF("Tip", var3)
		local var6 = arg0:findTF("Info", var3)
		local var7 = arg0:findTF("Btn", var3)
		local var8 = arg0:findTF("Name/Text", var6)
		local var9 = arg0:findTF("Mask/RarityBG", var3)
		local var10 = arg0:findTF("Ratio/NumImg", var6)

		if var2 then
			setActive(var4, true)
			setImageSprite(var4, LoadSprite("herohrzicon/" .. Ship.getPaintingName(var2)))
			setActive(var5, false)
			setActive(var6, true)

			local var11 = pg.ship_data_statistics[var2].name

			setText(var8, var11)

			local var12 = var8.localPosition
			local var13 = #var11

			if var13 <= 6 then
				var6.sizeDelta = Vector2(var0.WIDTH_MIN, var6.sizeDelta.y)
				GetComponent(var8, "Text").fontSize = var0.FONT_SIZE_MIN

				setAnchoredPosition(var8, {
					y = 0
				})
			elseif var13 <= 21 then
				var6.sizeDelta = Vector2(var0.WIDTH_MAX, var6.sizeDelta.y)
				GetComponent(var8, "Text").fontSize = var0.FONT_SIZE_MID

				setAnchoredPosition(var8, {
					y = 5
				})
			else
				var6.sizeDelta = Vector2(var0.WIDTH_MAX, var6.sizeDelta.y)
				GetComponent(var8, "Text").fontSize = var0.FONT_SIZE_MAX

				setAnchoredPosition(var8, {
					y = 11
				})
			end

			Canvas.ForceUpdateCanvases()

			local var14 = pg.ship_data_statistics[var2].rarity

			setImageSprite(var10, arg0.ratioSpriteMap[var14], true)
			setActive(var9, true)
			setImageSprite(var9, arg0.minRaritySpriteMap[var14])
		else
			setActive(var4, false)
			setActive(var5, true)
			setActive(var6, false)
			setActive(var9, false)
		end

		onButton(arg0, var7, function()
			if isActive(var4) then
				arg0.prayProxy:removeSelectedShipIDList(var2)

				arg0.selectedCount = arg0.selectedCount - 1

				arg0:updateSelectedShipList()
				arg0:updateShipList(arg0.fliteList)
			end
		end, SFX_PANEL)
	end

	local var15 = var1.lightTF

	if #var0 == arg0.pickUpNum then
		arg0.nextBtnCom.interactable = true

		setActive(var15, true)
	elseif #var0 < arg0.pickUpNum then
		arg0.nextBtnCom.interactable = false

		setActive(var15, false)
	end
end

function var0.updateShipList(arg0, arg1)
	local var0 = arg0.prayProxy:getSelectedShipIDList()

	function arg0.shipListSC.onUpdateItem(arg0, arg1)
		local var0 = arg1[arg0 + 1]
		local var1 = arg0:findTF("BG/Icon", arg1)

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. Ship.getPaintingName(var0), "", var1)

		local var2 = arg0:findTF("BG/GroupLocked", arg1)
		local var3 = pg.ship_data_template[var0].group_type

		if var3 and var3 > 0 then
			setActive(var2, not getProxy(CollectionProxy):getShipGroup(var3))
		else
			setActive(var2, false)
		end

		local var4 = arg0:findTF("BG/icon_bg/frame", arg1)
		local var5 = pg.ship_data_statistics[var0].rarity
		local var6 = ShipRarity.Rarity2Print(var5)

		setFrame(var4, var6)
		setIconColorful(arg0:findTF("BG", arg1), var5 - 1, {})

		local var7 = arg0:findTF("BG", arg1)

		setImageSprite(var7, GetSpriteFromAtlas("weaponframes", "bg" .. var6))

		local var8 = pg.ship_data_statistics[var0].name
		local var9 = arg0:findTF("NameBG/NameText", arg1)

		setText(var9, shortenString(var8, 6))

		local var10 = arg0:findTF("BG/SelectedImg", arg1)

		if table.indexof(var0, var0, 1) then
			SetActive(var10, true)
		else
			SetActive(var10, false)
		end

		setBlackMask(tf(arg1), var5 == ShipRarity.SSR and arg0:isSelectedSSR() and not isActive(var10), {
			recursive = true,
			color = Color(0, 0, 0, 0.6)
		})
		onButton(arg0, arg1, function()
			if arg0.selectedCount < arg0.pickUpNum then
				if isActive(var10) then
					arg0.prayProxy:removeSelectedShipIDList(var0)

					arg0.selectedCount = arg0.selectedCount - 1

					SetActive(var10, false)
					arg0:updateSelectedShipList()
					arg0:updateShipList(arg0.fliteList)
				elseif var5 == ShipRarity.SSR and arg0:isSelectedSSR() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("pray_build_UR_warning"))
				else
					arg0.prayProxy:insertSelectedShipIDList(var0)

					arg0.selectedCount = arg0.selectedCount + 1

					SetActive(var10, true)
					arg0:updateSelectedShipList()
					arg0:updateShipList(arg0.fliteList)
				end
			elseif arg0.selectedCount == arg0.pickUpNum then
				if isActive(var10) then
					arg0.prayProxy:removeSelectedShipIDList(var0)

					arg0.selectedCount = arg0.selectedCount - 1

					SetActive(var10, false)
					arg0:updateSelectedShipList()
					arg0:updateShipList(arg0.fliteList)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("error_pray_select_ship_max"))
				end
			end
		end, SFX_PANEL)
	end

	function arg0.shipListSC.onReturnItem(arg0, arg1)
		return
	end

	arg0.shipListSC:SetTotalCount(#arg1)
end

function var0.orderIDListByRarity(arg0, arg1)
	local var0 = getProxy(CollectionProxy)

	local function var1(arg0, arg1)
		local var0 = pg.ship_data_statistics[arg0].rarity
		local var1 = pg.ship_data_statistics[arg1].rarity
		local var2 = var0:getShipGroup(pg.ship_data_template[arg0].group_type) and 1 or 0
		local var3 = var0:getShipGroup(pg.ship_data_template[arg1].group_type) and 1 or 0

		if var2 == var3 then
			return var1 < var0
		else
			return var2 < var3
		end
	end

	table.sort(arg1, var1)
end

function var0.fliteShipIDList(arg0)
	local var0 = {}
	local var1 = arg0.prayProxy:getSelectedShipIDList()

	if var1 and #var1 > 0 then
		for iter0, iter1 in ipairs(var1) do
			table.insert(var0, 1, iter1)
		end
	end

	for iter2, iter3 in ipairs(arg0.orderFullList) do
		if not table.indexof(var1, iter3, 1) then
			local var2 = math.modf(iter3 / 10)
			local var3 = ShipGroup.New({
				id = var2
			})

			if ShipIndexConst.filterByType(var3, var0.ShipIndex.typeIndex) and ShipIndexConst.filterByRarity(var3, var0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCamp(var3, var0.ShipIndex.campIndex) then
				var0[#var0 + 1] = iter3
			end
		end
	end

	arg0.fliteList = var0
end

function var0.isMinPrefs(arg0)
	return GroupHelper.GetGroupPrefsByName("PAINTING") == DMFileChecker.Prefs.Min
end

function var0.isSelectedSSR(arg0)
	local var0 = false
	local var1 = arg0.prayProxy:getSelectedShipIDList()

	if var1 and #var1 > 0 then
		for iter0, iter1 in ipairs(var1) do
			if pg.ship_data_statistics[iter1].rarity == ShipRarity.SSR then
				var0 = true

				break
			end
		end
	end

	return var0
end

return var0
