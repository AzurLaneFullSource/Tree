ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = var0_0.Battle.BattleEvent
local var4_0 = class("BattleSkillProjectArea", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillProjectArea = var4_0
var4_0.__name = "BattleSkillProjectArea"

function var4_0.Ctor(arg0_1, arg1_1)
	var4_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._posX = arg0_1._tempData.arg_list.offset_x
	arg0_1._posZ = arg0_1._tempData.arg_list.offset_z
	arg0_1._width = arg0_1._tempData.arg_list.width
	arg0_1._height = arg0_1._tempData.arg_list.height
	arg0_1._lifeTime = arg0_1._tempData.arg_list.life_time
	arg0_1._fx = arg0_1._tempData.arg_list.effect
	arg0_1._expendDuration = arg0_1._tempData.arg_list.expend_duration
	arg0_1._widthSpeed = arg0_1._tempData.arg_list.width_expend_speed
	arg0_1._heightSpeed = arg0_1._tempData.arg_list.height_expend_speed
	arg0_1._buffID = arg0_1._tempData.arg_list.cld_buff_id
end

function var4_0.DoDataEffect(arg0_2, arg1_2)
	arg0_2:doSpawnAOE(arg1_2)
end

function var4_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:doSpawnAOE(arg1_3)
end

function var4_0.doSpawnAOE(arg0_4, arg1_4)
	local var0_4 = var0_0.Battle.BattleDataProxy.GetInstance()

	local function var1_4(arg0_5)
		for iter0_5, iter1_5 in ipairs(arg0_5) do
			if iter1_5.Active then
				local var0_5 = var0_4:GetUnitList()[iter1_5.UID]
				local var1_5 = var0_0.Battle.BattleBuffUnit.New(arg0_4._buffID)

				var0_5:AddBuff(var1_5, true)
			end
		end
	end

	local function var2_4(arg0_6)
		if arg0_6.Active then
			var0_4:GetUnitList()[arg0_6.UID]:RemoveBuff(arg0_4._buffID, true)
		end
	end

	local var3_4 = arg1_4:GetPosition()
	local var4_4 = Vector3(var3_4.x + arg0_4._posX, 0, var3_4.z + arg0_4._posZ)
	local var5_4 = var0_4:SpawnLastingCubeArea(var1_0.AOEField.SURFACE, arg1_4:GetIFF(), var4_4, arg0_4._width, arg0_4._height, arg0_4._lifeTime, var1_4, var2_4, true, arg0_4._fx, nil)

	if arg0_4._expendDuration > 0 then
		local var6_4 = var0_0.Battle.BattleAOEScaleableComponent.New(var5_4)

		var6_4:SetReferenceUnit(arg1_4)

		local var7_4 = {
			expendDuration = arg0_4._expendDuration,
			widthSpeed = arg0_4._widthSpeed,
			heightSpeed = arg0_4._heightSpeed
		}

		var6_4:ConfigData(var6_4.EXPEND, var7_4)
	end
end
