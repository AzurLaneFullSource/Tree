local var0_0 = class("IslandRestaurantPage", import("...base.IslandBasePage"))

var0_0.MAX_ASSISTANT_CNT = 2
var0_0.MAX_SHELF_CNT = 5

local var1_0 = Vector3(-210, 50)
local var2_0 = pg.island_item_data_template
local var3_0 = pg.island_set
local var4_0 = pg.island_buff_template

function var0_0.getUIName(arg0_1)
	return "IslandRestaurantUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_manage_title"))

	arg0_2.rankTF = arg0_2._tf:Find("rank")
	arg0_2.rankIcon = arg0_2.rankTF:Find("icon")
	arg0_2.rankSlider = arg0_2.rankTF:Find("exp")
	arg0_2.rankText = arg0_2.rankTF:Find("exp/progress")
	arg0_2.eventContainer = arg0_2._tf:Find("content/event_container")
	arg0_2.eventTitleTF = arg0_2.eventContainer:Find("event/title")
	arg0_2.eventDescTF = arg0_2.eventContainer:Find("event/desc/Text")

	setText(arg0_2.eventContainer:Find("event/desc/effect"), i18n("island_manage_produce_tip"))

	arg0_2.windowContainer = arg0_2._tf:Find("content/window_container")

	local var0_2 = arg0_2.windowContainer:Find("window")

	arg0_2.nameTF = var0_2:Find("name/Text")
	arg0_2.nameEnTF = var0_2:Find("name_en/Text")

	local var1_2 = var0_2:Find("left/content")

	arg0_2.shipUIList = UIItemList.New(var1_2, var1_2:Find("tpl"))

	setText(var1_2:Find("tpl/empty/Image/Text"), i18n("island_manage_sel_worker"))
	setText(var1_2:Find("tpl/lock/Image/Text"), i18n("island_manage_upgrade_worker_level"))
	setText(var1_2:Find("tpl/ship/skill/invalid/Text"), i18n("island_manage_skill_cant_use"))

	arg0_2.commoditiesTF = var0_2:Find("right/commodities")
	arg0_2.commoditiesEmptyTF = var0_2:Find("right/commodities_empty")

	setText(arg0_2.commoditiesEmptyTF, i18n("island_manage_stock_out"))

	arg0_2.scrollRect = arg0_2.commoditiesTF:GetComponent("LScrollRect")
	arg0_2.detailPanel = var0_2:Find("right/detail")
	arg0_2.detailNameTF = arg0_2.detailPanel:Find("dot/name")
	arg0_2.detailPriceTF = arg0_2.detailPanel:Find("price/value")
	arg0_2.detailDescTF = arg0_2.detailPanel:Find("desc")
	arg0_2.detailEffectTF = arg0_2.detailPanel:Find("effect/Text")
	arg0_2.shelfsTF = var0_2:Find("right/shelfs")

	setText(arg0_2.shelfsTF:Find("infos/tip"), i18n("island_manage_item_select"))

	arg0_2.extraCapacityTF = arg0_2.shelfsTF:Find("infos/capacity")

	setText(arg0_2.extraCapacityTF:Find("name"), i18n("island_manage_capacity"))

	arg0_2.extraCapacityEffectTF = arg0_2.extraCapacityTF:Find("effect")
	arg0_2.shelfUIList = UIItemList.New(arg0_2.shelfsTF:Find("content"), arg0_2.shelfsTF:Find("content/tpl"))

	local var2_2 = var0_2:Find("estimate")

	setText(var2_2:Find("Text"), i18n("island_manage_predict_saleroom"))
	setText(var2_2:Find("count/Text"), i18n("island_manage_cnt"))
	setText(var2_2:Find("sales/Text"), i18n("island_manage_saleroom") .. ":")

	arg0_2.estimateCntTF = var2_2:Find("count/value")
	arg0_2.estimateSalesTF = var2_2:Find("sales/value")
	arg0_2.buffInfoBtn = var2_2:Find("info")
	arg0_2.buffInfoPanel = var2_2:Find("info_panel")

	setText(arg0_2.buffInfoPanel:Find("Text"), i18n("island_manage_addition"))

	arg0_2.buffInfoUIList = UIItemList.New(arg0_2.buffInfoPanel:Find("effects"), arg0_2.buffInfoPanel:Find("effects/tpl"))
	arg0_2.buffInfoEmptyTF = arg0_2.buffInfoPanel:Find("empty")

	setText(arg0_2.buffInfoEmptyTF:Find("Text"), i18n("island_manage_no_addition"))

	arg0_2.btnsTF = var0_2:Find("btns")
	arg0_2.openBtn = arg0_2.btnsTF:Find("prepare/open"), setText(arg0_2.btnsTF:Find("prepare/auto/Text"), i18n("island_manage_auto_work"))

	setText(arg0_2.btnsTF:Find("prepare/open/Text"), i18n("island_manage_start_work"))
	setText(arg0_2.btnsTF:Find("opening/Text"), i18n("island_manage_working"))
	setText(arg0_2.btnsTF:Find("close/Text"), i18n("island_manage_result"))
	setText(arg0_2.btnsTF:Find("end/Text"), i18n("island_manage_end_daily_work"))

	arg0_2.ticketBtn = arg0_2.btnsTF:Find("opening/ticket")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.rankTF, function()
		arg0_3:OpenPage(IslandRestaurantRankPage, arg0_3.restId)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btnsTF:Find("prepare/auto"), function()
		if not arg0_3.isOperable then
			return
		end

		arg0_3:OnAutoSelect()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.openBtn, function()
		local var0_7 = {}

		for iter0_7, iter1_7 in ipairs(arg0_3.assistantsData) do
			var0_7[iter1_7.id] = arg0_3.selectedShipIds[iter0_7]
		end

		arg0_3:emit(IslandMediator.OPEN_RESTAURANT, {
			restId = arg0_3.restId,
			ships = var0_7,
			commodities = arg0_3.selectedDic
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btnsTF:Find("close"), function()
		arg0_3:emit(IslandMediator.CLOSE_RESTAURANT, arg0_3.restId, arg0_3.isPost)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.buffInfoBtn, function()
		if isActive(arg0_3.buffInfoPanel) then
			setActive(arg0_3.buffInfoPanel, false)
		else
			setActive(arg0_3.buffInfoPanel, true)
			arg0_3.buffInfoUIList:align(#arg0_3.buffInfos)
			setActive(arg0_3.buffInfoEmptyTF, #arg0_3.buffInfos == 0)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.ticketBtn, function()
		arg0_3:OpenPage(IslandTicketUsePage, IslandUseTicketCommand.TYPES.MANAGE, arg0_3.restId)
	end, SFX_PANEL)
	arg0_3.shipUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_3:UpdateShipItem(arg1_11, arg2_11)
		end
	end)

	function arg0_3.scrollRect.onInitItem(arg0_12)
		arg0_3:OnInitItem(arg0_12)
	end

	function arg0_3.scrollRect.onUpdateItem(arg0_13, arg1_13)
		arg0_3:OnUpdateItem(arg0_13, arg1_13)
	end

	arg0_3.shelfUIList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			arg0_3:UpdateShelfItem(arg1_14, arg2_14)
		end
	end)
	arg0_3.buffInfoUIList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg0_3.buffInfos[arg1_15 + 1]

			setText(arg2_15:Find("bg/name"), var0_15.name)
			setText(arg2_15:Find("bg/effect"), var0_15.effect)
		end
	end)

	arg0_3.priceFactor = var3_0.island_manage_price_coefficient.key_value_int / 100
	arg0_3.argA = var3_0.island_manage_sale_coefficient_a.key_value_int / 100
	arg0_3.argB = var3_0.island_manage_sale_coefficient_b.key_value_int / 100
	arg0_3.argC = var3_0.island_manage_sale_coefficient_c.key_value_int / 100
	arg0_3.saleConst = var3_0.island_manage_sale_constant.key_value_int / 100
	arg0_3.maxAttrEffect = pg.island_chara_att[1].manage_effect / 10000
	arg0_3.minSaleCnt = var3_0.island_manage_sale_limit.key_value_int
