ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = class("CardPuzzleBoardClicker")

var0.Battle.CardPuzzleBoardClicker = var2
var2.__name = "CardPuzzleBoardClicker"
var2.CLICK_STATE_CLICK = "CLICK_STATE_CLICK"
var2.CLICK_STATE_DRAG = "CLICK_STATE_DRAG"
var2.CLICK_STATE_RELEASE = "CLICK_STATE_RELEASE"
var2.CLICK_STATE_NONE = "CLICK_STATE_NONE"

function var2.Ctor(arg0, arg1)
	arg0._go = arg1

	arg0:Init()
end

function var2.Init(arg0)
	SetActive(arg0._go, true)

	arg0._distX, arg0._distY = 0, 0
	arg0._dirX, arg0._dirY = 0, 0
	arg0._prePress = false
	arg0._isPress = false

	local var0 = pg.CameraFixMgr.GetInstance()

	arg0._screenWidth, arg0._screenHeight = var0:GetCurrentWidth(), var0:GetCurrentHeight()

	arg0._go:GetComponent("StickController"):SetStickFunc(function(arg0, arg1)
		arg0:updateStick(arg0, arg1)
	end)
end

function var2.SetCardPuzzleComponent(arg0, arg1)
	arg0._cardPuzzleInfo = arg1
end

function var2.updateStick(arg0, arg1, arg2)
	if not arg0._cardPuzzleInfo:GetClickEnable() then
		return
	end

	arg0._initX = false
	arg0._initY = false

	if arg2 == -1 then
		arg0._startX = nil
		arg0._startY = nil
		arg0._isPress = false
	else
		arg0._isPress = true

		local var0 = arg1.x
		local var1 = arg1.y

		if arg0._startX == nil then
			arg0._startX = var0
			arg0._startY = var1
			arg0._initX = true
			arg0._initY = true
		else
			local var2 = var0 - arg0._lastPosX

			if var2 * arg0._dirX < 0 then
				arg0._startX = var0
				arg0._initX = true
			end

			if var2 ~= 0 then
				arg0._dirX = var2
			end

			local var3 = var1 - arg0._lastPosY

			if var3 * arg0._dirY < 0 then
				arg0._startY = var1
				arg0._initY = true
			end

			if var3 ~= 0 then
				arg0._dirY = var3
			end
		end

		arg0._distX = (var0 - arg0._startX) / arg0._screenWidth
		arg0._distY = (var1 - arg0._startY) / arg0._screenHeight
	end

	arg0._lastPosX = arg1.x
	arg0._lastPosY = arg1.y

	local var4

	if not arg0._prePress and arg0._isPress then
		var4 = var2.CLICK_STATE_CLICK
	elseif arg0._prePress and arg0._isPress then
		var4 = var2.CLICK_STATE_DRAG
	elseif arg0._prePress and not arg0._isPress then
		var4 = var2.CLICK_STATE_RELEASE
	else
		var4 = var2.CLICK_STATE_NONE
	end

	arg0._cardPuzzleInfo:UpdateClickPos(arg0._lastPosX, arg0._lastPosY, var4)

	arg0._prePress = arg0._isPress
end

function var2.GetDistance(arg0)
	return arg0._distX, arg0._distY
end

function var2.IsFirstPress(arg0)
	return arg0._initX, arg0._initY
end

function var2.IsPress(arg0)
	return arg0._isPress
end

function var2.Dispose(arg0)
	return
end
