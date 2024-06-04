local var0 = class("CentaurAwardPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, arg0.nday .. "/" .. #arg0.taskGroup)
	eachChild(arg0.items, function(arg0)
		local var0 = arg0:findTF("get_btn", arg0)
		local var1 = arg0:findTF("got_btn", arg0)
		local var2 = isActive(var1)

		setButtonEnabled(var1, false)
		setButtonEnabled(var0, not var2)

		if var2 then
			setActive(var0, true)
		end
	end)
end

return var0
