local var0 = class("ReturnAwardPage", import("...base.BaseActivityPage"))

var0.INVITER = 1
var0.RETURNER = 2

function var0.OnFirstFlush(arg0)
	local var0 = {
		InviterPage,
		ReturnerPage
	}
	local var1 = arg0.activity

	assert(var0[var1.data1], var1.data1)

	arg0.page = var0[var1.data1].New(arg0._tf, arg0.event)

	onButton(arg0, arg0.page.help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.returner_help.tip
		})
	end)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity

	assert(arg0.page)
	arg0.page:Update(var0)
end

function var0.OnDestroy(arg0)
	assert(arg0.page)
	arg0.page:Dispose()
end

function var0.UseSecondPage(arg0, arg1)
	return arg1.data1 > 1
end

return var0
