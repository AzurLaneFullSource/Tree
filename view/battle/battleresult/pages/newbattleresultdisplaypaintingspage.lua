local var0 = class("NewBattleResultDisplayPaintingsPage", import("view.base.BaseSubView"))
local var1 = 6
local var2 = 295

function var0.getUIName(arg0)
	return "NewBattleResultDisplayPaintingsPages"
end

function var0.OnLoaded(arg0)
	arg0.slots = {
		arg0:findTF("tpl")
	}
end

function var0.StaticGetFinalExpandPosition(arg0)
	if arg0 <= var1 then
		return var0.StaticGetExpandPosition(arg0, var1 - 1)
	else
		local var0 = arg0 - var1

		return var0.StaticGetExpandPosition(arg0, arg0 - 1) - var0 * Vector2(var2, 0)
	end
end

function var0.StaticGetExpandPosition(arg0, arg1)
	local var0 = math.ceil(arg1 / 2)
	local var1 = arg1 % 2 ~= 0
	local var2

	if arg0 > 6 and arg0 % 2 == 0 or arg0 <= 6 then
		var2 = var1 and Vector2(-730, 72) or Vector2(-457, -72)
	else
		var2 = var1 and Vector2(-751, -72) or Vector2(-437, 72)
	end

	return var2 + Vector2(590, 0) * (var0 - 1)
end

function var0.GetExpandPosition(arg0, arg1, arg2)
	return var0.StaticGetExpandPosition(arg1, arg2)
end

function var0.GetShrinkPosition(arg0, arg1, arg2)
	local var0 = arg0:GetExpandPosition(arg1, arg2)
	local var1 = arg2 % 2 ~= 0
	local var2 = Vector2(-125, -936)

	if arg1 > 6 and arg1 % 2 == 0 or arg1 <= 6 then
		return var1 and var0 - var2 or var0 + var2
	else
		return var1 and var0 + var2 or var0 - var2
	end
end

function var0.SetUp(arg0, arg1)
	arg0:Show()

	arg0.displayShips = arg0:ReSortFleetShips()

	seriesAsync({
		function(arg0)
			arg0:InitMainFleetShips(arg0)
		end,
		function(arg0)
			arg0:DisplayMainFleet(arg0)
		end,
		function(arg0)
			arg0:MoveMainFleetShips(arg0)
		end,
		function(arg0)
			arg0:InitSubFleetShips(arg0)
		end,
		function(arg0)
			arg0:DisplaySubFleet(arg0)
		end,
		function(arg0)
			onDelayTick(arg0, 0.5)
		end
	}, function()
		arg1()
	end)
end

function var0.ReSortFleetShips(arg0)
	local var0 = arg0.contextData.oldMainShips
	local var1 = arg0.contextData.statistics.mvpShipID
	local var2 = arg0.contextData.statistics._flagShipID
	local var3, var4, var5, var6 = NewBattleResultUtil.SeparateMvpShip(var0, var1, var2)
	local var7 = {}

	if var6 ~= nil then
		local var8 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(var6.configId).type
		local var9 = TeamType.GetTeamFromShipType(var8)

		if var9 == TeamType.Vanguard then
			NewBattleResultUtil.SpecialInsertItem(var7, var5, var4, var3, var6)
		elseif var9 == TeamType.Main then
			NewBattleResultUtil.SpecialInsertItem(var7, var5, var3, var4, var6)
		elseif var9 == TeamType.Submarine then
			NewBattleResultUtil.SpecialInsertItem(var7, var3, var4, var5, var6)
		end
	else
		var7 = var0
	end

	return var7
end

