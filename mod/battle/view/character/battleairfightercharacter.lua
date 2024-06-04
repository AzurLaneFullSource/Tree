ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleAirFighterUnit

var0.Battle.BattleAirFighterCharacter = class("BattleAirFighterCharacter", var0.Battle.BattleAircraftCharacter)
var0.Battle.BattleAirFighterCharacter.__name = "BattleAirFighterCharacter"

local var3 = var0.Battle.BattleAirFighterCharacter

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)

	arg0._scaleVector = Vector3(1, 1, 1)
end

function var3.SetUnitData(arg0, arg1)
	arg0._unitData = arg1

	arg0:AddUnitEvent()
	arg1:SetUnVisitable()
end

function var3.AddModel(arg0, arg1)
	arg0:SetGO(arg1)
	arg0:SetBoneList()
	arg0._unitData:ActiveCldBox()
end

function var3.Update(arg0)
	arg0:UpdateMatrix()
	arg0:UpdateUIComponentPosition()
	arg0:UpdateHPPop()
	arg0:UpdateHPPopContainerPosition()
	arg0:UpdateHPBarPosition()
	arg0:UpdatePosition()
	arg0:UpdateHpBar()

	local var0 = arg0._unitData:GetStrikeState()

	if var0 == var2.STRIKE_STATE_DOWN or var0 == var2.STRIKE_STATE_ATTACK or var0 == var2.STRIKE_STATE_UP then
		arg0:UpdateShadow()
	end
end

function var3.AddUnitEvent(arg0)
	var3.super.AddUnitEvent(arg0)
	arg0._unitData:RegisterEventListener(arg0, var1.AIR_STRIKE_STATE_CHANGE, arg0.onStrikeStateChange)
end

function var3.RemoveUnitEvent(arg0)
	var3.super.RemoveUnitEvent(arg0)
	arg0._unitData:UnregisterEventListener(arg0, var1.AIR_STRIKE_STATE_CHANGE)
end

function var3.onStrikeStateChange(arg0)
	local var0 = arg0._unitData:GetStrikeState()

	if var0 == var2.STRIKE_STATE_FLY then
		local var1 = (12 / (arg0._unitData:GetFormationIndex() + 3) + 1) * arg0._unitData:GetSize()

		arg0._scaleVector:Set(var1, var1, var1)

		arg0._tf.localScale = arg0._scaleVector

		arg0._shadow:SetActive(false)
	elseif var0 == var2.STRIKE_STATE_BACK then
		local var2 = arg0._unitData:GetSize()

		arg0._scaleVector:Set(-var2, var2, var2)

		arg0._tf.localScale = arg0._scaleVector

		arg0._HPBar:SetActive(true)
		arg0._shadow:SetActive(true)
	elseif var0 == var2.STRIKE_STATE_DOWN then
		-- block empty
	elseif var0 == var2.STRIKE_STATE_ATTACK then
		-- block empty
	elseif var0 == var2.STRIKE_STATE_UP then
		-- block empty
	elseif var0 == var2.STRIKE_STATE_FREE then
		-- block empty
	elseif var0 == var2.STRIKE_STATE_BACKWARD then
		local var3 = arg0._unitData:GetSize()

		arg0._scaleVector:Set(var3, var3, var3)

		arg0._tf.localScale = arg0._scaleVector
	end
end
