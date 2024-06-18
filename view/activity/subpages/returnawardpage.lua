local var0_0 = class("ReturnAwardPage", import("...base.BaseActivityPage"))

var0_0.INVITER = 1
var0_0.RETURNER = 2

function var0_0.OnFirstFlush(arg0_1)
	local var0_1 = {
		InviterPage,
		ReturnerPage
	}
	local var1_1 = arg0_1.activity

	assert(var0_1[var1_1.data1], var1_1.data1)

	arg0_1.page = var0_1[var1_1.data1].New(arg0_1._tf, arg0_1.event)

	onButton(arg0_1, arg0_1.page.help, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.returner_help.tip
		})
	end)
end

function var0_0.OnUpdateFlush(arg0_3)
	local var0_3 = arg0_3.activity

	assert(arg0_3.page)
	arg0_3.page:Update(var0_3)
end

function var0_0.OnDestroy(arg0_4)
	assert(arg0_4.page)
	arg0_4.page:Dispose()
end

function var0_0.UseSecondPage(arg0_5, arg1_5)
	return arg1_5.data1 > 1
end

return var0_0
