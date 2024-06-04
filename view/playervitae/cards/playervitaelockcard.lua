local var0 = class("PlayerVitaeLockCard", import(".PlayerVitaeBaseCard"))

function var0.OnInit(arg0)
	arg0.desc = arg0._tf:Find("Text")
end

function var0.OnUpdate(arg0, arg1, arg2)
	setText(arg0.desc, i18n("secretary_unlock" .. arg1))
end

function var0.OnDispose(arg0)
	return
end

return var0
