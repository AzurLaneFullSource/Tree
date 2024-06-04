ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = var0.Battle.BattleEvent
local var4 = class("BattleSkillProjectArea", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillProjectArea = var4
var4.__name = "BattleSkillProjectArea"

function var4.Ctor(arg0, arg1)
	var4.super.Ctor(arg0, arg1, lv)

	arg0._posX = arg0._tempData.arg_list.offset_x
	arg0._posZ = arg0._tempData.arg_list.offset_z
	arg0._width = arg0._tempData.arg_list.width
	arg0._height = arg0._tempData.arg_list.height
	arg0._lifeTime = arg0._tempData.arg_list.life_time
	arg0._fx = arg0._tempData.arg_list.effect
	arg0._expendDuration = arg0._tempData.arg_list.expend_duration
	arg0._widthSpeed = arg0._tempData.arg_list.width_expend_speed
	arg0._heightSpeed = arg0._tempData.arg_list.height_expend_speed
	arg0._buffID = arg0._tempData.arg_list.cld_buff_id
end

function var4.DoDataEffect(arg0, arg1)
	arg0:doSpawnAOE(arg1)
end

function var4.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:doSpawnAOE(arg1)
end

function var4.doSpawnAOE(arg0, arg1)
	local var0 = var0.Battle.BattleDataProxy.GetInstance()

	local function var1(arg0)
		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var0 = var0:GetUnitList()[iter1.UID]
				local var1 = var0.Battle.BattleBuffUnit.New(arg0._buffID)

				var0:AddBuff(var1, true)
			end
		end
	end

	local function var2(arg0)
		if arg0.Active then
			var0:GetUnitList()[arg0.UID]:RemoveBuff(arg0._buffID, true)
		end
	end

	local var3 = arg1:GetPosition()
	local var4 = Vector3(var3.x + arg0._posX, 0, var3.z + arg0._posZ)
	local var5 = var0:SpawnLastingCubeArea(var1.AOEField.SURFACE, arg1:GetIFF(), var4, arg0._width, arg0._height, arg0._lifeTime, var1, var2, true, arg0._fx, nil)

	if arg0._expendDuration > 0 then
		local var6 = var0.Battle.BattleAOEScaleableComponent.New(var5)

		var6:SetReferenceUnit(arg1)

		local var7 = {
			expendDuration = arg0._expendDuration,
			widthSpeed = arg0._widthSpeed,
			heightSpeed = arg0._heightSpeed
		}

		var6:ConfigData(var6.EXPEND, var7)
	end
end
