ys.Battle.BattleConstPlayerUnit = class("BattleConstPlayerUnit", ys.Battle.BattlePlayerUnit)
ys.Battle.BattleConstPlayerUnit.__name = "BattleConstPlayerUnit"

local var0_0 = ys.Battle.BattleConstPlayerUnit
local var1_0 = ys.Battle.BattleConst.EquipmentType

function var0_0.setWeapon(arg0_1, arg1_1)
	local var0_1 = arg0_1._tmpData.default_equip_list
	local var1_1 = arg0_1._tmpData.base_list

	arg0_1._proficiencyList = {}

	for iter0_1 = 1, #var0_1 do
		table.insert(arg0_1._proficiencyList, arg0_1._tmpData.equipment_proficiency[iter0_1] or 1)
	end

	local var2_1 = arg0_1._proficiencyList
	local var3_1 = arg0_1._tmpData.preload_count

	for iter1_1, iter2_1 in ipairs(var0_1) do
		if iter1_1 <= Ship.WEAPON_COUNT then
			local var4_1 = var2_1[iter1_1]
			local var5_1 = var3_1[iter1_1]

			;(function(arg0_2, arg1_2, arg2_2)
				local var0_2 = var1_1[iter1_1]

				for iter0_2 = 1, var0_2 do
					local var1_2 = arg0_1:AddWeapon(arg0_2, arg1_2, arg2_2, var4_1, iter1_1)
					local var2_2 = var1_2:GetTemplateData().type

					if iter0_2 <= var5_1 and (var2_2 == var1_0.POINT_HIT_AND_LOCK or var2_2 == var1_0.MANUAL_TORPEDO or var2_2 == var1_0.DISPOSABLE_TORPEDO) then
						var1_2:SetModifyInitialCD()
					end
				end
			end)(arg1_1[iter1_1] or var0_1[iter1_1])
		end
	end

	local var6_1 = #var0_1
	local var7_1 = arg0_1._tmpData.fix_equip_list

	for iter3_1, iter4_1 in ipairs(var7_1) do
		if iter4_1 and iter4_1 ~= -1 then
			local var8_1 = var2_1[iter3_1 + var6_1] or 1

			arg0_1:AddWeapon(iter4_1, nil, nil, var8_1, iter3_1 + var6_1)
		end
	end
end

function var0_0.IsAlive(arg0_3)
	return true
end

function var0_0.HideWaveFx(arg0_4)
	arg0_4:DispatchEvent(ys.Event.New(ys.Battle.BattleUnitEvent.HIDE_WAVE_FX))
end

function var0_0.UpdateHPAction(arg0_5, arg1_5, ...)
	var0_0.super.UpdateHPAction(arg0_5, arg1_5, ...)

	if arg1_5.dHP <= 0 then
		arg0_5:DispatchEvent(ys.Event.New(ys.Battle.BattleUnitEvent.ADD_BLINK, {
			blink = {
				blue = 1,
				peroid = 0.1,
				red = 1,
				green = 1,
				duration = 0.1
			}
		}))
	end
end
