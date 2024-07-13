local var0_0 = class("MainCommissionBtn4Mellow", import(".MainCommissionBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, 0)

	arg0_1.animationPlayer = arg1_1:GetComponent(typeof(Animation))
end

function var0_0.OnClick(arg0_2)
	arg0_2.animationPlayer:Play("anim_newmain_extend_show")
	arg0_2:emit(NewMainMediator.OPEN_COMMISION)
end

function var0_0.ResetCommissionBtn(arg0_3)
	arg0_3.animationPlayer:Play("anim_newmain_extend_hide")
end

function var0_0.Flush(arg0_4, arg1_4)
	local var0_4 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(CommissionInfoMediator)

	if not arg1_4 and not var0_4 then
		arg0_4:ResetCommissionBtn()
	end
end

return var0_0
