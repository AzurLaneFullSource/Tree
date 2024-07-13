ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleAOEScaleableComponent")

var0_0.Battle.BattleAOEScaleableComponent = var3_0
var3_0.__name = "BattleAOEScaleableComponent"
var3_0.FILL = 1
var3_0.EXPEND = 2

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._area = arg1_1

	arg0_1._area:AppendComponent(arg0_1)

	local var0_1 = arg0_1._area.Settle

	function arg0_1._area.Settle()
		arg0_1:updateScale()
		var0_1(arg0_1._area)
	end
end

function var3_0.Dispose(arg0_3)
	arg0_3._area = nil
	arg0_3._referenceUnit = nil
end

function var3_0.SetReferenceUnit(arg0_4, arg1_4)
	arg0_4._referenceUnit = arg1_4
	arg0_4._referencePoint = Clone(arg1_4:GetPosition())
end

function var3_0.ConfigData(arg0_5, arg1_5, arg2_5)
	if arg1_5 == var3_0.FILL then
		arg0_5.updateScale = var3_0.doFill
		arg0_5._upperBound = arg2_5.upperBound
		arg0_5._lowerBound = arg2_5.lowerBound
		arg0_5._rearBound = arg2_5.rearBound
		arg0_5._frontOffset = arg2_5.frontOffset
	elseif arg1_5 == var3_0.EXPEND then
		arg0_5._area:SetFXStatic(false)

		arg0_5.updateScale = var3_0.doExpend
		arg0_5._expendDuration = arg2_5.expendDuration
		arg0_5._widthExpendSpeed = arg2_5.widthSpeed
		arg0_5._heightExpendSpeed = arg2_5.heightSpeed
		arg0_5._expendStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0_5._lastExpendTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end
end

function var3_0.doFill(arg0_6)
	local var0_6 = setmetatable({}, {
		__index = arg0_6._referenceUnit:GetPosition()
	})
	local var1_6 = arg0_6._area:GetIFF()
	local var2_6 = math.abs(arg0_6._upperBound - arg0_6._lowerBound)
	local var3_6 = arg0_6._frontOffset * 2

	arg0_6._area:SetWidth(var3_6)
	arg0_6._area:SetHeight(var2_6)
	arg0_6._area:GetCldComponent():ResetSize(var3_6, 5, var2_6)

	local var4_6 = var2_6 * 0.5 + arg0_6._lowerBound
	local var5_6 = var0_6.x

	arg0_6._referencePoint.x = var5_6
	arg0_6._referencePoint.z = var4_6

	arg0_6._area:SetPosition(arg0_6._referencePoint)
end

function var3_0.doExpend(arg0_7)
	local var0_7 = pg.TimeMgr.GetInstance():GetCombatTime()

	if var0_7 - arg0_7._expendStartTime < arg0_7._expendDuration then
		local var1_7 = arg0_7._area:GetWidth()
		local var2_7 = arg0_7._area:GetHeight()
		local var3_7 = var0_7 - arg0_7._lastExpendTime
		local var4_7 = var1_7 + arg0_7._widthExpendSpeed * var3_7
		local var5_7 = var2_7 + arg0_7._heightExpendSpeed * var3_7

		arg0_7._area:SetWidth(var4_7)
		arg0_7._area:SetHeight(var5_7)
		arg0_7._area:GetCldComponent():ResetSize(var1_7, 5, var2_7)
	end
end