end

function var0_0.AddListeners(arg0_16)
	arg0_16:AddListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_16.Flush)
	arg0_16:AddListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_16.Flush)
	arg0_16:AddListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_16.Flush)
end

function var0_0.RemoveListeners(arg0_17)
	arg0_17:RemoveListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_17.Flush)
	arg0_17:RemoveListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_17.Flush)
	arg0_17:RemoveListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_17.Flush)
end

function var0_0.OnInitItem(arg0_18, arg1_18)
	local var0_18 = IslandFoodCard.New(arg1_18)

	onButton(arg0_18, var0_18._go, function()
		if isActive(arg0_18.detailPanel) then
			setActive(arg0_18.detailPanel, false)
		end

		if not arg0_18.isOperable then
			return
		end

		arg0_18:AddOnShelf(var0_18)
	end, SFX_PANEL)

	arg0_18.cards[arg1_18] = var0_18
end

function var0_0.AddOnShelf(arg0_20, arg1_20)
	if #arg0_20.shelfInfos >= arg0_20.shelfCnt then
		return
	end

	local var0_20 = math.min(arg1_20.item:GetCount(), arg0_20.baseCapacity + arg0_20.extraCapacity)

	arg0_20.selectedDic[arg1_20.item.id] = var0_20

	arg1_20:UpdateSelectedCnt(var0_20)
	arg0_20:FlushShelfs()
	arg0_20:FlushEstimate()
