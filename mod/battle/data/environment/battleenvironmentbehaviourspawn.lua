ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleFormulas
local var4 = class("BattleEnvironmentBehaviourSpawn", var0.Battle.BattleEnvironmentBehaviour)

var0.Battle.BattleEnvironmentBehaviourSpawn = var4
var4.__name = "BattleEnvironmentBehaviourSpawn"

function var4.Ctor(arg0)
	arg0._moveEndTime = nil
	arg0._targetIndex = 0

	var4.super.Ctor(arg0)
end

function var4.SetTemplate(arg0, arg1)
	var4.super.SetTemplate(arg0, arg1)

	arg0._content = arg1.content
	arg0._route = arg1.route or {}
	arg0._reloadTime = arg1.reload_time
	arg0._rounds = arg1.rounds
end

function var4.doBehaviour(arg0)
	arg0._targetIndex = arg0._targetIndex + 1

	if arg0._targetIndex <= arg0._rounds then
		local var0 = arg0._route[arg0._targetIndex]
		local var1 = var0.Battle.BattleDataProxy.GetInstance()
		local var2 = arg0._unit._aoeData
		local var3 = var2:GetPosition()
		local var4 = Clone(arg0._content)

		if var0 then
			table.merge(var4, var0)
		end

		local var5 = var4.count
		local var6 = var4.child_prefab
		local var7

		if var2:GetAreaType() == var1.AreaType.CUBE then
			local var8, var9 = unpack(var6.cld_data)

			var7 = arg0.GenerateRandomRectanglePosition(var2:GetWidth(), var2:GetHeight(), var5, math.max(var8, var9 or 0))
		elseif var2:GetAreaType() == var1.AreaType.COLUMN then
			local var10, var11 = unpack(var6.cld_data)

			var7 = arg0.GenerateRandomCirclePosition(var2:GetRange(), var5, math.max(var10, var11 or 0))
		end

		for iter0 = 1, var5 do
			var7[iter0] = var7[iter0] + var3
		end

		seriesAsync({
			function(arg0)
				if not var4.alert then
					arg0()

					return
				end

				for iter0 = 1, var5 do
					local var0 = var7[iter0]

					arg0.PlayAlert(var4.alert, var0)
				end

				arg0:RemoveAlertTimer()

				arg0._alertTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, var4.alert.delay or 1, arg0, true)
			end,
			function(arg0)
				for iter0 = 1, var5 do
					local var0 = Clone(var6)
					local var1 = var7[iter0]

					var0.coordinate = {
						var1.x,
						var1.y,
						var1.z
					}

					var1:SpawnEnvironment(var0)
				end
			end
		})
		var4.super.doBehaviour(arg0)
	else
		arg0:doExpire()
	end
end

function var4.RemoveAlertTimer(arg0)
	if arg0._alertTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._alertTimer)
	end

	arg0._alertTimer = nil
end

function var4.PlayAlert(arg0, arg1)
	local var0 = arg0.range
	local var1 = arg0.alert_fx

	if not var1 then
		return
	end

	local var2 = var0.Battle.BattleFXPool.GetInstance():GetFX(var1)
	local var3 = var2.transform
	local var4 = 0
	local var5 = pg.effect_offset

	if var5[var1] and var5[var1].y_scale == true then
		var4 = var0
	end

	var3.localScale = Vector3(var0, var4, var0)

	pg.EffectMgr.GetInstance():PlayBattleEffect(var2, arg1)
end

local var5 = math

function var4.GenerateRandomRectanglePosition(arg0, arg1, arg2, arg3)
	local var0 = var5.ceil(var5.sqrt(arg2))
	local var1 = {}

	for iter0 = 1, var0 * var0 do
		table.insert(var1, {
			weight = 65536,
			rst = iter0
		})
	end

	local var2 = {}

	for iter1 = 1, arg2 do
		local var3 = var3.WeightRandom(var1)

		var1[var3].weight = 0

		local var4 = var5.floor((var3 - 1) / var0)
		local var5 = var4 * var0

		for iter2 = 0, var0 - 1 do
			var1[var5 + iter2 + 1].weight = var1[var5 + iter2 + 1].weight / 2
		end

		local var6 = var3 - var4 * var0

		for iter3 = 0, var0 - 1 do
			var1[var6 + iter3 * var0].weight = var1[var6 + iter3 * var0].weight / 2
		end

		arg3 = arg3 / 2

		local var7 = (var6 - 1 - var0 / 2) * (arg0 / var0) + var5.random(1, 1000) / 1000 * (arg0 / var0 - 2 * arg3) + arg3
		local var8 = (var4 - var0 / 2) * (arg1 / var0) + var5.random(1, 1000) / 1000 * (arg1 / var0 - 2 * arg3) + arg3

		table.insert(var2, Vector3(var7, 0, var8))
	end

	return var2
end

local var6 = {
	Vector2(0, 0),
	Vector2(-0.66, 0),
	Vector2(-0.33, 0.58),
	Vector2(0.33, 0.58),
	Vector2(0.66, 0),
	Vector2(0.33, -0.58),
	Vector2(-0.33, -0.58)
}

function var4.GenerateRandomCirclePosition(arg0, arg1, arg2)
	local var0 = 1
	local var1 = 1
	local var2 = arg0

	while var1 < arg1 do
		var1 = var1 * 7
		var0 = var0 + 1
		var2 = var2 / 3
	end

	local var3 = {}

	for iter0 = 1, var1 do
		table.insert(var3, {
			weight = 256,
			rst = iter0
		})
	end

	local var4 = {}

	for iter1 = 1, arg1 do
		local var5 = var3.WeightRandom(var3)

		var3[var5].weight = 0

		local var6 = var5 - 1
		local var7 = 1
		local var8 = Vector2(0, 0)
		local var9 = var2

		for iter2 = var0, 2, -1 do
			local var10 = var6

			var6 = var5.floor(var6 / 7)

			local var11 = var10 - var6 * 7

			var9 = var9 * 3

			var8:Add(var9 * var6[var11 + 1])

			var7 = var7 * 7

			if iter2 > 2 and iter2 == var0 then
				for iter3 = var6 * var7 + 1, var6 * var7 + var7 do
					var3[iter3].weight = var3[iter3].weight / 2
				end
			end
		end

		local var12 = var5.random(1, 360)
		local var13 = var5.random(1, 1000) / 1000 * var5.max(var2 - arg2, 0)

		var8:Add(Vector2(var13 * var5.cos(var12), var13 * var5.sin(var12)))
		table.insert(var4, Vector3(var8.x, 0, var8.y))
	end

	return var4
end

function var4.Dispose(arg0)
	arg0:RemoveAlertTimer()
	table.clear(arg0)
	var4.super.Dispose(arg0)
end
