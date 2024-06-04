local var0 = class("NewBattleResultDisplayAwardPage", import("view.base.BaseEventLogic"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._tf = arg1

	var0.super.Ctor(arg0, arg2)

	arg0.contextData = arg3
end

function var0.ExecuteAction(arg0, arg1, arg2)
	arg0[arg1](arg0, arg2)
end

function var0.SetUp(arg0, arg1)
	local var0, var1 = arg0:CollectDrops()

	seriesAsync({
		function(arg0)
			arg0:ShowAwards(var0, var1, arg0)
		end,
		function(arg0)
			arg0:ShowShips(var0, arg0)
		end
	}, arg1)
end

function var0.ShowShips(arg0, arg1, arg2)
	local var0 = #_.filter(arg1, function(arg0)
		return arg0.type == DROP_TYPE_SHIP
	end)
	local var1 = getProxy(BayProxy):getNewShip(true)
	local var2 = {}

	_.each(var1, function(arg0)
		if arg0:isMetaShip() then
			table.insert(var2, arg0.configId)
		end
	end)
	_.each(arg1, function(arg0)
		local var0 = arg0.configId or arg0.id

		if Ship.isMetaShipByConfigID(var0) then
			local var1 = table.indexof(var2, var0)

			if var1 then
				table.remove(var2, var1)
			else
				local var2 = Ship.New({
					configId = var0
				})
				local var3 = getProxy(BayProxy):getMetaTransItemMap(var2.configId)

				if var3 then
					var2:setReMetaSpecialItemVO(var3)
				end

				table.insert(var1, var2)
			end
		end
	end)

	local var3 = {}

	for iter0 = math.max(1, #var1 - var0 + 1), #var1 do
		local var4 = var1[iter0]

		if PlayerPrefs.GetInt(DISPLAY_SHIP_GET_EFFECT) == 1 or var4.virgin or var4:getRarity() >= ShipRarity.Purple then
			local var5 = arg0.contextData.system == SYSTEM_SCENARIO and arg0.contextData.autoSkipFlag

			table.insert(var3, function(arg0)
				local var0 = var5 and not var4.virgin and 3 or nil

				arg0:emit(NewBattleResultMediator.GET_NEW_SHIP, var4, arg0, var0)
			end)
		end
	end

	seriesAsync(var3, arg2)
end

function var0.ShowAwards(arg0, arg1, arg2, arg3)
	local var0 = arg0.contextData.autoSkipFlag

	if #arg1 > 0 then
		arg0:emit(BaseUI.ON_AWARD, {
			items = arg1,
			extraBonus = arg2,
			removeFunc = arg3,
			closeOnCompleted = var0
		})
	else
		arg3()
	end
end

function var0.CollectDrops(arg0)
	local var0 = false
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.contextData.drops or {}) do
		table.insert(var1, iter1)
	end

	for iter2, iter3 in ipairs(arg0.contextData.extraDrops or {}) do
		iter3.riraty = true

		table.insert(var1, iter3)
	end

	local var2 = arg0.contextData.extraBuffList

	for iter4, iter5 in ipairs(var2 or {}) do
		if pg.benefit_buff_template[iter5].benefit_type == Chapter.OPERATION_BUFF_TYPE_REWARD then
			var0 = true

			break
		end
	end

	return var1, var0
end

function var0.Destroy(arg0)
	arg0.exited = true
end

return var0
