local var0 = class("StarSeaFacilityPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data3

	arg0:PlayStory()

	if arg0.dayTF then
		setText(arg0.dayTF, tostring(arg0.nday) .. "/7")
	end

	arg0.uilist:align(#arg0.taskGroup[arg0.nday])
end

return var0
