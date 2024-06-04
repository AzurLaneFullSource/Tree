local var0 = class("PipeGameScene")
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5

function var0.Ctor(arg0, arg1, arg2)
	var5 = PipeGameVo
	arg0._tf = arg1
	arg0._event = arg2
	arg0.sceneMask = findTF(arg0._tf, "sceneMask")
	arg0.sceneContent = findTF(arg0._tf, "sceneMask/sceneContainer")
	arg0._moveAnimator = GetComponent(arg0.sceneContent, typeof(Animator))
	arg0._bgRight = findTF(arg0.sceneContent, "scene_background/content/bgRight")
	arg0._bgRightAnimator = GetComponent(findTF(arg0._bgRight, "img"), typeof(Animator))

	local function var0(arg0, arg1)
		if arg0 == PipeGameEvent.REMOVE_RECT_TOP then
			arg0.rectCtrl:removeTopRectData()
		elseif arg0 == PipeGameEvent.PALY_ANIMATION_COMPLETE then
			var5.scoreNum = arg0.mapCtrl:getSuccessCount()

			arg0:playMove(function()
				arg0._event:emit(PipeGameEvent.GAME_OVER)
			end)
		elseif arg0 == PipeGameEvent.STOP_RECT_DRAG then
			arg0.rectCtrl:stopTopDrag()
		elseif arg0 == PipeGameEvent.SET_TOP_RECT then
			local var0 = arg0.rectCtrl:getTopData()

			arg0.mapCtrl:setClickTempItem(var0)
		elseif arg0 == PipeGameEvent.START_SETTLEMENT then
			var5.startSettlement = true
		end
	end

	arg0.mapCtrl = PipeMapControl.New(findTF(arg0.sceneContent, "scene/content/map"), var0)
	arg0.rectCtrl = PipeRectControll.New(findTF(arg0.sceneContent, "scene/content/rect"), findTF(arg0.sceneContent, "scene/content/dragPos"), var0)
	arg0.passCtrl = PiPePassTest.New(findTF(arg0.sceneContent, "scene/content/passTest"), function(arg0, arg1, arg2, arg3)
		if arg0.mapCtrl then
			local var0 = arg0.mapCtrl:checkItemSuccess(arg0, arg1, arg2, arg3)

			arg0.passCtrl:setPassDesc(var0)
		end
	end)

	arg0.passCtrl:setVisible(false)
	arg0:showContainer(false)
end

function var0.start(arg0)
	arg0:showContainer(true)
	arg0:resetScene()
	arg0.mapCtrl:start()
	arg0.rectCtrl:start()
end

function var0.step(arg0, arg1)
	arg0.mapCtrl:step()
	arg0.rectCtrl:step()
end

function var0.clear(arg0)
	arg0.mapCtrl:clear()
	arg0.rectCtrl:clear()
end

function var0.stop(arg0)
	arg0.mapCtrl:stop()
	arg0.rectCtrl:stop()
end

function var0.resume(arg0)
	arg0.mapCtrl:resume()
	arg0.rectCtrl:resume()
end

function var0.setGameOver(arg0)
	arg0.mapCtrl:startOverAniamtion()
end

function var0.dispose(arg0)
	arg0.mapCtrl:dispose()
	arg0.rectCtrl:dispose()
	arg0.passCtrl:dispose()

	if LeanTween.isTweening(go(arg0.sceneContent)) then
		LeanTween.cancel(go(arg0.sceneContent))
	end
end

function var0.resetScene(arg0)
	setActive(arg0._bgRight, false)
	arg0._moveAnimator:SetTrigger("reset")
end

function var0.playMove(arg0, arg1)
	local var0 = var5.GetResultLevel()

	setActive(arg0._bgRight, true)
	arg0._bgRightAnimator:SetTrigger(tostring(var0))
	arg0._moveAnimator:SetTrigger("move")
	LeanTween.delayedCall(go(arg0.sceneContent), 5, System.Action(function()
		if arg1 then
			arg1()
		end
	end))
end

function var0.showContainer(arg0, arg1)
	setActive(arg0.sceneMask, arg1)
end

function var0.press(arg0, arg1, arg2)
	return
end

function var0.joystickActive(arg0, arg1)
	return
end

return var0
