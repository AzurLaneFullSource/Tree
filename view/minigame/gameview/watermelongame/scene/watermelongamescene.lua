local var0_0 = class("WatermelonGameScene")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1.sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1.sceneContainer = findTF(arg0_1._tf, "sceneMask/sceneContainer")

	arg0_1:showContainer(false)

	arg0_1.physicsCtrl = WatermelonCollisionCtrl.New(arg0_1.contextData, arg0_1._event)
	arg0_1.ballCtrl = WatermelonBallCtrl.New(findTF(arg0_1.sceneContainer, "scene/content/physics_content"), arg0_1.contextData, arg0_1._event)

	arg0_1.physicsCtrl:setGameVo(arg0_1._gameVo)
	arg0_1.ballCtrl:setGameVo(arg0_1._gameVo)
	arg0_1._event:bind(WatermelonGameEvent.CLICK_DOWN, function(arg0_2, arg1_2, arg2_2)
		arg0_1.ballCtrl:dropBall()
	end)
	arg0_1._event:bind(WatermelonGameEvent.CLICK_MOVE, function(arg0_3, arg1_3, arg2_3)
		arg0_1.ballCtrl:moveWorld(arg1_3)
	end)
end

function var0_0.start(arg0_4)
	arg0_4:showContainer(true)
	arg0_4.physicsCtrl:start()
	arg0_4.ballCtrl:start()
end

function var0_0.step(arg0_5, arg1_5)
	arg0_5.physicsCtrl:step(arg1_5)
	arg0_5.ballCtrl:step(arg1_5)
end

function var0_0.clear(arg0_6)
	arg0_6.physicsCtrl:clear()
	arg0_6.ballCtrl:clear()
end

function var0_0.stop(arg0_7)
	arg0_7.physicsCtrl:stop()
	arg0_7.ballCtrl:stop()
end

function var0_0.resume(arg0_8)
	arg0_8.physicsCtrl:resume()
	arg0_8.ballCtrl:resume()
end

function var0_0.dispose(arg0_9)
	arg0_9.physicsCtrl:dispose()
	arg0_9.ballCtrl:dispose()
end

function var0_0.showContainer(arg0_10, arg1_10)
	setActive(arg0_10.sceneMask, arg1_10)
end

return var0_0
