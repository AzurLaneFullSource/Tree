ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleCameraSlider = class("BattleCameraSlider")

local var2_0 = class("BattleCameraSlider")

var0_0.Battle.BattleCameraSlider = var2_0
var2_0.__name = "BattleCameraSlider"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:Init()
end

function var2_0.Init(arg0_2)
	SetActive(arg0_2._go, true)

	arg0_2._distX, arg0_2._distY = 0, 0
	arg0_2._dirX, arg0_2._dirY = 0, 0
	arg0_2._isPress = false

	local var0_2 = pg.CameraFixMgr.GetInstance()

	arg0_2._screenWidth, arg0_2._screenHeight = var0_2.actualWidth, var0_2.actualHeight

	arg0_2._go:GetComponent("StickController"):SetStickFunc(function(arg0_3, arg1_3)
		arg0_2:updateStick(arg0_3, arg1_3)
	end)
end

function var2_0.updateStick(arg0_4, arg1_4, arg2_4)
	arg0_4._initX = false
	arg0_4._initY = false

	if arg2_4 == -1 then
		arg0_4._startX = nil
		arg0_4._startY = nil
		arg0_4._isPress = false
	else
		arg0_4._isPress = true

		local var0_4 = arg1_4.x
		local var1_4 = arg1_4.y

		if arg0_4._startX == nil then
			arg0_4._startX = var0_4
			arg0_4._startY = var1_4
			arg0_4._initX = true
			arg0_4._initY = true
		else
			local var2_4 = var0_4 - arg0_4._lastPosX

			if var2_4 * arg0_4._dirX < 0 then
				arg0_4._startX = var0_4
				arg0_4._initX = true
			end

			if var2_4 ~= 0 then
				arg0_4._dirX = var2_4
			end

			local var3_4 = var1_4 - arg0_4._lastPosY

			if var3_4 * arg0_4._dirY < 0 then
				arg0_4._startY = var1_4
				arg0_4._initY = true
			end

			if var3_4 ~= 0 then
				arg0_4._dirY = var3_4
			end
		end

		arg0_4._distX = (var0_4 - arg0_4._startX) / arg0_4._screenWidth
		arg0_4._distY = (var1_4 - arg0_4._startY) / arg0_4._screenHeight
	end

	arg0_4._lastPosX = arg1_4.x
	arg0_4._lastPosY = arg1_4.y
end

function var2_0.GetDistance(arg0_5)
	return arg0_5._distX, arg0_5._distY
end

function var2_0.IsFirstPress(arg0_6)
	return arg0_6._initX, arg0_6._initY
end

function var2_0.IsPress(arg0_7)
	return arg0_7._isPress
end
