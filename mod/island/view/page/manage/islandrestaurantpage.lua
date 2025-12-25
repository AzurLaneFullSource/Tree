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
	setText(arg0_2.buffInfoPanel:Find("tips"), i18n("island_manage_buff_tip"))

	arg0_2.btnsTF = var0_2:Find("btns")
	arg0_2.openBtn = arg0_2.btnsTF:Find("prepare/open"), setText(arg0_2.btnsTF:Find("prepare/auto/Text"), i18n("island_manage_auto_work"))

	setText(arg0_2.btnsTF:Find("prepare/open/Text"), i18n("island_manage_start_work"))
	setText(arg0_2.btnsTF:Find("opening/Text"), i18n("island_manage_working"))
	setText(arg0_2.btnsTF:Find("close/Text"), i18n("island_manage_result"))
	setText(arg0_2.btnsTF:Find("end/Text"), i18n("island_manage_end_daily_work"))

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
		setText(arg0_32.eventDescTF, var0_32.desc)
	end
end

function var0_0.FlushAssistants(arg0_33)
	if not arg0_33.selectedShipIds then
		local var0_33 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

		arg0_33.selectedShipIds = {}

		for iter0_33, iter1_33 in ipairs(arg0_33.assistantsData) do
			local var1_33 = iter1_33.shipId

			if var1_33 ~= 0 then
				table.insert(arg0_33.selectedShipIds, var1_33)
			end
		end
	end

	arg0_33.selectedShips = {}

	local var2_33 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	for iter2_33, iter3_33 in ipairs(arg0_33.selectedShipIds) do
		table.insert(arg0_33.selectedShips, var2_33:GetShipById(iter3_33))
	end

	arg0_33.shipUIList:align(var0_0.MAX_ASSISTANT_CNT)

	arg0_33.extraPricePer = 0
	arg0_33.extraCapacity = 0
	arg0_33.buffInfos = {}

	local var3_33 = IslandBuffHelper.GetManageSellPriceBuffs(arg0_33.selectedShips, arg0_33.restId)

	for iter4_33, iter5_33 in ipairs(var3_33) do
		local var4_33 = iter5_33:GetBuffEffect()[2]

		table.insert(arg0_33.buffInfos, {
			name = i18n("island_manage_saleroom"),
			effect = "+" .. var4_33 .. "%"
		})

		arg0_33.extraPricePer = arg0_33.extraPricePer + var4_33 / 100
	end

	local var5_33 = IslandBuffHelper.GetManageSellNumBuffs(arg0_33.selectedShips, arg0_33.restId)

	for iter6_33, iter7_33 in ipairs(var5_33) do
		local var6_33 = iter7_33:GetBuffEffect()[2]

		table.insert(arg0_33.buffInfos, {
			name = i18n("island_manage_capacity"),
			effect = "+" .. var6_33
		})

		arg0_33.extraCapacity = arg0_33.extraCapacity + var6_33
	end

	if arg0_33.statusCheckTimer then
		arg0_33.statusCheckTimer:Stop()
	end

	if arg0_33.isOperable then
		arg0_33.shipStatus = IslandBuffHelper.GetManageStatus(arg0_33.selectedShips, arg0_33.restId)

		if #arg0_33.shipStatus > 0 then
			arg0_33.statusCheckTimer = Timer.New(function()
				if underscore.reduce(arg0_33.shipStatus, 0, function(arg0_35, arg1_35)
					return arg0_35 + (arg1_35:IsExpiration() and 1 or 0)
				end) > 0 then
					arg0_33:OnStatusExpired()
				end
			end, 1, -1)

			arg0_33.statusCheckTimer:Start()
		end
	end

	setActive(arg0_33.extraCapacityTF, arg0_33.isOperable and arg0_33.extraCapacity > 0)
	setText(arg0_33.extraCapacityEffectTF, "+" .. arg0_33.extraCapacity)
	arg0_33.buffInfoUIList:align(#arg0_33.buffInfos)
	setActive(arg0_33.buffInfoEmptyTF, #arg0_33.buffInfos == 0)

	local var7_33 = arg0_33.shelfInfos and #arg0_33.shelfInfos > 0 and arg0_33.selectedShipIds and #arg0_33.selectedShipIds > 0

	setGray(arg0_33.openBtn, not var7_33, true)
	setButtonEnabled(arg0_33.openBtn, var7_33)
end

function var0_0.GetEffectiveManangeSkill(arg0_36, arg1_36)
	local var0_36 = arg1_36:GetSkill()

	return var0_36:IsEffectiveInRest(arg0_36.restId) and var0_36 or nil
end

function var0_0.GetEffectiveManangeUnlockSkill(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetEffectiveManangeSkill(arg1_37)

	return var0_37 and var0_37:IsUnlock() and var0_37 or nil
end

function var0_0.UpdateShipItem(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg1_38 + 1

	arg2_38.name = var0_38

	local var1_38 = var0_38 <= #arg0_38.assistantsData

	setActive(arg2_38:Find("lock"), not var1_38)

	local var2_38 = arg0_38.selectedShips[var0_38]

	setActive(arg2_38:Find("empty"), var1_38 and not var2_38)
	setActive(arg2_38:Find("ship"), var1_38 and var2_38)
	onButton(arg0_38, arg2_38, function()
		if not var1_38 or not arg0_38.isOperable then
			return
		end

		arg0_38:OpenPage(IslandShipSelectPage, {
			showBenefits = true,
			selectNum = #arg0_38.assistantsData,
			selectedIds = Clone(arg0_38.selectedShipIds),
			attrType = IslandShipAttr.MANAGE_KEY,
			confirmFunc = function(arg0_40)
				arg0_38:OnSelectedShipsDone(arg0_40)
			end,
			emptyInfoTitle = arg0_38.rest:getConfig("name")
		})
	end, SFX_PANEL)

	if var2_38 then
		local var3_38 = arg2_38:Find("ship")

		setText(var3_38:Find("name"), var2_38:GetName())

		local var4_38 = arg0_38:GetEffectiveManangeSkill(var2_38)

		setActive(var3_38:Find("skill"), var4_38 and var4_38:IsUnlock())
		setActive(var3_38:Find("skill_lock"), var4_38 and not var4_38:IsUnlock())

		local var5_38 = IslandShip.StaticGetPrefab(var2_38.id)

		GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var5_38, "", var3_38:Find("icon"))

		local var6_38 = var3_38:Find("skill")

		if var4_38 then
			if var4_38:IsUnlock() then
				setActive(var6_38:Find("effects"), true)
				setActive(var6_38:Find("invalid"), false)
				LoadImageSpriteAsync("island/islandskillicon/" .. var4_38:GetIcon(), var6_38:Find("skill_icon"))
				setText(var6_38:Find("skill_name"), var4_38:GetName())

				local var7_38 = IslandBuffHelper.GetAllShipManageBuffs(var2_38, arg0_38.restId)

				UIItemList.StaticAlign(var6_38:Find("effects"), var6_38:Find("effects/tpl"), #var7_38, function(arg0_41, arg1_41, arg2_41)
					if arg0_41 == UIItemList.EventUpdate then
						local var0_41 = var7_38[arg1_41 + 1]
						local var1_41 = var0_41:GetBuffType()
						local var2_41 = ""
						local var3_41 = ""

						if var1_41 == IslandBuffType.SHIP_MANAGE_SELL_PRICE then
							var2_41 = i18n("island_manage_saleroom")
							var3_41 = "+" .. var0_41:GetBuffEffect()[2] .. "%"
						elseif var1_41 == IslandBuffType.SHIP_MANAGE_SELL_NUM then
							var2_41 = i18n("island_manage_capacity")
							var3_41 = "+" .. var0_41:GetBuffEffect()[2]
						end

						setText(arg2_41:Find("name"), var2_41)
						setText(arg2_41:Find("effect"), var3_41)
					end
				end)
			else
				setText(var3_38:Find("skill_lock/Image/Text"), i18n("island_need_star_1", var2_38:GetSkillUnlockLevel()))
			end
		else
			local var8_38 = var2_38:GetSkill()

			setActive(var3_38:Find("skill"), true)
			LoadImageSpriteAsync("island/islandskillicon/" .. var8_38:GetIcon(), var6_38:Find("skill_icon"))
			setText(var6_38:Find("skill_name"), var8_38:GetName())
			setActive(var6_38:Find("effects"), false)
			setActive(var6_38:Find("invalid"), true)
		end
	end
end

function var0_0.FlushCards(arg0_42)
	arg0_42.displays = {}

	local var0_42 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	for iter0_42, iter1_42 in ipairs(arg0_42.rest:getConfig("item_id")) do
		local var1_42 = var0_42:GetItemById(iter1_42[1])

		if var1_42 then
			table.insert(arg0_42.displays, var1_42)
		end
	end

	setActive(arg0_42.commoditiesEmptyTF, #arg0_42.displays <= 0)
	setActive(arg0_42.commoditiesTF, #arg0_42.displays > 0)
	arg0_42:CaclAttrsFactors()

	if #arg0_42.displays > 0 then
		arg0_42:SortDisplays()
	end
end

function var0_0.SortDisplays(arg0_43)
	table.sort(arg0_43.displays, CompareFuncs({
		function(arg0_44)
			return -arg0_43.subAttrFactorsDic[arg0_44.id]
		end,
		function(arg0_45)
			return -arg0_45:getConfig("order_price") * arg0_43.priceFactor
		end,
		function(arg0_46)
			return arg0_46.id
		end
	}))

	if arg0_43:isShowing() then
		arg0_43.scrollRect:SetTotalCount(#arg0_43.displays, -1)
	end
end

function var0_0.CaclAttrsFactors(arg0_47)
	arg0_47.subAttrFactorsDic = {}
	arg0_47.mainAttrFactorsDic = {}

	for iter0_47, iter1_47 in ipairs(arg0_47.displays) do
		local var0_47 = iter1_47:getConfig("sub_attribute")[1]

		arg0_47.subAttrFactorsDic[iter1_47.id] = var0_47 and var0_0.CaclShipAttrFactors(arg0_47.selectedShips, var0_47) or 0
		arg0_47.mainAttrFactorsDic[iter1_47.id] = var0_0.CaclShipAttrFactors(arg0_47.selectedShips, IslandShipAttr.MANAGE_KEY)
	end
end

function var0_0.GetSubAttrFactors(arg0_48, arg1_48)
	if arg0_48.subAttrFactorsDic[arg1_48] then
		return arg0_48.subAttrFactorsDic[arg1_48]
	end

	local var0_48 = var2_0[arg1_48].sub_attribute[1]

	arg0_48.subAttrFactorsDic[arg1_48] = var0_48 and var0_0.CaclShipAttrFactors(arg0_48.selectedShips, var0_48) or 0

	return arg0_48.subAttrFactorsDic[arg1_48]
end

function var0_0.GetMainAttrFactors(arg0_49, arg1_49)
	if arg0_49.mainAttrFactorsDic[arg1_49] then
		return arg0_49.mainAttrFactorsDic[arg1_49]
	end

	arg0_49.mainAttrFactorsDic[arg1_49] = var0_0.CaclShipAttrFactors(arg0_49.selectedShips, IslandShipAttr.MANAGE_KEY)

	return arg0_49.mainAttrFactorsDic[arg1_49]
end

function var0_0.GetAttrsFactorsRatio(arg0_50, arg1_50)
	local var0_50 = var2_0[arg1_50].sub_attribute[2] / 100
	local var1_50 = arg0_50:GetMainAttrFactors(arg1_50) + arg0_50:GetSubAttrFactors(arg1_50) * var0_50
	local var2_50 = #arg0_50.assistantsData * (arg0_50.maxAttrEffect + arg0_50.maxAttrEffect * var0_50)

	return var2_50 == 0 and 0 or var1_50 / var2_50
end

function var0_0.FlushShelfs(arg0_51)
	if not arg0_51.selectedDic then
		arg0_51.selectedDic = {}

		for iter0_51, iter1_51 in ipairs(arg0_51.rest:GetCommondities()) do
			arg0_51.selectedDic[iter1_51.id] = iter1_51.num
		end
	end

	arg0_51.shelfInfos = {}

	for iter2_51, iter3_51 in pairs(arg0_51.selectedDic) do
		table.insert(arg0_51.shelfInfos, {
			id = iter2_51,
			num = iter3_51
		})
	end

	arg0_51.shelfUIList:align(var0_0.MAX_SHELF_CNT)

	local var0_51 = arg0_51.shelfInfos and #arg0_51.shelfInfos > 0 and arg0_51.selectedShipIds and #arg0_51.selectedShipIds > 0

	setGray(arg0_51.openBtn, not var0_51, true)
	setButtonEnabled(arg0_51.openBtn, var0_51)
end

function var0_0.UpdateShelfItem(arg0_52, arg1_52, arg2_52)
	local var0_52 = arg1_52 + 1

	arg2_52.name = var0_52

	local var1_52 = var0_52 <= arg0_52.shelfCnt

	setActive(arg2_52:Find("lock"), not var1_52)

	local var2_52 = arg0_52.shelfInfos[var0_52]

	setActive(arg2_52:Find("empty"), var1_52 and not var2_52)
	setActive(arg2_52:Find("commodity"), var1_52 and var2_52)

	if var2_52 then
		local var3_52 = arg2_52:Find("commodity")

		LoadImageSpriteAsync("island/" .. var2_0[var2_52.id].icon, var3_52:Find("bg/icon"))

		local var4_52 = arg0_52.baseCapacity + arg0_52.extraCapacity

		if arg0_52.isOperable then
			setText(var3_52:Find("count/Text"), var2_52.num .. "/" .. (arg0_52.extraCapacity > 0 and setColorStr(var4_52, "#7BF59DFF") or var4_52))
		else
			setText(var3_52:Find("count/Text"), var2_52.num)
		end

		setActive(var3_52:Find("event"), arg0_52.eventEffects[var2_52.id])

		local var5_52 = arg0_52:GetAttrsFactorsRatio(var2_52.id)

		setFillAmount(var3_52:Find("bg/silder/bar"), var5_52)
		setActive(var3_52:Find("reduce"), arg0_52.isOperable)
		onButton(arg0_52, var3_52:Find("reduce"), function()
			if not arg0_52.isOperable then
				return
			end

			arg0_52:ReduceShelfCnt(var2_52.id, 1)
			arg0_52:FlushEstimate()
		end, SFX_PANEL)

		if var4_52 < var2_52.num then
			arg0_52:ReduceShelfCnt(var2_52.id, var2_52.num - var4_52)
			arg0_52:FlushEstimate()
		end
	end
end

function var0_0.ReduceShelfCnt(arg0_54, arg1_54, arg2_54)
	arg0_54.selectedDic[arg1_54] = arg0_54.selectedDic[arg1_54] - arg2_54

	if arg0_54.selectedDic[arg1_54] <= 0 then
		arg0_54.selectedDic[arg1_54] = nil
	end

	arg0_54:UpdateCardWithItemId(arg1_54)
	arg0_54:FlushShelfs()
end

function var0_0.FlushEstimate(arg0_55)
	local var0_55 = arg0_55.rest:GetStatus()

	if var0_55 == IslandRestaurant.STATUS.OPENING or var0_55 == IslandRestaurant.STATUS.CLOSE then
		local var1_55 = arg0_55.rest:GetEstimateData()

		setText(arg0_55.estimateCntTF, var1_55.cntMin .. "-" .. var1_55.cntMax)
		setText(arg0_55.estimateSalesTF, var1_55.salesMin .. "-" .. var1_55.salesMax)
	else
		local var2_55, var3_55 = arg0_55.rest:GetRandomSaleCntBound()

		arg0_55.totalMinCnt, arg0_55.totalMaxCnt, arg0_55.totalMinSales, arg0_55.totalMaxSales = 0, 0, 0, 0

		for iter0_55, iter1_55 in pairs(arg0_55.selectedDic) do
			local var4_55 = arg0_55:CaclBaseSaleCnt(iter0_55)
			local var5_55 = math.min(iter1_55, math.max(arg0_55.minSaleCnt, var4_55 + var2_55))
			local var6_55 = math.min(iter1_55, math.max(arg0_55.minSaleCnt, var4_55 + var3_55))

			arg0_55.totalMinSales = arg0_55.totalMinSales + arg0_55:CaclGroupPrice(iter0_55, var5_55)
			arg0_55.totalMaxSales = arg0_55.totalMaxSales + arg0_55:CaclGroupPrice(iter0_55, var6_55)
			arg0_55.totalMinCnt = arg0_55.totalMinCnt + var5_55
			arg0_55.totalMaxCnt = arg0_55.totalMaxCnt + var6_55
		end

		setText(arg0_55.estimateCntTF, arg0_55.totalMinCnt .. "-" .. arg0_55.totalMaxCnt)
		setText(arg0_55.estimateSalesTF, arg0_55.totalMinSales .. "-" .. arg0_55.totalMaxSales)
	end
end

function var0_0.CaclBaseSaleCnt(arg0_56, arg1_56)
	local var0_56 = var2_0[arg1_56].manage_influence / 100 + (arg0_56.eventEffects[arg1_56] and arg0_56.eventInfluence or 0)
	local var1_56 = arg0_56.argA + arg0_56:GetMainAttrFactors(arg1_56)
	local var2_56 = var2_0[arg1_56].sub_attribute[2] / 100
	local var3_56 = arg0_56.argB + arg0_56:GetSubAttrFactors(arg1_56) * var2_56
	local var4_56 = arg0_56.argC + arg0_56.rest:GetRankFactor()

	return math.floor(var0_56 * var1_56 * var3_56 * var4_56 / arg0_56.saleConst)
end

function var0_0.CaclGroupPrice(arg0_57, arg1_57, arg2_57)
	local var0_57 = var2_0[arg1_57].order_price * arg0_57.priceFactor
	local var1_57 = arg0_57.eventEffects[arg1_57] or 0

	return math.floor(var0_57 * arg2_57 * (1 + var1_57 + arg0_57.extraPricePer))
end

function var0_0.OnStatusExpired(arg0_58)
	arg0_58:FlushAssistants()
	arg0_58:FlushCards()
	arg0_58:FlushShelfs()
	arg0_58:FlushEstimate()
end

function var0_0.OnSelectedShipsDone(arg0_59, arg1_59)
	arg0_59.selectedShipIds = arg1_59

	arg0_59:FlushAssistants()
	arg0_59:FlushCards()
	arg0_59:FlushShelfs()
	arg0_59:FlushEstimate()
end

function var0_0.OnAutoSelect(arg0_60)
	arg0_60.selectedShipIds = arg0_60:GetAutoShipIds()

	arg0_60:FlushAssistants()
	arg0_60:FlushCards()

	arg0_60.selectedDic = {}

	for iter0_60 = 1, arg0_60.shelfCnt do
		local var0_60 = arg0_60.displays[iter0_60]

		if var0_60 then
			arg0_60.selectedDic[var0_60.id] = math.min(var0_60:GetCount(), arg0_60.baseCapacity + arg0_60.extraCapacity)
		end
	end

	arg0_60.scrollRect:SetTotalCount(#arg0_60.displays, -1)
	arg0_60:FlushShelfs()
	arg0_60:FlushEstimate()
end

function var0_0.GetAutoShipIds(arg0_61)
	local var0_61 = underscore.select(getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShips(), function(arg0_62)
		return arg0_62:GetState() == IslandShip.STATE_NORMAL
	end)

	table.sort(var0_61, CompareFuncs({
		function(arg0_63)
			return arg0_61:GetEffectiveManangeUnlockSkill(arg0_63) and 0 or 1
		end,
		function(arg0_64)
			local var0_64 = IslandBuffHelper.GetShipBuffsByType({
				arg0_64
			}, IslandBuffType.SHIP_MANAGE_SELL_PRICE)

			return -underscore.reduce(var0_64, 0, function(arg0_65, arg1_65)
				return arg0_65 + arg1_65:GetBuffEffect()[2]
			end)
		end,
		function(arg0_66)
			local var0_66 = IslandBuffHelper.GetShipBuffsByType({
				arg0_66
			}, IslandBuffType.SHIP_MANAGE_SELL_NUM)

			return -underscore.reduce(var0_66, 0, function(arg0_67, arg1_67)
				return arg0_67 + arg1_67:GetBuffEffect()[2]
			end)
		end,
		function(arg0_68)
			return arg0_68.id
		end
	}))

	local var1_61 = {}

	for iter0_61 = 1, #arg0_61.assistantsData do
		if var0_61[iter0_61] then
			table.insert(var1_61, var0_61[iter0_61].id)
		end
	end

	if #var1_61 == 0 and #arg0_61.assistantsData > 0 then
		table.insert(var1_61, IslandCharacterAgency.NPC_CONFIG_ID)
	end

	return var1_61
end

function var0_0.FlushBtns(arg0_69)
	local var0_69 = arg0_69.rest:GetStatus()

	eachChild(arg0_69.btnsTF, function(arg0_70)
		setActive(arg0_70, arg0_70.name == var0_69)
	end)

	if var0_69 == IslandRestaurant.STATUS.OPENING then
		if not arg0_69.timer then
			arg0_69:StartTimer()
			arg0_69:UpdateTime()
		end
	else
		arg0_69:StopTimer()
	end

	setActive(arg0_69.buffInfoBtn, arg0_69.isOperable)
end

function var0_0.UpdateTime(arg0_71)
	local var0_71 = pg.TimeMgr.GetInstance()
	local var1_71 = arg0_71.rest:GetEndTime() - var0_71:GetServerTime()

	setText(arg0_71.btnsTF:Find("opening/time"), var0_71:DescCDTime(var1_71))

	if var1_71 <= 0 then
		arg0_71:FlushBtns()
	end
end

function var0_0.StartTimer(arg0_72)
	arg0_72.timer = Timer.New(function()
		arg0_72:UpdateTime()
	end, 1, -1)

	arg0_72.timer:Start()
end

function var0_0.StopTimer(arg0_74)
	if arg0_74.timer ~= nil then
		arg0_74.timer:Stop()

		arg0_74.timer = nil
	end
end

function var0_0.OnHide(arg0_75)
	arg0_75:StopTimer()

	if arg0_75.statusCheckTimer then
		arg0_75.statusCheckTimer:Stop()

		arg0_75.statusCheckTimer = nil
	end

	arg0_75:UnBlurPanel()
end

function var0_0.OnDisable(arg0_76)
	arg0_76:OnHide()
end

function var0_0.OnDestroy(arg0_77)
	ClearLScrollrect(arg0_77.scrollRect)
	arg0_77:OnHide()
end

function var0_0.CaclShipAttrFactors(arg0_78, arg1_78)
	local var0_78 = 0

	for iter0_78, iter1_78 in ipairs(arg0_78) do
		local var1_78 = iter1_78:GetAttrGrade(IslandShipAttr.GetAtrrName(arg1_78))

		var0_78 = var0_78 + pg.island_chara_att[var1_78].manage_effect / 10000
	end

	return var0_78
end

return var0_0
