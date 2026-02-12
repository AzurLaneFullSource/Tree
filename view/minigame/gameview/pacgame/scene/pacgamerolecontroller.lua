local var0_0 = class("PacGameRoleController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneMask = arg1_1
	arg0_1._event = arg2_1
	arg0_1._runningData = arg3_1
	arg0_1._content = findTF(arg0_1._sceneMask, "sceneContainer/scene/content/map")
end

function var0_0.SetParent(arg0_2)
	return
end

function var0_0.SetPosition(arg0_3)
	return
end

function var0_0.SetScale(arg0_4)
	return
end

function var0_0.Prepare(arg0_5)
	local var0_5 = arg0_5._runningData:GetConfig("player")
	local var1_5 = arg0_5._runningData:GetConfig("enemy")

	arg0_5._player = arg0_5:createRole(var0_5, false)
	arg0_5._enemys = arg0_5:createRoles(var1_5, true)

	arg0_5._player:SetPlayer(true)
	arg0_5._runningData:SetPlayer(arg0_5._player)
	arg0_5._runningData:SetEnemys(arg0_5._enemys)

	local var2_5 = arg0_5._runningData:GetMapConfig("player_start")
	local var3_5 = arg0_5._runningData:GetMapConfig("enemy_start")

	arg0_5:setRolePosWithIndex(arg0_5._player, var2_5, true)
	arg0_5:setRolesPosWithIndex(arg0_5._enemys, var3_5, true)
end

function var0_0.Start(arg0_6)
	return
end

function var0_0.Step(arg0_7, arg1_7)
	arg0_7._player:Step(arg1_7)

	for iter0_7, iter1_7 in ipairs(arg0_7._enemys) do
		iter1_7:Step(arg1_7)
	end

	arg0_7:updatePlayerDirect()
end

function var0_0.Clear(arg0_8)
	if arg0_8._player then
		arg0_8._player:Dispose()

		arg0_8._player = nil
	end

	if arg0_8._enemys then
		for iter0_8, iter1_8 in ipairs(arg0_8._enemys) do
			iter1_8:Dispose()
		end

		arg0_8._enemys = {}
	end

	arg0_8._runningData:SetPlayer(nil)
	arg0_8._runningData:SetEnemys({})
end

function var0_0.Stop(arg0_9)
	return
end

function var0_0.Resume(arg0_10)
	return
end

function var0_0.Dispose(arg0_11)
	return
end

function var0_0.updatePlayerDirect(arg0_12)
	local var0_12 = arg0_12._runningData:GetJoyData()
	local var1_12 = var0_12.x
	local var2_12 = var0_12.y

	if math.abs(var1_12) - math.abs(var2_12) >= 0.3 then
		var2_12 = 0
	elseif math.abs(var1_12) - math.abs(var2_12) <= -0.3 then
		var1_12 = 0
	end

	local var3_12 = math.sign(var1_12)
	local var4_12 = math.sign(var2_12)

	arg0_12._player:SetDirect({
		var3_12,
		var4_12
	})
end

function var0_0.setRolePosWithIndex(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg0_13._runningData:GetPosByIndex(arg2_13)

	arg1_13:SetPosition(var0_13)
	arg1_13:SetActive(arg3_13)
	arg1_13:SetGridIndex(arg2_13)
	arg1_13:SetStartIndex(arg2_13)
end

function var0_0.setRolesPosWithIndex(arg0_14, arg1_14, arg2_14, arg3_14)
	for iter0_14 = 1, #arg1_14 do
		arg0_14:setRolePosWithIndex(arg1_14[iter0_14], arg2_14[iter0_14], arg3_14)
	end
end

function var0_0.createRole(arg0_15, arg1_15)
	local var0_15 = PacGameConst.role_data[arg1_15]
	local var1_15 = var0_15.prefab
	local var2_15 = arg0_15._runningData:GetTplItemFromPool(var1_15, arg0_15._content)

	return (PacGameRole.New(var2_15, var0_15))
end

function var0_0.createRoles(arg0_16, arg1_16)
	local var0_16 = {}

	for iter0_16 = 1, #arg1_16 do
		local var1_16 = arg0_16:createRole(arg1_16[iter0_16])

		table.insert(var0_16, var1_16)
	end

	return var0_16
end

return var0_0
