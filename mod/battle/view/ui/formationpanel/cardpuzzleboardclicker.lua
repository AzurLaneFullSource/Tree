ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = class("CardPuzzleBoardClicker")

var0_0.Battle.CardPuzzleBoardClicker = var2_0
var2_0.__name = "CardPuzzleBoardClicker"
var2_0.CLICK_STATE_CLICK = "CLICK_STATE_CLICK"
var2_0.CLICK_STATE_DRAG = "CLICK_STATE_DRAG"
var2_0.CLICK_STATE_RELEASE = "CLICK_STATE_RELEASE"
var2_0.CLICK_STATE_NONE = "CLICK_STATE_NONE"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:Init()
end

function var2_0.Init(arg0_2)
	SetActive(arg0_2._go, true)

	arg0_2._distX, arg0_2._distY = 0, 0
	arg0_2._dirX, arg0_2._dirY = 0, 0
	arg0_2._prePress = false
	arg0_2._isPress = false

	local var0_2 = pg.CameraFixMgr.GetInstance()

	arg0_2._screenWidth, arg0_2._screenHeight = var0_2:GetCurrentWidth(), var0_2:GetCurrentHeight()

	arg0_2._go:GetComponent("StickController"):SetStickFunc(function(arg0_3, arg1_3)
		arg0_2:updateStick(arg0_3, arg1_3)
	end)
end

function var2_0.SetCardPuzzleComponent(arg0_4, arg1_4)
	arg0_4._cardPuzzleInfo = arg1_4
end

function var2_0.updateStick(arg0_5, arg1_5, arg2_5)
	if not arg0_5._cardPuzzleInfo:GetClickEnable() then
		return
	end

	arg0_5._initX = false
	arg0_5._initY = false

	if arg2_5 == -1 then
		arg0_5._startX = nil
		arg0_5._startY = nil
		arg0_5._isPress = false
	else
		arg0_5._isPress = true

		local var0_5 = arg1_5.x
		local var1_5 = arg1_5.y

		if arg0_5._startX == nil then
			arg0_5._startX = var0_5
			arg0_5._startY = var1_5
			arg0_5._initX = true
			arg0_5._initY = true
		else
			local var2_5 = var0_5 - arg0_5._lastPosX

			if var2_5 * arg0_5._dirX < 0 then
				arg0_5._startX = var0_5
				arg0_5._initX = true
			end

			if var2_5 ~= 0 then
				arg0_5._dirX = var2_5
			end

			local var3_5 = var1_5 - arg0_5._lastPosY

			if var3_5 * arg0_5._dirY < 0 then
				arg0_5._startY = var1_5
				arg0_5._initY = true
			end

			if var3_5 ~= 0 then
				arg0_5._dirY = var3_5
			end
		end

		arg0_5._distX = (var0_5 - arg0_5._startX) / arg0_5._screenWidth
		arg0_5._distY = (var1_5 - arg0_5._startY) / arg0_5._screenHeight
	end

	arg0_5._lastPosX = arg1_5.x
	arg0_5._lastPosY = arg1_5.y

	local var4_5

	if not arg0_5._prePress and arg0_5._isPress then
		var4_5 = var2_0.CLICK_STATE_CLICK
	elseif arg0_5._prePress and arg0_5._isPress then
		var4_5 = var2_0.CLICK_STATE_DRAG
	elseif arg0_5._prePress and not arg0_5._isPress then
		var4_5 = var2_0.CLICK_STATE_RELEASE
	else
		var4_5 = var2_0.CLICK_STATE_NONE
	end

	arg0_5._cardPuzzleInfo:UpdateClickPos(arg0_5._lastPosX, arg0_5._lastPosY, var4_5)

	arg0_5._prePress = arg0_5._isPress
end

function var2_0.GetDistance(arg0_6)
	return arg0_6._distX, arg0_6._distY
end

function var2_0.IsFirstPress(arg0_7)
	return arg0_7._initX, arg0_7._initY
end

function var2_0.IsPress(arg0_8)
	return arg0_8._isPress
end

function var2_0.Dispose(arg0_9)
	return
end
