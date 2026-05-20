local var0_0 = class("MallActivity", import("model.vo.Activity"))

var0_0.POINT_TYPE = {
	MAIN_STORY = 2,
	BRANCH_STORY = 3,
	SITE = 1,
	INTERACT_STORY = 4
}
var0_0.MAX_GOLD = 999999999

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	local var0_1 = arg1_1.mall

	arg0_1.gold = var0_1.gold
	arg0_1.round = var0_1.round
	arg0_1.triggeredPointIds = var0_1.story_list
	arg0_1.levelData = MallLevel.New(var0_1.level)
	arg0_1.orderData = MallOrder.New(var0_1.order)
	arg0_1.lastBalance = var0_1.last_round.balance
	arg0_1.lastIncome = 0

	local var1_1 = var0_1.last_round.floor_income
	local var2_1 = {}
	local var3_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1.floor_list) do
		var2_1[iter1_1.id] = iter1_1
		var3_1[iter1_1.id] = var1_1[iter1_1.id] or 0
		arg0_1.lastIncome = arg0_1.lastIncome + var3_1[iter1_1.id]
	end

	arg0_1.floorData = {}

	for iter2_1, iter3_1 in ipairs(pg.activity_mall_template.all) do
		local var4_1 = var2_1[iter3_1]
		local var5_1 = MallFloor.New(var4_1 or {
			id = iter3_1
		}, var4_1 ~= nil)

		var5_1:CheckUnlock(arg0_1.levelData.level)
		var5_1:SetLastIncome(var3_1[iter3_1])

		arg0_1.floorData[iter3_1] = var5_1
	end

	arg0_1.lastFloorStaffList = arg0_1:GetFloorStaffList()
	arg0_1.staffData = {}

	for iter4_1, iter5_1 in ipairs(var0_1.employee_list) do
		arg0_1.staffData[iter5_1.id] = MallStaff.New(iter5_1)
	end

	arg0_1:InitStaffStatus()
end

function var0_0.GetGold(arg0_2)
	return arg0_2.gold
end

function var0_0.AddGold(arg0_3, arg1_3)
	arg0_3.gold = arg0_3.gold + arg1_3
	arg0_3.gold = math.min(arg0_3.gold, var0_0.MAX_GOLD)
end

function var0_0.ReduceGold(arg0_4, arg1_4)
	arg0_4.gold = arg0_4.gold - arg1_4
end

function var0_0.IsGoldDrop(arg0_5, arg1_5)
	return arg1_5.type == DROP_TYPE_VITEM and arg1_5.id == arg0_5:getConfig("config_data")[1]
end

function var0_0.GetRound(arg0_6)
	return arg0_6.round
end

function var0_0.GetLastIncome(arg0_7)
	return arg0_7.lastIncome
end

function var0_0.GetLastBalance(arg0_8)
	return arg0_8.lastBalance
end

function var0_0.NextRound(arg0_9, arg1_9)
	arg0_9.round = arg0_9.round + 1

	local var0_9 = 0

	for iter0_9, iter1_9 in ipairs(arg1_9) do
		if iter0_9 ~= 1 then
			local var1_9 = iter0_9 - 1

			arg0_9.floorData[var1_9]:SetLastIncome(iter1_9)

			var0_9 = var0_9 + iter1_9
		end
	end

	arg0_9.lastIncome = var0_9
	arg0_9.lastBalance = math.min(arg0_9.gold + var0_9, var0_0.MAX_GOLD)
end

function var0_0.GetLevelData(arg0_10)
	return arg0_10.levelData
end

function var0_0.OnUpgradeDone(arg0_11, arg1_11)
	arg0_11.levelData:OnUpgradeDone(arg1_11)

	for iter0_11, iter1_11 in pairs(arg0_11.floorData) do
		iter1_11:CheckUnlock(arg1_11)
	end

	arg0_11.lastFloorStaffList = arg0_11:GetFloorStaffList()
end

function var0_0.GetTriggeredPointIds(arg0_12)
	return arg0_12.triggeredPointIds
end

function var0_0.OnTriggerPointDone(arg0_13, arg1_13)
	table.insert(arg0_13.triggeredPointIds, arg1_13)
end

function var0_0.GetStaffData(arg0_14)
	return arg0_14.staffData
end

function var0_0.GetStaffList(arg0_15)
	local var0_15 = underscore.values(arg0_15.staffData)

	table.sort(var0_15, CompareFuncs({
		function(arg0_16)
			return arg0_16:GetStatusInfos() == MallStaff.STATUS.ORDER and 1 or 0
		end,
		function(arg0_17)
			return arg0_17.id
		end
	}))

	return var0_15
end

function var0_0.AddStaff(arg0_18, arg1_18, arg2_18)
	arg0_18.staffData[arg2_18] = MallStaff.New({
		tid = arg1_18,
		id = arg2_18
	})
end

function var0_0.GetStaff(arg0_19, arg1_19)
	return arg0_19.staffData[arg1_19]
end

function var0_0.InitStaffStatus(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.orderData:GetStaffList()) do
		arg0_20.staffData[iter1_20]:SetStatus(MallStaff.STATUS.ORDER, {
			orderId = arg0_20.orderData.id
		})
	end

	for iter2_20, iter3_20 in pairs(arg0_20.floorData) do
		for iter4_20, iter5_20 in ipairs(iter3_20:GetStaffList()) do
			if iter5_20 ~= 0 then
				arg0_20.staffData[iter5_20]:SetStatus(MallStaff.STATUS.FLOOR, {
					floorId = iter3_20.id,
					floorIdx = iter4_20
				})
			end
		end
	end
