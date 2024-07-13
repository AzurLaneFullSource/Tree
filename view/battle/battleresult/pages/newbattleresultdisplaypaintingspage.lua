local var0_0 = class("NewBattleResultDisplayPaintingsPage", import("view.base.BaseSubView"))
local var1_0 = 6
local var2_0 = 295

function var0_0.getUIName(arg0_1)
	return "NewBattleResultDisplayPaintingsPages"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.slots = {
		arg0_2:findTF("tpl")
	}
end

function var0_0.StaticGetFinalExpandPosition(arg0_3)
	if arg0_3 <= var1_0 then
		return var0_0.StaticGetExpandPosition(arg0_3, var1_0 - 1)
	else
		local var0_3 = arg0_3 - var1_0

		return var0_0.StaticGetExpandPosition(arg0_3, arg0_3 - 1) - var0_3 * Vector2(var2_0, 0)
	end
end

function var0_0.StaticGetExpandPosition(arg0_4, arg1_4)
	local var0_4 = math.ceil(arg1_4 / 2)
	local var1_4 = arg1_4 % 2 ~= 0
	local var2_4

	if arg0_4 > 6 and arg0_4 % 2 == 0 or arg0_4 <= 6 then
		var2_4 = var1_4 and Vector2(-730, 72) or Vector2(-457, -72)
	else
		var2_4 = var1_4 and Vector2(-751, -72) or Vector2(-437, 72)
	end

	return var2_4 + Vector2(590, 0) * (var0_4 - 1)
end

function var0_0.GetExpandPosition(arg0_5, arg1_5, arg2_5)
	return var0_0.StaticGetExpandPosition(arg1_5, arg2_5)
end

