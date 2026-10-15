local var0_0 = class("NicoMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.progress = arg0_1.bg:Find("progress")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.activity:getConfig("config_data")

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnUpdateFlush(arg0_3)
	arg0_3.nday = arg0_3.activity.data3

	local var0_3, var1_3 = arg0_3:getColor()
	local var2_3 = #arg0_3.taskGroup
	local var3_3 = var0_3 and setColorStr(arg0_3.nday, var0_3) or arg0_3.nday
	local var4_3 = var1_3 and setColorStr("/" .. var2_3, var1_3) or var2_3

	setText(arg0_3.progress, var3_3 .. var4_3)
	arg0_3:PlayStory()
end

function var0_0.getColor(arg0_4)
	return "#ac8c9f", "#FF6767"
end

function var0_0.PlayStory(arg0_5)
	local var0_5 = arg0_5.activity:getConfig("config_client").story

	if checkExist(var0_5, {
		arg0_5.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_5[arg0_5.nday][1], function()
			if checkExist(var0_5, {
				arg0_5.nday
			}, {
				2
			}) then
				pg.NewStoryMgr.GetInstance():Play(var0_5[arg0_5.nday][2])
			end
		end)
	end
end

return var0_0
