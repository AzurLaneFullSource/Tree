local var0_0 = class("FushunEliteBeastChar", import(".FushunBeastChar"))

function var0_0.Hurt(arg0_1, arg1_1)
	if arg0_1:IsDeath() or arg0_1:IsEscape() then
		return
	end

	arg0_1.animatorEvent:SetEndEvent(nil)
	arg0_1.animatorEvent:SetEndEvent(function()
		arg0_1:Unfreeze()
	end)
	arg0_1:Freeze()
	arg0_1:UpdateHp(arg0_1.hp - arg1_1)
	arg0_1.animator:SetTrigger("damage")
end

function var0_0.UpdateHp(arg0_3, arg1_3)
	var0_0.super.UpdateHp(arg0_3, arg1_3)
	arg0_3.animator:SetInteger("hp", arg0_3.hp)
end

return var0_0
