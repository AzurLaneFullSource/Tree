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

	setText(arg0_2.eventContainer:Find("event/desc/effect"), "")

	arg0_2.itemsList = UIItemList.New(arg0_2._tf:Find("content/event_container/event/items"), arg0_2._tf:Find("content/event_container/event/items/tpl"))
	arg0_2.additionList = UIItemList.New(arg0_2._tf:Find("content/event_container/event/addition"), arg0_2._tf:Find("content/event_container/event/addition/tpl"))
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
	setText(arg0_2.buffInfoPanel:Find("tips"), i18n("island_manage_buff_tip"))

	arg0_2.btnsTF = var0_2:Find("btns")
	arg0_2.openBtn = arg0_2.btnsTF:Find("prepare/open"), setText(arg0_2.btnsTF:Find("prepare/auto/Text"), i18n("island_manage_auto_work"))

	setText(arg0_2.btnsTF:Find("prepare/open/Text"), i18n("island_manage_start_work"))
	setText(arg0_2.btnsTF:Find("opening/Text"), i18n("island_manage_working"))
	setText(arg0_2.btnsTF:Find("close/Text"), i18n("island_manage_result"))
	setText(arg0_2.btnsTF:Find("end/Text"), i18n("island_manage_end_daily_work"))
	setText(arg0_2._tf:Find("content/event_container/event/title/Text"), i18n("island_post_event_addition_label"))

	arg0_2.ticketBtn = arg0_2.btnsTF:Find("opening/ticket")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_manage.tip
		})
	end, SFX_PANEL)
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
		local var0_8 = {}

		for iter0_8, iter1_8 in ipairs(arg0_3.assistantsData) do
			var0_8[iter1_8.id] = arg0_3.selectedShipIds[iter0_8]
		end

		arg0_3:emit(IslandMediator.OPEN_RESTAURANT, {
			restId = arg0_3.restId,
			ships = var0_8,
			commodities = arg0_3.selectedDic,
			estimateData = {
				trade_id = arg0_3.restId,
				sell_num_min = arg0_3.totalMinCnt,
				sell_num_max = arg0_3.totalMaxCnt,
				sell_money_min = arg0_3.totalMinSales,
				sell_money_max = arg0_3.totalMaxSales
			}
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
	arg0_3.shipUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			arg0_3:UpdateShipItem(arg1_12, arg2_12)
		end
	end)

	function arg0_3.scrollRect.onInitItem(arg0_13)
		arg0_3:OnInitItem(arg0_13)
	end

	function arg0_3.scrollRect.onUpdateItem(arg0_14, arg1_14)
		arg0_3:OnUpdateItem(arg0_14, arg1_14)
	end

	arg0_3.shelfUIList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			arg0_3:UpdateShelfItem(arg1_15, arg2_15)
		end
	end)
	arg0_3.buffInfoUIList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = arg0_3.buffInfos[arg1_16 + 1]

			setText(arg2_16:Find("bg/name"), var0_16.name)
			setText(arg2_16:Find("bg/effect"), var0_16.effect)
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

function var0_0.AddListeners(arg0_17)
	arg0_17:AddListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_17.Flush)
	arg0_17:AddListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_17.Flush)
	arg0_17:AddListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_17.Flush)
end

function var0_0.RemoveListeners(arg0_18)
	arg0_18:RemoveListener(GAME.ISLAND_OPEN_RESTAURANT_DONE, arg0_18.Flush)
	arg0_18:RemoveListener(GAME.ISLAND_CLOSE_RESTAURANT_DONE, arg0_18.Flush)
	arg0_18:RemoveListener(IslandManageAgecny.ON_DAILY_REFRESH, arg0_18.Flush)
end

function var0_0.OnInitItem(arg0_19, arg1_19)
	local var0_19 = IslandFoodCard.New(arg1_19)

	onButton(arg0_19, var0_19._go, function()
		if isActive(arg0_19.detailPanel) then
			setActive(arg0_19.detailPanel, false)
		end

		if not arg0_19.isOperable then
			return
		end

		arg0_19:AddOnShelf(var0_19)
	end, SFX_PANEL)

	arg0_19.cards[arg1_19] = var0_19
end