end

function var0_0.ShowDetailPanel(arg0_21, arg1_21, arg2_21)
	setAnchoredPosition(arg0_21.detailPanel, arg2_21 + var1_0)
	setActive(arg0_21.detailPanel, true)
	setText(arg0_21.detailNameTF, arg1_21:GetName())

	local var0_21 = math.floor(arg1_21:getConfig("order_price") * arg0_21.priceFactor)

	setText(arg0_21.detailPriceTF, var0_21)
	setText(arg0_21.detailDescTF, arg1_21:GetDesc())

	local var1_21 = IslandShipAttr.GetAtrrName(arg1_21:getConfig("sub_attribute")[1])
	local var2_21 = i18n("island_manage_attr_effect") .. IslandShipAttr.ATTRS_CH[1] .. "、" .. IslandShipAttr.ToChinese(var1_21)

	setText(arg0_21.detailEffectTF, var2_21)
end

function var0_0.OnUpdateItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.cards[arg2_22]

	if not var0_22 then
		arg0_22:OnInitItem(arg2_22)

		var0_22 = arg0_22.cards[arg2_22]
	end

	local var1_22 = arg0_22.displays[arg1_22 + 1]

	if var1_22 then
		local var2_22 = arg0_22:GetAttrsFactorsRatio(var1_22.id)
		local var3_22 = arg0_22.selectedDic and arg0_22.selectedDic[var1_22.id] and arg0_22.selectedDic[var1_22.id] or 0

		var0_22:Update(var1_22, arg0_22.isOperable and var3_22 or 0, arg0_22.eventEffects[var1_22.id], var2_22)
	end

	local var4_22 = arg0_22.detailPanel.parent:InverseTransformPoint(var0_22._tf.position)

	GetOrAddComponent(var0_22._go, typeof(UILongPressTrigger)).onLongPressed:AddListener(function()
		arg0_22:ShowDetailPanel(var0_22.item, var4_22)
	end)
end

function var0_0.UpdateCardWithItemId(arg0_24, arg1_24)
	for iter0_24, iter1_24 in pairs(arg0_24.cards) do
		if iter1_24.item.id == arg1_24 then
			iter1_24:UpdateSelectedCnt(arg0_24.selectedDic[arg1_24] or 0)
		end
	end
end

function var0_0.OnShow(arg0_25, arg1_25, arg2_25)
	arg0_25:BlurPanel()
	setActive(arg0_25.buffInfoPanel, false)

	arg0_25.restId = arg1_25
	arg0_25.isPost = arg2_25
	arg0_25.cards = {}

	arg0_25:Flush()
end

function var0_0.OnEnable(arg0_26)
	arg0_26:Flush()
end

function var0_0.Flush(arg0_27)
	arg0_27:FlushData()
	arg0_27:FlushName()
	arg0_27:FlushRank()
	arg0_27:FlushEvent()

	arg0_27.selectedShipIds = nil

	arg0_27:FlushAssistants()

	arg0_27.selectedDic = nil

	arg0_27:FlushCards()
	arg0_27:FlushShelfs()
	arg0_27:FlushEstimate()
	arg0_27:FlushBtns()
end

