local var0_0 = class("IslandDockPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandDockUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.frameTr = arg0_2._tf:Find("frame")
	arg0_2.shipRect = arg0_2._tf:Find("frame/ships"):GetComponent("LScrollRect")
	arg0_2.inputTr = arg0_2._tf:Find("frame/filter_panel/search/input")
	arg0_2.indexBtn = arg0_2._tf:Find("frame/filter_panel/IndexIco")
	arg0_2.orderBtn = arg0_2._tf:Find("frame/filter_panel/index")
	arg0_2.orderIco = arg0_2._tf:Find("frame/filter_panel/index/content/icon/icon")
	arg0_2.orderTxt = arg0_2._tf:Find("frame/filter_panel/index/content/Text"):GetComponent(typeof(Text))

	function arg0_2.shipRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.shipRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.AddListeners(arg0_5)
	arg0_5:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_5.OnAddShip)
end

function var0_0.RemoveListeners(arg0_6)
	arg0_6:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_6.OnAddShip)
end

function var0_0.OnAddShip(arg0_7)
	arg0_7:FlushShips()
end

function var0_0.OnInit(arg0_8)
	onButton(arg0_8, arg0_8._tf, function()
		arg0_8:Hide()
	end, SFX_PANEL)
	onInputChanged(arg0_8, arg0_8.inputTr, function()
		local var0_10 = getInputText(arg0_8.inputTr)

		arg0_8.searchKey = var0_10

		arg0_8:FlushShips()
	end)
	onToggle(arg0_8, arg0_8.indexBtn, function(arg0_11)
		if arg0_11 then
			arg0_8:emit(IslandMediator.OPEN_SHIP_INDEX, {
				OnFilter = function(arg0_12)
					arg0_8:OnFilter(arg0_12)
				end,
				defaultIndex = arg0_8.sortData
			})
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.orderBtn, function()
		arg0_8.selectAsc = not arg0_8.selectAsc

		arg0_8:UpdateSortBtn()
		arg0_8:FlushShips()
	end, SFX_PANEL)

	arg0_8.cards = {}
	arg0_8.searchKey = ""
	arg0_8.selectAsc = true
	arg0_8.sortData = {
		sortIndex = IslandShipIndexLayer.SortRarity,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = IslandShipIndexLayer.ExtraALL
	}

	arg0_8:UpdateSortBtn()
end

function var0_0.OnFilter(arg0_14, arg1_14)
	arg0_14.sortData = arg1_14

	arg0_14:UpdateSortBtn()
	arg0_14:FlushShips()
end

function var0_0.Show(arg0_15)
	var0_0.super.Show(arg0_15)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_15.frameTr, {
		pbList = {
			arg0_15.frameTr
		}
	})

	arg0_15.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	arg0_15:FlushShips()
end

function var0_0.UpdateSortBtn(arg0_16)
	arg0_16.orderIco.localScale = arg0_16.selectAsc and Vector3(1, -1, 1) or Vector3(1, 1, 1)

	local var0_16, var1_16 = IslandShipIndexLayer.getSortFuncAndName(arg0_16.sortData.sortIndex, arg0_16.selectAsc)

	arg0_16.orderTxt.text = i18n(var1_16)
end

function var0_0.OnInitItem(arg0_17, arg1_17)
	local var0_17 = IslandShipCard.New(arg1_17)

	onButton(arg0_17, var0_17.go, function()
		arg0_17:ClearSelected(arg0_17.contextData.selectedId)
		arg0_17:emit(IslandShipMainPage.SELECT_SHIP, var0_17.configId)
		var0_17:UpdateSelected(arg0_17.contextData.selectedId)
	end, SFX_PANEL)

	arg0_17.cards[arg1_17] = var0_17
end

function var0_0.ClearSelected(arg0_19, arg1_19)
	for iter0_19, iter1_19 in pairs(arg0_19.cards) do
		if iter1_19.configId == arg1_19 then
			iter1_19:UpdateSelected(nil)

			break
		end
	end
end

function var0_0.OnUpdateItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.cards[arg2_20]

	if not var0_20 then
		arg0_20:OnInitItem(arg2_20)

		var0_20 = arg0_20.cards[arg2_20]
	end

	local var1_20 = arg0_20.displays[arg1_20 + 1]

	var0_20:Update(var1_20, arg0_20.contextData.selectedId)
end

function var0_0.FlushShips(arg0_21)
	arg0_21.displays = arg0_21:GetShips()

	arg0_21.shipRect:SetTotalCount(#arg0_21.displays)
end

local function var1_0(arg0_22, arg1_22)
	if not arg1_22 or arg1_22 == "" then
		return true
	end

	local var0_22 = string.lower(string.gsub(arg1_22, "%.", "%%."))
	local var1_22 = pg.island_ship[arg0_22].name

	return string.find(string.lower(var1_22), var0_22)
end

function var0_0.ToVShip(arg0_23, arg1_23)
	if not arg0_23.vship then
		arg0_23.vship = {}

		function arg0_23.vship.getNation()
			return arg0_23.vship.config.nationality
		end

		function arg0_23.vship.getShipType()
			return arg0_23.vship.config.type
		end

		function arg0_23.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_23.vship.config.type)
		end

		function arg0_23.vship.getRarity()
			return arg0_23.vship.config.rarity
		end
	end

	arg0_23.vship.config = arg1_23

	return arg0_23.vship
end

local function var2_0(arg0_28, arg1_28, arg2_28)
	local var0_28 = IslandShip.StaticGetShipGroup(arg1_28)
	local var1_28 = ShipGroup.getDefaultShipConfig(var0_28)
	local var2_28 = arg0_28:ToVShip(var1_28)
	local var3_28 = arg0_28.characterAgency:GetShipByConfigId(arg1_28)

	if ShipIndexConst.filterByCamp(var2_28, arg2_28.campIndex) and ShipIndexConst.filterByRarity(var2_28, arg2_28.rarityIndex) and IslandShipIndexLayer.filterByExtra(var3_28, arg2_28.extraIndex) then
		return true
	end

	return false
end

function var0_0.GetShips(arg0_29)
	local var0_29 = {}
	local var1_29 = arg0_29.characterAgency:GetUnlockOrCanUnlockShipConfigIds()

	for iter0_29, iter1_29 in ipairs(var1_29) do
		if var1_0(iter1_29, arg0_29.searchKey) and var2_0(arg0_29, iter1_29, arg0_29.sortData) then
			table.insert(var0_29, iter1_29)
		end
	end

	local var2_29 = IslandShipIndexLayer.getSortFuncAndName(arg0_29.sortData.sortIndex, arg0_29.selectAsc)

	table.sort(var0_29, CompareFuncs(var2_29))

	return var0_29
end

function var0_0.Hide(arg0_30)
	var0_0.super.Hide(arg0_30)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_30.frameTr, arg0_30._tf)
end

function var0_0.OnDestroy(arg0_31)
	ClearLScrollrect(arg0_31.shipRect)

	for iter0_31, iter1_31 in pairs(arg0_31.cards) do
		iter1_31:Dispose()
	end

	arg0_31.cards = nil
end

return var0_0
