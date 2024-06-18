ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = class("BattleEnvironmentBehaviourSpawn", var0_0.Battle.BattleEnvironmentBehaviour)

var0_0.Battle.BattleEnvironmentBehaviourSpawn = var4_0
var4_0.__name = "BattleEnvironmentBehaviourSpawn"

function var4_0.Ctor(arg0_1)
	arg0_1._moveEndTime = nil
	arg0_1._targetIndex = 0

	var4_0.super.Ctor(arg0_1)
end

function var4_0.SetTemplate(arg0_2, arg1_2)
	var4_0.super.SetTemplate(arg0_2, arg1_2)

	arg0_2._content = arg1_2.content
	arg0_2._route = arg1_2.route or {}
	arg0_2._reloadTime = arg1_2.reload_time
	arg0_2._rounds = arg1_2.rounds
end

function var4_0.doBehaviour(arg0_3)
	arg0_3._targetIndex = arg0_3._targetIndex + 1

	if arg0_3._targetIndex <= arg0_3._rounds then
		local var0_3 = arg0_3._route[arg0_3._targetIndex]
		local var1_3 = var0_0.Battle.BattleDataProxy.GetInstance()
		local var2_3 = arg0_3._unit._aoeData
		local var3_3 = var2_3:GetPosition()
		local var4_3 = Clone(arg0_3._content)

		if var0_3 then
			table.merge(var4_3, var0_3)
		end

		local var5_3 = var4_3.count
		local var6_3 = var4_3.child_prefab
		local var7_3

		if var2_3:GetAreaType() == var1_0.AreaType.CUBE then
			local var8_3, var9_3 = unpack(var6_3.cld_data)

			var7_3 = arg0_3.GenerateRandomRectanglePosition(var2_3:GetWidth(), var2_3:GetHeight(), var5_3, math.max(var8_3, var9_3 or 0))
		elseif var2_3:GetAreaType() == var1_0.AreaType.COLUMN then
			local var10_3, var11_3 = unpack(var6_3.cld_data)

			var7_3 = arg0_3.GenerateRandomCirclePosition(var2_3:GetRange(), var5_3, math.max(var10_3, var11_3 or 0))
		end

		for iter0_3 = 1, var5_3 do
			var7_3[iter0_3] = var7_3[iter0_3] + var3_3
		end

		seriesAsync({
			function(arg0_4)
				if not var4_3.alert then
					arg0_4()

					return
				end

				for iter0_4 = 1, var5_3 do
					local var0_4 = var7_3[iter0_4]

					arg0_3.PlayAlert(var4_3.alert, var0_4)
				end

				arg0_3:RemoveAlertTimer()

				arg0_3._alertTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, var4_3.alert.delay or 1, arg0_4, true)
			end,
			function(arg0_5)
				for iter0_5 = 1, var5_3 do
					local var0_5 = Clone(var6_3)
					local var1_5 = var7_3[iter0_5]

					var0_5.coordinate = {
						var1_5.x,
						var1_5.y,
						var1_5.z
					}

					var1_3:SpawnEnvironment(var0_5)
				end
			end
		})
		var4_0.super.doBehaviour(arg0_3)
	else
		arg0_3:doExpire()
	end
end

function var4_0.RemoveAlertTimer(arg0_6)
	if arg0_6._alertTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_6._alertTimer)
	end

	arg0_6._alertTimer = nil
end

function var4_0.PlayAlert(arg0_7, arg1_7)
	local var0_7 = arg0_7.range
	local var1_7 = arg0_7.alert_fx

	if not var1_7 then
		return
	end

	local var2_7 = var0_0.Battle.BattleFXPool.GetInstance():GetFX(var1_7)
	local var3_7 = var2_7.transform
	local var4_7 = 0
	local var5_7 = pg.effect_offset

	if var5_7[var1_7] and var5_7[var1_7].y_scale == true then
		var4_7 = var0_7
	end

	var3_7.localScale = Vector3(var0_7, var4_7, var0_7)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var2_7, arg1_7)
end

local var5_0 = math