function var0_0.AddOnShelf(arg0_21, arg1_21)
	if #arg0_21.shelfInfos >= arg0_21.shelfCnt then
		return
	end

	local var0_21 = math.min(arg1_21.item:GetCount(), arg0_21.baseCapacity + arg0_21.extraCapacity)

	arg0_21.selectedDic[arg1_21.item.id] = var0_21

	arg1_21:UpdateSelectedCnt(var0_21)
	arg0_21:FlushShelfs()
	arg0_21:FlushEstimate()
end

function var0_0.ShowDetailPanel(arg0_22, arg1_22, arg2_22)
	setAnchoredPosition(arg0_22.detailPanel, arg2_22 + var1_0)
	setActive(arg0_22.detailPanel, true)
	setText(arg0_22.detailNameTF, arg1_22:GetName())

	local var0_22 = math.floor(arg1_22:getConfig("order_price") * arg0_22.priceFactor)

	setText(arg0_22.detailPriceTF, var0_22)
	setText(arg0_22.detailDescTF, arg1_22:GetDesc())

	local var1_22 = IslandShipAttr.GetAtrrName(arg1_22:getConfig("sub_attribute")[1])
	local var2_22 = i18n("island_manage_attr_effect") .. IslandShipAttr.ATTRS_CH[1] .. "、" .. IslandShipAttr.ToChinese(var1_22)

	setText(arg0_22.detailEffectTF, var2_22)
end

