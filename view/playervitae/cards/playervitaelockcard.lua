local var0_0 = class("PlayerVitaeLockCard", import(".PlayerVitaeBaseCard"))

function var0_0.OnInit(arg0_1)
	arg0_1.desc = arg0_1._tf:Find("Text")
end

function var0_0.OnUpdate(arg0_2, arg1_2, arg2_2)
	setText(arg0_2.desc, i18n("secretary_unlock" .. arg1_2))
end

function var0_0.OnDispose(arg0_3)
	return
end

return var0_0
