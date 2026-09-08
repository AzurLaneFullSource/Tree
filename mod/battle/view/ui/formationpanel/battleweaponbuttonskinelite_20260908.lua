ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleWeaponButtonSkinElite_20260908", var0_0.Battle.BattleWeaponButtonSkinElite_20251218)

var0_0.Battle.BattleWeaponButtonSkinElite_20260908 = var1_0
var1_0.__name = "BattleWeaponButtonSkinElite_20260908"

function var1_0.updateProgressBar(arg0_1)
	local var0_1 = arg0_1._progressInfo:GetCurrent() / arg0_1._progressInfo:GetMax()

	arg0_1._progressBar.fillAmount = var0_1

	if arg0_1._progressInfo.GetCount and arg0_1._progressInfo:GetCount() > 0 then
		arg0_1._bgEff:GetComponent(typeof(CanvasGroup)).alpha = 1
	else
		arg0_1._bgEff:GetComponent(typeof(CanvasGroup)).alpha = var0_1
	end
end

return var1_0
