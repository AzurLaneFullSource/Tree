local var0 = class("LittleRenownPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.heartTpl = arg0:findTF("HeartTpl", arg0.bg)
	arg0.heartContainer = arg0:findTF("HeartContainer", arg0.bg)
	arg0.heartUIItemList = UIItemList.New(arg0.heartContainer, arg0.heartTpl)

	arg0.heartUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0.ptData:GetLevelProgress()
			local var2 = arg0:findTF("Full", arg2)

			setActive(var2, not (var1 < var0))
		end
	end)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1 = arg0.ptData:GetLevelProgress()

	arg0.heartUIItemList:align(var1)
end

return var0
