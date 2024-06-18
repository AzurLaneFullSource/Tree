local var0_0 = class("Responder")
local var1_0 = {
	__index = function(arg0_1, arg1_1)
		arg0_1[arg1_1] = {}

		return arg0_1[arg1_1]
	end
}

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.binder = arg1_2
end

function var0_0.reset(arg0_3)
	if arg0_3.map then
		for iter0_3, iter1_3 in pairs(arg0_3.map) do
			underscore.each(iter1_3, function(arg0_4)
				Destroy(arg0_4._tf)
			end)
		end
	end

	arg0_3.timeRiver = {}
	arg0_3.fireList = {}
	arg0_3.eventRange = {}
	arg0_3.map = setmetatable({}, var1_0)
	arg0_3.findingResult = {}
	arg0_3.reactorRyza = nil
	arg0_3.enemyCount = 0
end

function var0_0.AddListener(arg0_5, arg1_5, arg2_5, arg3_5)
	arg0_5.eventRange[arg1_5] = arg0_5.eventRange[arg1_5] or setmetatable({}, var1_0)

	local var0_5 = arg0_5.eventRange[arg1_5]

	for iter0_5, iter1_5 in ipairs(arg3_5) do
		table.insert(var0_5[tostring(arg2_5.pos + iter1_5)], arg2_5)
	end
end

function var0_0.RemoveListener(arg0_6, arg1_6, arg2_6, arg3_6)
	if not arg3_6 then
		return
	end

	local var0_6 = arg0_6.eventRange[arg1_6]

	for iter0_6, iter1_6 in ipairs(arg3_6) do
		table.removebyvalue(var0_6[tostring(arg2_6.pos + iter1_6)], arg2_6)
	end
end

local var2_0 = {
	{
		0,
		1
	},
	{
		1,
		0
	},
	{
		0,
		-1
	},
	{
		-1,
		0
	}
}

function var0_0.InRange(arg0_7, arg1_7)
	local var0_7 = arg0_7.binder.config.mapSize

	if arg1_7.x < 0 or arg1_7.y < 0 or arg1_7.x >= var0_7.x or arg1_7.y >= var0_7.y then
		return false
	else
		return true
	end
end

function var0_0.GetCrossFire(arg0_8, arg1_8, arg2_8)
	local var0_8 = {
		0,
		0,
		0,
		0
	}

	for iter0_8, iter1_8 in ipairs(var2_0) do
		for iter2_8 = 1, arg2_8 do
			local var1_8 = arg1_8 + NewPos(unpack(iter1_8)) * iter2_8
			local var2_8 = arg0_8:GetFirePassability(var1_8)

			if var2_8 < 2 then
				var0_8[iter0_8] = iter2_8
			end

			if var2_8 > 0 then
				break
			end
		end
	end

	local var3_8 = {}

	for iter3_8, iter4_8 in ipairs(arg0_8.timeRiver) do
		if isa(iter4_8, EnemyConductor) then
			iter4_8:CheckBlock(arg1_8, var0_8, var3_8)
		end
	end

	local var4_8 = {
		{
			0,
			0
		}
	}

	for iter5_8, iter6_8 in ipairs(var2_0) do
		for iter7_8 = 1, var0_8[iter5_8] do
			table.insert(var4_8, {
				iter6_8[1] * iter7_8,
				iter6_8[2] * iter7_8
			})
		end
	end

	return var0_8, var4_8, var3_8
end

function var0_0.getRangeList(arg0_9, arg1_9, arg2_9)
	return underscore.map(arg2_9, function(arg0_10)
		return arg1_9.pos + NewPos(unpack(arg0_10))
	end)
end

