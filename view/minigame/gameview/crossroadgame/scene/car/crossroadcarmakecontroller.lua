local var0_0 = class("CrossRoadCarMakeController")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._runningData = arg1_1
	arg0_1.backRoadTF = arg1_1:GetRoadTF(CrossRoadGameConst.BACK_ROAD_NAME)
	arg0_1.backRoadList = arg1_1:GetRoadList(CrossRoadGameConst.BACK_ROAD_NAME)
	arg0_1.carTpl = arg1_1:GetAllCarTpl()
	arg0_1.carGameObjectList = {}
	arg0_1.delatTime = 0

	for iter0_1 = 1, CrossRoadGameConst.GAME_TRACK_COUNT do
		arg0_1.carGameObjectList[iter0_1] = {}
	end

	arg0_1._runningData:SetTrackCarGoList(arg0_1.carGameObjectList)
end

function var0_0.Prepare(arg0_2)
	arg0_2._trackCarGOList = {}

	for iter0_2 = 1, CrossRoadGameConst.GAME_TRACK_COUNT do
		arg0_2._trackCarGOList[iter0_2] = {}
	end

	arg0_2._runningData:SetTrackCarGoList(arg0_2.carGameObjectList)
end

function var0_0.MakeRandomCar(arg0_3, arg1_3)
	local var0_3 = CrossRoadGameHelper:WeightCarRandom()
	local var1_3 = math.random(1, CrossRoadGameConst.GAME_TRACK_COUNT)
	local var2_3

	for iter0_3, iter1_3 in ipairs(CrossRoadGameConst.CAR_TPL) do
		if iter1_3 == var0_3.resource then
			var2_3 = tf(instantiate(arg0_3.carTpl[iter0_3]))
		end
	end

	local var3_3 = CrossRoadCar.New(var2_3, var0_3, var1_3, arg0_3._runningData)
	local var4_3 = arg0_3.backRoadTF:Find(tostring(var1_3))
	local var5_3 = arg0_3.backRoadList[var1_3].startTF.anchoredPosition
	local var6_3 = Vector2.New(var5_3.x, var5_3.y - var0_3.length)
	local var7_3 = CrossRoadGameConst.START_CAR_SCALE

	var3_3:SetScale(Vector3(var7_3, var7_3, 1))
	var3_3:SetParent(var4_3)
	var3_3:SetPosition(var6_3)
	var3_3:SetTarget(var5_3)
	var3_3:SetDirect({
		0,
		1
	})
	table.insert(arg0_3.carGameObjectList[var1_3], var3_3)
	arg0_3._runningData:SetTrackCarGoList(arg0_3.carGameObjectList)
end

function var0_0.Step(arg0_4)
	for iter0_4 = 1, CrossRoadGameConst.GAME_TRACK_COUNT do
		for iter1_4 = #arg0_4.carGameObjectList[iter0_4], 1, -1 do
			local var0_4 = arg0_4.carGameObjectList[iter0_4][iter1_4]

			if var0_4:GetNeedDispose() then
				table.remove(arg0_4.carGameObjectList[iter0_4], iter1_4)
				var0_4:Dispose()
				arg0_4._runningData:SetTrackCarGoList(arg0_4.carGameObjectList)
			end
		end
	end
end

function var0_0.Clear(arg0_5)
	for iter0_5 = 1, CrossRoadGameConst.GAME_TRACK_COUNT do
		for iter1_5 = #arg0_5.carGameObjectList[iter0_5], 1, -1 do
			local var0_5 = arg0_5.carGameObjectList[iter0_5][iter1_5]

			table.remove(arg0_5.carGameObjectList[iter0_5], iter1_5)
			var0_5:Dispose()
			arg0_5._runningData:SetTrackCarGoList(arg0_5.carGameObjectList)
		end
	end
end

return var0_0
