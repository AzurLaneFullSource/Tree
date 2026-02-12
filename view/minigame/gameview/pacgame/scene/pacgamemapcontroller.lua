local var0_0 = class("PacGameMapController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneMask = arg1_1
	arg0_1._event = arg2_1
	arg0_1._runningData = arg3_1
	arg0_1._mapTF = findTF(arg0_1._sceneMask, "sceneContainer/scene/content/map")
	arg0_1._grids = {}
	arg0_1._gridDic = {}
	arg0_1._mapTFDic = {}

	for iter0_1 = 0, arg0_1._mapTF.childCount - 1 do
		local var0_1 = arg0_1._mapTF:GetChild(iter0_1)

		arg0_1._mapTFDic[iter0_1 + 1] = var0_1
	end
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

function var0_0.SetGridIndex(arg0_5)
	return
end

function var0_0.Prepare(arg0_6)
	arg0_6._mapData = arg0_6._runningData:GetMapData()
	arg0_6._activeScoreCount = 0
	arg0_6._ignoreScore = arg0_6._mapData.ignore_score

	arg0_6:prepareMap()
end

function var0_0.Start(arg0_7)
	arg0_7._player = arg0_7._runningData:GetPlayer()
	arg0_7._scoreCount = arg0_7._runningData:GetScoreCount()
	arg0_7._delayReflashScoreTime = nil
	arg0_7._roles = arg0_7._runningData:GetRoles()

	arg0_7:reflashGridScore()
end

function var0_0.Step(arg0_8, arg1_8)
	arg0_8._deltaTime = arg1_8

	arg0_8:udateScoreGrid()
	arg0_8:updateReflashTime()
	arg0_8:updateRoleLayer()
end

function var0_0.updateReflashTime(arg0_9)
	if arg0_9._delayReflashScoreTime and arg0_9._delayReflashScoreTime > 0 then
		arg0_9._delayReflashScoreTime = arg0_9._delayReflashScoreTime - arg0_9._deltaTime

		if arg0_9._delayReflashScoreTime <= 0 then
			arg0_9._delayReflashScoreTime = nil

			arg0_9:reflashGridScore()
		end
	end
end

function var0_0.Clear(arg0_10)
	for iter0_10 = 1, #arg0_10._grids do
		arg0_10._grids[iter0_10]:Dispose()
	end

	arg0_10._roles = {}
	arg0_10._grids = {}
	arg0_10._gridDic = {}
	arg0_10._player = nil
	arg0_10._delayReflashScoreTime = nil
	arg0_10._scoreCount = 0
end

function var0_0.Stop(arg0_11)
	return
end

function var0_0.Resume(arg0_12)
	return
end

function var0_0.Dispose(arg0_13)
	arg0_13._roles = {}
	arg0_13._grids = {}
	arg0_13._gridDic = {}
end

function var0_0.prepareMap(arg0_14)
	local var0_14 = arg0_14._mapData.grid_list
	local var1_14 = arg0_14._mapData.grid_width
	local var2_14 = arg0_14._mapData.grid_height
	local var3_14 = arg0_14._mapData.map_bound
	local var4_14 = arg0_14._mapData.horizontal
	local var5_14 = arg0_14._mapData.vertical
	local var6_14 = arg0_14._mapData.offset

	arg0_14._mapTF.anchoredPosition = Vector2(-var3_14[1] / 2 + var1_14 / 2 + var6_14[1], var3_14[2] / 2 - var2_14 / 2 + var6_14[2])

	for iter0_14 = 1, #var0_14 do
		local var7_14 = var0_14[iter0_14]

		for iter1_14 = 1, #var7_14 do
			local var8_14 = var7_14[iter1_14]

			if var8_14 == 0 then
				var8_14 = PacGameConst.default_grid
			end

			local var9_14 = PacGameConst.grid_data[var8_14]
			local var10_14 = arg0_14._runningData:GetTplItemFromPool(var9_14.prefab, arg0_14._mapTFDic[iter0_14])
			local var11_14 = var4_14 * (iter0_14 - 1) + iter1_14
			local var12_14 = var7_14[iter1_14]
			local var13_14 = PacGameGrid.New(var10_14, var11_14, var12_14)
			local var14_14 = Vector2((iter1_14 - 1) * var1_14, -(iter0_14 - 1) * var2_14)

			var13_14:SetPosition(var14_14)
			var13_14:SetActive(true)
			var13_14:SetVH(iter0_14, iter1_14)
			table.insert(arg0_14._grids, var13_14)

			arg0_14._gridDic[var11_14] = var13_14
		end
	end

	arg0_14._runningData:SetGrids(arg0_14._grids, arg0_14._gridDic)
	arg0_14._runningData:SetMapTFDic(arg0_14._mapTFDic)
end

function var0_0.reflashGridScore(arg0_15)
	if arg0_15._runningData:GetEditor() then
		return
	end

	arg0_15._activeScoreCount = 0

	local var0_15 = arg0_15._player:GetGridIndex()

	for iter0_15 = 1, #arg0_15._grids do
		local var1_15 = arg0_15._grids[iter0_15]
		local var2_15 = var1_15:GetIndex()

		if var1_15:HasScore() then
			if not table.contains(arg0_15._ignoreScore, var2_15) then
				var1_15:SetScoreFlag(true)

				arg0_15._activeScoreCount = arg0_15._activeScoreCount + 1
			else
				var1_15:SetScoreFlag(false)
			end
		end
	end
end

function var0_0.udateScoreGrid(arg0_16)
	if arg0_16._activeScoreCount <= 0 then
		if not arg0_16._delayReflashScoreTime then
			arg0_16._delayReflashScoreTime = 2
		end

		return
	end

	local var0_16 = arg0_16._player:GetGridIndex()
	local var1_16 = arg0_16._gridDic[var0_16]

	if var1_16 and var1_16:GetScoreFlag() then
		arg0_16._event(PacGameScene.GET_SCORE, var1_16:GetScore(), nil)
		var1_16:SetScoreFlag(false)

		arg0_16._activeScoreCount = arg0_16._activeScoreCount - 1
	end
end

function var0_0.updateRoleLayer(arg0_17)
	for iter0_17 = 1, #arg0_17._roles do
		local var0_17 = arg0_17._roles[iter0_17]
		local var1_17 = var0_17:GetGridIndexNext()
		local var2_17 = arg0_17._gridDic[var1_17]

		if var2_17 then
			local var3_17, var4_17 = var2_17:GetVH()

			if var0_17:GetParent() ~= arg0_17._mapTFDic[var3_17] then
				var0_17:SetParent(arg0_17._mapTFDic[var3_17])
			end
		end
	end
end

return var0_0
