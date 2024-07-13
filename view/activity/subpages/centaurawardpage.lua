local var0_0 = class("CentaurAwardPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, arg0_1.nday .. "/" .. #arg0_1.taskGroup)
	eachChild(arg0_1.items, function(arg0_2)
		local var0_2 = arg0_1:findTF("get_btn", arg0_2)
		local var1_2 = arg0_1:findTF("got_btn", arg0_2)
		local var2_2 = isActive(var1_2)

		setButtonEnabled(var1_2, false)
		setButtonEnabled(var0_2, not var2_2)

		if var2_2 then
			setActive(var0_2, true)
		end
	end)
end

return var0_0
