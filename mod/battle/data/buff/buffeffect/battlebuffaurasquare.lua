ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAuraSquare", var0.Battle.BattleBuffAura)

var0.Battle.BattleBuffAuraSquare = var1
var1.__name = "BattleBuffAuraSquare"

local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleConfig

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = var0.Battle.BattleDataProxy.GetInstance()
	local var1, var2, var3, var4 = var0:GetTotalBounds()
	local var5 = var4 - var3
	local var6 = var1 - var2
	local var7 = var2 + var6 * 0.5
	local var8 = var3 + var5 * 0.5

	arg0._unit = arg1
	arg0._buffLevel = arg2:GetLv()

	local var9 = arg0._tempData.arg_list

	arg0._arraWidth = var9.cld_data.box.width or var5
	arg0._auraHeight = var9.cld_data.box.height or var6
	arg0._buffID = var9.buff_id
	arg0._friendly = var9.friendly_fire or false
	arg0._frontOffset = var9.cld_data.box.front_offset or 0

	local var10, var11, var12 = arg0:getAreaCldFunc(arg1)
	local var13 = arg1:GetIFF()

	arg0._aura = var0:SpawnLastingCubeArea(var2.AOEField.SURFACE, var13, arg1:GetPosition(), arg0._arraWidth, arg0._auraHeight, 0, var10, var11, arg0._friendly, nil, var12, false)

	local var14 = var0.Battle.BattleAOEScaleableComponent.New(arg0._aura)

	var14:SetReferenceUnit(arg1)

	local var15 = var13 == var3.FRIENDLY_CODE and var3 or var4
	local var16 = {
		upperBound = var1,
		lowerBound = var2,
		rearBound = var15,
		frontOffset = arg0._frontOffset
	}

	var14:ConfigData(var14.FILL, var16)

	local function var17(arg0)
		local var0 = arg0._aura:GetPosition()
		local var1 = arg0._aura:GetWidth()
		local var2 = arg0._aura:GetHeight()

		return var0, var1, var2
	end

	arg0._effectIndex = "BattleBuffAuraSquare" .. arg0._buffID

	local var18 = {
		index = arg0._effectIndex,
		effect = var9.effect,
		fillFunc = var17
	}

	arg1:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.ADD_EFFECT, var18))
end

function var1.Clear(arg0)
	arg0._unit:DispatchEvent(var0.Event.New(var0.Battle.BattleUnitEvent.CANCEL_EFFECT, {
		index = arg0._effectIndex
	}))
	var1.super.Clear(arg0)
end
