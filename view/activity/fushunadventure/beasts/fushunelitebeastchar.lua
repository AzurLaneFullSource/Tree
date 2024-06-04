local var0 = class("FushunEliteBeastChar", import(".FushunBeastChar"))

function var0.Hurt(arg0, arg1)
	if arg0:IsDeath() or arg0:IsEscape() then
		return
	end

	arg0.animatorEvent:SetEndEvent(nil)
	arg0.animatorEvent:SetEndEvent(function()
		arg0:Unfreeze()
	end)
	arg0:Freeze()
	arg0:UpdateHp(arg0.hp - arg1)
	arg0.animator:SetTrigger("damage")
end

function var0.UpdateHp(arg0, arg1)
	var0.super.UpdateHp(arg0, arg1)
	arg0.animator:SetInteger("hp", arg0.hp)
end

return var0
