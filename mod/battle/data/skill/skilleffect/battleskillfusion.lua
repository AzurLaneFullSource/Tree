ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleAttr
local var2_0 = var0_0.Battle.BattleTargetChoise

var0_0.Battle.BattleSkillFusion = class("BattleSkillFusion", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillFusion.__name = "BattleSkillFusion"

local var3_0 = var0_0.Battle.BattleSkillFusion

var3_0.FREEZE_POS = {
	Vector3(-10000, 0, 58),
	[-1] = Vector3(10000, 0, 58)
}

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	var3_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._fusionUnitTempID = arg0_1._tempData.arg_list.fusion_id
	arg0_1._fusionUnitSkinID = arg0_1._tempData.arg_list.ship_skin_id
	arg0_1._elementTagList = arg0_1._tempData.arg_list.element_tag_list
	arg0_1._attrInheritList = arg0_1._tempData.arg_list.attr_inherit_list
	arg0_1._fusionUnitEquipmentList = {}

	for iter0_1, iter1_1 in ipairs(arg0_1._tempData.arg_list.weapon_id_list) do
		table.insert(arg0_1._fusionUnitEquipmentList, {
			id = iter1_1,
			equipment = {
				weapon_id = {
					iter1_1
				}
			}
		})
	end

	arg0_1._fusionUnitSkillList = {}

	for iter2_1, iter3_1 in ipairs(arg0_1._tempData.arg_list.buff_list) do
		table.insert(arg0_1._fusionUnitSkillList, {
			id = iter3_1,
			level = arg0_1._level
		})
	end

	arg0_1._duration = arg0_1._tempData.arg_list.duration
end

function var3_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	arg0_2:doFusion(arg1_2)
end

function var3_0.DoDataEffectWithoutTarget(arg0_3, arg1_3, arg2_3)
	arg0_3:doFusion(arg1_3)
end

function var3_0.doFusion(arg0_4, arg1_4)
	local var0_4 = var2_0.TargetAllHelp(arg1_4)
	local var1_4 = var2_0.TargetShipTag(arg1_4, {
		ship_tag_list = arg0_4._elementTagList
	}, var0_4)
	local var2_4 = {}

	for iter0_4, iter1_4 in ipairs(Ship.PROPERTIES) do
		var2_4[iter1_4] = 1
	end

	local var3_4 = var0_0.Battle.BattleDataProxy.GetInstance()
	local var4_4 = {
		name = "123",
		shipGS = 1,
		id = arg1_4.id,
		tmpID = arg0_4._fusionUnitTempID,
		skinId = arg0_4._fusionUnitSkinID,
		level = var1_0.GetCurrent(arg1_4, "formulaLevel"),
		equipment = arg0_4._fusionUnitEquipmentList,
		properties = var2_4,
		baseProperties = var2_4,
		proficiency = {
			1,
			1,
			1
		},
		rarity = arg1_4:GetRarity(),
		intimacy = arg1_4:GetIntimacy(),
		skills = arg0_4._fusionUnitSkillList,
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
	local var5_4 = var3_4:SpawnFusionUnit(arg1_4, var4_4, var1_4, arg0_4._attrInheritList)
	local var6_4 = var5_4:GetHP()
	local var7_4 = {}

	for iter2_4, iter3_4 in ipairs(var1_4) do
		if iter3_4:IsMainFleetUnit() then
			var7_4[iter3_4] = Clone(iter3_4:GetPosition())
		end

		var3_4:FreezeUnit(iter3_4)
		iter3_4:SetPosition(var3_0.FREEZE_POS[iter3_4:GetIFF()])
	end

	if arg1_4:IsMainFleetUnit() then
		var7_4[arg1_4] = Clone(arg1_4:GetPosition())
	end

	var3_4:FreezeUnit(arg1_4)
	arg1_4:SetPosition(var3_0.FREEZE_POS[arg1_4:GetIFF()])

	arg0_4._fusionTimer = nil

	local function var8_4()
		local var0_5, var1_5 = var5_4:GetHP()
		local var2_5 = var1_5 - var0_5
		local var3_5 = 0
		local var4_5 = var5_4:GetPosition()
		local var5_5 = var5_4:GetAttrByName("hpProvideRate")

		if arg1_4:IsMainFleetUnit() then
			arg1_4:SetPosition(var7_4[arg1_4])
		else
			arg1_4:SetPosition(Clone(var4_5))
		end

		local var6_5 = math.floor(var2_5 * var5_5[arg1_4:GetAttrByName("id")])

		var3_4:HandleDirectDamage(arg1_4, var6_5)
		var3_4:ActiveFreezeUnit(arg1_4)

		for iter0_5, iter1_5 in ipairs(var1_4) do
			if iter1_5:IsMainFleetUnit() then
				iter1_5:SetPosition(var7_4[iter1_5])
			else
				iter1_5:SetPosition(Clone(var4_5))
			end

			local var7_5 = math.floor(var2_5 * var5_5[iter1_5:GetAttrByName("id")])

			var3_4:HandleDirectDamage(iter1_5, var7_5)
			var3_4:ActiveFreezeUnit(iter1_5)
		end

		var3_4:DefusionUnit(var5_4)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_4._fusionTimer)
	end

	arg0_4._fusionTimer = pg.TimeMgr.GetInstance():AddBattleTimer("fusionSkillTimer", 0, arg0_4._duration, var8_4, true)
end

function var3_0.Clear(arg0_6)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_6._fusionTimer)
	var3_0.super.Clear(arg0_6)
end
