ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAura", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAura = var1
var1.__name = "BattleBuffAura"

local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleConfig

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._buffLevel = arg2:GetLv()

	local var0 = arg0._tempData.arg_list

	arg0._auraRange = var0.cld_data.box.range
	arg0._buffID = var0.buff_id
	arg0._friendly = var0.friendly_fire or false

	local var1, var2, var3 = arg0:getAreaCldFunc(arg1)

	arg0._aura = var0.Battle.BattleDataProxy.GetInstance():SpawnLastingColumnArea(var2.AOEField.SURFACE, arg1:GetIFF(), arg1:GetPosition(), arg0._auraRange, 0, var1, var2, arg0._friendly, nil, var3, false)
	arg0._angle = var0.cld_data.angle

	if arg0._angle then
		arg0._aura:SetSectorAngle(arg0._angle, arg1:GetDirection())
	end

	local var4 = var0.Battle.BattleAOEMobilizedComponent.New(arg0._aura)

	var4:SetReferenceUnit(arg1)
	var4:ConfigData(var4.FOLLOW)
end

function var1.getAreaCldFunc(arg0, arg1)
	local var0 = function(arg0)
		local var0 = arg0:getTargetList(arg1, {
			"TargetEntityUnit"
		})

		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				for iter2, iter3 in ipairs(var0) do
					if iter3:GetUniqueID() == iter1.UID then
						local var1 = var0.Battle.BattleBuffUnit.New(arg0._buffID, arg0._buffLevel, arg0._caster)

						iter3:AddBuff(var1, true)

						break
					end
				end
			end
		end
	end

	local function var1(arg0)
		if arg0.Active then
			local var0 = arg0:getTargetList(arg1, {
				"TargetEntityUnit"
			})

			for iter0, iter1 in ipairs(var0) do
				if iter1:GetUniqueID() == arg0.UID then
					iter1:RemoveBuff(arg0._buffID, true)

					break
				end
			end
		end
	end

	local function var2(arg0)
		if arg0.Active then
			local var0 = arg0:getTargetList(arg1, {
				"TargetEntityUnit"
			})

			for iter0, iter1 in ipairs(var0) do
				if iter1:GetUniqueID() == arg0.UID then
					iter1:RemoveBuff(arg0._buffID, true)

					break
				end
			end
		end
	end

	return var0, var1, var2
end

function var1.Clear(arg0)
	arg0._aura:SetActiveFlag(false)

	arg0._aura = nil

	var1.super.Clear(arg0)
end
