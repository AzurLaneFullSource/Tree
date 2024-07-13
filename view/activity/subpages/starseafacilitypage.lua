local var0_0 = class("StarSeaFacilityPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	arg0_1.nday = arg0_1.activity.data3

	arg0_1:PlayStory()

	if arg0_1.dayTF then
		setText(arg0_1.dayTF, tostring(arg0_1.nday) .. "/7")
	end

	arg0_1.uilist:align(#arg0_1.taskGroup[arg0_1.nday])
end

return var0_0
