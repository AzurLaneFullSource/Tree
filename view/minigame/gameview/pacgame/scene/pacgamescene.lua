local var0_0 = class("PacGameScene")

var0_0.GET_SCORE = "PacGameScene:get_score"
var0_0.HIT_PLAYER = "PacGameScene:hit_player"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1._sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1._sceneContainer = findTF(arg0_1._tf, "sceneMask/sceneContainer")

	function arg0_1._eventCallback(arg0_2, arg1_2, arg2_2)
		arg0_1:onEventHandle(arg0_2, arg1_2, arg2_2)
	end

	arg0_1._pacGameRunningData = PacGameRunningData.New()

	arg0_1._pacGameRunningData:SetTpl(findTF(arg0_1._tf, "tpl"))
	arg0_1:ShowContainer(false)

	arg0_1._mapController = PacGameMapController.New(arg0_1._sceneMask, arg0_1._eventCallback, arg0_1._pacGameRunningData)
	arg0_1._movingController = PacGameMovingController.New(arg0_1._sceneMask, arg0_1._eventCallback, arg0_1._pacGameRunningData)
	arg0_1._roleController = PacGameRoleController.New(arg0_1._sceneMask, arg0_1._eventCallback, arg0_1._pacGameRunningData)
	arg0_1._enemyController = PacGameEnemyController.New(arg0_1._sceneMask, arg0_1._eventCallback, arg0_1._pacGameRunningData)
	arg0_1._itemController = PacGameItemController.New(arg0_1._sceneMask, arg0_1._eventCallback, arg0_1._pacGameRunningData)
	arg0_1._editorController = PacGameEditorController.New(arg0_1._sceneMask, arg0_1._eventCallback, arg0_1._pacGameRunningData)
end

function var0_0.onEventHandle(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg1_3 == var0_0.GET_SCORE then
		arg0_3._event:emit(SimpleMGEvent.ADD_SCORE, {
			num = arg2_3
		})
	elseif arg1_3 == var0_0.HIT_PLAYER then
		arg0_3._event:emit(SimpleMGEvent.GAME_OVER)
	end
end

function var0_0.ShowContainer(arg0_4, arg1_4)
	setActive(arg0_4._sceneMask, arg1_4)
end

function var0_0.Prepare(arg0_5)
	local var0_5 = arg0_5._gameVo:GetGameRound()

	print("round id = " .. var0_5)

	local var1_5 = PacGameConst.chapter_data[var0_5]
	local var2_5 = arg0_5._gameVo:GetEditor()

	arg0_5._pacGameRunningData:SetChapterData(var1_5)
	arg0_5._pacGameRunningData:SetEditor(var2_5)
	arg0_5._mapController:Prepare()
	arg0_5._movingController:Prepare()
	arg0_5._roleController:Prepare()
	arg0_5._enemyController:Prepare()
	arg0_5._itemController:Prepare()
	arg0_5._editorController:Prepare()
end

function var0_0.Start(arg0_6)
	arg0_6:ShowContainer(true)
	arg0_6._mapController:Start()
	arg0_6._movingController:Start()
	arg0_6._roleController:Start()
	arg0_6._enemyController:Start()
	arg0_6._itemController:Start()
	arg0_6._editorController:Start()
end

function var0_0.Step(arg0_7)
	local var0_7 = arg0_7._gameVo:GetDeltaTime()
	local var1_7 = arg0_7._gameVo:GetJoyStickData()

	arg0_7._pacGameRunningData:SetJoyData(var1_7)
	arg0_7._mapController:Step(var0_7)
	arg0_7._movingController:Step(var0_7)
	arg0_7._roleController:Step(var0_7)
	arg0_7._enemyController:Step(var0_7)
	arg0_7._itemController:Step(var0_7)
	arg0_7._editorController:Step(var0_7)
end

function var0_0.Clear(arg0_8)
	arg0_8._mapController:Clear()
	arg0_8._movingController:Clear()
	arg0_8._roleController:Clear()
	arg0_8._enemyController:Clear()
	arg0_8._itemController:Clear()
	arg0_8._pacGameRunningData:Clear()
	arg0_8._editorController:Clear()
end

function var0_0.Stop(arg0_9)
	arg0_9._mapController:Stop()
	arg0_9._movingController:Stop()
	arg0_9._roleController:Stop()
	arg0_9._enemyController:Stop()
	arg0_9._itemController:Stop()
	arg0_9._editorController:Stop()
end

function var0_0.Resume(arg0_10)
	arg0_10._mapController:Resume()
	arg0_10._movingController:Resume()
	arg0_10._roleController:Resume()
	arg0_10._enemyController:Resume()
	arg0_10._itemController:Resume()
	arg0_10._editorController:Resume()
end

function var0_0.Dispose(arg0_11)
	arg0_11._mapController:Dispose()
	arg0_11._movingController:Dispose()
	arg0_11._roleController:Dispose()
	arg0_11._enemyController:Dispose()
	arg0_11._itemController:Dispose()
	arg0_11._editorController:Dispose()
	arg0_11._pacGameRunningData:Dispose()

	arg0_11._pacGameRunningData = nil
end

return var0_0
