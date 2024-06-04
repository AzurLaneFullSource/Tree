local var0 = class("Responder")
local var1 = {
	__index = function(arg0, arg1)
		arg0[arg1] = {}

		return arg0[arg1]
	end
}

function var0.Ctor(arg0, arg1)
	arg0.binder = arg1
end

function var0.reset(arg0)
	if arg0.map then
		for iter0, iter1 in pairs(arg0.map) do
			underscore.each(iter1, function(arg0)
				Destroy(arg0._tf)
			end)
		end
	end

	arg0.timeRiver = {}
	arg0.fireList = {}
	arg0.eventRange = {}
	arg0.map = setmetatable({}, var1)
	arg0.findingResult = {}
	arg0.reactorRyza = nil
	arg0.enemyCount = 0
end

function var0.AddListener(arg0, arg1, arg2, arg3)
	arg0.eventRange[arg1] = arg0.eventRange[arg1] or setmetatable({}, var1)

	local var0 = arg0.eventRange[arg1]

	for iter0, iter1 in ipairs(arg3) do
		table.insert(var0[tostring(arg2.pos + iter1)], arg2)
	end
end

function var0.RemoveListener(arg0, arg1, arg2, arg3)
	if not arg3 then
		return
	end

	local var0 = arg0.eventRange[arg1]

	for iter0, iter1 in ipairs(arg3) do
		table.removebyvalue(var0[tostring(arg2.pos + iter1)], arg2)
	end
end

