ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAura", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAura = var1_0
var1_0.__name = "BattleBuffAura"

local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleConfig

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._buffLevel = arg2_2:GetLv()

	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._auraRange = var0_2.cld_data.box.range
	arg0_2._buffID = var0_2.buff_id
	arg0_2._friendly = var0_2.friendly_fire or false

	local var1_2, var2_2, var3_2 = arg0_2:getAreaCldFunc(arg1_2)

	arg0_2._aura = var0_0.Battle.BattleDataProxy.GetInstance():SpawnLastingColumnArea(var2_0.AOEField.SURFACE, arg1_2:GetIFF(), arg1_2:GetPosition(), arg0_2._auraRange, 0, var1_2, var2_2, arg0_2._friendly, nil, var3_2, false)
	arg0_2._angle = var0_2.cld_data.angle

	if arg0_2._angle then
		arg0_2._aura:SetSectorAngle(arg0_2._angle, arg1_2:GetDirection())
	end

	local var4_2 = var0_0.Battle.BattleAOEMobilizedComponent.New(arg0_2._aura)

	var4_2:SetReferenceUnit(arg1_2)
	var4_2:ConfigData(var4_2.FOLLOW)
end

function var1_0.getAreaCldFunc(arg0_3, arg1_3)
	local function var0_3(arg0_4)
		local var0_4 = arg0_3:getTargetList(arg1_3, {
			"TargetEntityUnit"
		})

		for iter0_4, iter1_4 in ipairs(arg0_4) do
			if iter1_4.Active then
				for iter2_4, iter3_4 in ipairs(var0_4) do
					if iter3_4:GetUniqueID() == iter1_4.UID then
						local var1_4 = var0_0.Battle.BattleBuffUnit.New(arg0_3._buffID, arg0_3._buffLevel, arg0_3._caster)

						iter3_4:AddBuff(var1_4, true)

						break
					end
				end
			end
		end
	end

	local function var1_3(arg0_5)
		if arg0_5.Active then
			local var0_5 = arg0_3:getTargetList(arg1_3, {
				"TargetEntityUnit"
			})

			for iter0_5, iter1_5 in ipairs(var0_5) do
				if iter1_5:GetUniqueID() == arg0_5.UID then
					iter1_5:RemoveBuff(arg0_3._buffID, true)

					break
				end
			end
		end
	end

	local function var2_3(arg0_6)
		if arg0_6.Active then
			local var0_6 = arg0_3:getTargetList(arg1_3, {
				"TargetEntityUnit"
			})

			for iter0_6, iter1_6 in ipairs(var0_6) do
				if iter1_6:GetUniqueID() == arg0_6.UID then
					iter1_6:RemoveBuff(arg0_3._buffID, true)

					break
				end
			end
		end
	end

	return var0_3, var1_3, var2_3
end

function var1_0.Clear(arg0_7)
	arg0_7._aura:SetActiveFlag(false)

	arg0_7._aura = nil

	var1_0.super.Clear(arg0_7)
end
