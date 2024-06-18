ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffShiftWeapon = class("BattleBuffShiftWeapon", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffShiftWeapon.__name = "BattleBuffShiftWeapon"

local var1_0 = var0_0.Battle.BattleBuffShiftWeapon

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._detachID = arg0_2._tempData.arg_list.detach_id
	arg0_2._attachID = arg0_2._tempData.arg_list.weapon_id
	arg0_2._detachLabel = arg0_2._tempData.arg_list.detach_labelList
	arg0_2._fixedEnabled = arg0_2._tempData.arg_list.fixed
	arg0_2._initCD = arg0_2._tempData.arg_list.initial_over_heat
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg0_3:shiftWeapon(arg1_3)
end

function var1_0.shiftWeapon(arg0_4, arg1_4)
	local var0_4 = arg0_4:removeWeapon(arg1_4)

	if not var0_4 or var0_4:IsFixedWeapon() and not arg0_4._fixedEnabled then
		return
	end

	local var1_4 = var0_4:GetEquipmentLabel()
	local var2_4 = var0_4:GetSkinID()
	local var3_4 = var0_4:GetPotential()
	local var4_4 = var0_4:GetEquipmentIndex()
	local var5_4 = 0
	local var6_4 = {}

	while var0_4 ~= nil do
		table.insert(var6_4, var0_4:GetModifyInitialCD())

		var5_4 = var5_4 + 1
		var0_4 = arg0_4:removeWeapon(arg1_4)
	end

	for iter0_4 = 1, var5_4 do
		local var7_4 = arg1_4:AddWeapon(arg0_4._attachID, var1_4, var2_4, var3_4, var4_4)

		if var6_4[iter0_4] then
			var7_4:SetModifyInitialCD()
		end
	end
end

function var1_0.removeWeapon(arg0_5, arg1_5)
	local var0_5

	if arg0_5._detachID then
		var0_5 = arg1_5:RemoveWeapon(arg0_5._detachID)
	elseif arg0_5._detachLabel then
		var0_5 = arg1_5:RemoveWeaponByLabel(arg0_5._detachLabel)
	end

	return var0_5
end