local var2 = {
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

function var0.InRange(arg0, arg1)
	local var0 = arg0.binder.config.mapSize

	if arg1.x < 0 or arg1.y < 0 or arg1.x >= var0.x or arg1.y >= var0.y then
		return false
	else
		return true
	end
end

function var0.GetCrossFire(arg0, arg1, arg2)
	local var0 = {
		0,
		0,
		0,
		0
	}

	for iter0, iter1 in ipairs(var2) do
		for iter2 = 1, arg2 do
			local var1 = arg1 + NewPos(unpack(iter1)) * iter2
			local var2 = arg0:GetFirePassability(var1)

			if var2 < 2 then
				var0[iter0] = iter2
			end

			if var2 > 0 then
				break
			end
		end
	end

	local var3 = {}

	for iter3, iter4 in ipairs(arg0.timeRiver) do
		if isa(iter4, EnemyConductor) then
			iter4:CheckBlock(arg1, var0, var3)
		end
	end

	local var4 = {
		{
			0,
			0
		}
	}

	for iter5, iter6 in ipairs(var2) do
		for iter7 = 1, var0[iter5] do
			table.insert(var4, {
				iter6[1] * iter7,
				iter6[2] * iter7
			})
		end
	end

	return var0, var4, var3
end

function var0.getRangeList(arg0, arg1, arg2)
	return underscore.map(arg2, function(arg0)
		return arg1.pos + NewPos(unpack(arg0))
	end)
end

function var0.EventCall(arg0, arg1, arg2, arg3, arg4)
	if isa(arg4, Reactor) then
		if arg4 == MoveRyza then
			arg0.reactorRyza:React(arg1, arg2)
		else
			arg4:React(arg1, arg2)
		end
	else
		local var0 = arg0.eventRange[arg1]

		if not var0 then
			return
		end

		for iter0, iter1 in ipairs(arg0:getRangeList(arg3, arg4)) do
			for iter2, iter3 in ipairs(underscore.rest(var0[tostring(iter1)], 1)) do
				iter3:React(arg1, arg2)
			end
		end
	end
end

function var0.CreateCall(arg0, arg1)
	table.insert(arg0.map[tostring(arg1.pos)], arg1)

	if arg1:InTimeRiver() then
		table.insert(arg0.timeRiver, arg1)
	end

	if isa(arg1, MoveRyza) then
		arg0.reactorRyza = arg1
	elseif isa(arg1, MoveEnemy) then
		arg0.enemyCount = defaultValue(arg0.enemyCount, 0) + 1
	elseif isa(arg1, EffectFire) then
		table.insert(arg0.fireList, arg1)
	end
end

function var0.DestroyCall(arg0, arg1, arg2)
	table.removebyvalue(arg0.map[tostring(arg1.pos)], arg1)

	if arg1:InTimeRiver() then
		table.removebyvalue(arg0.timeRiver, arg1)
	end

	arg0.binder:emit(RyzaMiniGameView.EVENT_DESTROY, arg1, arg2)

	if isa(arg1, MoveEnemy) then
		arg0.enemyCount = arg0.enemyCount - 1

		if arg0.enemyCount == 0 then
			arg0:GameFinish(true)
		end
	elseif isa(arg1, EffectFire) then
		table.removebyvalue(arg0.fireList, arg1)
	end
end

function var0.GetCellPassability(arg0, arg1)
	if not arg0:InRange(arg1) then
		return false
	end

	for iter0, iter1 in ipairs(arg0.map[tostring(arg1)]) do
		if not iter1:CellPassability() then
			return false, iter1
		end
	end

	return true
end

function var0.GetFirePassability(arg0, arg1)
	if not arg0:InRange(arg1) then
		return 2
	end

	return underscore.reduce(arg0.map[tostring(arg1)], 0, function(arg0, arg1)
		return math.max(arg0, arg1:FirePassability())
	end)
end

function var0.GetCellCanBomb(arg0, arg1)
	if not arg0:InRange(arg1) then
		return false
	end

	return underscore.all(arg0.map[tostring(arg1)], function(arg0)
		return not isa(arg0, ObjectBomb)
	end)
end

function var0.TimeFlow(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.timeRiver) do
		iter1:TimeUpdate(arg1)
	end
end

function var0.Create(arg0, arg1)
	arg0.binder:emit(RyzaMiniGameView.EVENT_CREATE, arg1)
end

function var0.GetJoyStick(arg0)
	return NewPos(arg0.binder.uiMgr.hrz, -arg0.binder.uiMgr.vtc)
end

function var0.RyzaBomb(arg0)
	arg0.reactorRyza:SetBomb()
end

function var0.GameFinish(arg0, arg1)
	arg0.binder:emit(RyzaMiniGameView.EVENT_FINISH, arg1)
end

function var0.WindowFocrus(arg0, arg1)
	arg0.binder:emit(RyzaMiniGameView.EVENT_WINDOW_FOCUS, arg1)
end

function var0.SyncStatus(arg0, arg1, arg2, arg3)
	arg0.binder:emit(RyzaMiniGameView.EVENT_STATUS_SYNC, arg1, arg2, arg3)
end

function var0.UpdateHide(arg0, arg1, arg2)
	arg0.binder:emit(RyzaMiniGameView.EVENT_UPDATE_HIDE, arg1, arg2)
end

function var0.UpdatePos(arg0, arg1, arg2)
	table.removebyvalue(arg0.map[tostring(arg1.pos)], arg1)
	table.insert(arg0.map[tostring(arg2)], arg1)
end

local function var3(arg0, arg1)
	local var0 = arg1.pos - arg0.pos

	for iter0, iter1 in ipairs(arg0.range) do
		for iter2, iter3 in ipairs(arg1.range) do
			local var1 = {
				{},
				{}
			}

			for iter4, iter5 in ipairs(iter1) do
				var1[iter4][1] = iter5[1] - iter3[iter4][2]
				var1[iter4][2] = iter5[2] - iter3[iter4][1]
			end

			if var0.x > var1[1][1] and var0.x < var1[1][2] and var0.y > var1[2][1] and var0.y < var1[2][2] then
				return true
			end
		end
	end

	return false
end

function var0.Wayfinding(arg0, arg1)
	if arg0.reactorRyza.hide or arg0:CollideRyza(arg1) then
		arg0.findingResult[arg1] = nil

		return {
			arg0.realPos
		}
	elseif arg0.findingResult[arg1] then
		local var0 = arg0.findingResult[arg1]

		if var0.ryzaPos == arg0.reactorRyza.pos and var0.reactorPos == arg1.pos then
			return var0.path
		else
			arg0.findingResult[arg1] = nil
		end
	end

	local var1 = {
		arg1.pos
	}
	local var2 = {
		[tostring(arg1.pos)] = 0
	}

	local function var3(arg0)
		local var0 = {}

		while var2[tostring(var1[arg0])] > 0 do
			table.insert(var0, var1[arg0])

			arg0 = var2[tostring(var1[arg0])]
		end

		arg0.findingResult[arg1] = {
			ryzaPos = arg0.reactorRyza.pos,
			reactorPos = arg1.pos,
			path = var0
		}

		return var0
	end

	local var4 = 0
	local var5

	while var4 < #var1 do
		var4 = var4 + 1

		for iter0, iter1 in ipairs(var2) do
			local var6 = var1[var4] + NewPos(unpack(iter1))

			if var2[tostring(var6)] == nil then
				if arg0:GetCellPassability(var6) then
					var2[tostring(var6)] = var4

					table.insert(var1, var6)

					if var3({
						pos = arg0.reactorRyza.realPos,
						range = arg0.reactorRyza:GetCollideRange()
					}, {
						pos = var6,
						range = arg1:GetCollideRange()
					}) then
						return var3(#var1)
					end
				else
					var2[tostring(var6)] = false
				end
			end
		end

		for iter2, iter3 in ipairs(var2) do
			local var7 = NewPos(unpack(iter3))
			local var8 = NewPos(unpack(var2[iter2 % 4 + 1]))
			local var9 = var1[var4] + var7 + var8

			if var2[tostring(var1[var4] + var7)] and var2[tostring(var1[var4] + var8)] and var2[tostring(var9)] == nil and arg0:GetCellPassability(var9) then
				var2[tostring(var9)] = var4

				table.insert(var1, var9)

				if var3({
					pos = arg0.reactorRyza.realPos,
					range = arg0.reactorRyza:GetCollideRange()
				}, {
					pos = var9,
					range = arg1:GetCollideRange()
				}) then
					return var3(#var1)
				end
			end
		end
	end
end

function var0.SearchRyza(arg0, arg1, arg2)
	if arg0.reactorRyza.hide then
		return false
	else
		return ((arg1.realPos or arg1.pos) - arg0.reactorRyza.realPos):SqrMagnitude() < arg2 * arg2
	end
end

function var0.CollideRyza(arg0, arg1)
	return var3({
		pos = arg0.reactorRyza.realPos,
		range = arg0.reactorRyza:GetCollideRange()
	}, {
		pos = arg1.realPos,
		range = arg1:GetCollideRange()
	})
end

function var0.CollideFire(arg0, arg1)
	return underscore.filter(arg0.fireList, function(arg0)
		return var3({
			pos = arg0.pos,
			range = arg0:GetCollideRange()
		}, {
			pos = arg1.realPos,
			range = arg1:GetCollideRange()
		})
	end)
end

return var0
