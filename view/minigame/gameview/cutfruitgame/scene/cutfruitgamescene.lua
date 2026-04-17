local var0_0 = class("CutFruitGameScene")

var0_0.GET_SCORE = "CutFruitGameScene:get_score"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1._sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1._sceneContainer = findTF(arg0_1._tf, "sceneMask/sceneContainer")

	function arg0_1._eventCallback(arg0_2, arg1_2, arg2_2)
		arg0_1:onEventHandle(arg0_2, arg1_2, arg2_2)
	end

	arg0_1._cutFruitGameRunningData = CutFruitGameRunningData.New()

	arg0_1:ShowContainer(false)
	arg0_1._event:bind(CutFruitGameView.EVENT_DIRECT, function(arg0_3, arg1_3, arg2_3)
		arg0_1._gameController:InputDirect(arg1_3)
	end)

	arg0_1._gameController = CutFruitGameController.New(findTF(arg0_1._sceneContainer, "scene/content"), arg0_1._event, arg0_1._cutFruitGameRunningData)
end

function var0_0.onEventHandle(arg0_4, arg1_4, arg2_4, arg3_4)
	if arg1_4 == var0_0.GET_SCORE then
		arg0_4._event:emit(SimpleMGEvent.ADD_SCORE, {
			num = arg2_4
		})
	end
end

function var0_0.ShowContainer(arg0_5, arg1_5)
	setActive(arg0_5._sceneMask, arg1_5)
end

function var0_0.Prepare(arg0_6, arg1_6)
	arg0_6._cutFruitGameRunningData:SetChapterConfig(CutFruitGameConst.chapter_data[arg0_6._gameVo:GetGameRound()])
	arg0_6._cutFruitGameRunningData:SetCharData(arg1_6)
	arg0_6._gameController:Prepare()
end

function var0_0.Start(arg0_7)
	arg0_7:ShowContainer(true)
	arg0_7._gameController:Start()
end

function var0_0.Step(arg0_8)
	local var0_8 = arg0_8._gameVo:GetDeltaTime()

	arg0_8._gameController:Step(var0_8)
end

function var0_0.Clear(arg0_9)
	arg0_9._gameController:Clear()
end

function var0_0.Stop(arg0_10)
	arg0_10._gameController:Stop()
end

function var0_0.Resume(arg0_11)
	arg0_11._gameController:Resume()
end

function var0_0.GameOver(arg0_12)
	arg0_12._gameController:GameOver()
end

function var0_0.Dispose(arg0_13)
	arg0_13._cutFruitGameRunningData:Dispose()

	arg0_13._cutFruitGameRunningData = nil
end

return var0_0
