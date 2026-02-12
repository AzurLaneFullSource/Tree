local var0_0 = class("PacGameRunningData")

function var0_0.Ctor(arg0_1)
	arg0_1._tpl = nil
	arg0_1._tplItemPool = {}
	arg0_1._roles = {}
end

function var0_0.SetChapterData(arg0_2, arg1_2)
	arg0_2._chapterData = arg1_2
end

function var0_0.GetConfig(arg0_3, arg1_3)
	return arg0_3._chapterData[arg1_3]
end

function var0_0.GetMapConfig(arg0_4, arg1_4)
	return arg0_4._mapData[arg1_4]
end

function var0_0.GetMapData(arg0_5)
	if not arg0_5._mapData and arg0_5._chapterData then
		arg0_5._mapData = PacGameConst.map_data[arg0_5._chapterData.map]
	end

	return arg0_5._mapData
end

function var0_0.GetGridRect(arg0_6)
	return arg0_6._mapData.grid_width, arg0_6._mapData.grid_height
end

function var0_0.GetGridWH(arg0_7)
	return arg0_7._mapData.vertical, arg0_7._mapData.horizontal
end

function var0_0.SetEditor(arg0_8, arg1_8)
	arg0_8._editorFlag = arg1_8
end

function var0_0.GetEditor(arg0_9)
	return arg0_9._editorFlag
end

function var0_0.SetGrids(arg0_10, arg1_10, arg2_10)
	arg0_10._grids = arg1_10
	arg0_10._gridDic = {}
	arg0_10._gridDic = arg2_10
end

function var0_0.GetGrids(arg0_11)
	return arg0_11._grids
end

function var0_0.GetGridDic(arg0_12)
	return arg0_12._gridDic
end

function var0_0.SetPlayer(arg0_13, arg1_13)
	arg0_13._player = arg1_13

	table.insert(arg0_13._roles, arg1_13)
end

function var0_0.GetPlayer(arg0_14)
	return arg0_14._player
end

function var0_0.SetEnemys(arg0_15, arg1_15)
	arg0_15._enemys = arg1_15

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		table.insert(arg0_15._roles, iter1_15)
	end
end

function var0_0.SetMapTFDic(arg0_16, arg1_16)
	arg0_16._mapTFDic = arg1_16
end

function var0_0.GetMapTFDic(arg0_17)
	return arg0_17._mapTFDic
end

function var0_0.GetEnemys(arg0_18)
	return arg0_18._enemys
end

function var0_0.GetPlayerStartIndex(arg0_19)
	return arg0_19._mapData.player_start
end

function var0_0.GetRoles(arg0_20)
	return arg0_20._roles
end

function var0_0.GetPosByIndex(arg0_21, arg1_21)
	if not arg0_21._gridDic then
		return Vector2(0, 0)
	end

	return arg0_21._gridDic[arg1_21]:GetPosition()
end

function var0_0.SetJoyData(arg0_22, arg1_22)
	arg0_22._joyData = arg1_22
end

function var0_0.GetJoyData(arg0_23)
	return arg0_23._joyData
end

function var0_0.GetScoreCount(arg0_24)
	if arg0_24._scoreCount and arg0_24._scoreCount > 0 then
		return arg0_24._scoreCount
	end

	arg0_24._scoreCount = 0

	if arg0_24._gridDic then
		for iter0_24, iter1_24 in pairs(arg0_24._gridDic) do
			if iter1_24:HasScore() then
				arg0_24._scoreCount = arg0_24._scoreCount + 1
			end
		end
	end

	return arg0_24._scoreCount
end

function var0_0.getDirectGrid(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg1_25 - 1

	if var0_25 % arg0_25._mapData.horizontal == 0 and arg2_25.x == -1 then
		return nil
	elseif var0_25 % arg0_25._mapData.horizontal == arg0_25._mapData.horizontal - 1 and arg2_25.x == 1 then
		return nil
	elseif var0_25 < arg0_25._mapData.horizontal and arg2_25.y == 1 then
		return nil
	elseif var0_25 >= arg0_25._mapData.horizontal * (arg0_25._mapData.vertical - 1) and arg2_25.y == -1 then
		return nil
	end

	local var1_25

	if arg2_25.x ~= 0 then
		var1_25 = arg1_25 + arg2_25.x
	elseif arg2_25.y ~= 0 then
		var1_25 = arg1_25 + -arg2_25.y * arg0_25._mapData.horizontal
	end

	if var1_25 then
		local var2_25 = arg0_25._gridDic[var1_25]

		if var2_25 and var2_25:GetPassAble() then
			return var2_25
		end
	end

	return nil
end

function var0_0.GetNearGridIndex(arg0_26, arg1_26)
	local var0_26 = {}
	local var1_26 = arg0_26:getDirectGrid(arg1_26, Vector2(-1, 0))
	local var2_26 = arg0_26:getDirectGrid(arg1_26, Vector2(1, 0))
	local var3_26 = arg0_26:getDirectGrid(arg1_26, Vector2(0, 1))
	local var4_26 = arg0_26:getDirectGrid(arg1_26, Vector2(0, -1))

	if var1_26 then
		table.insert(var0_26, var1_26:GetIndex())
	end

	if var2_26 then
		table.insert(var0_26, var2_26:GetIndex())
	end

	if var3_26 then
		table.insert(var0_26, var3_26:GetIndex())
	end

	if var4_26 then
		table.insert(var0_26, var4_26:GetIndex())
	end

	return var0_26
end

function var0_0.SetTpl(arg0_27, arg1_27)
	arg0_27._tpl = arg1_27
end

function var0_0.GetTplItemFromPool(arg0_28, arg1_28, arg2_28)
	if not arg1_28 or arg1_28 == "" then
		return nil
	end

	if not arg2_28 then
		return nil
	end

	if arg0_28._tplItemPool[arg1_28] == nil then
		arg0_28._tplItemPool[arg1_28] = {}
	end

	if #arg0_28._tplItemPool[arg1_28] == 0 then
		local var0_28 = tf(instantiate(findTF(arg0_28._tpl, arg1_28)))

		setParent(var0_28, arg2_28)

		return var0_28, true
	else
		return table.remove(arg0_28._tplItemPool[arg1_28], #arg0_28._tplItemPool[arg1_28]), false
	end

	return nil, nil
end

function var0_0.Clear(arg0_29)
	arg0_29._chapterData = nil
	arg0_29._mapData = nil
	arg0_29._player = nil
	arg0_29._enemys = nil
	arg0_29._scoreCount = 0
	arg0_29._roles = {}
end

function var0_0.Dispose(arg0_30)
	arg0_30._tpl = nil
	arg0_30._tplItemPool = {}
	arg0_30._chapterData = nil
	arg0_30._mapData = nil
	arg0_30._scoreCount = 0
	arg0_30._gridDic = {}
	arg0_30._grids = {}
end

return var0_0
