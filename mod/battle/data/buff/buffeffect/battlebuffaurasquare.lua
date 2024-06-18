ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAuraSquare", var0_0.Battle.BattleBuffAura)

var0_0.Battle.BattleBuffAuraSquare = var1_0
var1_0.__name = "BattleBuffAuraSquare"

local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleConfig

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = var0_0.Battle.BattleDataProxy.GetInstance()
	local var1_2, var2_2, var3_2, var4_2 = var0_2:GetTotalBounds()
	local var5_2 = var4_2 - var3_2
	local var6_2 = var1_2 - var2_2
	local var7_2 = var2_2 + var6_2 * 0.5
	local var8_2 = var3_2 + var5_2 * 0.5

	arg0_2._unit = arg1_2
	arg0_2._buffLevel = arg2_2:GetLv()

	local var9_2 = arg0_2._tempData.arg_list

	arg0_2._arraWidth = var9_2.cld_data.box.width or var5_2
	arg0_2._auraHeight = var9_2.cld_data.box.height or var6_2
	arg0_2._buffID = var9_2.buff_id
	arg0_2._friendly = var9_2.friendly_fire or false
	arg0_2._frontOffset = var9_2.cld_data.box.front_offset or 0

	local var10_2, var11_2, var12_2 = arg0_2:getAreaCldFunc(arg1_2)
	local var13_2 = arg1_2:GetIFF()

	arg0_2._aura = var0_2:SpawnLastingCubeArea(var2_0.AOEField.SURFACE, var13_2, arg1_2:GetPosition(), arg0_2._arraWidth, arg0_2._auraHeight, 0, var10_2, var11_2, arg0_2._friendly, nil, var12_2, false)

	local var14_2 = var0_0.Battle.BattleAOEScaleableComponent.New(arg0_2._aura)

	var14_2:SetReferenceUnit(arg1_2)

	local var15_2 = var13_2 == var3_0.FRIENDLY_CODE and var3_2 or var4_2
	local var16_2 = {
		upperBound = var1_2,
		lowerBound = var2_2,
		rearBound = var15_2,
		frontOffset = arg0_2._frontOffset
	}

	var14_2:ConfigData(var14_2.FILL, var16_2)

	local function var17_2(arg0_3)
		local var0_3 = arg0_2._aura:GetPosition()
		local var1_3 = arg0_2._aura:GetWidth()
		local var2_3 = arg0_2._aura:GetHeight()

		return var0_3, var1_3, var2_3
	end

	arg0_2._effectIndex = "BattleBuffAuraSquare" .. arg0_2._buffID

	local var18_2 = {
		index = arg0_2._effectIndex,
		effect = var9_2.effect,
		fillFunc = var17_2
	}

	arg1_2:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ADD_EFFECT, var18_2))
end

function var1_0.Clear(arg0_4)
	arg0_4._unit:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CANCEL_EFFECT, {
		index = arg0_4._effectIndex
	}))
	var1_0.super.Clear(arg0_4)
end
