local var0_0 = class("FuShunEnemySpawner")
local var1_0 = 1
local var2_0 = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.parent = arg1_1
	arg0_1.index = 0
	arg0_1.score = 0
	arg0_1.changeTime = -1
	arg0_1.mode = var1_0
	arg0_1.OnSpawn = arg2_1
	arg0_1.targetTime = 0
	arg0_1.delta = 0
	arg0_1.starting = false
end

function var0_0.Start(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.delta = 0
	arg0_2.changeTime = -1

	if arg3_2 then
		arg0_2.delta = arg2_2
	end

	arg0_2.targetTime = arg2_2
	arg0_2.mode = arg1_2
	arg0_2.starting = true

	FushunAdventureGame.LOG(" spawner time  :", arg2_2)
end

function var0_0.Update(arg0_3)
	if not arg0_3.starting then
		return
	end

	arg0_3.delta = arg0_3.delta + Time.deltaTime

	if arg0_3.delta >= arg0_3.targetTime then
		arg0_3.delta = 0

		arg0_3:Spawn()

		if arg0_3.changeTime ~= -1 then
			arg0_3:Start(arg0_3.mode, arg0_3.changeTime, false)
		end
	end
end

function var0_0.NormalMode(arg0_4)
	local var0_4 = arg0_4:CalcTime(arg0_4.score)

	arg0_4:Start(var1_0, var0_4, true)
end

function var0_0.CarzyMode(arg0_5)
	local var0_5 = FushunAdventureGameConst.EX_ENEMY_SPAWN_TIME

	arg0_5:Start(var2_0, var0_5, true)
end

function var0_0.Spawn(arg0_6)
	local var0_6 = arg0_6.mode

	arg0_6.index = arg0_6.index + 1

	local var1_6 = arg0_6.index
	local var2_6 = arg0_6:GetConfigByScore(arg0_6.score)

	assert(var2_6)
	ResourceMgr.Inst:getAssetAsync("ui/fa_" .. var2_6.name, "", function(arg0_7)
		local var0_7 = instantiate(arg0_7)

		var0_7.transform:SetParent(arg0_6.parent, false)

		if arg0_6.OnSpawn then
			arg0_6.OnSpawn({
				go = var0_7,
				config = var2_6,
				speed = var0_6 == var1_0 and var2_6.speed or var2_6.crazy_speed,
				index = var1_6
			})
		end
	end, true, true)
end

function var0_0.GetConfigByScore(arg0_8, arg1_8)
	local var0_8 = FushunAdventureGameConst.PROPABILITES
	local var1_8

	for iter0_8, iter1_8 in ipairs(var0_8) do
		local var2_8 = iter1_8[1][1]
		local var3_8 = iter1_8[1][2]

		if var2_8 <= arg1_8 and arg1_8 <= var3_8 then
			var1_8 = iter1_8

			break
		end
	end

	var1_8 = var1_8 or var0_8[#var0_8]

	local var4_8 = var1_8[2]
	local var5_8 = var1_8[3]
	local var6_8 = var1_8[4]
	local var7_8 = math.random(1, 100)

	FushunAdventureGame.LOG("rate :", var4_8, var5_8, var6_8, " r :", var7_8)

	local var8_8 = 1

	if var4_8 < var7_8 and var7_8 <= var4_8 + var5_8 then
		var8_8 = 2
	elseif var7_8 > var4_8 + var5_8 and var7_8 <= 100 then
		var8_8 = 3
	end

	return FushunAdventureGameConst.ENEMYS[var8_8]
end

function var0_0.UpdateScore(arg0_9, arg1_9)
	arg0_9.score = arg1_9

	if arg0_9.mode == var2_0 then
		return
	end

	local var0_9 = arg0_9:CalcTime(arg1_9)

	if arg0_9.targetTime ~= var0_9 then
		arg0_9.changeTime = var0_9
	end
end

function var0_0.CalcTime(arg0_10, arg1_10)
	local var0_10 = FushunAdventureGameConst.ENEMY_SPAWN_TIME_ADDITION
	local var1_10

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var2_10 = iter1_10[1][1]
		local var3_10 = iter1_10[1][2]

		if var2_10 <= arg1_10 and arg1_10 <= var3_10 then
			var1_10 = iter1_10

			break
		end
	end

	var1_10 = var1_10 or var0_10[#var0_10]

	local var4_10 = var1_10[2]

	return (math.random(var4_10[1], var4_10[2]))
end

function var0_0.Stop(arg0_11)
	arg0_11.starting = false
end

function var0_0.Dispose(arg0_12)
	arg0_12:Stop()
end

return var0_0