function var0.InitSubFleetShips(arg0, arg1)
	if arg0.exited then
		return
	end

	local var0 = arg0.displayShips

	if #var0 <= var1 then
		arg1()

		return
	end

	local var1 = #var0 - var1

	for iter0 = 1, var1 do
		if arg0.slots[iter0] then
			retPaintingPrefab(arg0.slots[iter0]:Find("mask/painting"), var0[iter0]:getPainting())
		end
	end

	local var2 = {}

	for iter1 = var1 + 1, math.max(var1, #var0) do
		local var3 = Object.Instantiate(arg0.slots[1], arg0.slots[1].parent)

		table.insert(arg0.slots, var3)

		local var4 = var0[iter1]

		var3.localPosition = arg0:GetExpandPosition(#var0, iter1)

		table.insert(var2, function(arg0)
			setPaintingPrefabAsync(var3:Find("mask/painting"), var4:getPainting(), "biandui", arg0)
		end)
	end

	parallelAsync(var2, function()
		onDelayTick(arg1, 0.05)
	end)
end

function var0.DisplaySubFleet(arg0, arg1)
	if arg0.exited then
		return
	end

	arg0:EffectSlots(false)

	local var0 = arg0.displayShips

	if #var0 <= var1 then
		arg1()

		return
	end

	local var1 = {}
	local var2 = #var0 - var1

	for iter0 = var1 + 1, math.max(var1, #var0) do
		local var3 = arg0.slots[iter0]
		local var4 = arg0:GetExpandPosition(#var0, iter0).x
		local var5 = var4 - var2 * var2

		table.insert(var1, function(arg0)
			if arg0.exited then
				return
			end

			LeanTween.value(var3.gameObject, var4, var5, 0.3):setOnUpdate(System.Action_float(function(arg0)
				var3.localPosition = Vector3(arg0, var3.localPosition.y, 0)
			end)):setEase(LeanTweenType.easeOutQuad)
			onDelayTick(function()
				if arg0.exited then
					return
				end

				setActive(var3:Find("mask/blink"), true)
			end, 0.15)
			onDelayTick(function()
				if arg0.exited then
					return
				end

				setActive(var3:Find("mask/blink"), false)
			end, 0.2)
			onDelayTick(arg0, 0.1)
		end)
	end

	seriesAsync(var1, function()
		arg0:EffectSlots(true)
		arg1()
	end)
end

function var0.EffectSlots(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.slots) do
		if not IsNil(iter1) then
			setActive(iter1:Find("effect"), arg1)
		end
	end
end

function var0.MoveMainFleetShips(arg0, arg1)
	if arg0.exited then
		return
	end

	local var0 = #arg0.displayShips

	if var0 <= var1 then
		arg1()

		return
	end

	local var1 = {}
	local var2 = var0 - var1

	for iter0, iter1 in ipairs(arg0.slots) do
		table.insert(var1, function(arg0)
			local var0 = arg0:GetExpandPosition(var0, iter0).x
			local var1 = var0 - var2 * var2

			LeanTween.value(iter1.gameObject, var0, var1, 0.3):setOnUpdate(System.Action_float(function(arg0)
				iter1.localPosition = Vector3(arg0, iter1.localPosition.y, 0)
			end)):setEase(LeanTweenType.easeOutQuad):setOnComplete(System.Action(arg0))
		end)
	end

	parallelAsync(var1, function()
		return
	end)
	onDelayTick(function()
		if arg0.exited then
			return
		end

		arg1()

		for iter0 = 1, var2 do
			if arg0.slots[iter0] then
				setActive(arg0.slots[iter0], false)
			end
		end
	end, 0.05)
end

function var0.DisplayMainFleet(arg0, arg1)
	if arg0.exited then
		return
	end

	local var0 = {}
	local var1 = var1 - #arg0.slots
	local var2 = #arg0.displayShips

	for iter0, iter1 in ipairs(arg0.slots) do
		table.insert(var0, function(arg0)
			if arg0.exited then
				return
			end

			local var0 = var1 + iter0
			local var1 = arg0:GetExpandPosition(var2, var0)
			local var2 = arg0:GetShrinkPosition(var2, var0)

			LeanTween.value(iter1.gameObject, var2, var1, 0.29):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0)
				iter1.localPosition = arg0
			end))
			onNextTick(arg0)
		end)
	end

	local var3 = 0

	Timer.New(function()
		if arg0.exited then
			return
		end

		for iter0, iter1 in ipairs(arg0.slots) do
			setActive(iter1:Find("mask/blink"), var3 % 2 ~= 0 == (iter0 % 2 ~= 0))
		end

		var3 = var3 + 1
	end, 0.059, 5):Start()
	Timer.New(function()
		if arg0.exited then
			return
		end

		for iter0, iter1 in ipairs(arg0.slots) do
			setActive(iter1:Find("mask/blink"), false)
		end
	end, 0.3, 1):Start()
	seriesAsync(var0, function()
		arg0:EffectSlots(true)
		onDelayTick(arg1, 0.5)
	end)
end

function var0.InitMainFleetShips(arg0, arg1)
	local var0 = arg0.displayShips
	local var1 = math.min(var1, #var0)

	for iter0 = 2, var1 do
		local var2 = Object.Instantiate(arg0.slots[1], arg0.slots[1].parent)

		table.insert(arg0.slots, var2)
	end

	local var3 = {}
	local var4 = var1 - var1

	for iter1 = 1, var1 do
		local var5 = var0[iter1]
		local var6 = arg0.slots[iter1]

		var6.localPosition = arg0:GetShrinkPosition(#var0, var4 + iter1)

		table.insert(var3, function(arg0)
			if arg0.exited then
				return
			end

			setPaintingPrefabAsync(var6:Find("mask/painting"), var5:getPainting(), "biandui", arg0)
		end)
	end

	parallelAsync(var3, arg1)
end

function var0.OnDestroy(arg0)
	arg0.exited = true

	if arg0:isShowing() then
		arg0:Hide()
	end

	local var0 = arg0.displayShips or {}

	for iter0, iter1 in ipairs(arg0.slots or {}) do
		if iter1 then
			local var1 = iter1:Find("mask/painting")

			if var1 and var0[iter0] and var1:Find("fitter").childCount > 0 then
				retPaintingPrefab(var1, var0[iter0]:getPainting())
			end
		end

		if iter1 and LeanTween.isTweening(iter1.gameObject) then
			LeanTween.cancel(iter1.gameObject)
		end
	end
end

return var0
