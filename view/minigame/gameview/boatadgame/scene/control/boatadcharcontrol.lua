local var0_0 = class("BoatAdCharControl")
local var1_0
local var2_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	var2_0 = BoatAdGameConst
	arg0_1._bgContent = arg1_1
	arg0_1._eventCall = arg2_1
	arg0_1._charContent = findTF(arg0_1._bgContent, "scene/content")

	local var0_1 = var2_0.game_char[var1_0.char_id]
	local var1_1 = var1_0.GetGameTplTf(var0_1.tpl)

	arg0_1._char = BoatAdChar.New(var1_1, arg0_1._eventCall)

	arg0_1._char:setData(var0_1)
	arg0_1._char:setContent(arg0_1._charContent)
end

function var0_0.start(arg0_2)
	var1_0.SetGameChar(arg0_2._char)
	arg0_2._char:start()
end

function var0_0.step(arg0_3, arg1_3)
	local var0_3 = var1_0.joyStickData
	local var1_3 = 0
	local var2_3 = 0
	local var3_3 = 0
	local var4_3 = 0

	if var0_3 and var0_3.active then
		local var5_3, var6_3 = var0_3.x, var0_3.y

		var3_3 = var0_3.directX, var0_3.directY

		if math.abs(var5_3) < 0.2 then
			var3_3 = 0
		end

		if math.abs(var6_3) < 0.2 then
			local var7_3 = 0
		end
	end

	arg0_3._char:changeDirect(var3_3, 0)
	arg0_3._char:step(arg1_3)

	if not arg0_3._char:getLife() then
		arg0_3._eventCall(BoatAdGameEvent.PLAYER_DEAD, true)
	end
end

function var0_0.stop(arg0_4)
	arg0_4._char:stop()
end

function var0_0.resume(arg0_5)
	arg0_5._char:resume()
end

function var0_0.clear(arg0_6)
	arg0_6._char:clear()
end

function var0_0.dispose(arg0_7)
	return
end

function var0_0.onEventCall(arg0_8, arg1_8, arg2_8)
	if arg1_8 == BoatAdGameEvent.PLAYER_EVENT_DAMAGE then
		arg0_8._char:damage(arg2_8)
	end
end

return var0_0
