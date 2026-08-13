local var0_0 = class("CrossRoadCarMgr")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneMaskTF = arg1_1
	arg0_1._data = arg2_1
	arg0_1._event = arg3_1

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.carMakeController = CrossRoadCarMakeController.New(arg0_2._data)
	arg0_2.carMoveController = CrossRoadCarMoveController.New(arg0_2._data, arg0_2._event)
	arg0_2.deltaTime = 0
	arg0_2.makedelayTime = CrossRoadGameConst.MAKE_CAR_TIME[1]
	arg0_2.lastMakeTime = CrossRoadGameConst.FIRST_CAR_TIQIAN_TIME
end

function var0_0.Prepare(arg0_3)
	arg0_3.carMakeController:Prepare()
end

function var0_0.Step(arg0_4, arg1_4)
	arg0_4.deltaTime = arg0_4.deltaTime + arg1_4

	local var0_4 = arg0_4._data:GetRoundCnt()
	local var1_4 = math.max(math.min(var0_4, #CrossRoadGameConst.MAKE_CAR_TIME), 1)

	arg0_4.makedelayTime = CrossRoadGameConst.MAKE_CAR_TIME[var1_4]

	if arg0_4.deltaTime > arg0_4.lastMakeTime + arg0_4.makedelayTime then
		arg0_4.lastMakeTime = arg0_4.deltaTime

		arg0_4.carMakeController:MakeRandomCar(arg0_4.deltaTime)
	end

	arg0_4.carMakeController:Step()
	arg0_4.carMoveController:Step(arg1_4)
end

function var0_0.Clear(arg0_5)
	arg0_5.time = 0

	arg0_5.carMakeController:Clear()
	arg0_5.carMoveController:Clear()
end

return var0_0
