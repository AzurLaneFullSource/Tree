ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleAirFighterUnit

var0_0.Battle.BattleAirFighterCharacter = class("BattleAirFighterCharacter", var0_0.Battle.BattleAircraftCharacter)
var0_0.Battle.BattleAirFighterCharacter.__name = "BattleAirFighterCharacter"

local var3_0 = var0_0.Battle.BattleAirFighterCharacter

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)

	arg0_1._scaleVector = Vector3(1, 1, 1)
end

function var3_0.SetUnitData(arg0_2, arg1_2)
	arg0_2._unitData = arg1_2

	arg0_2:AddUnitEvent()
	arg1_2:SetUnVisitable()
end

function var3_0.AddModel(arg0_3, arg1_3)
	arg0_3:SetGO(arg1_3)
	arg0_3:SetBoneList()
	arg0_3._unitData:ActiveCldBox()
end

function var3_0.Update(arg0_4)
	arg0_4:UpdateMatrix()
	arg0_4:UpdateUIComponentPosition()
	arg0_4:UpdateHPPop()
	arg0_4:UpdateHPPopContainerPosition()
	arg0_4:UpdateHPBarPosition()
	arg0_4:UpdatePosition()
	arg0_4:UpdateHpBar()

	local var0_4 = arg0_4._unitData:GetStrikeState()

	if var0_4 == var2_0.STRIKE_STATE_DOWN or var0_4 == var2_0.STRIKE_STATE_ATTACK or var0_4 == var2_0.STRIKE_STATE_UP then
		arg0_4:UpdateShadow()
	end
end

function var3_0.AddUnitEvent(arg0_5)
	var3_0.super.AddUnitEvent(arg0_5)
	arg0_5._unitData:RegisterEventListener(arg0_5, var1_0.AIR_STRIKE_STATE_CHANGE, arg0_5.onStrikeStateChange)
end

function var3_0.RemoveUnitEvent(arg0_6)
	var3_0.super.RemoveUnitEvent(arg0_6)
	arg0_6._unitData:UnregisterEventListener(arg0_6, var1_0.AIR_STRIKE_STATE_CHANGE)
end

function var3_0.onStrikeStateChange(arg0_7)
	local var0_7 = arg0_7._unitData:GetStrikeState()

	if var0_7 == var2_0.STRIKE_STATE_FLY then
		local var1_7 = (12 / (arg0_7._unitData:GetFormationIndex() + 3) + 1) * arg0_7._unitData:GetSize()

		arg0_7._scaleVector:Set(var1_7, var1_7, var1_7)

		arg0_7._tf.localScale = arg0_7._scaleVector

		arg0_7._shadow:SetActive(false)
	elseif var0_7 == var2_0.STRIKE_STATE_BACK then
		local var2_7 = arg0_7._unitData:GetSize()

		arg0_7._scaleVector:Set(-var2_7, var2_7, var2_7)

		arg0_7._tf.localScale = arg0_7._scaleVector

		arg0_7._HPBar:SetActive(true)
		arg0_7._shadow:SetActive(true)
	elseif var0_7 == var2_0.STRIKE_STATE_DOWN then
		-- block empty
	elseif var0_7 == var2_0.STRIKE_STATE_ATTACK then
		-- block empty
	elseif var0_7 == var2_0.STRIKE_STATE_UP then
		-- block empty
	elseif var0_7 == var2_0.STRIKE_STATE_FREE then
		-- block empty
	elseif var0_7 == var2_0.STRIKE_STATE_BACKWARD then
		local var3_7 = arg0_7._unitData:GetSize()

		arg0_7._scaleVector:Set(var3_7, var3_7, var3_7)

		arg0_7._tf.localScale = arg0_7._scaleVector
	end
end
