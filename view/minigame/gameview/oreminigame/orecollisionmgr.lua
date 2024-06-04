local var0 = class("OreCollisionMgr")

function var0.Ctor(arg0, arg1)
	arg0.binder = arg1
	arg0.oreMap = {}
	arg0.enemyMap = {}
end

function var0.SetAkashiObject(arg0, arg1)
	arg0.akashiControl = arg1
end

function var0.AddOreObject(arg0, arg1, arg2)
	arg0.oreMap[arg1] = arg2
end

function var0.RemoveOreObject(arg0, arg1, arg2)
	arg0.oreMap[arg1] = nil
end

function var0.AddEnemyObject(arg0, arg1, arg2, arg3)
	if not arg0.enemyMap[arg1] then
		arg0.enemyMap[arg1] = {}
	end

	arg0.enemyMap[arg1][arg2] = arg3
end

function var0.RemoveEnemyObject(arg0, arg1, arg2, arg3)
	arg0.enemyMap[arg1][arg2] = nil
end

function var0.Reset(arg0)
	arg0.oreMap = {}
	arg0.enemyMap = {}
	arg0.oreTarget = ""
end

local function var1(arg0, arg1)
	local var0 = {
		x = math.abs(arg1.pos.x - arg0.pos.x),
		y = math.abs(arg1.pos.y - arg0.pos.y)
	}
	local var1 = arg0.aabb
	local var2 = arg1.aabb
	local var3 = math.abs(var1[2][1] - var1[1][1]) / 2 + math.abs(var2[2][1] - var2[1][1]) / 2
	local var4 = math.abs(var1[2][2] - var1[1][2]) / 2 + math.abs(var2[2][2] - var2[1][2]) / 2

	if var3 > var0.x and var4 > var0.y then
		return true
	end

	return false
end

local function var2(arg0, arg1, arg2)
	switch(arg0, {
		W = function()
			return arg2.x < arg1.x
		end,
		N = function()
			return arg2.y > arg1.y
		end,
		E = function()
			return arg2.x > arg1.x
		end,
		S = function()
			return arg2.y < arg1.y
		end
	})

	return false
end

function var0.GetCarryOreTarget(arg0)
	local var0
	local var1
	local var2 = OreGameConfig.CARRY_RADIUS
	local var3 = OreGameConfig.CARRY_LOOKAT_RADIUS
	local var4 = arg0.akashiControl:GetAnimDirLabel()
	local var5 = arg0.akashiControl:GetCollisionInfo().pos

	for iter0, iter1 in pairs(arg0.oreMap) do
		local var6 = iter1:GetCollisionInfo().pos

		if var2(var4, var5, var6) then
			local var7 = Vector2.Distance(var5, var6)

			if var7 <= var3 and (not var1 or var7 <= var1) then
				var0, var1 = iter0, var7
			end
		end
	end

	if var0 and var1 then
		return var0
	end

	for iter2, iter3 in pairs(arg0.oreMap) do
		local var8 = iter3:GetCollisionInfo().pos
		local var9 = Vector2.Distance(var5, var8)

		if var9 <= var2 and (not var1 or var9 <= var1) then
			var0, var1 = iter2, var9
		end
	end

	return var0 or ""
end

function var0.UpdateOreStatus(arg0)
	local var0 = arg0:GetCarryOreTarget()

	if arg0.oreTarget ~= var0 then
		arg0.oreTarget = var0

		arg0.binder:emit(OreGameConfig.EVENT_UPDATE_ORE_TARGET, {
			index = arg0.oreTarget
		})
	end
end

function var0.UpdateAkashiCollision(arg0)
	if arg0.akashiControl:IsInvincible() then
		return
	end

	local var0 = arg0.akashiControl:GetCollisionInfo()

	for iter0, iter1 in pairs(arg0.enemyMap) do
		for iter2, iter3 in pairs(iter1) do
			local var1 = iter3:GetCollisionInfo()

			if var1(var0, var1) then
				arg0.binder:emit(OreGameConfig.EVENT_AKASHI_COLLISION, {
					a = arg0.akashiControl,
					b = iter3
				})

				return
			end
		end
	end
end

function var0.UpdateEnemyCollision(arg0)
	for iter0, iter1 in pairs(arg0.enemyMap) do
		local var0 = {}

		for iter2, iter3 in pairs(iter1) do
			if not var0[iter2] then
				var0[iter2] = {}
			end

			local var1 = iter3:GetCollisionInfo()

			for iter4, iter5 in pairs(iter1) do
				if not var0[iter4] then
					var0[iter4] = {}
				end

				if iter4 ~= iter2 and not var0[iter2][iter4] and not var0[iter4][iter2] then
					local var2 = iter5:GetCollisionInfo()

					if var1(var1, var2) then
						arg0.binder:emit(OreGameConfig.EVENT_ENEMY_COLLISION, {
							a = iter3,
							b = iter5
						})
					end

					var0[iter2][iter4] = true
					var0[iter4][iter2] = true
				end
			end
		end
	end
end

function var0.OnTimer(arg0, arg1)
	arg0:UpdateOreStatus()
	arg0:UpdateAkashiCollision()
	arg0:UpdateEnemyCollision()
end

return var0
