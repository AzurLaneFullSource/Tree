local var0 = class("WorldMapShip", import("...BaseEntity"))

var0.Fields = {
	fleetId = "number",
	buffs = "table",
	triggers = "table",
	id = "number",
	hpRant = "number"
}
var0.EventHpRantChange = "WorldMapShip.EventHpRantChange"
var0.EventUpdateBuff = "WorldMapShip.EventUpdateBuff"
var0.EventUpdateBroken = "WorldMapShip.EventUpdateBroken"

function var0.Build(arg0)
	arg0.id = nil
	arg0.hpRant = 10000
	arg0.buffs = {}
	arg0.triggers = {}
end

function var0.Setup(arg0, arg1)
	arg0.id = arg1.id
	arg0.hpRant = arg1.hp_rant
	arg0.buffs = WorldConst.ParsingBuffs(arg1.buff_list)
end

function var0.Dispose(arg0)
	arg0:Clear()
end

function var0.GetImportWorldShipVO(arg0)
	return setmetatable({
		triggers = arg0.triggers,
		isBroken = arg0:IsBroken(),
		IsBenefitSkillActive = function(arg0, arg1)
			local var0 = false

			if arg1.type == Ship.BENEFIT_SKILL then
				if not arg0.isBroken and (not arg1.limit[1] or arg1.limit[1] == arg0.triggers.TeamNumbers) then
					var0 = true
				end
			elseif arg1.type == Ship.BENEFIT_EQUIP then
				local var1 = arg1.limit
				local var2 = arg0:getAllEquipments()

				for iter0, iter1 in ipairs(var2) do
					if iter1 and table.contains(var1, iter1:getConfig("id")) then
						var0 = true

						break
					end
				end
			elseif arg1.type == Ship.BENEFIT_MAP_AURA then
				var0 = not arg0.isBroken
			elseif arg1.type == Ship.BENEFIT_AID then
				var0 = not arg0.isBroken
			end

			return var0
		end,
		GetStaminaDiscount = function(arg0, arg1)
			local var0 = 0

			if arg1 == WorldConst.OpReqSub then
				for iter0, iter1 in pairs(arg0:getAllSkills()) do
					local var1 = tonumber(iter0 .. string.format("%.2d", iter1.level))
					local var2 = pg.skill_benefit_template[var1]

					if var2 and arg0:IsBenefitSkillActive(var2) and (var2.type == Ship.BENEFIT_EQUIP or var2.type == Ship.BENEFIT_SKILL) then
						var0 = var0 + defaultValue(var2.world_extra_effect[1], 0)
					end
				end
			end

			return var0
		end
	}, {
		__index = WorldConst.FetchRawShipVO(arg0.id)
	})
end

function var0.UpdateHpRant(arg0, arg1)
	if arg0.hpRant ~= arg1 then
		arg0.hpRant = arg1

		arg0:DispatchEvent(var0.EventHpRantChange)
	end
end

function var0.IsValid(arg0)
	return tobool(WorldConst.FetchRawShipVO(arg0.id))
end

function var0.IsAlive(arg0)
	return arg0.hpRant > 0
end

function var0.IsHpFull(arg0)
	return arg0.hpRant == 10000
end

function var0.IsHpSafe(arg0)
	return arg0.hpRant >= 3000
end

function var0.GetBuffList(arg0)
	local var0 = underscore.filter(underscore.values(arg0.buffs), function(arg0)
		return arg0:GetFloor() > 0
	end)
	local var1 = arg0.fleetId and nowWorld():GetFleet(arg0.fleetId):GetDamageBuff()

	if var1 then
		table.insert(var0, var1)
	end

	return var0
end

function var0.GetBuff(arg0, arg1)
	if not arg0.buffs[arg1] then
		arg0.buffs[arg1] = WorldBuff.New()

		arg0.buffs[arg1]:Setup({
			floor = 0,
			id = arg1
		})
	end

	return arg0.buffs[arg1]
end

function var0.AddBuff(arg0, arg1, arg2)
	assert(arg1 and arg2)
	arg0:GetBuff(arg1):AddFloor(arg2)

	if arg1 == WorldConst.BrokenBuffId then
		arg0:DispatchEvent(var0.EventUpdateBroken)
	end

	arg0:DispatchEvent(var0.EventUpdateBuff)
end

function var0.RemoveBuff(arg0, arg1, arg2)
	local var0 = arg0:GetBuff(arg1)

	if arg2 then
		var0:AddFloor(arg2 * -1)
	else
		arg0.buffs[arg1] = nil
	end

	if arg1 == WorldConst.BrokenBuffId then
		arg0:DispatchEvent(var0.EventUpdateBroken)
	end

	arg0:DispatchEvent(var0.EventUpdateBuff)
end

function var0.IsBuffMax(arg0, arg1)
	return arg0:GetBuff(arg1):GetFloor() >= WorldBuff.GetTemplate(arg1).buff_maxfloor
end

function var0.Rebirth(arg0)
	assert(arg0.hpRant <= 0)

	local var0 = pg.gameset.world_death_hpfix.key_value

	arg0:UpdateHpRant(var0)
	arg0:AddBuff(WorldConst.BrokenBuffId, 1)
end

function var0.Repair(arg0)
	arg0:UpdateHpRant(10000)
	arg0:RemoveBuff(WorldConst.BrokenBuffId)
end

function var0.Regenerate(arg0, arg1)
	local var0 = math.min(10000, arg0.hpRant + arg1)

	arg0:UpdateHpRant(var0)
end

function var0.RegenerateValue(arg0, arg1)
	local var0 = math.floor(arg1 / WorldConst.FetchShipVO(arg0.id):getProperties(nil, true, false)[AttributeType.Durability] * 10000)
	local var1 = math.min(10000, arg0.hpRant + var0)

	arg0:UpdateHpRant(var1)
end

function var0.IsBroken(arg0)
	return arg0:GetBuff(WorldConst.BrokenBuffId):GetFloor() > 0
end

function var0.GetShipBuffProperties(arg0)
	local var0 = {}
	local var1 = {}
	local var2 = arg0.fleetId and nowWorld():GetFleet(arg0.fleetId):GetBuffList() or {}

	WorldConst.AppendPropertiesFromBuffList(var0, var1, var2)

	return var0, var1
end

function var0.GetShipPowerBuffProperties(arg0)
	local var0 = {}
	local var1 = arg0:GetBuffList()

	WorldConst.ExtendPropertiesRatesFromBuffList(var0, var1)

	return var0
end

return var0