end

function var0_0.SetStaffExtraData(arg0_21, arg1_21, arg2_21)
	arg0_21.staffData[arg1_21]:SetExtraData(arg2_21)
end

function var0_0.GetOrderData(arg0_22)
	return arg0_22.orderData
end

function var0_0.OnStartOrderDone(arg0_23, arg1_23, arg2_23, arg3_23)
	arg0_23.orderData:StartOrder(arg1_23, arg2_23, arg3_23)

	for iter0_23, iter1_23 in ipairs(arg3_23) do
		arg0_23.staffData[iter1_23]:SetStatus(MallStaff.STATUS.ORDER, {
			orderId = iter1_23
		})
	end

	arg0_23:ReduceGold(MallOrder.GetCostGold(arg1_23))
end

function var0_0.OnCompleteOrderDone(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.orderData:GetStaffList()) do
		arg0_24.staffData[iter1_24]:SetStatus(MallStaff.STATUS.NORMAL, {})
	end

	arg0_24.orderData:CompleteOrder(arg1_24)
end

function var0_0.GetFloorStaffList(arg0_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in pairs(arg0_25.floorData) do
		if iter1_25:IsUnlock() then
			for iter2_25, iter3_25 in ipairs(iter1_25:GetStaffList()) do
				table.insert(var0_25, iter3_25)
			end
		end
	end

	return var0_25
end

function var0_0.GetFloorData(arg0_26)
	return arg0_26.floorData
end

function var0_0.GetFloor(arg0_27, arg1_27)
	return arg0_27.floorData[arg1_27]
end

function var0_0.GetFloorList(arg0_28)
	local var0_28 = underscore.values(arg0_28.floorData)

	table.sort(var0_28, CompareFuncs({
		function(arg0_29)
			return -arg0_29.id
		end
	}))

	return var0_28
end

function var0_0.GetFloorListAsc(arg0_30)
	local var0_30 = underscore.values(arg0_30.floorData)

	table.sort(var0_30, CompareFuncs({
		function(arg0_31)
			return arg0_31.id
		end
	}))

	return var0_30
end

function var0_0.NeedUpdateFloorStaff(arg0_32)
	local var0_32 = arg0_32:GetFloorStaffList()

	if #var0_32 ~= #arg0_32.lastFloorStaffList then
		return true
	end

	for iter0_32, iter1_32 in ipairs(var0_32) do
		if iter1_32 ~= arg0_32.lastFloorStaffList[iter0_32] then
			return true
		end
	end

	return false
end

function var0_0.OnUpdateFloorStaffDone(arg0_33, arg1_33)
	arg0_33.lastFloorStaffList = arg1_33
end

function var0_0.SetFloorStaff(arg0_34, arg1_34, arg2_34, arg3_34)
	arg0_34:_RemoveFloorStaff(arg1_34, arg2_34)

	if arg3_34 ~= 0 then
		arg0_34:_AddFloorStaff(arg1_34, arg2_34, arg3_34)
	else
		local var0_34 = arg0_34.floorData[arg1_34]:GetStaffList()
		local var1_34 = {}

		if arg2_34 ~= #var0_34 then
			for iter0_34 = arg2_34 + 1, #var0_34 do
				if var0_34[iter0_34] ~= 0 then
					table.insert(var1_34, var0_34[iter0_34])
				end

				arg0_34:_RemoveFloorStaff(arg1_34, iter0_34)
			end

			for iter1_34, iter2_34 in ipairs(var1_34) do
				arg0_34:_AddFloorStaff(arg1_34, arg2_34 - 1 + iter1_34, iter2_34)
			end
		end
	end
end

function var0_0._RemoveFloorStaff(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg0_35.floorData[arg1_35]:GetStaffList()[arg2_35]

	if var0_35 == 0 then
		return
	end

	arg0_35.floorData[arg1_35]:SetStaff(arg2_35, 0)
	arg0_35.staffData[var0_35]:SetStatus(MallStaff.STATUS.NORMAL, {})
end

function var0_0._AddFloorStaff(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = arg0_36.floorData[arg1_36]:GetStaffList()[arg2_36]

	assert(var0_36 == 0, string.format("%d楼的第%d个位置已有员工%d, 请先移除！", arg1_36, arg2_36, arg3_36))

	local var1_36, var2_36 = arg0_36.staffData[arg3_36]:GetStatusInfos()

	assert(var1_36 == MallStaff.STATUS.NORMAL, string.format("员工%d处于被占用状态！(%d)", arg3_36, var1_36))
	arg0_36.floorData[arg1_36]:SetStaff(arg2_36, arg3_36)
	arg0_36.staffData[arg3_36]:SetStatus(MallStaff.STATUS.FLOOR, {
		floorId = arg1_36,
		floorIdx = arg2_36
	})
end

function var0_0.IsStaffDrop(arg0_37)
	if arg0_37.type ~= DROP_TYPE_VITEM then
		return false
	end

	if arg0_37:getConfig("virtual_type") ~= 103 then
		return false
	end

	local var0_37 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)

	if not var0_37 then
		return false
	end

	if arg0_37:getConfig("link_id") ~= var0_37.id then
		return false
	end

	return arg0_37.id ~= var0_37:getConfig("config_data")[1]
end

return var0_0
