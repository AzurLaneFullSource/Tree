local var0_0 = class("WorldMapShip", import("...BaseEntity"))

var0_0.Fields = {
	fleetId = "number",
	buffs = "table",
	triggers = "table",
	id = "number",
	hpRant = "number"
}
var0_0.EventHpRantChange = "WorldMapShip.EventHpRantChange"
var0_0.EventUpdateBuff = "WorldMapShip.EventUpdateBuff"
var0_0.EventUpdateBroken = "WorldMapShip.EventUpdateBroken"

function var0_0.Build(arg0_1)
	arg0_1.id = nil
	arg0_1.hpRant = 10000
	arg0_1.buffs = {}
	arg0_1.triggers = {}
end

function var0_0.Setup(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.hpRant = arg1_2.hp_rant
	arg0_2.buffs = WorldConst.ParsingBuffs(arg1_2.buff_list)
end

function var0_0.Dispose(arg0_3)
	arg0_3:Clear()
end

function var0_0.GetImportWorldShipVO(arg0_4)
	return setmetatable({
		triggers = arg0_4.triggers,
		isBroken = arg0_4:IsBroken(),
		IsBenefitSkillActive = function(arg0_5, arg1_5)
			local var0_5 = false

			if arg1_5.type == Ship.BENEFIT_SKILL then
				if not arg0_5.isBroken and (not arg1_5.limit[1] or arg1_5.limit[1] == arg0_5.triggers.TeamNumbers) then
					var0_5 = true
				end
			elseif arg1_5.type == Ship.BENEFIT_EQUIP then
				local var1_5 = arg1_5.limit
				local var2_5 = arg0_5:getAllEquipments()

				for iter0_5, iter1_5 in ipairs(var2_5) do
					if iter1_5 and table.contains(var1_5, iter1_5:getConfig("id")) then
						var0_5 = true

						break
					end
				end
			elseif arg1_5.type == Ship.BENEFIT_MAP_AURA then
				var0_5 = not arg0_5.isBroken
			elseif arg1_5.type == Ship.BENEFIT_AID then
				var0_5 = not arg0_5.isBroken
			end

			return var0_5
		end,
		GetStaminaDiscount = function(arg0_6, arg1_6)
			local var0_6 = 0

			if arg1_6 == WorldConst.OpReqSub then
				for iter0_6, iter1_6 in pairs(arg0_6:getAllSkills()) do
					local var1_6 = tonumber(iter0_6 .. string.format("%.2d", iter1_6.level))
					local var2_6 = pg.skill_benefit_template[var1_6]

					if var2_6 and arg0_6:IsBenefitSkillActive(var2_6) and (var2_6.type == Ship.BENEFIT_EQUIP or var2_6.type == Ship.BENEFIT_SKILL) then
						var0_6 = var0_6 + defaultValue(var2_6.world_extra_effect[1], 0)
					end
				end
			end

			return var0_6
		end
	}, {
		__index = WorldConst.FetchRawShipVO(arg0_4.id)
	})
end

function var0_0.UpdateHpRant(arg0_7, arg1_7)
	if arg0_7.hpRant ~= arg1_7 then
		arg0_7.hpRant = arg1_7

		arg0_7:DispatchEvent(var0_0.EventHpRantChange)
	end
end

function var0_0.IsValid(arg0_8)
	return tobool(WorldConst.FetchRawShipVO(arg0_8.id))
end

function var0_0.IsAlive(arg0_9)
	return arg0_9.hpRant > 0
end

function var0_0.IsHpFull(arg0_10)
	return arg0_10.hpRant == 10000
end

function var0_0.IsHpSafe(arg0_11)
	return arg0_11.hpRant >= 3000
end

function var0_0.GetBuffList(arg0_12)
	local var0_12 = underscore.filter(underscore.values(arg0_12.buffs), function(arg0_13)
		return arg0_13:GetFloor() > 0
	end)
	local var1_12 = arg0_12.fleetId and nowWorld():GetFleet(arg0_12.fleetId):GetDamageBuff()

	if var1_12 then
		table.insert(var0_12, var1_12)
	end

	return var0_12
end

function var0_0.GetBuff(arg0_14, arg1_14)
	if not arg0_14.buffs[arg1_14] then
		arg0_14.buffs[arg1_14] = WorldBuff.New()

		arg0_14.buffs[arg1_14]:Setup({
			floor = 0,
			id = arg1_14
		})
	end

	return arg0_14.buffs[arg1_14]
end

function var0_0.AddBuff(arg0_15, arg1_15, arg2_15)
	assert(arg1_15 and arg2_15)
	arg0_15:GetBuff(arg1_15):AddFloor(arg2_15)

	if arg1_15 == WorldConst.BrokenBuffId then
		arg0_15:DispatchEvent(var0_0.EventUpdateBroken)
	end

	arg0_15:DispatchEvent(var0_0.EventUpdateBuff)
end

function var0_0.RemoveBuff(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16:GetBuff(arg1_16)

	if arg2_16 then
		var0_16:AddFloor(arg2_16 * -1)
	else
		arg0_16.buffs[arg1_16] = nil
	end

	if arg1_16 == WorldConst.BrokenBuffId then
		arg0_16:DispatchEvent(var0_0.EventUpdateBroken)
	end

	arg0_16:DispatchEvent(var0_0.EventUpdateBuff)
end

function var0_0.IsBuffMax(arg0_17, arg1_17)
	return arg0_17:GetBuff(arg1_17):GetFloor() >= WorldBuff.GetTemplate(arg1_17).buff_maxfloor
end

function var0_0.Rebirth(arg0_18)
	assert(arg0_18.hpRant <= 0)

	local var0_18 = pg.gameset.world_death_hpfix.key_value

	arg0_18:UpdateHpRant(var0_18)
	arg0_18:AddBuff(WorldConst.BrokenBuffId, 1)
end

function var0_0.Repair(arg0_19)
	arg0_19:UpdateHpRant(10000)
	arg0_19:RemoveBuff(WorldConst.BrokenBuffId)
end

function var0_0.Regenerate(arg0_20, arg1_20)
	local var0_20 = math.min(10000, arg0_20.hpRant + arg1_20)

	arg0_20:UpdateHpRant(var0_20)
end

function var0_0.RegenerateValue(arg0_21, arg1_21)
	local var0_21 = math.floor(arg1_21 / WorldConst.FetchShipVO(arg0_21.id):getProperties(nil, true, false)[AttributeType.Durability] * 10000)
	local var1_21 = math.min(10000, arg0_21.hpRant + var0_21)

	arg0_21:UpdateHpRant(var1_21)
end

function var0_0.IsBroken(arg0_22)
	return arg0_22:GetBuff(WorldConst.BrokenBuffId):GetFloor() > 0
end

function var0_0.GetShipBuffProperties(arg0_23)
	local var0_23 = {}
	local var1_23 = {}
	local var2_23 = arg0_23.fleetId and nowWorld():GetFleet(arg0_23.fleetId):GetBuffList() or {}

	WorldConst.AppendPropertiesFromBuffList(var0_23, var1_23, var2_23)

	return var0_23, var1_23
end

function var0_0.GetShipPowerBuffProperties(arg0_24)
	local var0_24 = {}
	local var1_24 = arg0_24:GetBuffList()

	WorldConst.ExtendPropertiesRatesFromBuffList(var0_24, var1_24)

	return var0_24
end

return var0_0
