ys.Battle.BattleConstPlayerUnit = class("BattleConstPlayerUnit", ys.Battle.BattlePlayerUnit)
ys.Battle.BattleConstPlayerUnit.__name = "BattleConstPlayerUnit"

local var0 = ys.Battle.BattleConstPlayerUnit
local var1 = ys.Battle.BattleConst.EquipmentType

function var0.setWeapon(arg0, arg1)
	local var0 = arg0._tmpData.default_equip_list
	local var1 = arg0._tmpData.base_list

	arg0._proficiencyList = {}

	for iter0 = 1, #var0 do
		table.insert(arg0._proficiencyList, arg0._tmpData.equipment_proficiency[iter0] or 1)
	end

	local var2 = arg0._proficiencyList
	local var3 = arg0._tmpData.preload_count

	for iter1, iter2 in ipairs(var0) do
		if iter1 <= Ship.WEAPON_COUNT then
			local var4 = var2[iter1]
			local var5 = var3[iter1]

			;(function(arg0, arg1, arg2)
				local var0 = var1[iter1]

				for iter0 = 1, var0 do
					local var1 = arg0:AddWeapon(arg0, arg1, arg2, var4, iter1)
					local var2 = var1:GetTemplateData().type

					if iter0 <= var5 and (var2 == var1.POINT_HIT_AND_LOCK or var2 == var1.MANUAL_TORPEDO or var2 == var1.DISPOSABLE_TORPEDO) then
						var1:SetModifyInitialCD()
					end
				end
			end)(arg1[iter1] or var0[iter1])
		end
	end

	local var6 = #var0
	local var7 = arg0._tmpData.fix_equip_list

	for iter3, iter4 in ipairs(var7) do
		if iter4 and iter4 ~= -1 then
			local var8 = var2[iter3 + var6] or 1

			arg0:AddWeapon(iter4, nil, nil, var8, iter3 + var6)
		end
	end
end

function var0.IsAlive(arg0)
	return true
end

function var0.HideWaveFx(arg0)
	arg0:DispatchEvent(ys.Event.New(ys.Battle.BattleUnitEvent.HIDE_WAVE_FX))
end

function var0.UpdateHPAction(arg0, arg1, ...)
	var0.super.UpdateHPAction(arg0, arg1, ...)

	if arg1.dHP <= 0 then
		arg0:DispatchEvent(ys.Event.New(ys.Battle.BattleUnitEvent.ADD_BLINK, {
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
