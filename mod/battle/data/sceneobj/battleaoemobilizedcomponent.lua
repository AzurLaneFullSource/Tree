ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = class("BattleAOEMobilizedComponent")

var0.Battle.BattleAOEMobilizedComponent = var2
var2.__name = "BattleAOEMobilizedComponent"
var2.STAY = 0
var2.FOLLOW = 1
var2.REFERENCE = 2

function var2.Ctor(arg0, arg1)
	arg0._area = arg1

	arg0._area:AppendComponent(arg0)

	local var0 = arg0._area.Settle

	function arg0._area.Settle()
		arg0:updatePosition()
		var0(arg0._area)
	end
end

function var2.Dispose(arg0)
	arg0._area = nil
	arg0._referenceUnit = nil
end

function var2.SetReferenceUnit(arg0, arg1)
	arg0._referenceUnit = arg1
	arg0._referencePoint = Clone(arg1:GetPosition())
end

function var2.ConfigData(arg0, arg1, arg2)
	if arg1 == var2.STAY then
		arg0.updatePosition = var2.doStay
	elseif arg1 == var2.FOLLOW then
		arg0.updatePosition = var2.doFollow
	elseif arg1 == var2.REFERENCE then
		arg0.updatePosition = var2.doReference
		arg0._speedVector = Vector3.New(arg2.speedX, 0, 0)
	end
end

function var2.doStay()
	return
end

function var2.doFollow(arg0)
	local var0 = setmetatable({}, {
		__index = arg0._referenceUnit:GetPosition()
	})

	arg0._area:SetPosition(var0)
end

function var2.doReference(arg0)
	arg0._referencePoint:Add(arg0._speedVector)
	arg0._area:SetPosition(arg0._referencePoint)
end
