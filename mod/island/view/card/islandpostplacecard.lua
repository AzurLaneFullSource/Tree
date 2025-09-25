local var0_0 = class("IslandPostPlaceCard")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.nameTF = arg0_1._tf:Find("name")
	arg0_1.lockTF = arg0_1._tf:Find("lock")
	arg0_1.itemUIList = UIItemList.New(arg0_1._tf:Find("items"), arg0_1._tf:Find("items/tpl"))

	arg0_1.itemUIList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg0_1:UpdateSlotItem(arg0_1.slotIds[arg1_2 + 1], arg2_2)
		end
	end)

	arg0_1.shipUIList = UIItemList.New(arg0_1._tf:Find("ships"), arg0_1._tf:Find("ships/tpl"))

	arg0_1.shipUIList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg0_1:UpdateSlotShip(arg0_1.slotIds[arg1_3 + 1], arg2_3)
		end
	end)

	arg0_1.timers = {}
end

function var0_0.Update(arg0_4, arg1_4, arg2_4)
	arg0_4:RemoveAllTimer()

	arg0_4.id = arg1_4
	arg0_4.onClickCommission = arg2_4

	local var0_4 = pg.island_production_place[arg0_4.id]

	setText(arg0_4.nameTF, var0_4.name)

	arg0_4.buildingData = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg0_4.id)

	setActive(arg0_4.lockTF, not arg0_4.buildingData)

	local var1_4 = var0_4.commission_slot

	arg0_4.slotIds = {}
	arg0_4.slotId2CommissionId = {}

	for iter0_4, iter1_4 in ipairs(var1_4) do
		local var2_4 = pg.island_production_commission[iter1_4].slot

		table.insert(arg0_4.slotIds, pg.island_production_commission[iter1_4].slot)

		arg0_4.slotId2CommissionId[var2_4] = iter1_4
	end

	arg0_4.itemUIList:align(#arg0_4.slotIds)
	arg0_4.shipUIList:align(#arg0_4.slotIds)
end

function var0_0.UpdateSlot(arg0_5, arg1_5)
	local var0_5 = tostring(arg1_5)

	arg0_5:UpdateSlotItem(arg1_5, arg0_5.itemUIList.container:Find(var0_5))
	arg0_5:UpdateSlotShip(arg1_5, arg0_5.shipUIList.container:Find(var0_5))
end

function var0_0.UpdateSlotItem(arg0_6, arg1_6, arg2_6)
	arg2_6.name = arg1_6

	local var0_6 = arg0_6.buildingData and arg0_6.buildingData:GetDelegationSlotData(arg1_6)

	setActive(arg2_6:Find("lock"), not var0_6)
	setActive(arg2_6:Find("unlock"), var0_6)
	arg0_6:RemoveTimer(arg1_6)

	if var0_6 then
		local var1_6 = var0_6:GetFormulaId()

		setActive(arg2_6:Find("unlock/add"), not var1_6)
		setActive(arg2_6:Find("unlock/formula"), var1_6)

		if var1_6 then
			local var2_6 = pg.island_formula[var1_6].commission_product[1][1]
			local var3_6 = Drop.New({
				count = 0,
				type = DROP_TYPE_ISLAND_ITEM,
				id = var2_6
			}):getConfigTable().icon

			LoadImageSpriteAsync("island/" .. var3_6, arg2_6:Find("unlock/formula/icon"))
		end

		local var4_6 = var0_6:GetSlotRoleData()

		setActive(arg2_6:Find("unlock/formula/get"), not var4_6)

		if var4_6 then
			arg0_6:AddTimer(arg2_6, var0_6)
		else
			arg2_6:Find("unlock/formula/fill"):GetComponent(typeof(Image)).fillAmount = 1
		end

		onButton(arg0_6, arg2_6, function()
			existCall(arg0_6.onClickCommission, arg0_6.slotId2CommissionId[arg1_6])
		end, SFX_PANEL)
	else
		removeAllOnButton(arg2_6)
	end
end

function var0_0.UpdateSlotShip(arg0_8, arg1_8, arg2_8)
	arg2_8.name = arg1_8

	local var0_8 = arg0_8.buildingData and arg0_8.buildingData:GetDelegationSlotData(arg1_8)

	setActive(arg2_8:Find("lock"), not var0_8)
	setActive(arg2_8:Find("unlock"), var0_8)

	if var0_8 then
		local var1_8 = var0_8:GetSlotRoleData()

		setActive(arg2_8:Find("unlock/add"), not var1_8)
		setActive(arg2_8:Find("unlock/ship"), var1_8)

		if var1_8 then
			local var2_8 = IslandShip.StaticGetPrefab(var1_8.ship_id)

			LoadImageSpriteAsync("squareicon/" .. var2_8, arg2_8:Find("unlock/ship/mask/icon"))
		end

		onButton(arg0_8, arg2_8, function()
			existCall(arg0_8.onClickCommission, arg0_8.slotId2CommissionId[arg1_8])
		end, SFX_PANEL)
	else
		removeAllOnButton(arg2_8)
	end
end

function var0_0.AddTimer(arg0_10, arg1_10, arg2_10)
	arg0_10:RemoveTimer(arg2_10.id)

	local var0_10 = arg1_10:Find("unlock/formula/fill"):GetComponent(typeof(Image))

	local function var1_10()
		arg0_10:RemoveTimer(arg2_10.id)
		setActive(arg1_10:Find("unlock/formula/get"), true)

		var0_10.fillAmount = 1
	end

	local var2_10 = Timer.New(function()
		local var0_12 = arg2_10:GetSlotRoleData()

		if not var0_12 then
			var1_10()
		else
			local var1_12 = var0_12:InCurrentTime()
			local var2_12 = pg.TimeMgr.GetInstance():GetServerTime() - var0_12:InCurrentTimeStart(var1_12)

			var0_10.fillAmount = var2_12 / var0_12:CurrentTimeNeed(var1_12)
		end
	end, 1, -1)

	var2_10:Start()
	var2_10.func()

	arg0_10.timers[arg2_10.id] = var2_10
end

function var0_0.RemoveTimer(arg0_13, arg1_13)
	if arg0_13.timers[arg1_13] then
		arg0_13.timers[arg1_13]:Stop()

		arg0_13.timers[arg1_13] = nil
	end
end

function var0_0.RemoveAllTimer(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.timers) do
		iter1_14:Stop()

		iter1_14 = nil
	end

	arg0_14.timers = {}
end

function var0_0.Dispose(arg0_15)
	arg0_15:RemoveAllTimer()
	pg.DelegateInfo.Dispose(arg0_15)
end

return var0_0
