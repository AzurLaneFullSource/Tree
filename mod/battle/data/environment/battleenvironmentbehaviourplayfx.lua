ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleEnvironmentBehaviourPlayFX", var0.Battle.BattleEnvironmentBehaviour)

var0.Battle.BattleEnvironmentBehaviourPlayFX = var3
var3.__name = "BattleEnvironmentBehaviourPlayFX"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.SetTemplate(arg0, arg1)
	var3.super.SetTemplate(arg0, arg1)

	arg0._FXID = arg0._tmpData.FX_ID
	arg0._offset = arg0._tmpData.offset and Vector3(unpack(arg0._tmpData.offset)) or Vector3.zero
end

function var3.doBehaviour(arg0)
	local var0 = 1

	if arg0._tmpData.scaleRate then
		local var1 = arg0._unit:GetAOEData()
		local var2 = var1:GetAreaType()
		local var3

		if var2 == var1.AreaType.CUBE then
			var3 = var1:GetWidth()
		elseif var2 == var1.AreaType.COLUMN then
			var3 = var1:GetRange()
		end

		var0 = arg0._tmpData.scaleRate * var3
	elseif arg0._tmpData.scale then
		var0 = arg0._tmpData.scale
	end

	local var4 = arg0._unit:GetAOEData():GetPosition() + arg0._offset

	var0.Battle.BattleDataProxy.GetInstance():SpawnEffect(arg0._FXID, var4, var0)
	var3.super.doBehaviour(arg0)
end
