local var0_0 = class("PacGameItemController")
local var1_0 = 5
local var2_0 = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneMask = arg1_1
	arg0_1._event = arg2_1
	arg0_1._runningData = arg3_1
	arg0_1._content = findTF(arg0_1._sceneMask, "sceneContainer/scene/content/map")
end

function var0_0.Prepare(arg0_2)
	arg0_2._itemConfig = arg0_2._runningData:GetMapConfig("item")
	arg0_2._gridDic = arg0_2._runningData:GetGridDic()
	arg0_2._mapTFDic = arg0_2._runningData:GetMapTFDic()
	arg0_2._player = arg0_2._runningData:GetPlayer()
end

function var0_0.Start(arg0_3)
	arg0_3._createItemTime = PacGameConst.item_time
	arg0_3._items = {}
end

function var0_0.Step(arg0_4, arg1_4)
	arg0_4._deltaTime = arg1_4

	if arg0_4._runningData:GetEditor() then
		return
	end

	if arg0_4._createItemTime and arg0_4._createItemTime > 0 then
		arg0_4._createItemTime = arg0_4._createItemTime - arg1_4

		if arg0_4._createItemTime <= 0 then
			arg0_4:tryCreateItem()

			arg0_4._createItemTime = PacGameConst.item_time
		end
	end

	local var0_4 = arg0_4._player:GetGridIndex()

	for iter0_4 = #arg0_4._items, 1, -1 do
		local var1_4 = arg0_4._items[iter0_4]
		local var2_4 = var1_4:GetIndex()
		local var3_4 = var1_4:GetConfig("effect")
		local var4_4 = var1_4:GetConfig("effect_time")

		if var2_4 == var0_4 then
			arg0_4:SetItemEffect(var3_4, var4_4)
			var1_4:Dispose()
			table.remove(arg0_4._items, iter0_4)
		end
	end
end

function var0_0.Clear(arg0_5)
	arg0_5._player = nil

	for iter0_5 = #arg0_5._items, 1, -1 do
		arg0_5._items[iter0_5]:Dispose()
	end

	arg0_5._items = {}
end

function var0_0.Stop(arg0_6)
	return
end

function var0_0.Resume(arg0_7)
	return
end

function var0_0.Dispose(arg0_8)
	return
end

function var0_0.SetItemEffect(arg0_9, arg1_9, arg2_9)
	if not arg0_9._player then
		return
	end

	if arg1_9 == var2_0 then
		arg0_9._player:SetRush(true, arg2_9)
	end
end

function var0_0.tryCreateItem(arg0_10)
	local var0_10 = {}
	local var1_10 = arg0_10._player:GetGridIndex()

	for iter0_10, iter1_10 in pairs(arg0_10._gridDic) do
		if iter1_10:GetPassAble() and not iter1_10:GetScoreFlag() and iter1_10:GetIndex() ~= var1_10 then
			table.insert(var0_10, iter1_10:GetIndex())
		end
	end

	if #arg0_10._items <= PacGameConst.max_item_count and #var0_10 >= 10 and math.random() <= PacGameConst.item_rate then
		local var2_10 = var0_10[math.random(1, #var0_10)]
		local var3_10 = arg0_10._gridDic[var2_10]
		local var4_10 = var3_10:GetIndex()
		local var5_10 = var3_10:GetPosition()
		local var6_10, var7_10 = var3_10:GetVH()
		local var8_10 = arg0_10._mapTFDic[var6_10]
		local var9_10 = arg0_10._itemConfig[math.random(1, #arg0_10._itemConfig)]
		local var10_10 = arg0_10:createItem(var9_10, var4_10, var8_10)

		var10_10:SetPosition(var5_10)
		table.insert(arg0_10._items, var10_10)
	end
end

function var0_0.createItem(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = PacGameConst.item_data[arg1_11]
	local var1_11 = var0_11.prefab
	local var2_11 = arg0_11._runningData:GetTplItemFromPool(var1_11, arg3_11)

	return (PacGameItem.New(var2_11, arg2_11, var0_11))
end

return var0_0