function var0_0.FlushData(arg0_28)
	arg0_28.rest = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(arg0_28.restId)
	arg0_28.shelfCnt = arg0_28.rest:GetShelfCnt()
	arg0_28.assistantsData = arg0_28.rest:GetAssistants()
	arg0_28.baseCapacity = arg0_28.rest:GetBaseShelfCapacity()
	arg0_28.extraCapacity = 0
	arg0_28.isOperable = arg0_28.rest:GetStatus() == IslandRestaurant.STATUS.PREPARE
end

function var0_0.FlushName(arg0_29)
	setText(arg0_29.nameTF, arg0_29.rest:getConfig("name"))
	setText(arg0_29.nameEnTF, arg0_29.rest:getConfig("name_en"))
end

function var0_0.FlushRank(arg0_30)
	LoadImageSpriteAsync("island/islandrestaurant/" .. arg0_30.rest:GetRankIcon(), arg0_30.rankIcon)

	local var0_30 = arg0_30.rest:GetSales()
	local var1_30 = arg0_30.rest:GetCanUpgradeExp()

	setText(arg0_30.rankText, var0_30 .. "/" .. var1_30)
	setSlider(arg0_30.rankSlider, 0, 1, var1_30 == 0 and 0 or var0_30 / var1_30)
end

function var0_0.FlushEvent(arg0_31)
	arg0_31.eventId, arg0_31.eventEffects, arg0_31.eventInfluence = arg0_31.rest:GetEventInfo()

	setActive(arg0_31.eventContainer, arg0_31.eventId ~= 0)

	if arg0_31.eventId ~= 0 then
		local var0_31 = pg.island_manage_event[arg0_31.eventId]

		setText(arg0_31.eventTitleTF, var0_31.name)
		setText(arg0_31.eventDescTF, var0_31.desc)
	end
end

function var0_0.FlushAssistants(arg0_32)
	if not arg0_32.selectedShipIds then
		local var0_32 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

		arg0_32.selectedShipIds = {}

		for iter0_32, iter1_32 in ipairs(arg0_32.assistantsData) do
			local var1_32 = iter1_32.shipId

			if var1_32 ~= 0 then
				table.insert(arg0_32.selectedShipIds, var1_32)
			end
		end
	end

	arg0_32.selectedShips = {}

	local var2_32 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	for iter2_32, iter3_32 in ipairs(arg0_32.selectedShipIds) do
		table.insert(arg0_32.selectedShips, var2_32:GetShipById(iter3_32))
	end

	arg0_32.shipUIList:align(var0_0.MAX_ASSISTANT_CNT)

	arg0_32.extraPricePer = 0
	arg0_32.extraCapacity = 0
	arg0_32.buffInfos = {}

	local var3_32 = IslandBuffHelper.GetManangeSellPriceBuffs(arg0_32.selectedShips, arg0_32.restId)

	for iter4_32, iter5_32 in ipairs(var3_32) do
		local var4_32 = iter5_32:GetBuffEffect()[2]

		table.insert(arg0_32.buffInfos, {
			name = i18n("island_manage_saleroom"),
			effect = "+" .. var4_32 .. "%"
		})

		arg0_32.extraPricePer = arg0_32.extraPricePer + var4_32 / 100
	end

	local var5_32 = IslandBuffHelper.GetManangeSellNumBuffs(arg0_32.selectedShips, arg0_32.restId)

	for iter6_32, iter7_32 in ipairs(var5_32) do
		local var6_32 = iter7_32:GetBuffEffect()[2]

		table.insert(arg0_32.buffInfos, {
			name = i18n("island_manage_capacity"),
			effect = "+" .. var6_32
		})

		arg0_32.extraCapacity = arg0_32.extraCapacity + var6_32
	end

	setActive(arg0_32.extraCapacityTF, arg0_32.extraCapacity > 0)
	setText(arg0_32.extraCapacityEffectTF, "+" .. arg0_32.extraCapacity)

	local var7_32 = arg0_32.shelfInfos and #arg0_32.shelfInfos > 0 and arg0_32.selectedShipIds and #arg0_32.selectedShipIds > 0

	setGray(arg0_32.openBtn, not var7_32, true)
	setButtonEnabled(arg0_32.openBtn, var7_32)
end

function var0_0.GetEffectiveManangeSkill(arg0_33, arg1_33)
	local var0_33 = arg1_33:GetSkill()

	return var0_33:IsEffectiveInRest(arg0_33.restId) and var0_33 or nil
end

