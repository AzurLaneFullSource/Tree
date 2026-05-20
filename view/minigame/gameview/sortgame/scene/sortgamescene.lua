local var0_0 = class("SortGameScene")

var0_0.GET_SCORE = "SortGameScene:get_score"
var0_0.REMOVE_ITEM = "SortGameScene:remove_item"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1._sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1._sceneContainer = findTF(arg0_1._tf, "sceneMask/sceneContainer")

	function arg0_1._eventCallback(arg0_2, arg1_2, arg2_2)
		arg0_1:onEventHandle(arg0_2, arg1_2, arg2_2)
	end

	arg0_1._sortGameRunningData = SortGameRunningData.New()
	arg0_1._gridController = SortGameGridController.New(findTF(arg0_1._sceneContainer, "scene/content"), arg0_1._event, arg0_1._sortGameRunningData)

	arg0_1:ShowContainer(false)
end

function var0_0.onEventHandle(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg1_3 == var0_0.GET_SCORE then
		arg0_3._event:emit(SimpleMGEvent.ADD_SCORE, {
			num = arg2_3
		})
	end
end

function var0_0.ShowContainer(arg0_4, arg1_4)
	setActive(arg0_4._sceneMask, arg1_4)
end

function var0_0.Prepare(arg0_5)
	local var0_5 = arg0_5._gameVo:GetGameRound()
	local var1_5 = SortGameConst.chapter_data[var0_5]

	arg0_5._sortGameRunningData:SetChapterData(var1_5)
	arg0_5._gridController:Prepare()
	arg0_5._event:emit(SortGameView.UPDATE_PLAYER, arg0_5._sortGameRunningData:GetPlayerPrefab())
end

function var0_0.Start(arg0_6)
	arg0_6:ShowContainer(true)
	arg0_6._gridController:Start()

	arg0_6._gameTimeSpeak = false
end

function var0_0.Step(arg0_7)
	local var0_7 = arg0_7._gameVo:GetDeltaTime()
	local var1_7 = arg0_7._gameVo:GetTimeInteger()

	if var1_7 <= SortGameConst.last_speak_time and not arg0_7._gameTimeSpeak then
		arg0_7._event:emit(SortGameView.PLAYER_SPEAK, arg0_7._sortGameRunningData:GetSpeakData(SortGameConst.sort_conifg_type_time))

		arg0_7._gameTimeSpeak = true
	end

	arg0_7._gridController:Step(var0_7, var1_7)
end

function var0_0.Clear(arg0_8)
	arg0_8._gridController:Clear()
end

function var0_0.Stop(arg0_9)
	arg0_9._gridController:Stop()
end

function var0_0.Resume(arg0_10)
	arg0_10._gridController:Resume()
end

function var0_0.Dispose(arg0_11)
	arg0_11._sortGameRunningData:Dispose()

	arg0_11._sortGameRunningData = nil

	arg0_11._gridController:Dispose()
end

return var0_0
