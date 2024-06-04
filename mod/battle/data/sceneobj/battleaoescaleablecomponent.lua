ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleAOEScaleableComponent")

var0.Battle.BattleAOEScaleableComponent = var3
var3.__name = "BattleAOEScaleableComponent"
var3.FILL = 1
var3.EXPEND = 2

function var3.Ctor(arg0, arg1)
	arg0._area = arg1

	arg0._area:AppendComponent(arg0)

	local var0 = arg0._area.Settle

	function arg0._area.Settle()
		arg0:updateScale()
		var0(arg0._area)
	end
end

function var3.Dispose(arg0)
	arg0._area = nil
	arg0._referenceUnit = nil
end

function var3.SetReferenceUnit(arg0, arg1)
	arg0._referenceUnit = arg1
	arg0._referencePoint = Clone(arg1:GetPosition())
end

function var3.ConfigData(arg0, arg1, arg2)
	if arg1 == var3.FILL then
		arg0.updateScale = var3.doFill
		arg0._upperBound = arg2.upperBound
		arg0._lowerBound = arg2.lowerBound
		arg0._rearBound = arg2.rearBound
		arg0._frontOffset = arg2.frontOffset
	elseif arg1 == var3.EXPEND then
		arg0._area:SetFXStatic(false)

		arg0.updateScale = var3.doExpend
		arg0._expendDuration = arg2.expendDuration
		arg0._widthExpendSpeed = arg2.widthSpeed
		arg0._heightExpendSpeed = arg2.heightSpeed
		arg0._expendStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0._lastExpendTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

function var3.doFill(arg0)
	local var0 = setmetatable({}, {
		__index = arg0._referenceUnit:GetPosition()
	})
	local var1 = arg0._area:GetIFF()
	local var2 = math.abs(arg0._upperBound - arg0._lowerBound)
	local var3 = arg0._frontOffset * 2

	arg0._area:SetWidth(var3)
	arg0._area:SetHeight(var2)
	arg0._area:GetCldComponent():ResetSize(var3, 5, var2)

	local var4 = var2 * 0.5 + arg0._lowerBound
	local var5 = var0.x

	arg0._referencePoint.x = var5
	arg0._referencePoint.z = var4

	arg0._area:SetPosition(arg0._referencePoint)
end

function var3.doExpend(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	if var0 - arg0._expendStartTime < arg0._expendDuration then
		local var1 = arg0._area:GetWidth()
		local var2 = arg0._area:GetHeight()
		local var3 = var0 - arg0._lastExpendTime
		local var4 = var1 + arg0._widthExpendSpeed * var3
		local var5 = var2 + arg0._heightExpendSpeed * var3

		arg0._area:SetWidth(var4)
		arg0._area:SetHeight(var5)
		arg0._area:GetCldComponent():ResetSize(var1, 5, var2)
	end
end