function var0_0.GetEffectiveManangeUnlockSkill(arg0_34, arg1_34)
	local var0_34 = arg0_34:GetEffectiveManangeSkill(arg1_34)

	return var0_34 and var0_34:IsUnlock() and var0_34 or nil
end

function var0_0.UpdateShipItem(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg1_35 + 1

	arg2_35.name = var0_35

	local var1_35 = var0_35 <= #arg0_35.assistantsData

	setActive(arg2_35:Find("lock"), not var1_35)

	local var2_35 = arg0_35.selectedShips[var0_35]

	setActive(arg2_35:Find("empty"), var1_35 and not var2_35)
	setActive(arg2_35:Find("ship"), var1_35 and var2_35)
	onButton(arg0_35, arg2_35, function()
		if not var1_35 or not arg0_35.isOperable then
			return
		end

		arg0_35:OpenPage(IslandShipSelectPage, {
			showBenefits = true,
			selectNum = #arg0_35.assistantsData,
			selectedIds = Clone(arg0_35.selectedShipIds),
			attrType = IslandShipAttr.MANAGE_KEY,
			confirmFunc = function(arg0_37)
				arg0_35:OnSelectedShipsDone(arg0_37)
			end,
			emptyInfoTitle = arg0_35.rest:getConfig("name")
		})
	end, SFX_PANEL)

	if var2_35 then
		local var3_35 = arg2_35:Find("ship")

		setText(var3_35:Find("name"), var2_35:GetName())

		local var4_35 = arg0_35:GetEffectiveManangeSkill(var2_35)

		setActive(var3_35:Find("skill"), var4_35 and var4_35:IsUnlock())
		setActive(var3_35:Find("skill_lock"), var4_35 and not var4_35:IsUnlock())

		local var5_35 = IslandShip.StaticGetPrefab(var2_35.id)

		GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var5_35, "", var3_35:Find("icon"))

		local var6_35 = var3_35:Find("skill")

		if var4_35 then
			if var4_35:IsUnlock() then
				setActive(var6_35:Find("effects"), true)
				setActive(var6_35:Find("invalid"), false)
				LoadImageSpriteAsync("island/islandskillicon/" .. var4_35:GetIcon(), var6_35:Find("skill_icon"))
				setText(var6_35:Find("skill_name"), var4_35:GetName())

				local var7_35 = IslandBuffHelper.GetAllShipManangeBuffs(var2_35, arg0_35.restId)

				UIItemList.StaticAlign(var6_35:Find("effects"), var6_35:Find("effects/tpl"), #var7_35, function(arg0_38, arg1_38, arg2_38)
					if arg0_38 == UIItemList.EventUpdate then
						local var0_38 = var7_35[arg1_38 + 1]
						local var1_38 = var0_38:GetBuffType()
						local var2_38 = ""
						local var3_38 = ""

						if var1_38 == IslandBuffType.SHIP_MANAGE_SELL_PRICE then
							var2_38 = i18n("island_manage_saleroom")
							var3_38 = "+" .. var0_38:GetBuffEffect()[2] .. "%"
						elseif var1_38 == IslandBuffType.SHIP_MANAGE_SELL_NUM then
							var2_38 = i18n("island_manage_capacity")
							var3_38 = "+" .. var0_38:GetBuffEffect()[2]
						end

						setText(arg2_38:Find("name"), var2_38)
						setText(arg2_38:Find("effect"), var3_38)
					end
				end)
			else
				setText(var3_35:Find("skill_lock/Image/Text"), i18n("island_need_star_1", var2_35:GetSkillUnlockLevel()))
			end
		else
			local var8_35 = var2_35:GetSkill()

			setActive(var3_35:Find("skill"), true)
			LoadImageSpriteAsync("island/islandskillicon/" .. var8_35:GetIcon(), var6_35:Find("skill_icon"))
			setText(var6_35:Find("skill_name"), var8_35:GetName())
			setActive(var6_35:Find("effects"), false)
			setActive(var6_35:Find("invalid"), true)
		end
	end
end

