ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleAircraftCharacter = class("BattleAircraftCharacter", var0_0.Battle.BattleCharacter)
var0_0.Battle.BattleAircraftCharacter.__name = "BattleAircraftCharacter"

local var2_0 = var0_0.Battle.BattleAircraftCharacter

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)

	arg0_1._hpBarOffset = Vector3(0, 1.6, 0)

	arg0_1:SetYShakeMin()
	arg0_1:SetYShakeMax()

	arg0_1.shadowScale = Vector3.one
	arg0_1.shadowPos = Vector3.zero
end

function var2_0.SetUnitData(arg0_2, arg1_2)
	arg0_2._unitData = arg1_2

	arg0_2:AddUnitEvent()
end

function var2_0.InitWeapon(arg0_3)
	arg0_3._weapon = arg0_3._unitData:GetWeapon()

	for iter0_3, iter1_3 in ipairs(arg0_3._weapon) do
		iter1_3:RegisterEventListener(arg0_3, var1_0.CREATE_BULLET, arg0_3.onCreateBullet)
	end
end

function var2_0.GetModleID(arg0_4)
	return arg0_4._unitData:GetSkinID()
end

function var2_0.GetInitScale(arg0_5)
	return 1
end

function var2_0.AddUnitEvent(arg0_6)
	return
end

function var2_0.RemoveUnitEvent(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7._weapon) do
		iter1_7:UnregisterEventListener(arg0_7, var1_0.CREATE_BULLET)
	end

	if arg0_7._unitData:GetIFF() == var0_0.Battle.BattleConfig.FOE_CODE then
		arg0_7._unitData:UnregisterEventListener(arg0_7, var1_0.UPDATE_AIR_CRAFT_HP)
	end
end

function var2_0.PlayAction(arg0_8)
	return
end

function var2_0.Update(arg0_9)
	arg0_9:UpdateMatrix()
	arg0_9:UpdateDirection()
	arg0_9:UpdateUIComponentPosition()
	arg0_9:UpdateShadow()
	arg0_9:UpdatePosition()

	if arg0_9._unitData:GetIFF() == var0_0.Battle.BattleConfig.FOE_CODE then
		arg0_9:UpdateHPPop()
		arg0_9:UpdateHPPopContainerPosition()
		arg0_9:UpdateHPBarPosition()
		arg0_9:UpdateHpBar()
	end
end

function var2_0.UpdatePosition(arg0_10)
	if not arg0_10._unitData:IsOutViewBound() then
		arg0_10._tf.localPosition = arg0_10._unitData:GetPosition()
	end

	arg0_10._characterPos = arg0_10._unitData:GetPosition()
end

function var2_0.UpdateDirection(arg0_11)
	if arg0_11._unitData:GetCurrentState() ~= arg0_11._unitData.STATE_CREATE then
		return
	end

	local var0_11 = arg0_11._unitData:GetSize()

	if arg0_11._unitData:GetDirection() == var0_0.Battle.BattleConst.UnitDir.RIGHT then
		arg0_11._tf.localScale = Vector3(var0_11, var0_11, var0_11)
	elseif arg0_11._unitData:GetDirection() == var0_0.Battle.BattleConst.UnitDir.LEFT then
		arg0_11._tf.localScale = Vector3(-var0_11, var0_11, var0_11)
	end
end

function var2_0.UpdateHPBarPosition(arg0_12)
	arg0_12._hpBarPos:Copy(arg0_12._referenceVector):Add(arg0_12._hpBarOffset)

	arg0_12._HPBarTf.position = arg0_12._hpBarPos
end

function var2_0.UpdateShadow(arg0_13)
	if arg0_13._shadow and arg0_13._unitData:GetCurrentState() == arg0_13._unitData.STATE_CREATE then
		local var0_13 = arg0_13._unitData:GetPosition()
		local var1_13 = math.min(4, math.max(2, 4 - 4 * var0_13.y / var0_0.Battle.BattleConfig.AircraftHeight))

		arg0_13.shadowScale.x, arg0_13.shadowScale.z = var1_13, var1_13
		arg0_13._shadowTF.localScale = arg0_13.shadowScale
		arg0_13.shadowPos.x, arg0_13.shadowPos.z = var0_13.x, var0_13.z
		arg0_13._shadowTF.position = arg0_13.shadowPos
	end
end

function var2_0.GetYShake(arg0_14)
	arg0_14._YShakeCurrent = arg0_14._YShakeCurrent or 0
	arg0_14._YShakeDir = arg0_14._YShakeDir or 1
	arg0_14._YShakeCurrent = arg0_14._YShakeCurrent + 0.1 * arg0_14._YShakeDir

	if arg0_14._YShakeCurrent > arg0_14._YShakeMax and arg0_14._YShakeDir == 1 then
		arg0_14._YShakeDir = -1

		arg0_14:SetYShakeMin()
	elseif arg0_14._YShakeCurrent < arg0_14._YShakeMin and arg0_14._YShakeDir == -1 then
		arg0_14._YShakeDir = 1

		arg0_14:SetYShakeMax()
	end

	return arg0_14._YShakeCurrent
end

function var2_0.SetYShakeMin(arg0_15)
	arg0_15._YShakeMin = -1 - 2 * math.random()
end

function var2_0.SetYShakeMax(arg0_16)
	arg0_16._YShakeMax = 1 + 2 * math.random()
end

function var2_0.AddModel(arg0_17, arg1_17)
	arg0_17:SetGO(arg1_17)

	arg0_17._hpBarOffset = Vector3(0, arg0_17._unitData:GetBoxSize().y, 0)

	arg0_17:SetBoneList()

	arg0_17._tf.position = arg0_17._unitData:GetPosition()

	arg0_17:UpdateMatrix()
	arg0_17._unitData:ActiveCldBox()
end

function var2_0.AddShadow(arg0_18, arg1_18)
	arg0_18._shadow = arg0_18:GetTf():Find("model/shadow").gameObject
	arg0_18._shadowTF = arg0_18._shadow.transform
end

function var2_0.AddHPBar(arg0_19, arg1_19)
	arg0_19._HPBar = arg1_19
	arg0_19._HPBarTf = arg1_19.transform
	arg0_19._HPProgress = arg0_19._HPBarTf:Find("blood"):GetComponent(typeof(Image))

	arg1_19:SetActive(true)
	arg0_19._unitData:RegisterEventListener(arg0_19, var1_0.UPDATE_AIR_CRAFT_HP, arg0_19.OnUpdateHP)
	arg0_19:UpdateHpBar()
end

function var2_0.updateSomkeFX(arg0_20)
	return
end
