ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleEnvironmentBehaviourPlayFX", var0_0.Battle.BattleEnvironmentBehaviour)

var0_0.Battle.BattleEnvironmentBehaviourPlayFX = var3_0
var3_0.__name = "BattleEnvironmentBehaviourPlayFX"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.SetTemplate(arg0_2, arg1_2)
	var3_0.super.SetTemplate(arg0_2, arg1_2)

	arg0_2._FXID = arg0_2._tmpData.FX_ID
	arg0_2._offset = arg0_2._tmpData.offset and Vector3(unpack(arg0_2._tmpData.offset)) or Vector3.zero
end

function var3_0.doBehaviour(arg0_3)
	local var0_3 = 1

	if arg0_3._tmpData.scaleRate then
		local var1_3 = arg0_3._unit:GetAOEData()
		local var2_3 = var1_3:GetAreaType()
		local var3_3

		if var2_3 == var1_0.AreaType.CUBE then
			var3_3 = var1_3:GetWidth()
		elseif var2_3 == var1_0.AreaType.COLUMN then
			var3_3 = var1_3:GetRange()
		end

		var0_3 = arg0_3._tmpData.scaleRate * var3_3
	elseif arg0_3._tmpData.scale then
		var0_3 = arg0_3._tmpData.scale
	end

	local var4_3 = arg0_3._unit:GetAOEData():GetPosition() + arg0_3._offset

	var0_0.Battle.BattleDataProxy.GetInstance():SpawnEffect(arg0_3._FXID, var4_3, var0_3)
	var3_0.super.doBehaviour(arg0_3)
end
