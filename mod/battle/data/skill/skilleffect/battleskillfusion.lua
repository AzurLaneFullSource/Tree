ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleAttr
local var2 = var0.Battle.BattleTargetChoise

var0.Battle.BattleSkillFusion = class("BattleSkillFusion", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillFusion.__name = "BattleSkillFusion"

local var3 = var0.Battle.BattleSkillFusion

var3.FREEZE_POS = {
	Vector3(-10000, 0, 58),
	[-1] = Vector3(10000, 0, 58)
}

function var3.Ctor(arg0, arg1, arg2)
	var3.super.Ctor(arg0, arg1, arg2)

	arg0._fusionUnitTempID = arg0._tempData.arg_list.fusion_id
	arg0._fusionUnitSkinID = arg0._tempData.arg_list.ship_skin_id
	arg0._elementTagList = arg0._tempData.arg_list.element_tag_list
	arg0._attrInheritList = arg0._tempData.arg_list.attr_inherit_list
	arg0._fusionUnitEquipmentList = {}

	for iter0, iter1 in ipairs(arg0._tempData.arg_list.weapon_id_list) do
		table.insert(arg0._fusionUnitEquipmentList, {
			id = iter1,
			equipment = {
				weapon_id = {
					iter1
				}
			}
		})
	end

	arg0._fusionUnitSkillList = {}

	for iter2, iter3 in ipairs(arg0._tempData.arg_list.buff_list) do
		table.insert(arg0._fusionUnitSkillList, {
			id = iter3,
			level = arg0._level
		})
	end

	arg0._duration = arg0._tempData.arg_list.duration
end

function var3.DoDataEffect(arg0, arg1, arg2)
	arg0:doFusion(arg1)
end

function var3.DoDataEffectWithoutTarget(arg0, arg1, arg2)
	arg0:doFusion(arg1)
end

function var3.doFusion(arg0, arg1)
	local var0 = var2.TargetAllHelp(arg1)
	local var1 = var2.TargetShipTag(arg1, {
		ship_tag_list = arg0._elementTagList
	}, var0)
	local var2 = {}

	for iter0, iter1 in ipairs(Ship.PROPERTIES) do
		var2[iter1] = 1
	end

	local var3 = var0.Battle.BattleDataProxy.GetInstance()
	local var4 = {
		name = "123",
		shipGS = 1,
		id = arg1.id,
		tmpID = arg0._fusionUnitTempID,
		skinId = arg0._fusionUnitSkinID,
		level = var1.GetCurrent(arg1, "formulaLevel"),
		equipment = arg0._fusionUnitEquipmentList,
		properties = var2,
		baseProperties = var2,
		proficiency = {
			1,
			1,
			1
		},
		rarity = arg1:GetRarity(),
		intimacy = arg1:GetIntimacy(),
		skills = arg0._fusionUnitSkillList,
		baseList = {
			1,
			1,
			1
		},
		preloasList = {
			0,
			0,
			0
		}
	}
	local var5 = var3:SpawnFusionUnit(arg1, var4, var1, arg0._attrInheritList)
	local var6 = var5:GetHP()
	local var7 = {}

	for iter2, iter3 in ipairs(var1) do
		if iter3:IsMainFleetUnit() then
			var7[iter3] = Clone(iter3:GetPosition())
		end

		var3:FreezeUnit(iter3)
		iter3:SetPosition(var3.FREEZE_POS[iter3:GetIFF()])
	end

	if arg1:IsMainFleetUnit() then
		var7[arg1] = Clone(arg1:GetPosition())
	end

	var3:FreezeUnit(arg1)
	arg1:SetPosition(var3.FREEZE_POS[arg1:GetIFF()])

	arg0._fusionTimer = nil

	local function var8()
		local var0, var1 = var5:GetHP()
		local var2 = var1 - var0
		local var3 = 0
		local var4 = var5:GetPosition()
		local var5 = var5:GetAttrByName("hpProvideRate")

		if arg1:IsMainFleetUnit() then
			arg1:SetPosition(var7[arg1])
		else
			arg1:SetPosition(Clone(var4))
		end

		local var6 = math.floor(var2 * var5[arg1:GetAttrByName("id")])

		var3:HandleDirectDamage(arg1, var6)
		var3:ActiveFreezeUnit(arg1)

		for iter0, iter1 in ipairs(var1) do
			if iter1:IsMainFleetUnit() then
				iter1:SetPosition(var7[iter1])
			else
				iter1:SetPosition(Clone(var4))
			end

			local var7 = math.floor(var2 * var5[iter1:GetAttrByName("id")])

			var3:HandleDirectDamage(iter1, var7)
			var3:ActiveFreezeUnit(iter1)
		end

		var3:DefusionUnit(var5)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._fusionTimer)
	end

	arg0._fusionTimer = pg.TimeMgr.GetInstance():AddBattleTimer("fusionSkillTimer", 0, arg0._duration, var8, true)
end

function var3.Clear(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._fusionTimer)
	var3.super.Clear(arg0)
end
