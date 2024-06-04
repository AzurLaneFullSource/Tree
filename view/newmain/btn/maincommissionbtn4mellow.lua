local var0 = class("MainCommissionBtn4Mellow", import(".MainCommissionBtn"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2, 0)

	arg0.animationPlayer = arg1:GetComponent(typeof(Animation))
end

function var0.OnClick(arg0)
	arg0.animationPlayer:Play("anim_newmain_extend_show")
	arg0:emit(NewMainMediator.OPEN_COMMISION)
end

function var0.ResetCommissionBtn(arg0)
	arg0.animationPlayer:Play("anim_newmain_extend_hide")
end

function var0.Flush(arg0, arg1)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(CommissionInfoMediator)

	if not arg1 and not var0 then
		arg0:ResetCommissionBtn()
	end
end

return var0