function var0_0.OnUpdateItem(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.cards[arg2_23]

	if not var0_23 then
		arg0_23:OnInitItem(arg2_23)

		var0_23 = arg0_23.cards[arg2_23]
	end

	local var1_23 = arg0_23.displays[arg1_23 + 1]

	if var1_23 then
		local var2_23 = arg0_23:GetAttrsFactorsRatio(var1_23.id)
		local var3_23 = arg0_23.selectedDic and arg0_23.selectedDic[var1_23.id] and arg0_23.selectedDic[var1_23.id] or 0

		var0_23:Update(var1_23, arg0_23.isOperable and var3_23 or 0, arg0_23.eventEffects[var1_23.id], var2_23)
	end

	local var4_23 = arg0_23.detailPanel.parent:InverseTransformPoint(var0_23._tf.position)

	GetOrAddComponent(var0_23._go, typeof(UILongPressTrigger)).onLongPressed:AddListener(function()
		arg0_23:ShowDetailPanel(var0_23.item, var4_23)
	end)
end

function var0_0.UpdateCardWithItemId(arg0_25, arg1_25)
	for iter0_25, iter1_25 in pairs(arg0_25.cards) do
		if iter1_25.item.id == arg1_25 then
			iter1_25:UpdateSelectedCnt(arg0_25.selectedDic[arg1_25] or 0)
		end
	end
end

function var0_0.OnShow(arg0_26, arg1_26, arg2_26)
	arg0_26:BlurPanel()
	setActive(arg0_26.buffInfoPanel, false)

	arg0_26.restId = arg1_26
	arg0_26.isPost = arg2_26
	arg0_26.cards = {}

	arg0_26:Flush()
end

function var0_0.OnEnable(arg0_27)
	arg0_27:Flush()
end

function var0_0.Flush(arg0_28)
	arg0_28:FlushData()
	arg0_28:FlushName()
	arg0_28:FlushRank()
	arg0_28:FlushEvent()

	arg0_28.selectedShipIds = nil

	arg0_28:FlushAssistants()

	arg0_28.selectedDic = nil

	arg0_28:FlushCards()
	arg0_28:FlushShelfs()
	arg0_28:FlushEstimate()
	arg0_28:FlushBtns()
end

function var0_0.FlushData(arg0_29)
	arg0_29.rest = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(arg0_29.restId)
	arg0_29.shelfCnt = arg0_29.rest:GetShelfCnt()
	arg0_29.assistantsData = arg0_29.rest:GetAssistants()
	arg0_29.baseCapacity = arg0_29.rest:GetBaseShelfCapacity()
	arg0_29.extraCapacity = 0
	arg0_29.isOperable = arg0_29.rest:GetStatus() == IslandRestaurant.STATUS.PREPARE
end

function var0_0.FlushName(arg0_30)
	setText(arg0_30.nameTF, arg0_30.rest:getConfig("name"))
	setText(arg0_30.nameEnTF, arg0_30.rest:getConfig("name_en"))
end

function var0_0.FlushRank(arg0_31)
	LoadImageSpriteAsync("island/islandrestaurant/" .. arg0_31.rest:GetRankIcon(), arg0_31.rankIcon)

	local var0_31 = arg0_31.rest:GetSales()
	local var1_31 = arg0_31.rest:GetCanUpgradeExp()

	setText(arg0_31.rankText, var0_31 .. "/" .. var1_31)
	setSlider(arg0_31.rankSlider, 0, 1, var1_31 == 0 and 0 or var0_31 / var1_31)
end

function var0_0.FlushEvent(arg0_32)
	arg0_32.eventId, arg0_32.eventEffects, arg0_32.eventInfluence = arg0_32.rest:GetEventInfo()

	setActive(arg0_32.eventContainer, arg0_32.eventId ~= 0)

	if arg0_32.eventId ~= 0 then
		local var0_32 = pg.island_manage_event[arg0_32.eventId]

		setText(arg0_32.eventTitleTF, var0_32.name)
		setText(arg0_32.eventDescTF, string.gsub(var0_32.desc, "$1", arg0_32.rest:getConfig("name")))
		arg0_32:UpdateAddition(arg0_32.rest)
	end
end

function var0_0.UpdateAddition(arg0_33, arg1_33)
	local var0_33 = arg0_33:WarpItemInfo(arg1_33)

	arg0_33.itemsList:make(function(arg0_34, arg1_34, arg2_34)
		if arg0_34 == UIItemList.EventUpdate then
			local var0_34 = var0_33[arg1_34 + 1]
			local var1_34 = Drop.New({
				count = 0,
				type = DROP_TYPE_ISLAND_ITEM,
				id = var0_34.id
			})

			updateCustomDrop(arg2_34, var1_34)
		end
	end)
	arg0_33.itemsList:align(#var0_33)

	local var1_33 = arg1_33:GetEventInfo()
	local var2_33 = pg.island_manage_event[var1_33]
	local var3_33 = arg0_33:WarpAdditionInfo(var2_33)

	arg0_33.additionList:make(function(arg0_35, arg1_35, arg2_35)
		if arg0_35 == UIItemList.EventUpdate then
			setText(arg2_35:Find("Text"), var3_33[arg1_35 + 1][1])
			setText(arg2_35:Find("value"), "+" .. var3_33[arg1_35 + 1][2] .. "%")
		end
	end)
	arg0_33.additionList:align(#var3_33)
end

function var0_0.WarpItemInfo(arg0_36, arg1_36)
	local var0_36 = {}
	local var1_36, var2_36 = arg1_36:GetEventInfo()
	local var3_36 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_36, iter1_36 in ipairs(arg1_36:getConfig("item_id")) do
		local var4_36 = var3_36:GetItemById(iter1_36[1]) or IslandItem.New({
			id = iter1_36[1]
		})

		if var4_36 and var2_36[var4_36.id] then
			table.insert(var0_36, var4_36)
		end
	end

	return var0_36
end

function var0_0.WarpAdditionInfo(arg0_37, arg1_37)
	local var0_37 = {}

	table.insert(var0_37, {
		i18n("island_addition_influence"),
		arg1_37.influence_bonus
	})
	table.insert(var0_37, {
		i18n("island_addition_sale"),
		arg1_37.event_effect[1][1]
	})

	return var0_37
end

function var0_0.FlushAssistants(arg0_38)
	if not arg0_38.selectedShipIds then
		local var0_38 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

		arg0_38.selectedShipIds = {}

		for iter0_38, iter1_38 in ipairs(arg0_38.assistantsData) do
			local var1_38 = iter1_38.shipId

			if var1_38 ~= 0 then
				table.insert(arg0_38.selectedShipIds, var1_38)
			end
		end
	end

	arg0_38.selectedShips = {}

	local var2_38 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	for iter2_38, iter3_38 in ipairs(arg0_38.selectedShipIds) do
		table.insert(arg0_38.selectedShips, var2_38:GetShipById(iter3_38))
	end

	arg0_38.shipUIList:align(var0_0.MAX_ASSISTANT_CNT)

	arg0_38.extraPricePer = 0
	arg0_38.extraCapacity = 0
	arg0_38.buffInfos = {}

	local var3_38 = IslandBuffHelper.GetManageSellPriceBuffs(arg0_38.selectedShips, arg0_38.restId)

	for iter4_38, iter5_38 in ipairs(var3_38) do
		local var4_38 = iter5_38:GetBuffEffect()[2]

		table.insert(arg0_38.buffInfos, {
			name = i18n("island_manage_saleroom"),
			effect = "+" .. var4_38 .. "%"
		})

		arg0_38.extraPricePer = arg0_38.extraPricePer + var4_38 / 100
	end

	local var5_38 = IslandBuffHelper.GetManageSellNumBuffs(arg0_38.selectedShips, arg0_38.restId)

	for iter6_38, iter7_38 in ipairs(var5_38) do
		local var6_38 = iter7_38:GetBuffEffect()[2]

		table.insert(arg0_38.buffInfos, {
			name = i18n("island_manage_capacity"),
			effect = "+" .. var6_38
		})

		arg0_38.extraCapacity = arg0_38.extraCapacity + var6_38
	end

	if arg0_38.statusCheckTimer then
		arg0_38.statusCheckTimer:Stop()
	end

	if arg0_38.isOperable then
		arg0_38.shipStatus = IslandBuffHelper.GetManageStatus(arg0_38.selectedShips, arg0_38.restId)

		if #arg0_38.shipStatus > 0 then
			arg0_38.statusCheckTimer = Timer.New(function()
				if underscore.reduce(arg0_38.shipStatus, 0, function(arg0_40, arg1_40)
					return arg0_40 + (arg1_40:IsExpiration() and 1 or 0)
				end) > 0 then
					arg0_38:OnStatusExpired()
				end
			end, 1, -1)

			arg0_38.statusCheckTimer:Start()
		end
	end

	setActive(arg0_38.extraCapacityTF, arg0_38.isOperable and arg0_38.extraCapacity > 0)
	setText(arg0_38.extraCapacityEffectTF, "+" .. arg0_38.extraCapacity)
	arg0_38.buffInfoUIList:align(#arg0_38.buffInfos)
	setActive(arg0_38.buffInfoEmptyTF, #arg0_38.buffInfos == 0)

	local var7_38 = arg0_38.shelfInfos and #arg0_38.shelfInfos > 0 and arg0_38.selectedShipIds and #arg0_38.selectedShipIds > 0

	setGray(arg0_38.openBtn, not var7_38, true)
	setButtonEnabled(arg0_38.openBtn, var7_38)
end

function var0_0.GetEffectiveManangeSkill(arg0_41, arg1_41)
	local var0_41 = arg1_41:GetSkill()

	return var0_41:IsEffectiveInRest(arg0_41.restId) and var0_41 or nil
end

function var0_0.GetEffectiveManangeUnlockSkill(arg0_42, arg1_42)
	local var0_42 = arg0_42:GetEffectiveManangeSkill(arg1_42)

	return var0_42 and var0_42:IsUnlock() and var0_42 or nil
end

function var0_0.UpdateShipItem(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg1_43 + 1

	arg2_43.name = var0_43

	local var1_43 = var0_43 <= #arg0_43.assistantsData

	setActive(arg2_43:Find("lock"), not var1_43)

	local var2_43 = arg0_43.selectedShips[var0_43]

	setActive(arg2_43:Find("empty"), var1_43 and not var2_43)
	setActive(arg2_43:Find("ship"), var1_43 and var2_43)
	onButton(arg0_43, arg2_43, function()
		if not var1_43 or not arg0_43.isOperable then
			return
		end

		arg0_43:OpenPage(IslandShipSelectPage, {
			showBenefits = true,
			selectNum = #arg0_43.assistantsData,
			selectedIds = Clone(arg0_43.selectedShipIds),
			attrType = IslandShipAttr.MANAGE_KEY,
			confirmFunc = function(arg0_45)
				arg0_43:OnSelectedShipsDone(arg0_45)
			end,
			emptyInfoTitle = arg0_43.rest:getConfig("name")
		})
	end, SFX_PANEL)

	if var2_43 then
		local var3_43 = arg2_43:Find("ship")

		setText(var3_43:Find("name"), var2_43:GetName())

		local var4_43 = arg0_43:GetEffectiveManangeSkill(var2_43)

		setActive(var3_43:Find("skill"), var4_43 and var4_43:IsUnlock())
		setActive(var3_43:Find("skill_lock"), var4_43 and not var4_43:IsUnlock())

		local var5_43 = IslandShip.StaticGetPrefab(var2_43.id)

		GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var5_43, "", var3_43:Find("icon"))

		local var6_43 = var3_43:Find("skill")

		if var4_43 then
			if var4_43:IsUnlock() then
				setActive(var6_43:Find("effects"), true)
				setActive(var6_43:Find("invalid"), false)
				LoadImageSpriteAsync("island/islandskillicon/" .. var4_43:GetIcon(), var6_43:Find("skill_icon"))
				setText(var6_43:Find("skill_name"), var4_43:GetName())

				local var7_43 = IslandBuffHelper.GetAllShipManageBuffs(var2_43, arg0_43.restId)

				UIItemList.StaticAlign(var6_43:Find("effects"), var6_43:Find("effects/tpl"), #var7_43, function(arg0_46, arg1_46, arg2_46)
					if arg0_46 == UIItemList.EventUpdate then
						local var0_46 = var7_43[arg1_46 + 1]
						local var1_46 = var0_46:GetBuffType()
						local var2_46 = ""
						local var3_46 = ""

						if var1_46 == IslandBuffType.SHIP_MANAGE_SELL_PRICE then
							var2_46 = i18n("island_manage_saleroom")
							var3_46 = "+" .. var0_46:GetBuffEffect()[2] .. "%"
						elseif var1_46 == IslandBuffType.SHIP_MANAGE_SELL_NUM then
							var2_46 = i18n("island_manage_capacity")
							var3_46 = "+" .. var0_46:GetBuffEffect()[2]
						end

						setText(arg2_46:Find("name"), var2_46)
						setText(arg2_46:Find("effect"), var3_46)
					end
				end)
			else
				setText(var3_43:Find("skill_lock/Image/Text"), i18n("island_need_star_1", var2_43:GetSkillUnlockLevel()))
			end
		else
			local var8_43 = var2_43:GetSkill()

			setActive(var3_43:Find("skill"), true)
			LoadImageSpriteAsync("island/islandskillicon/" .. var8_43:GetIcon(), var6_43:Find("skill_icon"))
			setText(var6_43:Find("skill_name"), var8_43:GetName())
			setActive(var6_43:Find("effects"), false)
			setActive(var6_43:Find("invalid"), true)
		end
	end
end

function var0_0.FlushCards(arg0_47)
	arg0_47.displays = {}

	local var0_47 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_47, iter1_47 in ipairs(arg0_47.rest:getConfig("item_id")) do
		local var1_47 = var0_47:GetItemById(iter1_47[1])

		if var1_47 then
			table.insert(arg0_47.displays, var1_47)
		end
	end

	setActive(arg0_47.commoditiesEmptyTF, #arg0_47.displays <= 0)
	setActive(arg0_47.commoditiesTF, #arg0_47.displays > 0)
	arg0_47:CaclAttrsFactors()

	if #arg0_47.displays > 0 then
		arg0_47:SortDisplays()
	end
end

function var0_0.SortDisplays(arg0_48)
	table.sort(arg0_48.displays, CompareFuncs({
		function(arg0_49)
			return -arg0_48.subAttrFactorsDic[arg0_49.id]
		end,
		function(arg0_50)
			return -arg0_50:getConfig("order_price") * arg0_48.priceFactor
		end,
		function(arg0_51)
			return arg0_51.id
		end
	}))

	if arg0_48:isShowing() then
		arg0_48.scrollRect:SetTotalCount(#arg0_48.displays, -1)
	end
end

function var0_0.CaclAttrsFactors(arg0_52)
	arg0_52.subAttrFactorsDic = {}
	arg0_52.mainAttrFactorsDic = {}

	for iter0_52, iter1_52 in ipairs(arg0_52.displays) do
		local var0_52 = iter1_52:getConfig("sub_attribute")[1]

		arg0_52.subAttrFactorsDic[iter1_52.id] = var0_52 and var0_0.CaclShipAttrFactors(arg0_52.selectedShips, var0_52) or 0
		arg0_52.mainAttrFactorsDic[iter1_52.id] = var0_0.CaclShipAttrFactors(arg0_52.selectedShips, IslandShipAttr.MANAGE_KEY)
	end
end

function var0_0.GetSubAttrFactors(arg0_53, arg1_53)
	if arg0_53.subAttrFactorsDic[arg1_53] then
		return arg0_53.subAttrFactorsDic[arg1_53]
	end

	local var0_53 = var2_0[arg1_53].sub_attribute[1]

	arg0_53.subAttrFactorsDic[arg1_53] = var0_53 and var0_0.CaclShipAttrFactors(arg0_53.selectedShips, var0_53) or 0

	return arg0_53.subAttrFactorsDic[arg1_53]
end

function var0_0.GetMainAttrFactors(arg0_54, arg1_54)
	if arg0_54.mainAttrFactorsDic[arg1_54] then
		return arg0_54.mainAttrFactorsDic[arg1_54]
	end

	arg0_54.mainAttrFactorsDic[arg1_54] = var0_0.CaclShipAttrFactors(arg0_54.selectedShips, IslandShipAttr.MANAGE_KEY)

	return arg0_54.mainAttrFactorsDic[arg1_54]
end

function var0_0.GetAttrsFactorsRatio(arg0_55, arg1_55)
	local var0_55 = var2_0[arg1_55].sub_attribute[2] / 100
	local var1_55 = arg0_55:GetMainAttrFactors(arg1_55) + arg0_55:GetSubAttrFactors(arg1_55) * var0_55
	local var2_55 = #arg0_55.assistantsData * (arg0_55.maxAttrEffect + arg0_55.maxAttrEffect * var0_55)

	return var2_55 == 0 and 0 or var1_55 / var2_55
end

function var0_0.FlushShelfs(arg0_56)
	if not arg0_56.selectedDic then
		arg0_56.selectedDic = {}

		for iter0_56, iter1_56 in ipairs(arg0_56.rest:GetCommondities()) do
			arg0_56.selectedDic[iter1_56.id] = iter1_56.num
		end
	end

	arg0_56.shelfInfos = {}

	for iter2_56, iter3_56 in pairs(arg0_56.selectedDic) do
		table.insert(arg0_56.shelfInfos, {
			id = iter2_56,
			num = iter3_56
		})
	end

	arg0_56.shelfUIList:align(var0_0.MAX_SHELF_CNT)

	local var0_56 = arg0_56.shelfInfos and #arg0_56.shelfInfos > 0 and arg0_56.selectedShipIds and #arg0_56.selectedShipIds > 0

	setGray(arg0_56.openBtn, not var0_56, true)
	setButtonEnabled(arg0_56.openBtn, var0_56)
end

function var0_0.UpdateShelfItem(arg0_57, arg1_57, arg2_57)
	local var0_57 = arg1_57 + 1

	arg2_57.name = var0_57

	local var1_57 = var0_57 <= arg0_57.shelfCnt

	setActive(arg2_57:Find("lock"), not var1_57)

	local var2_57 = arg0_57.shelfInfos[var0_57]

	setActive(arg2_57:Find("empty"), var1_57 and not var2_57)
	setActive(arg2_57:Find("commodity"), var1_57 and var2_57)

	if var2_57 then
		local var3_57 = arg2_57:Find("commodity")

		LoadImageSpriteAsync("island/" .. var2_0[var2_57.id].icon, var3_57:Find("bg/icon"))

		local var4_57 = arg0_57.baseCapacity + arg0_57.extraCapacity

		if arg0_57.isOperable then
			setText(var3_57:Find("count/Text"), var2_57.num .. "/" .. (arg0_57.extraCapacity > 0 and setColorStr(var4_57, "#7BF59DFF") or var4_57))
		else
			setText(var3_57:Find("count/Text"), var2_57.num)
		end

		setActive(var3_57:Find("event"), arg0_57.eventEffects[var2_57.id])

		local var5_57 = arg0_57:GetAttrsFactorsRatio(var2_57.id)

		setFillAmount(var3_57:Find("bg/silder/bar"), var5_57)
		setActive(var3_57:Find("reduce"), arg0_57.isOperable)
		onButton(arg0_57, var3_57:Find("reduce"), function()
			if not arg0_57.isOperable then
				return
			end

			arg0_57:ReduceShelfCnt(var2_57.id, 1)
			arg0_57:FlushEstimate()
		end, SFX_PANEL)

		if var4_57 < var2_57.num then
			arg0_57:ReduceShelfCnt(var2_57.id, var2_57.num - var4_57)
			arg0_57:FlushEstimate()
		end
	end
end

function var0_0.ReduceShelfCnt(arg0_59, arg1_59, arg2_59)
	arg0_59.selectedDic[arg1_59] = arg0_59.selectedDic[arg1_59] - arg2_59

	if arg0_59.selectedDic[arg1_59] <= 0 then
		arg0_59.selectedDic[arg1_59] = nil
	end

	arg0_59:UpdateCardWithItemId(arg1_59)
	arg0_59:FlushShelfs()
end

function var0_0.FlushEstimate(arg0_60)
	local var0_60 = arg0_60.rest:GetStatus()

	if var0_60 == IslandRestaurant.STATUS.OPENING or var0_60 == IslandRestaurant.STATUS.CLOSE then
		local var1_60 = arg0_60.rest:GetEstimateData()

		setText(arg0_60.estimateCntTF, var1_60.cntMin .. "-" .. var1_60.cntMax)
		setText(arg0_60.estimateSalesTF, var1_60.salesMin .. "-" .. var1_60.salesMax)
	else
		local var2_60, var3_60 = arg0_60.rest:GetRandomSaleCntBound()

		arg0_60.totalMinCnt, arg0_60.totalMaxCnt, arg0_60.totalMinSales, arg0_60.totalMaxSales = 0, 0, 0, 0

		for iter0_60, iter1_60 in pairs(arg0_60.selectedDic) do
			local var4_60 = arg0_60:CaclBaseSaleCnt(iter0_60)
			local var5_60 = math.min(iter1_60, math.max(arg0_60.minSaleCnt, var4_60 + var2_60))
			local var6_60 = math.min(iter1_60, math.max(arg0_60.minSaleCnt, var4_60 + var3_60))

			arg0_60.totalMinSales = arg0_60.totalMinSales + arg0_60:CaclGroupPrice(iter0_60, var5_60)
			arg0_60.totalMaxSales = arg0_60.totalMaxSales + arg0_60:CaclGroupPrice(iter0_60, var6_60)
			arg0_60.totalMinCnt = arg0_60.totalMinCnt + var5_60
			arg0_60.totalMaxCnt = arg0_60.totalMaxCnt + var6_60
		end

		setText(arg0_60.estimateCntTF, arg0_60.totalMinCnt .. "-" .. arg0_60.totalMaxCnt)
		setText(arg0_60.estimateSalesTF, arg0_60.totalMinSales .. "-" .. arg0_60.totalMaxSales)
	end
end

function var0_0.CaclBaseSaleCnt(arg0_61, arg1_61)
	local var0_61 = var2_0[arg1_61].manage_influence / 100 + (arg0_61.eventEffects[arg1_61] and arg0_61.eventInfluence or 0)
	local var1_61 = arg0_61.argA + arg0_61:GetMainAttrFactors(arg1_61)
	local var2_61 = var2_0[arg1_61].sub_attribute[2] / 100
	local var3_61 = arg0_61.argB + arg0_61:GetSubAttrFactors(arg1_61) * var2_61
	local var4_61 = arg0_61.argC + arg0_61.rest:GetRankFactor()

	return math.floor(var0_61 * var1_61 * var3_61 * var4_61 / arg0_61.saleConst)
end

function var0_0.CaclGroupPrice(arg0_62, arg1_62, arg2_62)
	local var0_62 = var2_0[arg1_62].order_price * arg0_62.priceFactor
	local var1_62 = arg0_62.eventEffects[arg1_62] or 0

	return math.floor(var0_62 * arg2_62 * (1 + var1_62 + arg0_62.extraPricePer))
end

function var0_0.OnStatusExpired(arg0_63)
	arg0_63:FlushAssistants()
	arg0_63:FlushCards()
	arg0_63:FlushShelfs()
	arg0_63:FlushEstimate()
end

function var0_0.OnSelectedShipsDone(arg0_64, arg1_64)
	arg0_64.selectedShipIds = arg1_64

	arg0_64:FlushAssistants()
	arg0_64:FlushCards()
	arg0_64:FlushShelfs()
	arg0_64:FlushEstimate()
end

function var0_0.OnAutoSelect(arg0_65)
	arg0_65.selectedShipIds = arg0_65:GetAutoShipIds()

	arg0_65:FlushAssistants()
	arg0_65:FlushCards()

	arg0_65.selectedDic = {}

	for iter0_65 = 1, arg0_65.shelfCnt do
		local var0_65 = arg0_65.displays[iter0_65]

		if var0_65 then
			arg0_65.selectedDic[var0_65.id] = math.min(var0_65:GetCount(), arg0_65.baseCapacity + arg0_65.extraCapacity)
		end
	end

	arg0_65.scrollRect:SetTotalCount(#arg0_65.displays, -1)
	arg0_65:FlushShelfs()
	arg0_65:FlushEstimate()
end

function var0_0.GetAutoShipIds(arg0_66)
	local var0_66 = underscore.select(getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShips(), function(arg0_67)
		return arg0_67:GetState() == IslandShip.STATE_NORMAL
	end)

	table.sort(var0_66, CompareFuncs({
		function(arg0_68)
			return arg0_66:GetEffectiveManangeUnlockSkill(arg0_68) and 0 or 1
		end,
		function(arg0_69)
			local var0_69 = IslandBuffHelper.GetShipBuffsByType({
				arg0_69
			}, IslandBuffType.SHIP_MANAGE_SELL_PRICE)

			return -underscore.reduce(var0_69, 0, function(arg0_70, arg1_70)
				return arg0_70 + arg1_70:GetBuffEffect()[2]
			end)
		end,
		function(arg0_71)
			local var0_71 = IslandBuffHelper.GetShipBuffsByType({
				arg0_71
			}, IslandBuffType.SHIP_MANAGE_SELL_NUM)

			return -underscore.reduce(var0_71, 0, function(arg0_72, arg1_72)
				return arg0_72 + arg1_72:GetBuffEffect()[2]
			end)
		end,
		function(arg0_73)
			return arg0_73.id
		end
	}))

	local var1_66 = {}

	for iter0_66 = 1, #arg0_66.assistantsData do
		if var0_66[iter0_66] then
			table.insert(var1_66, var0_66[iter0_66].id)
		end
	end

	if #var1_66 == 0 and #arg0_66.assistantsData > 0 then
		table.insert(var1_66, IslandCharacterAgency.NPC_CONFIG_ID)
	end

	return var1_66
end

function var0_0.FlushBtns(arg0_74)
	local var0_74 = arg0_74.rest:GetStatus()

	eachChild(arg0_74.btnsTF, function(arg0_75)
		setActive(arg0_75, arg0_75.name == var0_74)
	end)

	if var0_74 == IslandRestaurant.STATUS.OPENING then
		if not arg0_74.timer then
			arg0_74:StartTimer()
			arg0_74:UpdateTime()
		end
	else
		arg0_74:StopTimer()
	end

	setActive(arg0_74.buffInfoBtn, arg0_74.isOperable)
end

function var0_0.UpdateTime(arg0_76)
	local var0_76 = pg.TimeMgr.GetInstance()
	local var1_76 = arg0_76.rest:GetEndTime() - var0_76:GetServerTime()

	setText(arg0_76.btnsTF:Find("opening/time"), var0_76:DescCDTime(var1_76))

	if var1_76 <= 0 then
		arg0_76:FlushBtns()
	end
end

function var0_0.StartTimer(arg0_77)
	arg0_77.timer = Timer.New(function()
		arg0_77:UpdateTime()
	end, 1, -1)

	arg0_77.timer:Start()
end

function var0_0.StopTimer(arg0_79)
	if arg0_79.timer ~= nil then
		arg0_79.timer:Stop()

		arg0_79.timer = nil
	end
end

function var0_0.OnHide(arg0_80)
	arg0_80:StopTimer()

	if arg0_80.statusCheckTimer then
		arg0_80.statusCheckTimer:Stop()

		arg0_80.statusCheckTimer = nil
	end

	arg0_80:UnBlurPanel()
end

function var0_0.OnDisable(arg0_81)
	arg0_81:OnHide()
end

function var0_0.OnDestroy(arg0_82)
	ClearLScrollrect(arg0_82.scrollRect)
	arg0_82:OnHide()
end

function var0_0.CaclShipAttrFactors(arg0_83, arg1_83)
	local var0_83 = 0

	for iter0_83, iter1_83 in ipairs(arg0_83) do
		local var1_83 = iter1_83:GetAttrGrade(IslandShipAttr.GetAtrrName(arg1_83))

		var0_83 = var0_83 + pg.island_chara_att[var1_83].manage_effect / 10000
	end

	return var0_83
end

return var0_0
