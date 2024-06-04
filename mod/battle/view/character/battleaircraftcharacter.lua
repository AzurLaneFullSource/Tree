ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent

var0.Battle.BattleAircraftCharacter = class("BattleAircraftCharacter", var0.Battle.BattleCharacter)
var0.Battle.BattleAircraftCharacter.__name = "BattleAircraftCharacter"

local var2 = var0.Battle.BattleAircraftCharacter

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)

	arg0._hpBarOffset = Vector3(0, 1.6, 0)

	arg0:SetYShakeMin()
	arg0:SetYShakeMax()

	arg0.shadowScale = Vector3.one
	arg0.shadowPos = Vector3.zero
end

function var2.SetUnitData(arg0, arg1)
	arg0._unitData = arg1

	arg0:AddUnitEvent()
end

function var2.InitWeapon(arg0)
	arg0._weapon = arg0._unitData:GetWeapon()

	for iter0, iter1 in ipairs(arg0._weapon) do
		iter1:RegisterEventListener(arg0, var1.CREATE_BULLET, arg0.onCreateBullet)
	end
end

function var2.GetModleID(arg0)
	return arg0._unitData:GetSkinID()
end

function var2.GetInitScale(arg0)
	return 1
end

function var2.AddUnitEvent(arg0)
	return
end

function var2.RemoveUnitEvent(arg0)
	for iter0, iter1 in ipairs(arg0._weapon) do
		iter1:UnregisterEventListener(arg0, var1.CREATE_BULLET)
	end

	if arg0._unitData:GetIFF() == var0.Battle.BattleConfig.FOE_CODE then
		arg0._unitData:UnregisterEventListener(arg0, var1.UPDATE_AIR_CRAFT_HP)
	end
end

function var2.PlayAction(arg0)
	return
end

function var2.Update(arg0)
	arg0:UpdateMatrix()
	arg0:UpdateDirection()
	arg0:UpdateUIComponentPosition()
	arg0:UpdateShadow()
	arg0:UpdatePosition()

	if arg0._unitData:GetIFF() == var0.Battle.BattleConfig.FOE_CODE then
		arg0:UpdateHPPop()
		arg0:UpdateHPPopContainerPosition()
		arg0:UpdateHPBarPosition()
		arg0:UpdateHpBar()
	end
end

function var2.UpdatePosition(arg0)
	if not arg0._unitData:IsOutViewBound() then
		arg0._tf.localPosition = arg0._unitData:GetPosition()
	end

	arg0._characterPos = arg0._unitData:GetPosition()
end

function var2.UpdateDirection(arg0)
	if arg0._unitData:GetCurrentState() ~= arg0._unitData.STATE_CREATE then
		return
	end

	local var0 = arg0._unitData:GetSize()

	if arg0._unitData:GetDirection() == var0.Battle.BattleConst.UnitDir.RIGHT then
		arg0._tf.localScale = Vector3(var0, var0, var0)
	elseif arg0._unitData:GetDirection() == var0.Battle.BattleConst.UnitDir.LEFT then
		arg0._tf.localScale = Vector3(-var0, var0, var0)
	end
end

function var2.UpdateHPBarPosition(arg0)
	arg0._hpBarPos:Copy(arg0._referenceVector):Add(arg0._hpBarOffset)

	arg0._HPBarTf.position = arg0._hpBarPos
end

function var2.UpdateShadow(arg0)
	if arg0._shadow and arg0._unitData:GetCurrentState() == arg0._unitData.STATE_CREATE then
		local var0 = arg0._unitData:GetPosition()
		local var1 = math.min(4, math.max(2, 4 - 4 * var0.y / var0.Battle.BattleConfig.AircraftHeight))

		arg0.shadowScale.x, arg0.shadowScale.z = var1, var1
		arg0._shadowTF.localScale = arg0.shadowScale
		arg0.shadowPos.x, arg0.shadowPos.z = var0.x, var0.z
		arg0._shadowTF.position = arg0.shadowPos
	end
end

function var2.GetYShake(arg0)
	arg0._YShakeCurrent = arg0._YShakeCurrent or 0
	arg0._YShakeDir = arg0._YShakeDir or 1
	arg0._YShakeCurrent = arg0._YShakeCurrent + 0.1 * arg0._YShakeDir

	if arg0._YShakeCurrent > arg0._YShakeMax and arg0._YShakeDir == 1 then
		arg0._YShakeDir = -1

		arg0:SetYShakeMin()
	elseif arg0._YShakeCurrent < arg0._YShakeMin and arg0._YShakeDir == -1 then
		arg0._YShakeDir = 1

		arg0:SetYShakeMax()
	end

	return arg0._YShakeCurrent
end

function var2.SetYShakeMin(arg0)
	arg0._YShakeMin = -1 - 2 * math.random()
end

function var2.SetYShakeMax(arg0)
	arg0._YShakeMax = 1 + 2 * math.random()
end

function var2.AddModel(arg0, arg1)
	arg0:SetGO(arg1)

	arg0._hpBarOffset = Vector3(0, arg0._unitData:GetBoxSize().y, 0)

	arg0:SetBoneList()

	arg0._tf.position = arg0._unitData:GetPosition()

	arg0:UpdateMatrix()
	arg0._unitData:ActiveCldBox()
end

function var2.AddShadow(arg0, arg1)
	arg0._shadow = arg0:GetTf():Find("model/shadow").gameObject
	arg0._shadowTF = arg0._shadow.transform
end

function var2.AddHPBar(arg0, arg1)
	arg0._HPBar = arg1
	arg0._HPBarTf = arg1.transform
	arg0._HPProgress = arg0._HPBarTf:Find("blood"):GetComponent(typeof(Image))

	arg1:SetActive(true)
	arg0._unitData:RegisterEventListener(arg0, var1.UPDATE_AIR_CRAFT_HP, arg0.OnUpdateHP)
	arg0:UpdateHpBar()
end

function var2.updateSomkeFX(arg0)
	return
end
