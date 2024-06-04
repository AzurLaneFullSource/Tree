ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffShiftWeapon = class("BattleBuffShiftWeapon", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffShiftWeapon.__name = "BattleBuffShiftWeapon"

local var1 = var0.Battle.BattleBuffShiftWeapon

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._detachID = arg0._tempData.arg_list.detach_id
	arg0._attachID = arg0._tempData.arg_list.weapon_id
	arg0._detachLabel = arg0._tempData.arg_list.detach_labelList
	arg0._fixedEnabled = arg0._tempData.arg_list.fixed
	arg0._initCD = arg0._tempData.arg_list.initial_over_heat
end

function var1.onAttach(arg0, arg1, arg2)
	arg0:shiftWeapon(arg1)
end

function var1.shiftWeapon(arg0, arg1)
	local var0 = arg0:removeWeapon(arg1)

	if not var0 or var0:IsFixedWeapon() and not arg0._fixedEnabled then
		return
	end

	local var1 = var0:GetEquipmentLabel()
	local var2 = var0:GetSkinID()
	local var3 = var0:GetPotential()
	local var4 = var0:GetEquipmentIndex()
	local var5 = 0
	local var6 = {}

	while var0 ~= nil do
		table.insert(var6, var0:GetModifyInitialCD())

		var5 = var5 + 1
		var0 = arg0:removeWeapon(arg1)
	end

	for iter0 = 1, var5 do
		local var7 = arg1:AddWeapon(arg0._attachID, var1, var2, var3, var4)

		if var6[iter0] then
			var7:SetModifyInitialCD()
		end
	end
end

function var1.removeWeapon(arg0, arg1)
	local var0

	if arg0._detachID then
		var0 = arg1:RemoveWeapon(arg0._detachID)
	elseif arg0._detachLabel then
		var0 = arg1:RemoveWeaponByLabel(arg0._detachLabel)
	end

	return var0
end
