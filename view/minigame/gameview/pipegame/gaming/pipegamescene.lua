local var0_0 = class("PipeGameScene")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var5_0 = PipeGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1.sceneContent = findTF(arg0_1._tf, "sceneMask/sceneContainer")
	arg0_1._moveAnimator = GetComponent(arg0_1.sceneContent, typeof(Animator))
	arg0_1._bgRight = findTF(arg0_1.sceneContent, "scene_background/content/bgRight")
	arg0_1._bgRightAnimator = GetComponent(findTF(arg0_1._bgRight, "img"), typeof(Animator))

	local function var0_1(arg0_2, arg1_2)
		if arg0_2 == PipeGameEvent.REMOVE_RECT_TOP then
			arg0_1.rectCtrl:removeTopRectData()
		elseif arg0_2 == PipeGameEvent.PALY_ANIMATION_COMPLETE then
			var5_0.scoreNum = arg0_1.mapCtrl:getSuccessCount()

			arg0_1:playMove(function()
				arg0_1._event:emit(PipeGameEvent.GAME_OVER)
			end)
		elseif arg0_2 == PipeGameEvent.STOP_RECT_DRAG then
			arg0_1.rectCtrl:stopTopDrag()
		elseif arg0_2 == PipeGameEvent.SET_TOP_RECT then
			local var0_2 = arg0_1.rectCtrl:getTopData()

			arg0_1.mapCtrl:setClickTempItem(var0_2)
		elseif arg0_2 == PipeGameEvent.START_SETTLEMENT then
			var5_0.startSettlement = true
		end
	end

	arg0_1.mapCtrl = PipeMapControl.New(findTF(arg0_1.sceneContent, "scene/content/map"), var0_1)
	arg0_1.rectCtrl = PipeRectControll.New(findTF(arg0_1.sceneContent, "scene/content/rect"), findTF(arg0_1.sceneContent, "scene/content/dragPos"), var0_1)
	arg0_1.passCtrl = PiPePassTest.New(findTF(arg0_1.sceneContent, "scene/content/passTest"), function(arg0_4, arg1_4, arg2_4, arg3_4)
		if arg0_1.mapCtrl then
			local var0_4 = arg0_1.mapCtrl:checkItemSuccess(arg0_4, arg1_4, arg2_4, arg3_4)

			arg0_1.passCtrl:setPassDesc(var0_4)
		end
	end)

	arg0_1.passCtrl:setVisible(false)
	arg0_1:showContainer(false)
end

function var0_0.start(arg0_5)
	arg0_5:showContainer(true)
	arg0_5:resetScene()
	arg0_5.mapCtrl:start()
	arg0_5.rectCtrl:start()
end

function var0_0.step(arg0_6, arg1_6)
	arg0_6.mapCtrl:step()
	arg0_6.rectCtrl:step()
end

function var0_0.clear(arg0_7)
	arg0_7.mapCtrl:clear()
	arg0_7.rectCtrl:clear()
end

function var0_0.stop(arg0_8)
	arg0_8.mapCtrl:stop()
	arg0_8.rectCtrl:stop()
end

function var0_0.resume(arg0_9)
	arg0_9.mapCtrl:resume()
	arg0_9.rectCtrl:resume()
end

function var0_0.setGameOver(arg0_10)
	arg0_10.mapCtrl:startOverAniamtion()
end

function var0_0.dispose(arg0_11)
	arg0_11.mapCtrl:dispose()
	arg0_11.rectCtrl:dispose()
	arg0_11.passCtrl:dispose()

	if LeanTween.isTweening(go(arg0_11.sceneContent)) then
		LeanTween.cancel(go(arg0_11.sceneContent))
	end
end

function var0_0.resetScene(arg0_12)
	setActive(arg0_12._bgRight, false)
	arg0_12._moveAnimator:SetTrigger("reset")
end

function var0_0.playMove(arg0_13, arg1_13)
	local var0_13 = var5_0.GetResultLevel()

	setActive(arg0_13._bgRight, true)
	arg0_13._bgRightAnimator:SetTrigger(tostring(var0_13))
	arg0_13._moveAnimator:SetTrigger("move")
	LeanTween.delayedCall(go(arg0_13.sceneContent), 5, System.Action(function()
		if arg1_13 then
			arg1_13()
		end
	end))
end

function var0_0.showContainer(arg0_15, arg1_15)
	setActive(arg0_15.sceneMask, arg1_15)
end

function var0_0.press(arg0_16, arg1_16, arg2_16)
	return
end

function var0_0.joystickActive(arg0_17, arg1_17)
	return
end

return var0_0
