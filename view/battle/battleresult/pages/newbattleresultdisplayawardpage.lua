local var0_0 = class("NewBattleResultDisplayAwardPage", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1

	var0_0.super.Ctor(arg0_1, arg2_1)

	arg0_1.contextData = arg3_1
end

function var0_0.ExecuteAction(arg0_2, arg1_2, arg2_2)
	arg0_2[arg1_2](arg0_2, arg2_2)
end

function var0_0.SetUp(arg0_3, arg1_3)
	local var0_3, var1_3 = arg0_3:CollectDrops()

	seriesAsync({
		function(arg0_4)
			arg0_3:ShowAwards(var0_3, var1_3, arg0_4)
		end,
		function(arg0_5)
			arg0_3:ShowShips(var0_3, arg0_5)
		end
	}, arg1_3)
end

function var0_0.ShowShips(arg0_6, arg1_6, arg2_6)
	local var0_6 = #_.filter(arg1_6, function(arg0_7)
		return arg0_7.type == DROP_TYPE_SHIP
	end)
	local var1_6 = getProxy(BayProxy):getNewShip(true)
	local var2_6 = {}

	_.each(var1_6, function(arg0_8)
		if arg0_8:isMetaShip() then
			table.insert(var2_6, arg0_8.configId)
		end
	end)
	_.each(arg1_6, function(arg0_9)
		local var0_9 = arg0_9.configId or arg0_9.id

		if Ship.isMetaShipByConfigID(var0_9) then
			local var1_9 = table.indexof(var2_6, var0_9)

			if var1_9 then
				table.remove(var2_6, var1_9)
			else
				local var2_9 = Ship.New({
					configId = var0_9
				})
				local var3_9 = getProxy(BayProxy):getMetaTransItemMap(var2_9.configId)

				if var3_9 then
					var2_9:setReMetaSpecialItemVO(var3_9)
				end

				table.insert(var1_6, var2_9)
			end
		end
	end)

	local var3_6 = {}

	for iter0_6 = math.max(1, #var1_6 - var0_6 + 1), #var1_6 do
		local var4_6 = var1_6[iter0_6]

		if PlayerPrefs.GetInt(DISPLAY_SHIP_GET_EFFECT) == 1 or var4_6.virgin or var4_6:getRarity() >= ShipRarity.Purple then
			local var5_6 = arg0_6.contextData.system == SYSTEM_SCENARIO and arg0_6.contextData.autoSkipFlag

			table.insert(var3_6, function(arg0_10)
				local var0_10 = var5_6 and not var4_6.virgin and 3 or nil

				arg0_6:emit(NewBattleResultMediator.GET_NEW_SHIP, var4_6, arg0_10, var0_10)
			end)
		end
	end

	seriesAsync(var3_6, arg2_6)
end

function var0_0.ShowAwards(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg0_11.contextData.autoSkipFlag

	if #arg1_11 > 0 then
		arg0_11:emit(BaseUI.ON_AWARD, {
			items = arg1_11,
			extraBonus = arg2_11,
			removeFunc = arg3_11,
			closeOnCompleted = var0_11
		})
	else
		arg3_11()
	end
end

function var0_0.CollectDrops(arg0_12)
	local var0_12 = false
	local var1_12 = {}

	for iter0_12, iter1_12 in ipairs(arg0_12.contextData.drops or {}) do
		table.insert(var1_12, iter1_12)
	end

	for iter2_12, iter3_12 in ipairs(arg0_12.contextData.extraDrops or {}) do
		iter3_12.riraty = true

		table.insert(var1_12, iter3_12)
	end

	local var2_12 = arg0_12.contextData.extraBuffList

	for iter4_12, iter5_12 in ipairs(var2_12 or {}) do
		if pg.benefit_buff_template[iter5_12].benefit_type == Chapter.OPERATION_BUFF_TYPE_REWARD then
			var0_12 = true

			break
		end
	end

	return var1_12, var0_12
end

function var0_0.Destroy(arg0_13)
	arg0_13.exited = true
end

return var0_0
