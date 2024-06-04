local var0 = class("FuShunEnemySpawner")
local var1 = 1
local var2 = 2

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.parent = arg1
	arg0.index = 0
	arg0.score = 0
	arg0.changeTime = -1
	arg0.mode = var1
	arg0.OnSpawn = arg2
	arg0.targetTime = 0
	arg0.delta = 0
	arg0.starting = false
	arg0.fushunLoader = arg3
end

function var0.Start(arg0, arg1, arg2, arg3)
	arg0.delta = 0
	arg0.changeTime = -1

	if arg3 then
		arg0.delta = arg2
	end

	arg0.targetTime = arg2
	arg0.mode = arg1
	arg0.starting = true

	FushunAdventureGame.LOG(" spawner time  :", arg2)
end

function var0.Update(arg0)
	if not arg0.starting then
		return
	end

	arg0.delta = arg0.delta + Time.deltaTime

	if arg0.delta >= arg0.targetTime then
		arg0.delta = 0

		arg0:Spawn()

		if arg0.changeTime ~= -1 then
			arg0:Start(arg0.mode, arg0.changeTime, false)
		end
	end
end

function var0.NormalMode(arg0)
	local var0 = arg0:CalcTime(arg0.score)

	arg0:Start(var1, var0, true)
end

function var0.CarzyMode(arg0)
	local var0 = FushunAdventureGameConst.EX_ENEMY_SPAWN_TIME

	arg0:Start(var2, var0, true)
end

function var0.Spawn(arg0)
	local var0 = arg0.mode

	arg0.index = arg0.index + 1

	local var1 = arg0.index
	local var2 = arg0:GetConfigByScore(arg0.score)

	assert(var2)
	arg0.fushunLoader:GetPrefab("FushunAdventure/" .. var2.name, "", function(arg0)
		arg0.transform:SetParent(arg0.parent, false)

		if arg0.OnSpawn then
			arg0.OnSpawn({
				go = arg0,
				config = var2,
				speed = var0 == var1 and var2.speed or var2.crazy_speed,
				index = var1
			})
		end
	end, var2.name)
end

function var0.GetConfigByScore(arg0, arg1)
	local var0 = FushunAdventureGameConst.PROPABILITES
	local var1

	for iter0, iter1 in ipairs(var0) do
		local var2 = iter1[1][1]
		local var3 = iter1[1][2]

		if var2 <= arg1 and arg1 <= var3 then
			var1 = iter1

			break
		end
	end

	var1 = var1 or var0[#var0]

	local var4 = var1[2]
	local var5 = var1[3]
	local var6 = var1[4]
	local var7 = math.random(1, 100)

	FushunAdventureGame.LOG("rate :", var4, var5, var6, " r :", var7)

	local var8 = 1

	if var4 < var7 and var7 <= var4 + var5 then
		var8 = 2
	elseif var7 > var4 + var5 and var7 <= 100 then
		var8 = 3
	end

	return FushunAdventureGameConst.ENEMYS[var8]
end

function var0.UpdateScore(arg0, arg1)
	arg0.score = arg1

	if arg0.mode == var2 then
		return
	end

	local var0 = arg0:CalcTime(arg1)

	if arg0.targetTime ~= var0 then
		arg0.changeTime = var0
	end
end

function var0.CalcTime(arg0, arg1)
	local var0 = FushunAdventureGameConst.ENEMY_SPAWN_TIME_ADDITION
	local var1

	for iter0, iter1 in ipairs(var0) do
		local var2 = iter1[1][1]
		local var3 = iter1[1][2]

		if var2 <= arg1 and arg1 <= var3 then
			var1 = iter1

			break
		end
	end

	var1 = var1 or var0[#var0]

	local var4 = var1[2]

	return (math.random(var4[1], var4[2]))
end

function var0.Stop(arg0)
	arg0.starting = false
end

function var0.Dispose(arg0)
	arg0:Stop()
end

return var0
