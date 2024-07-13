ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = class("BattleAOEMobilizedComponent")

var0_0.Battle.BattleAOEMobilizedComponent = var2_0
var2_0.__name = "BattleAOEMobilizedComponent"
var2_0.STAY = 0
var2_0.FOLLOW = 1
var2_0.REFERENCE = 2

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._area = arg1_1

	arg0_1._area:AppendComponent(arg0_1)

	local var0_1 = arg0_1._area.Settle

	function arg0_1._area.Settle()
		arg0_1:updatePosition()
		var0_1(arg0_1._area)
	end
end

function var2_0.Dispose(arg0_3)
	arg0_3._area = nil
	arg0_3._referenceUnit = nil
end

function var2_0.SetReferenceUnit(arg0_4, arg1_4)
	arg0_4._referenceUnit = arg1_4
	arg0_4._referencePoint = Clone(arg1_4:GetPosition())
end

function var2_0.ConfigData(arg0_5, arg1_5, arg2_5)
	if arg1_5 == var2_0.STAY then
		arg0_5.updatePosition = var2_0.doStay
	elseif arg1_5 == var2_0.FOLLOW then
		arg0_5.updatePosition = var2_0.doFollow
	elseif arg1_5 == var2_0.REFERENCE then
		arg0_5.updatePosition = var2_0.doReference
		arg0_5._speedVector = Vector3.New(arg2_5.speedX, 0, 0)
	end
end

function var2_0.doStay()
	return
end

function var2_0.doFollow(arg0_7)
	local var0_7 = setmetatable({}, {
		__index = arg0_7._referenceUnit:GetPosition()
	})

	arg0_7._area:SetPosition(var0_7)
end

function var2_0.doReference(arg0_8)
	arg0_8._referencePoint:Add(arg0_8._speedVector)
	arg0_8._area:SetPosition(arg0_8._referencePoint)
end