function var0_0.FlushCards(arg0_39)
	arg0_39.displays = {}

	local var0_39 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_39, iter1_39 in ipairs(arg0_39.rest:getConfig("item_id")) do
		local var1_39 = var0_39:GetItemById(iter1_39[1])

		if var1_39 then
			table.insert(arg0_39.displays, var1_39)
		end
	end

	setActive(arg0_39.commoditiesEmptyTF, #arg0_39.displays <= 0)
	setActive(arg0_39.commoditiesTF, #arg0_39.displays > 0)
	arg0_39:CaclAttrsFactors()

	if #arg0_39.displays > 0 then
		arg0_39:SortDisplays()
	end
end

function var0_0.SortDisplays(arg0_40)
	table.sort(arg0_40.displays, CompareFuncs({
		function(arg0_41)
			return -arg0_40.subAttrFactorsDic[arg0_41.id]
		end,
		function(arg0_42)
			return -arg0_42:getConfig("order_price") * arg0_40.priceFactor
		end,
		function(arg0_43)
			return arg0_43.id
		end
	}))

	if arg0_40:isShowing() then
		arg0_40.scrollRect:SetTotalCount(#arg0_40.displays, -1)
	end
end

function var0_0.CaclAttrsFactors(arg0_44)
	arg0_44.subAttrFactorsDic = {}
	arg0_44.mainAttrFactorsDic = {}

	for iter0_44, iter1_44 in ipairs(arg0_44.displays) do
		local var0_44 = iter1_44:getConfig("sub_attribute")[1]

		arg0_44.subAttrFactorsDic[iter1_44.id] = var0_44 and var0_0.CaclShipAttrFactors(arg0_44.selectedShips, var0_44) or 0
		arg0_44.mainAttrFactorsDic[iter1_44.id] = var0_0.CaclShipAttrFactors(arg0_44.selectedShips, IslandShipAttr.MANAGE_KEY)
	end
end

function var0_0.GetSubAttrFactors(arg0_45, arg1_45)
	if arg0_45.subAttrFactorsDic[arg1_45] then
		return arg0_45.subAttrFactorsDic[arg1_45]
	end

	local var0_45 = var2_0[arg1_45].sub_attribute[1]

	arg0_45.subAttrFactorsDic[arg1_45] = var0_45 and var0_0.CaclShipAttrFactors(arg0_45.selectedShips, var0_45) or 0

	return arg0_45.subAttrFactorsDic[arg1_45]
end

function var0_0.GetMainAttrFactors(arg0_46, arg1_46)
	if arg0_46.mainAttrFactorsDic[arg1_46] then
		return arg0_46.mainAttrFactorsDic[arg1_46]
	end

	arg0_46.mainAttrFactorsDic[arg1_46] = var0_0.CaclShipAttrFactors(arg0_46.selectedShips, IslandShipAttr.MANAGE_KEY)

	return arg0_46.mainAttrFactorsDic[arg1_46]
end

function var0_0.GetAttrsFactorsRatio(arg0_47, arg1_47)
	local var0_47 = var2_0[arg1_47].sub_attribute[2] / 100
	local var1_47 = arg0_47:GetMainAttrFactors(arg1_47) + arg0_47:GetSubAttrFactors(arg1_47) * var0_47
	local var2_47 = #arg0_47.assistantsData * (arg0_47.maxAttrEffect + arg0_47.maxAttrEffect * var0_47)

	return var2_47 == 0 and 0 or var1_47 / var2_47
end

function var0_0.FlushShelfs(arg0_48)
	if not arg0_48.selectedDic then
		arg0_48.selectedDic = {}

		for iter0_48, iter1_48 in ipairs(arg0_48.rest:GetCommondities()) do
			arg0_48.selectedDic[iter1_48.id] = iter1_48.num
		end
	end

	arg0_48.shelfInfos = {}

	for iter2_48, iter3_48 in pairs(arg0_48.selectedDic) do
		table.insert(arg0_48.shelfInfos, {
			id = iter2_48,
			num = iter3_48
		})
	end

	arg0_48.shelfUIList:align(var0_0.MAX_SHELF_CNT)

	local var0_48 = arg0_48.shelfInfos and #arg0_48.shelfInfos > 0 and arg0_48.selectedShipIds and #arg0_48.selectedShipIds > 0

	setGray(arg0_48.openBtn, not var0_48, true)
	setButtonEnabled(arg0_48.openBtn, var0_48)
end

function var0_0.UpdateShelfItem(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg1_49 + 1

	arg2_49.name = var0_49

	local var1_49 = var0_49 <= arg0_49.shelfCnt

	setActive(arg2_49:Find("lock"), not var1_49)

	local var2_49 = arg0_49.shelfInfos[var0_49]

	setActive(arg2_49:Find("empty"), var1_49 and not var2_49)
	setActive(arg2_49:Find("commodity"), var1_49 and var2_49)

	if var2_49 then
		local var3_49 = arg2_49:Find("commodity")

		LoadImageSpriteAsync("island/" .. var2_0[var2_49.id].icon, var3_49:Find("bg/icon"))

		local var4_49 = arg0_49.baseCapacity + arg0_49.extraCapacity

		setText(var3_49:Find("count/Text"), var2_49.num .. "/" .. (arg0_49.extraCapacity > 0 and setColorStr(var4_49, "#7BF59DFF") or var4_49))
		setActive(var3_49:Find("event"), arg0_49.eventEffects[var2_49.id])

		local var5_49 = arg0_49:GetAttrsFactorsRatio(var2_49.id)

		setFillAmount(var3_49:Find("bg/silder/bar"), var5_49)
		setActive(var3_49:Find("reduce"), arg0_49.isOperable)
		onButton(arg0_49, var3_49:Find("reduce"), function()
			if not arg0_49.isOperable then
				return
			end

			arg0_49:ReduceShelfCnt(var2_49.id, 1)
			arg0_49:FlushEstimate()
		end, SFX_PANEL)
	end
end

function var0_0.ReduceShelfCnt(arg0_51, arg1_51, arg2_51)
	arg0_51.selectedDic[arg1_51] = arg0_51.selectedDic[arg1_51] - arg2_51

	if arg0_51.selectedDic[arg1_51] <= 0 then
		arg0_51.selectedDic[arg1_51] = nil
	end

	arg0_51:UpdateCardWithItemId(arg1_51)
	arg0_51:FlushShelfs()
end

function var0_0.FlushEstimate(arg0_52)
	local var0_52, var1_52 = arg0_52.rest:GetRandomSaleCntBound()
	local var2_52 = 0
	local var3_52 = 0
	local var4_52 = 0
	local var5_52 = 0

	for iter0_52, iter1_52 in pairs(arg0_52.selectedDic) do
		local var6_52 = arg0_52:CaclBaseSaleCnt(iter0_52)
		local var7_52 = math.min(iter1_52, math.max(arg0_52.minSaleCnt, var6_52 + var0_52))
		local var8_52 = math.min(iter1_52, math.max(arg0_52.minSaleCnt, var6_52 + var1_52))

		var4_52 = var4_52 + arg0_52:CaclGroupPrice(iter0_52, var7_52)
		var5_52 = var5_52 + arg0_52:CaclGroupPrice(iter0_52, var8_52)
		var2_52 = var2_52 + var7_52
		var3_52 = var3_52 + var8_52
	end

	setText(arg0_52.estimateCntTF, var2_52 .. "-" .. var3_52)
	setText(arg0_52.estimateSalesTF, var4_52 .. "-" .. var5_52)
end

function var0_0.CaclBaseSaleCnt(arg0_53, arg1_53)
	local var0_53 = var2_0[arg1_53].manage_influence / 100 + (arg0_53.eventEffects[arg1_53] and arg0_53.eventInfluence or 0)
	local var1_53 = arg0_53.argA + arg0_53:GetMainAttrFactors(arg1_53)
	local var2_53 = var2_0[arg1_53].sub_attribute[2] / 100
	local var3_53 = arg0_53.argB + arg0_53:GetSubAttrFactors(arg1_53) * var2_53
	local var4_53 = arg0_53.argC + arg0_53.rest:GetRankFactor()

	return math.floor(var0_53 * var1_53 * var3_53 * var4_53 / arg0_53.saleConst)
end

function var0_0.CaclGroupPrice(arg0_54, arg1_54, arg2_54)
	local var0_54 = var2_0[arg1_54].order_price * arg0_54.priceFactor
	local var1_54 = arg0_54.eventEffects[arg1_54] or 0

	return math.floor(var0_54 * arg2_54 * (1 + var1_54 + arg0_54.extraPricePer))
end

function var0_0.OnSelectedShipsDone(arg0_55, arg1_55)
	arg0_55.selectedShipIds = arg1_55

	arg0_55:FlushAssistants()
	arg0_55:FlushCards()
	arg0_55:FlushShelfs()
	arg0_55:FlushEstimate()
end

function var0_0.OnAutoSelect(arg0_56)
	arg0_56.selectedShipIds = arg0_56:GetAutoShipIds()

	arg0_56:FlushAssistants()
	arg0_56:FlushCards()

	arg0_56.selectedDic = {}

	for iter0_56 = 1, arg0_56.shelfCnt do
		local var0_56 = arg0_56.displays[iter0_56]

		if var0_56 then
			arg0_56.selectedDic[var0_56.id] = math.min(var0_56:GetCount(), arg0_56.baseCapacity + arg0_56.extraCapacity)
		end
	end

	arg0_56.scrollRect:SetTotalCount(#arg0_56.displays, -1)
	arg0_56:FlushShelfs()
	arg0_56:FlushEstimate()
end

function var0_0.GetAutoShipIds(arg0_57)
	local var0_57 = underscore.select(getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShips(), function(arg0_58)
		return arg0_58:GetState() == IslandShip.STATE_NORMAL
	end)

	table.sort(var0_57, CompareFuncs({
		function(arg0_59)
			return arg0_57:GetEffectiveManangeUnlockSkill(arg0_59) and 0 or 1
		end,
		function(arg0_60)
			local var0_60 = IslandBuffHelper.GetShipBuffsByType({
				arg0_60
			}, IslandBuffType.SHIP_MANAGE_SELL_PRICE)

			return -underscore.reduce(var0_60, 0, function(arg0_61, arg1_61)
				return arg0_61 + arg1_61:GetBuffEffect()[2]
			end)
		end,
		function(arg0_62)
			local var0_62 = IslandBuffHelper.GetShipBuffsByType({
				arg0_62
			}, IslandBuffType.SHIP_MANAGE_SELL_NUM)

			return -underscore.reduce(var0_62, 0, function(arg0_63, arg1_63)
				return arg0_63 + arg1_63:GetBuffEffect()[2]
			end)
		end,
		function(arg0_64)
			return arg0_64.id
		end
	}))

	local var1_57 = {}

	for iter0_57 = 1, #arg0_57.assistantsData do
		if var0_57[iter0_57] then
			table.insert(var1_57, var0_57[iter0_57].id)
		end
	end

	if #var1_57 == 0 and #arg0_57.assistantsData > 0 then
		table.insert(var1_57, IslandCharacterAgency.NPC_CONFIG_ID)
	end

	return var1_57
end

function var0_0.FlushBtns(arg0_65)
	local var0_65 = arg0_65.rest:GetStatus()

	eachChild(arg0_65.btnsTF, function(arg0_66)
		setActive(arg0_66, arg0_66.name == var0_65)
	end)

	if var0_65 == IslandRestaurant.STATUS.OPENING then
		if not arg0_65.timer then
			arg0_65:StartTimer()
			arg0_65:UpdateTime()
		end
	else
		arg0_65:StopTimer()
	end
end

function var0_0.UpdateTime(arg0_67)
	local var0_67 = pg.TimeMgr.GetInstance()
	local var1_67 = arg0_67.rest:GetEndTime() - var0_67:GetServerTime()

	setText(arg0_67.btnsTF:Find("opening/time"), var0_67:DescCDTime(var1_67))

	if var1_67 <= 0 then
		arg0_67:FlushBtns()
	end
end

function var0_0.StartTimer(arg0_68)
	arg0_68.timer = Timer.New(function()
		arg0_68:UpdateTime()
	end, 1, -1)

	arg0_68.timer:Start()
end

function var0_0.StopTimer(arg0_70)
	if arg0_70.timer ~= nil then
		arg0_70.timer:Stop()

		arg0_70.timer = nil
	end
end

function var0_0.OnHide(arg0_71)
	arg0_71:StopTimer()
	arg0_71:UnBlurPanel()
end

function var0_0.OnDisable(arg0_72)
	arg0_72:OnHide()
end

function var0_0.OnDestroy(arg0_73)
	ClearLScrollrect(arg0_73.scrollRect)
	arg0_73:OnHide()
end

function var0_0.CaclShipAttrFactors(arg0_74, arg1_74)
	local var0_74 = 0

	for iter0_74, iter1_74 in ipairs(arg0_74) do
		local var1_74 = iter1_74:GetAttrGrade(IslandShipAttr.GetAtrrName(arg1_74))

		var0_74 = var0_74 + pg.island_chara_att[var1_74].manage_effect / 10000
	end

	return var0_74
end

return var0_0