function var0_0.GetShrinkPosition(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6:GetExpandPosition(arg1_6, arg2_6)
	local var1_6 = arg2_6 % 2 ~= 0
	local var2_6 = Vector2(-125, -936)

	if arg1_6 > 6 and arg1_6 % 2 == 0 or arg1_6 <= 6 then
		return var1_6 and var0_6 - var2_6 or var0_6 + var2_6
	else
		return var1_6 and var0_6 + var2_6 or var0_6 - var2_6
	end
end

function var0_0.SetUp(arg0_7, arg1_7)
	arg0_7:Show()

	arg0_7.displayShips = arg0_7:ReSortFleetShips()

	seriesAsync({
		function(arg0_8)
			arg0_7:InitMainFleetShips(arg0_8)
		end,
		function(arg0_9)
			arg0_7:DisplayMainFleet(arg0_9)
		end,
		function(arg0_10)
			arg0_7:MoveMainFleetShips(arg0_10)
		end,
		function(arg0_11)
			arg0_7:InitSubFleetShips(arg0_11)
		end,
		function(arg0_12)
			arg0_7:DisplaySubFleet(arg0_12)
		end,
		function(arg0_13)
			onDelayTick(arg0_13, 0.5)
		end
	}, function()
		arg1_7()
	end)
end

function var0_0.ReSortFleetShips(arg0_15)
	local var0_15 = arg0_15.contextData.oldMainShips
	local var1_15 = arg0_15.contextData.statistics.mvpShipID
	local var2_15 = arg0_15.contextData.statistics._flagShipID
	local var3_15, var4_15, var5_15, var6_15 = NewBattleResultUtil.SeparateMvpShip(var0_15, var1_15, var2_15)
	local var7_15 = {}

	if var6_15 ~= nil then
		local var8_15 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(var6_15.configId).type
		local var9_15 = TeamType.GetTeamFromShipType(var8_15)

		if var9_15 == TeamType.Vanguard then
			NewBattleResultUtil.SpecialInsertItem(var7_15, var5_15, var4_15, var3_15, var6_15)
		elseif var9_15 == TeamType.Main then
			NewBattleResultUtil.SpecialInsertItem(var7_15, var5_15, var3_15, var4_15, var6_15)
		elseif var9_15 == TeamType.Submarine then
			NewBattleResultUtil.SpecialInsertItem(var7_15, var3_15, var4_15, var5_15, var6_15)
		end
	else
		var7_15 = var0_15
	end

	return var7_15
end

function var0_0.InitSubFleetShips(arg0_16, arg1_16)
	if arg0_16.exited then
		return
	end

	local var0_16 = arg0_16.displayShips

	if #var0_16 <= var1_0 then
		arg1_16()

		return
	end

	local var1_16 = #var0_16 - var1_0

	for iter0_16 = 1, var1_16 do
		if arg0_16.slots[iter0_16] then
			retPaintingPrefab(arg0_16.slots[iter0_16]:Find("mask/painting"), var0_16[iter0_16]:getPainting())
		end
	end

	local var2_16 = {}

	for iter1_16 = var1_0 + 1, math.max(var1_0, #var0_16) do
		local var3_16 = Object.Instantiate(arg0_16.slots[1], arg0_16.slots[1].parent)

		table.insert(arg0_16.slots, var3_16)

		local var4_16 = var0_16[iter1_16]

		var3_16.localPosition = arg0_16:GetExpandPosition(#var0_16, iter1_16)

		table.insert(var2_16, function(arg0_17)
			setPaintingPrefabAsync(var3_16:Find("mask/painting"), var4_16:getPainting(), "biandui", arg0_17)
		end)
	end

	parallelAsync(var2_16, function()
		onDelayTick(arg1_16, 0.05)
	end)
end

function var0_0.DisplaySubFleet(arg0_19, arg1_19)
	if arg0_19.exited then
		return
	end

	arg0_19:EffectSlots(false)

	local var0_19 = arg0_19.displayShips

	if #var0_19 <= var1_0 then
		arg1_19()

		return
	end

	local var1_19 = {}
	local var2_19 = #var0_19 - var1_0

	for iter0_19 = var1_0 + 1, math.max(var1_0, #var0_19) do
		local var3_19 = arg0_19.slots[iter0_19]
		local var4_19 = arg0_19:GetExpandPosition(#var0_19, iter0_19).x
		local var5_19 = var4_19 - var2_19 * var2_0

		table.insert(var1_19, function(arg0_20)
			if arg0_19.exited then
				return
			end

			LeanTween.value(var3_19.gameObject, var4_19, var5_19, 0.3):setOnUpdate(System.Action_float(function(arg0_21)
				var3_19.localPosition = Vector3(arg0_21, var3_19.localPosition.y, 0)
			end)):setEase(LeanTweenType.easeOutQuad)
			onDelayTick(function()
				if arg0_19.exited then
					return
				end

				setActive(var3_19:Find("mask/blink"), true)
			end, 0.15)
			onDelayTick(function()
				if arg0_19.exited then
					return
				end

				setActive(var3_19:Find("mask/blink"), false)
			end, 0.2)
			onDelayTick(arg0_20, 0.1)
		end)
	end

	seriesAsync(var1_19, function()
		arg0_19:EffectSlots(true)
		arg1_19()
	end)
end

function var0_0.EffectSlots(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.slots) do
		if not IsNil(iter1_25) then
			setActive(iter1_25:Find("effect"), arg1_25)
		end
	end
end

function var0_0.MoveMainFleetShips(arg0_26, arg1_26)
	if arg0_26.exited then
		return
	end

	local var0_26 = #arg0_26.displayShips

	if var0_26 <= var1_0 then
		arg1_26()

		return
	end

	local var1_26 = {}
	local var2_26 = var0_26 - var1_0

	for iter0_26, iter1_26 in ipairs(arg0_26.slots) do
		table.insert(var1_26, function(arg0_27)
			local var0_27 = arg0_26:GetExpandPosition(var0_26, iter0_26).x
			local var1_27 = var0_27 - var2_26 * var2_0

			LeanTween.value(iter1_26.gameObject, var0_27, var1_27, 0.3):setOnUpdate(System.Action_float(function(arg0_28)
				iter1_26.localPosition = Vector3(arg0_28, iter1_26.localPosition.y, 0)
			end)):setEase(LeanTweenType.easeOutQuad):setOnComplete(System.Action(arg0_27))
		end)
	end

	parallelAsync(var1_26, function()
		return
	end)
	onDelayTick(function()
		if arg0_26.exited then
			return
		end

		arg1_26()

		for iter0_30 = 1, var2_26 do
			if arg0_26.slots[iter0_30] then
				setActive(arg0_26.slots[iter0_30], false)
			end
		end
	end, 0.05)
end

function var0_0.DisplayMainFleet(arg0_31, arg1_31)
	if arg0_31.exited then
		return
	end

	local var0_31 = {}
	local var1_31 = var1_0 - #arg0_31.slots
	local var2_31 = #arg0_31.displayShips

	for iter0_31, iter1_31 in ipairs(arg0_31.slots) do
		table.insert(var0_31, function(arg0_32)
			if arg0_31.exited then
				return
			end

			local var0_32 = var1_31 + iter0_31
			local var1_32 = arg0_31:GetExpandPosition(var2_31, var0_32)
			local var2_32 = arg0_31:GetShrinkPosition(var2_31, var0_32)

			LeanTween.value(iter1_31.gameObject, var2_32, var1_32, 0.29):setOnUpdate(System.Action_UnityEngine_Vector2(function(arg0_33)
				iter1_31.localPosition = arg0_33
			end))
			onNextTick(arg0_32)
		end)
	end

	local var3_31 = 0

	Timer.New(function()
		if arg0_31.exited then
			return
		end

		for iter0_34, iter1_34 in ipairs(arg0_31.slots) do
			setActive(iter1_34:Find("mask/blink"), var3_31 % 2 ~= 0 == (iter0_34 % 2 ~= 0))
		end

		var3_31 = var3_31 + 1
	end, 0.059, 5):Start()
	Timer.New(function()
		if arg0_31.exited then
			return
		end

		for iter0_35, iter1_35 in ipairs(arg0_31.slots) do
			setActive(iter1_35:Find("mask/blink"), false)
		end
	end, 0.3, 1):Start()
	seriesAsync(var0_31, function()
		arg0_31:EffectSlots(true)
		onDelayTick(arg1_31, 0.5)
	end)
end

function var0_0.InitMainFleetShips(arg0_37, arg1_37)
	local var0_37 = arg0_37.displayShips
	local var1_37 = math.min(var1_0, #var0_37)

	for iter0_37 = 2, var1_37 do
		local var2_37 = Object.Instantiate(arg0_37.slots[1], arg0_37.slots[1].parent)

		table.insert(arg0_37.slots, var2_37)
	end

	local var3_37 = {}
	local var4_37 = var1_0 - var1_37

	for iter1_37 = 1, var1_37 do
		local var5_37 = var0_37[iter1_37]
		local var6_37 = arg0_37.slots[iter1_37]

		var6_37.localPosition = arg0_37:GetShrinkPosition(#var0_37, var4_37 + iter1_37)

		table.insert(var3_37, function(arg0_38)
			if arg0_37.exited then
				return
			end

			setPaintingPrefabAsync(var6_37:Find("mask/painting"), var5_37:getPainting(), "biandui", arg0_38)
		end)
	end

	parallelAsync(var3_37, arg1_37)
end

function var0_0.OnDestroy(arg0_39)
	arg0_39.exited = true

	if arg0_39:isShowing() then
		arg0_39:Hide()
	end

	local var0_39 = arg0_39.displayShips or {}

	for iter0_39, iter1_39 in ipairs(arg0_39.slots or {}) do
		if iter1_39 then
			local var1_39 = iter1_39:Find("mask/painting")

			if var1_39 and var0_39[iter0_39] and var1_39:Find("fitter").childCount > 0 then
				retPaintingPrefab(var1_39, var0_39[iter0_39]:getPainting())
			end
		end

		if iter1_39 and LeanTween.isTweening(iter1_39.gameObject) then
			LeanTween.cancel(iter1_39.gameObject)
		end
	end
end

return var0_0
