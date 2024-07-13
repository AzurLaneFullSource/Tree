ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleReisalinAPView")

var0_0.Battle.BattleReisalinAPView = var3_0
var3_0.__name = "BattleReisalinAPView"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1

	arg0_1:init()
end

function var3_0.init(arg0_2)
	arg0_2._apCap = var2_0.FLEET_ATTR_CAP[arg0_2:GetAttrName()]
	arg0_2._count = findTF(arg0_2._tf, "count")
	arg0_2._glow = findTF(arg0_2._tf, "glow_gizmos")
	arg0_2._countText = arg0_2._count:GetComponent(typeof(Text))

	SetActive(arg0_2._tf, true)
	arg0_2:UpdateAP(0)
end

function var3_0.UpdateAP(arg0_3, arg1_3)
	arg0_3._countText.text = arg1_3

	if arg1_3 >= arg0_3._apCap then
		arg0_3._countText.color = Color.ReisalinGold

		SetActive(arg0_3._glow, true)
	else
		arg0_3._countText.color = Color.white

		SetActive(arg0_3._glow, false)
	end
end

function var3_0.GetAttrName(arg0_4)
	return var2_0.ALCHEMIST_AP_NAME
end

function var3_0.Dispose(arg0_5)
	arg0_5._count = nil
	arg0_5._glow = nil
	arg0_5._countText = nil
	arg0_5._tf = nil
end
