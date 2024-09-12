local var0_0 = class("TouchCakeScene")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0

var0_0.EVENT_ACTION_PROP = "event action prop"
var0_0.EVENT_ACTION_CAKE = "event action cake"
var0_0.EVENT_ACTION_WIELD = "event action wield"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var5_0 = TouchCakeGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1.sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1.sceneContent = findTF(arg0_1._tf, "sceneMask/sceneContainer")

	local function var0_1(arg0_2, arg1_2, arg2_2)
		arg0_1:onSceneEventCall(arg0_2, arg1_2, arg2_2)
	end

	arg0_1:showContainer(false)

	local var1_1 = findTF(arg0_1.sceneContent, "scene/content/cakeContent")

	arg0_1.cakeController = TouchCakeTowerController.New(var1_1, var0_1)

	local var2_1 = findTF(arg0_1.sceneContent, "scene/content/charContent")

	arg0_1.charController = TouchCakeCharController.New(var2_1, var0_1)

	local var3_1 = findTF(arg0_1.sceneContent, "scene/content/effectContent")

	arg0_1.effectController = TouchCakeEffectController.New(var3_1, var0_1)
end

function var0_0.onSceneEventCall(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg1_3 == TouchCakeScene.EVENT_ACTION_PROP then
		local var0_3 = arg2_3.prop
		local var1_3 = var0_3.data.dizzi
		local var2_3 = var0_3.data.guard
		local var3_3 = var0_3.data.boom
		local var4_3 = var0_3.data.score
		local var5_3 = arg0_3.charController:getDirect()

		if var0_3.direct == var5_3 then
			if arg3_3 then
				arg3_3(true)
			end

			if var4_3 and var4_3 >= 0 then
				local var6_3 = arg0_3:getScore(var4_3, var5_0.comboNum)

				arg0_3._event:emit(TouchCakeGameEvent.ADD_SCORE, var6_3)
			end

			if var2_3 and var2_3 > 0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_0.SFX_COUNT_PERFECT)
				arg0_3.charController:guard(var2_3)
			end

			if var1_3 and var1_3 > 0 and arg0_3.charController:dizzi(var1_3) then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_0.SFX_COUNT_STEP)
				arg0_3._event:emit(TouchCakeGameEvent.PLAYER_DIZZI, var4_3)
			end

			if var3_3 and var3_3 > 0 and not arg0_3.charController:getGuard() then
				arg0_3.effectController:showBoom(var3_3, 0.1)
				arg0_3._event:emit(TouchCakeGameEvent.PLAYER_BOOM)
			end
		elseif arg3_3 then
			arg3_3(false)
		end
	elseif arg1_3 == TouchCakeScene.EVENT_ACTION_WIELD then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_0.SFX_COUNT_THROW)
		arg0_3.cakeController:touchBottomCake(arg2_3, arg3_3)
	elseif arg1_3 == TouchCakeScene.EVENT_ACTION_CAKE then
		local var7_3 = arg2_3.cake.score

		if var7_3 and var7_3 >= 0 then
			arg0_3._event:emit(TouchCakeGameEvent.ADD_COMBO)

			local var8_3 = arg0_3:getScore(var7_3, var5_0.comboNum)

			arg0_3._event:emit(TouchCakeGameEvent.ADD_SCORE, var8_3)
		end
	end
end

function var0_0.start(arg0_4)
	arg0_4.touchTimeCache = -1

	arg0_4:showContainer(true)
	arg0_4.cakeController:start()
	arg0_4.charController:start()
	arg0_4.effectController:start()
end

function var0_0.step(arg0_5)
	if arg0_5.touchTimeCache and arg0_5.touchTimeCache > 0 then
		arg0_5.touchTimeCache = arg0_5.touchTimeCache - var5_0.deltaTime

		if arg0_5.touchTimeCache <= 0 then
			arg0_5.touchTimeCache = -1

			arg0_5:touchDirect(arg0_5.touchDirectCache, true)
		end
	end

	arg0_5.cakeController:step()
	arg0_5.charController:step()
	arg0_5.effectController:step()
end

function var0_0.clear(arg0_6)
	return
end

function var0_0.stop(arg0_7)
	arg0_7.cakeController:stop()
	arg0_7.charController:stop()
	arg0_7.effectController:stop()
end

function var0_0.resume(arg0_8)
	arg0_8.cakeController:resume()
	arg0_8.charController:resume()
	arg0_8.effectController:resume()
end

function var0_0.setGameOver(arg0_9)
	return
end

function var0_0.dispose(arg0_10)
	arg0_10.cakeController:dispose()
	arg0_10.charController:dispose()
end

function var0_0.showContainer(arg0_11, arg1_11)
	setActive(arg0_11.sceneMask, arg1_11)
end

function var0_0.press(arg0_12, arg1_12, arg2_12)
	if arg1_12 == KeyCode.A and arg2_12 then
		arg0_12:touchDirect(-1, false)
	elseif arg1_12 == KeyCode.D and arg2_12 then
		arg0_12:touchDirect(1, false)
	end
end

function var0_0.getScore(arg0_13, arg1_13, arg2_13)
	if arg2_13 <= 0 then
		arg2_13 = 1
	end

	for iter0_13 = #TouchCakeGameConst.score_rate_count, 1, -1 do
		local var0_13 = TouchCakeGameConst.score_rate_count[iter0_13][1]
		local var1_13 = TouchCakeGameConst.score_rate_count[iter0_13][2]

		if var0_13 <= arg2_13 then
			return math.floor(arg1_13 * var1_13)
		end
	end

	return arg1_13
end

function var0_0.touchDirect(arg0_14, arg1_14, arg2_14)
	if not arg0_14.charController:getTouchAble() or not arg0_14.cakeController:getTouchAble() then
		if not arg2_14 then
			arg0_14.touchTimeCache = 0.1
			arg0_14.touchDirectCache = arg1_14
		end

		return
	end

	arg0_14.touchTimeCache = -1

	if arg1_14 == -1 then
		arg0_14.charController:onTouchLeft()
	elseif arg1_14 == 1 then
		arg0_14.charController:onTouchRight()
	end
end

return var0_0
