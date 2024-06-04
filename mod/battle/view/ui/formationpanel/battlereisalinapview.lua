ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleReisalinAPView")

var0.Battle.BattleReisalinAPView = var3
var3.__name = "BattleReisalinAPView"

function var3.Ctor(arg0, arg1)
	arg0._tf = arg1

	arg0:init()
end

function var3.init(arg0)
	arg0._apCap = var2.FLEET_ATTR_CAP[arg0:GetAttrName()]
	arg0._count = findTF(arg0._tf, "count")
	arg0._glow = findTF(arg0._tf, "glow_gizmos")
	arg0._countText = arg0._count:GetComponent(typeof(Text))

	SetActive(arg0._tf, true)
	arg0:UpdateAP(0)
end

function var3.UpdateAP(arg0, arg1)
	arg0._countText.text = arg1

	if arg1 >= arg0._apCap then
		arg0._countText.color = Color.ReisalinGold

		SetActive(arg0._glow, true)
	else
		arg0._countText.color = Color.white

		SetActive(arg0._glow, false)
	end
end

function var3.GetAttrName(arg0)
	return var2.ALCHEMIST_AP_NAME
end

function var3.Dispose(arg0)
	arg0._count = nil
	arg0._glow = nil
	arg0._countText = nil
	arg0._tf = nil
end
