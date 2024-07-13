local var0_0 = class("OreCollisionMgr")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.binder = arg1_1
	arg0_1.oreMap = {}
	arg0_1.enemyMap = {}
end

function var0_0.SetAkashiObject(arg0_2, arg1_2)
	arg0_2.akashiControl = arg1_2
end

function var0_0.AddOreObject(arg0_3, arg1_3, arg2_3)
	arg0_3.oreMap[arg1_3] = arg2_3
end

function var0_0.RemoveOreObject(arg0_4, arg1_4, arg2_4)
	arg0_4.oreMap[arg1_4] = nil
end

function var0_0.AddEnemyObject(arg0_5, arg1_5, arg2_5, arg3_5)
	if not arg0_5.enemyMap[arg1_5] then
		arg0_5.enemyMap[arg1_5] = {}
	end

	arg0_5.enemyMap[arg1_5][arg2_5] = arg3_5
end

function var0_0.RemoveEnemyObject(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6.enemyMap[arg1_6][arg2_6] = nil
end

function var0_0.Reset(arg0_7)
	arg0_7.oreMap = {}
	arg0_7.enemyMap = {}
	arg0_7.oreTarget = ""
end

local function var1_0(arg0_8, arg1_8)
	local var0_8 = {
		x = math.abs(arg1_8.pos.x - arg0_8.pos.x),
		y = math.abs(arg1_8.pos.y - arg0_8.pos.y)
	}
	local var1_8 = arg0_8.aabb
	local var2_8 = arg1_8.aabb
	local var3_8 = math.abs(var1_8[2][1] - var1_8[1][1]) / 2 + math.abs(var2_8[2][1] - var2_8[1][1]) / 2
	local var4_8 = math.abs(var1_8[2][2] - var1_8[1][2]) / 2 + math.abs(var2_8[2][2] - var2_8[1][2]) / 2

	if var3_8 > var0_8.x and var4_8 > var0_8.y then
		return true
	end

	return false
end

local function var2_0(arg0_9, arg1_9, arg2_9)
	switch(arg0_9, {
		W = function()
			return arg2_9.x < arg1_9.x
		end,
		N = function()
			return arg2_9.y > arg1_9.y
		end,
		E = function()
			return arg2_9.x > arg1_9.x
		end,
		S = function()
			return arg2_9.y < arg1_9.y
		end
	})

	return false
end

function var0_0.GetCarryOreTarget(arg0_14)
	local var0_14
	local var1_14
	local var2_14 = OreGameConfig.CARRY_RADIUS
	local var3_14 = OreGameConfig.CARRY_LOOKAT_RADIUS
	local var4_14 = arg0_14.akashiControl:GetAnimDirLabel()
	local var5_14 = arg0_14.akashiControl:GetCollisionInfo().pos

	for iter0_14, iter1_14 in pairs(arg0_14.oreMap) do
		local var6_14 = iter1_14:GetCollisionInfo().pos

		if var2_0(var4_14, var5_14, var6_14) then
			local var7_14 = Vector2.Distance(var5_14, var6_14)

			if var7_14 <= var3_14 and (not var1_14 or var7_14 <= var1_14) then
				var0_14, var1_14 = iter0_14, var7_14
			end
		end
	end

	if var0_14 and var1_14 then
		return var0_14
	end

	for iter2_14, iter3_14 in pairs(arg0_14.oreMap) do
		local var8_14 = iter3_14:GetCollisionInfo().pos
		local var9_14 = Vector2.Distance(var5_14, var8_14)

		if var9_14 <= var2_14 and (not var1_14 or var9_14 <= var1_14) then
			var0_14, var1_14 = iter2_14, var9_14
		end
	end

	return var0_14 or ""
end

function var0_0.UpdateOreStatus(arg0_15)
	local var0_15 = arg0_15:GetCarryOreTarget()

	if arg0_15.oreTarget ~= var0_15 then
		arg0_15.oreTarget = var0_15

		arg0_15.binder:emit(OreGameConfig.EVENT_UPDATE_ORE_TARGET, {
			index = arg0_15.oreTarget
		})
	end
end

function var0_0.UpdateAkashiCollision(arg0_16)
	if arg0_16.akashiControl:IsInvincible() then
		return
	end

	local var0_16 = arg0_16.akashiControl:GetCollisionInfo()

	for iter0_16, iter1_16 in pairs(arg0_16.enemyMap) do
		for iter2_16, iter3_16 in pairs(iter1_16) do
			local var1_16 = iter3_16:GetCollisionInfo()

			if var1_0(var0_16, var1_16) then
				arg0_16.binder:emit(OreGameConfig.EVENT_AKASHI_COLLISION, {
					a = arg0_16.akashiControl,
					b = iter3_16
				})

				return
			end
		end
	end
end

function var0_0.UpdateEnemyCollision(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.enemyMap) do
		local var0_17 = {}

		for iter2_17, iter3_17 in pairs(iter1_17) do
			if not var0_17[iter2_17] then
				var0_17[iter2_17] = {}
			end

			local var1_17 = iter3_17:GetCollisionInfo()

			for iter4_17, iter5_17 in pairs(iter1_17) do
				if not var0_17[iter4_17] then
					var0_17[iter4_17] = {}
				end

				if iter4_17 ~= iter2_17 and not var0_17[iter2_17][iter4_17] and not var0_17[iter4_17][iter2_17] then
					local var2_17 = iter5_17:GetCollisionInfo()

					if var1_0(var1_17, var2_17) then
						arg0_17.binder:emit(OreGameConfig.EVENT_ENEMY_COLLISION, {
							a = iter3_17,
							b = iter5_17
						})
					end

					var0_17[iter2_17][iter4_17] = true
					var0_17[iter4_17][iter2_17] = true
				end
			end
		end
	end
end

function var0_0.OnTimer(arg0_18, arg1_18)
	arg0_18:UpdateOreStatus()
	arg0_18:UpdateAkashiCollision()
	arg0_18:UpdateEnemyCollision()
end

return var0_0