function var0_0.EventCall(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	if isa(arg4_11, Reactor) then
		if arg4_11 == MoveRyza then
			arg0_11.reactorRyza:React(arg1_11, arg2_11)
		else
			arg4_11:React(arg1_11, arg2_11)
		end
	else
		local var0_11 = arg0_11.eventRange[arg1_11]

		if not var0_11 then
			return
		end

		for iter0_11, iter1_11 in ipairs(arg0_11:getRangeList(arg3_11, arg4_11)) do
			for iter2_11, iter3_11 in ipairs(underscore.rest(var0_11[tostring(iter1_11)], 1)) do
				iter3_11:React(arg1_11, arg2_11)
			end
		end
	end
end

function var0_0.CreateCall(arg0_12, arg1_12)
	table.insert(arg0_12.map[tostring(arg1_12.pos)], arg1_12)

	if arg1_12:InTimeRiver() then
		table.insert(arg0_12.timeRiver, arg1_12)
	end

	if isa(arg1_12, MoveRyza) then
		arg0_12.reactorRyza = arg1_12
	elseif isa(arg1_12, MoveEnemy) then
		arg0_12.enemyCount = defaultValue(arg0_12.enemyCount, 0) + 1
	elseif isa(arg1_12, EffectFire) then
		table.insert(arg0_12.fireList, arg1_12)
	end
end

function var0_0.DestroyCall(arg0_13, arg1_13, arg2_13)
	table.removebyvalue(arg0_13.map[tostring(arg1_13.pos)], arg1_13)

	if arg1_13:InTimeRiver() then
		table.removebyvalue(arg0_13.timeRiver, arg1_13)
	end

	arg0_13.binder:emit(RyzaMiniGameView.EVENT_DESTROY, arg1_13, arg2_13)

	if isa(arg1_13, MoveEnemy) then
		arg0_13.enemyCount = arg0_13.enemyCount - 1

		if arg0_13.enemyCount == 0 then
			arg0_13:GameFinish(true)
		end
	elseif isa(arg1_13, EffectFire) then
		table.removebyvalue(arg0_13.fireList, arg1_13)
	end
end

function var0_0.GetCellPassability(arg0_14, arg1_14)
	if not arg0_14:InRange(arg1_14) then
		return false
	end

	for iter0_14, iter1_14 in ipairs(arg0_14.map[tostring(arg1_14)]) do
		if not iter1_14:CellPassability() then
			return false, iter1_14
		end
	end

	return true
end

function var0_0.GetFirePassability(arg0_15, arg1_15)
	if not arg0_15:InRange(arg1_15) then
		return 2
	end

	return underscore.reduce(arg0_15.map[tostring(arg1_15)], 0, function(arg0_16, arg1_16)
		return math.max(arg0_16, arg1_16:FirePassability())
	end)
end

function var0_0.GetCellCanBomb(arg0_17, arg1_17)
	if not arg0_17:InRange(arg1_17) then
		return false
	end

	return underscore.all(arg0_17.map[tostring(arg1_17)], function(arg0_18)
		return not isa(arg0_18, ObjectBomb)
	end)
end

function var0_0.TimeFlow(arg0_19, arg1_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.timeRiver) do
		iter1_19:TimeUpdate(arg1_19)
	end
end

function var0_0.Create(arg0_20, arg1_20)
	arg0_20.binder:emit(RyzaMiniGameView.EVENT_CREATE, arg1_20)
end

function var0_0.GetJoyStick(arg0_21)
	return NewPos(arg0_21.binder.uiMgr.hrz, -arg0_21.binder.uiMgr.vtc)
end

function var0_0.RyzaBomb(arg0_22)
	arg0_22.reactorRyza:SetBomb()
end

function var0_0.GameFinish(arg0_23, arg1_23)
	arg0_23.binder:emit(RyzaMiniGameView.EVENT_FINISH, arg1_23)
end

function var0_0.WindowFocrus(arg0_24, arg1_24)
	arg0_24.binder:emit(RyzaMiniGameView.EVENT_WINDOW_FOCUS, arg1_24)
end

function var0_0.SyncStatus(arg0_25, arg1_25, arg2_25, arg3_25)
	arg0_25.binder:emit(RyzaMiniGameView.EVENT_STATUS_SYNC, arg1_25, arg2_25, arg3_25)
end

function var0_0.UpdateHide(arg0_26, arg1_26, arg2_26)
	arg0_26.binder:emit(RyzaMiniGameView.EVENT_UPDATE_HIDE, arg1_26, arg2_26)
end

function var0_0.UpdatePos(arg0_27, arg1_27, arg2_27)
	table.removebyvalue(arg0_27.map[tostring(arg1_27.pos)], arg1_27)
	table.insert(arg0_27.map[tostring(arg2_27)], arg1_27)
end

local function var3_0(arg0_28, arg1_28)
	local var0_28 = arg1_28.pos - arg0_28.pos

	for iter0_28, iter1_28 in ipairs(arg0_28.range) do
		for iter2_28, iter3_28 in ipairs(arg1_28.range) do
			local var1_28 = {
				{},
				{}
			}

			for iter4_28, iter5_28 in ipairs(iter1_28) do
				var1_28[iter4_28][1] = iter5_28[1] - iter3_28[iter4_28][2]
				var1_28[iter4_28][2] = iter5_28[2] - iter3_28[iter4_28][1]
			end

			if var0_28.x > var1_28[1][1] and var0_28.x < var1_28[1][2] and var0_28.y > var1_28[2][1] and var0_28.y < var1_28[2][2] then
				return true
			end
		end
	end

	return false
end

function var0_0.Wayfinding(arg0_29, arg1_29)
	if arg0_29.reactorRyza.hide or arg0_29:CollideRyza(arg1_29) then
		arg0_29.findingResult[arg1_29] = nil

		return {
			arg0_29.realPos
		}
	elseif arg0_29.findingResult[arg1_29] then
		local var0_29 = arg0_29.findingResult[arg1_29]

		if var0_29.ryzaPos == arg0_29.reactorRyza.pos and var0_29.reactorPos == arg1_29.pos then
			return var0_29.path
		else
			arg0_29.findingResult[arg1_29] = nil
		end
	end

	local var1_29 = {
		arg1_29.pos
	}
	local var2_29 = {
		[tostring(arg1_29.pos)] = 0
	}

	local function var3_29(arg0_30)
		local var0_30 = {}

		while var2_29[tostring(var1_29[arg0_30])] > 0 do
			table.insert(var0_30, var1_29[arg0_30])

			arg0_30 = var2_29[tostring(var1_29[arg0_30])]
		end

		arg0_29.findingResult[arg1_29] = {
			ryzaPos = arg0_29.reactorRyza.pos,
			reactorPos = arg1_29.pos,
			path = var0_30
		}

		return var0_30
	end

	local var4_29 = 0
	local var5_29

	while var4_29 < #var1_29 do
		var4_29 = var4_29 + 1

		for iter0_29, iter1_29 in ipairs(var2_0) do
			local var6_29 = var1_29[var4_29] + NewPos(unpack(iter1_29))

			if var2_29[tostring(var6_29)] == nil then
				if arg0_29:GetCellPassability(var6_29) then
					var2_29[tostring(var6_29)] = var4_29

					table.insert(var1_29, var6_29)

					if var3_0({
						pos = arg0_29.reactorRyza.realPos,
						range = arg0_29.reactorRyza:GetCollideRange()
					}, {
						pos = var6_29,
						range = arg1_29:GetCollideRange()
					}) then
						return var3_29(#var1_29)
					end
				else
					var2_29[tostring(var6_29)] = false
				end
			end
		end

		for iter2_29, iter3_29 in ipairs(var2_0) do
			local var7_29 = NewPos(unpack(iter3_29))
			local var8_29 = NewPos(unpack(var2_0[iter2_29 % 4 + 1]))
			local var9_29 = var1_29[var4_29] + var7_29 + var8_29

			if var2_29[tostring(var1_29[var4_29] + var7_29)] and var2_29[tostring(var1_29[var4_29] + var8_29)] and var2_29[tostring(var9_29)] == nil and arg0_29:GetCellPassability(var9_29) then
				var2_29[tostring(var9_29)] = var4_29

				table.insert(var1_29, var9_29)

				if var3_0({
					pos = arg0_29.reactorRyza.realPos,
					range = arg0_29.reactorRyza:GetCollideRange()
				}, {
					pos = var9_29,
					range = arg1_29:GetCollideRange()
				}) then
					return var3_29(#var1_29)
				end
			end
		end
	end
end

function var0_0.SearchRyza(arg0_31, arg1_31, arg2_31)
	if arg0_31.reactorRyza.hide then
		return false
	else
		return ((arg1_31.realPos or arg1_31.pos) - arg0_31.reactorRyza.realPos):SqrMagnitude() < arg2_31 * arg2_31
	end
end

function var0_0.CollideRyza(arg0_32, arg1_32)
	return var3_0({
		pos = arg0_32.reactorRyza.realPos,
		range = arg0_32.reactorRyza:GetCollideRange()
	}, {
		pos = arg1_32.realPos,
		range = arg1_32:GetCollideRange()
	})
end

function var0_0.CollideFire(arg0_33, arg1_33)
	return underscore.filter(arg0_33.fireList, function(arg0_34)
		return var3_0({
			pos = arg0_34.pos,
			range = arg0_34:GetCollideRange()
		}, {
			pos = arg1_33.realPos,
			range = arg1_33:GetCollideRange()
		})
	end)
end

return var0_0
