local var0_0 = class("LittleRenownPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.heartTpl = arg0_1:findTF("HeartTpl", arg0_1.bg)
	arg0_1.heartContainer = arg0_1:findTF("HeartContainer", arg0_1.bg)
	arg0_1.heartUIItemList = UIItemList.New(arg0_1.heartContainer, arg0_1.heartTpl)

	arg0_1.heartUIItemList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg1_2 + 1
			local var1_2 = arg0_1.ptData:GetLevelProgress()
			local var2_2 = arg0_1:findTF("Full", arg2_2)

			setActive(var2_2, not (var1_2 < var0_2))
		end
	end)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	local var0_3, var1_3 = arg0_3.ptData:GetLevelProgress()

	arg0_3.heartUIItemList:align(var1_3)
end

return var0_0
