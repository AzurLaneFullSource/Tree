local var0_0 = class("ForestVacationSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	arg0_1.nday = arg0_1.activity.data3

	if arg0_1.dayTF then
		setText(arg0_1.dayTF, arg0_1.nday .. "/" .. #arg0_1.taskGroup)
	end

	arg0_1.uilist:align(#arg0_1.taskGroup[arg0_1.nday])
end

function var0_0.GetProgressColor(arg0_2)
	return "#A5AE90"
end

return var0_0