function var4_0.GenerateRandomRectanglePosition(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = var5_0.ceil(var5_0.sqrt(arg2_8))
	local var1_8 = {}

	for iter0_8 = 1, var0_8 * var0_8 do
		table.insert(var1_8, {
			weight = 65536,
			rst = iter0_8
		})
	end

	local var2_8 = {}

	for iter1_8 = 1, arg2_8 do
		local var3_8 = var3_0.WeightRandom(var1_8)

		var1_8[var3_8].weight = 0

		local var4_8 = var5_0.floor((var3_8 - 1) / var0_8)
		local var5_8 = var4_8 * var0_8

		for iter2_8 = 0, var0_8 - 1 do
			var1_8[var5_8 + iter2_8 + 1].weight = var1_8[var5_8 + iter2_8 + 1].weight / 2
		end

		local var6_8 = var3_8 - var4_8 * var0_8

		for iter3_8 = 0, var0_8 - 1 do
			var1_8[var6_8 + iter3_8 * var0_8].weight = var1_8[var6_8 + iter3_8 * var0_8].weight / 2
		end

		arg3_8 = arg3_8 / 2

		local var7_8 = (var6_8 - 1 - var0_8 / 2) * (arg0_8 / var0_8) + var5_0.random(1, 1000) / 1000 * (arg0_8 / var0_8 - 2 * arg3_8) + arg3_8
		local var8_8 = (var4_8 - var0_8 / 2) * (arg1_8 / var0_8) + var5_0.random(1, 1000) / 1000 * (arg1_8 / var0_8 - 2 * arg3_8) + arg3_8

		table.insert(var2_8, Vector3(var7_8, 0, var8_8))
	end

	return var2_8
end

local var6_0 = {
	Vector2(0, 0),
	Vector2(-0.66, 0),
	Vector2(-0.33, 0.58),
	Vector2(0.33, 0.58),
	Vector2(0.66, 0),
	Vector2(0.33, -0.58),
	Vector2(-0.33, -0.58)
}

function var4_0.GenerateRandomCirclePosition(arg0_9, arg1_9, arg2_9)
	local var0_9 = 1
	local var1_9 = 1
	local var2_9 = arg0_9

	while var1_9 < arg1_9 do
		var1_9 = var1_9 * 7
		var0_9 = var0_9 + 1
		var2_9 = var2_9 / 3
	end

	local var3_9 = {}

	for iter0_9 = 1, var1_9 do
		table.insert(var3_9, {
			weight = 256,
			rst = iter0_9
		})
	end

	local var4_9 = {}

	for iter1_9 = 1, arg1_9 do
		local var5_9 = var3_0.WeightRandom(var3_9)

		var3_9[var5_9].weight = 0

		local var6_9 = var5_9 - 1
		local var7_9 = 1
		local var8_9 = Vector2(0, 0)
		local var9_9 = var2_9

		for iter2_9 = var0_9, 2, -1 do
			local var10_9 = var6_9

			var6_9 = var5_0.floor(var6_9 / 7)

			local var11_9 = var10_9 - var6_9 * 7

			var9_9 = var9_9 * 3

			var8_9:Add(var9_9 * var6_0[var11_9 + 1])

			var7_9 = var7_9 * 7

			if iter2_9 > 2 and iter2_9 == var0_9 then
				for iter3_9 = var6_9 * var7_9 + 1, var6_9 * var7_9 + var7_9 do
					var3_9[iter3_9].weight = var3_9[iter3_9].weight / 2
				end
			end
		end

		local var12_9 = var5_0.random(1, 360)
		local var13_9 = var5_0.random(1, 1000) / 1000 * var5_0.max(var2_9 - arg2_9, 0)

		var8_9:Add(Vector2(var13_9 * var5_0.cos(var12_9), var13_9 * var5_0.sin(var12_9)))
		table.insert(var4_9, Vector3(var8_9.x, 0, var8_9.y))
	end

	return var4_9
end

function var4_0.Dispose(arg0_10)
	arg0_10:RemoveAlertTimer()
	table.clear(arg0_10)
	var4_0.super.Dispose(arg0_10)
end
