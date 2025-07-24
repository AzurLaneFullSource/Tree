ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleYumiaManaView")

var0_0.Battle.BattleYumiaManaView = var3_0
var3_0.__name = "BattleYumiaManaView"
var3_0.TIPS_DURATION = 5

function var3_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1._go = arg1_1.gameObject

	arg0_1:init()
end

function var3_0.init(arg0_2)
	arg0_2._apCap = var2_0.FLEET_ATTR_CAP[arg0_2:GetAttrName()]
	arg0_2._count = findTF(arg0_2._tf, "count")
	arg0_2._progress = findTF(arg0_2._tf, "progress")
	arg0_2._countText = arg0_2._count:GetComponent(typeof(Text))

	SetActive(arg0_2._tf, true)

	arg0_2._barVector = rtf(arg0_2._progress).sizeDelta

	arg0_2:UpdateMana(0)
	setText(findTF(arg0_2._tf, "tips/text", i18n("yumia_mana_battle_tip")))
	setText(findTF(arg0_2._tf, "tips/text_shade", i18n("yumia_mana_battle_tip")))
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:showTips()
	end)
end

function var3_0.UpdateMana(arg0_4, arg1_4)
	setText(arg0_4._count, arg1_4)

	arg0_4._barVector.x = arg1_4
	rtf(arg0_4._progress).sizeDelta = arg0_4._barVector
end

function var3_0.GetAttrName(arg0_5)
	return var2_0.YUMIA_MANA_NAME
end

function var3_0.showTips(arg0_6)
	if LeanTween.isTweening(arg0_6._go) then
		return
	end

	SetActive(arg0_6._tf:Find("tips"), true)
	LeanTween.delayedCall(arg0_6._go, var3_0.TIPS_DURATION, System.Action(function()
		SetActive(arg0_6._tf:Find("tips"), false)
	end))
end

function var3_0.Dispose(arg0_8)
	LeanTween.cancel(arg0_8._go)
	pg.DelegateInfo.Dispose(arg0_8)

	arg0_8._count = nil
	arg0_8._progress = nil
	arg0_8._countText = nil
	arg0_8._tf = nil
end
