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
	arg0_2.animationPlayer = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

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
		arg0_8.dftAniEvent:SetEndEvent(function()
			arg0_8.dftAniEvent:SetEndEvent(nil)
			arg0_8:Hide()
		end)
		arg0_8.animationPlayer:Play("IslandDockUI_out")
	end, SFX_PANEL)
	onInputChanged(arg0_8, arg0_8.inputTr, function()
		local var0_11 = getInputText(arg0_8.inputTr)

		arg0_8.searchKey = var0_11

		arg0_8:FlushShips()
	end)
	onToggle(arg0_8, arg0_8.indexBtn, function(arg0_12)
		if arg0_12 then
			arg0_8:emit(IslandMediator.OPEN_SHIP_INDEX, {
				OnFilter = function(arg0_13)
					arg0_8:OnFilter(arg0_13)
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
		sortIndex = IslandShipIndexLayer.SortLevel,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = IslandShipIndexLayer.ExtraALL
	}

	arg0_8:UpdateSortBtn()
end

function var0_0.OnFilter(arg0_15, arg1_15)
	arg0_15.sortData = arg1_15

	arg0_15:UpdateSortBtn()
	arg0_15:FlushShips()
end

function var0_0.Show(arg0_16)
	var0_0.super.Show(arg0_16)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_16.frameTr, {
		pbList = {
			arg0_16.frameTr
		}
	})

	arg0_16.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	arg0_16:FlushShips()
end

function var0_0.UpdateSortBtn(arg0_17)
	arg0_17.orderIco.localScale = arg0_17.selectAsc and Vector3(1, 1, 1) or Vector3(1, -1, 1)

	local var0_17, var1_17 = IslandShipIndexLayer.getSortFuncAndName(arg0_17.sortData.sortIndex, arg0_17.selectAsc)

	arg0_17.orderTxt.text = i18n(var1_17)
end

function var0_0.OnInitItem(arg0_18, arg1_18)
	local var0_18 = IslandShipCard.New(arg1_18)

	onButton(arg0_18, var0_18.go, function()
		arg0_18:ClearSelected(arg0_18.contextData.selectedId)
		arg0_18:emit(IslandShipMainPage.SELECT_SHIP, var0_18.configId)
		var0_18:UpdateSelected(arg0_18.contextData.selectedId)
	end, SFX_PANEL)

	arg0_18.cards[arg1_18] = var0_18
end

function var0_0.ClearSelected(arg0_20, arg1_20)
	for iter0_20, iter1_20 in pairs(arg0_20.cards) do
		if iter1_20.configId == arg1_20 then
			iter1_20:UpdateSelected(nil)

			break
		end
	end
end

function var0_0.OnUpdateItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.cards[arg2_21]

	if not var0_21 then
		arg0_21:OnInitItem(arg2_21)

		var0_21 = arg0_21.cards[arg2_21]
	end

	local var1_21 = arg0_21.displays[arg1_21 + 1]

	var0_21:Update(var1_21, arg0_21.contextData.selectedId)
end

function var0_0.FlushShips(arg0_22)
	arg0_22.displays = arg0_22:GetShips()

	arg0_22.shipRect:SetTotalCount(#arg0_22.displays)
end

local function var1_0(arg0_23, arg1_23)
	if not arg1_23 or arg1_23 == "" then
		return true
	end

	local var0_23 = string.lower(string.gsub(arg1_23, "%.", "%%."))
	local var1_23 = IslandShip.StaticGetName(arg0_23)

	return string.find(string.lower(var1_23), var0_23)
end

function var0_0.ToVShip(arg0_24, arg1_24)
	if not arg0_24.vship then
		arg0_24.vship = {}

		function arg0_24.vship.getNation()
			return arg0_24.vship.config.nationality
		end

		function arg0_24.vship.getShipType()
			return arg0_24.vship.config.type
		end

		function arg0_24.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_24.vship.config.type)
		end

		function arg0_24.vship.getRarity()
			return arg0_24.vship.config.rarity
		end
	end

	arg0_24.vship.config = arg1_24

	return arg0_24.vship
end

local function var2_0(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg1_29
	local var1_29 = ShipGroup.getDefaultShipConfig(var0_29)
	local var2_29 = arg0_29:ToVShip(var1_29)
	local var3_29 = arg0_29.characterAgency:GetShipById(arg1_29)

	if ShipIndexConst.filterByCamp(var2_29, arg2_29.campIndex) and ShipIndexConst.filterByRarity(var2_29, arg2_29.rarityIndex) and IslandShipIndexLayer.filterByExtra(var3_29, arg2_29.extraIndex) then
		return true
	end

	return false
end

function var0_0.GetShips(arg0_30)
	local var0_30 = {}
	local var1_30 = arg0_30.characterAgency:GetUnlockOrCanUnlockShipConfigIds()

	for iter0_30, iter1_30 in ipairs(var1_30) do
		if var1_0(iter1_30, arg0_30.searchKey) and var2_0(arg0_30, iter1_30, arg0_30.sortData) then
			table.insert(var0_30, iter1_30)
		end
	end

	local var2_30 = IslandShipIndexLayer.getSortFuncAndName(arg0_30.sortData.sortIndex, arg0_30.selectAsc)

	table.sort(var0_30, CompareFuncs(var2_30))

	return var0_30
end

function var0_0.Hide(arg0_31)
	var0_0.super.Hide(arg0_31)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_31.frameTr, arg0_31._tf)
	arg0_31:emit(IslandShipMainPage.CLOSE_DOCK)
end

function var0_0.OnDestroy(arg0_32)
	ClearLScrollrect(arg0_32.shipRect)

	for iter0_32, iter1_32 in pairs(arg0_32.cards) do
		iter1_32:Dispose()
	end

	arg0_32.cards = nil
end

return var0_0
