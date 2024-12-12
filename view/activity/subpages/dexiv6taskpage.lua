local var0_0 = class("MaoxiV4TaskPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	arg0_1.nday = arg0_1.activity.data3

	arg0_1:PlayStory()

	if arg0_1.dayTF then
		setText(arg0_1.dayTF, tostring(arg0_1.nday))
	end

	arg0_1.uilist:align(#arg0_1.taskGroup[arg0_1.nday])
end

function var0_0.PlayStory(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client").story
	local var1_2 = arg0_2.activity:getConfig("config_client").specialstory
	local var2_2

	if arg0_2.nday == 1 then
		local var3_2 = arg0_2.taskGroup[arg0_2.nday][1]
		local var4_2 = arg0_2.taskGroup[arg0_2.nday][2]
		local var5_2 = arg0_2.taskProxy:getTaskVO(var3_2)
		local var6_2 = arg0_2.taskProxy:getTaskVO(var4_2)

		if var5_2:isReceive() and var6_2:isReceive() then
			var2_2 = var1_2[1]
		else
			var2_2 = var0_2[arg0_2.nday]
		end
	elseif arg0_2.nday == 2 then
		if not pg.NewStoryMgr.GetInstance():IsPlayed(var1_2[1]) then
			var2_2 = var1_2[1]
		else
			var2_2 = var0_2[arg0_2.nday]
		end
	elseif arg0_2.nday == #var0_2 then
		local var7_2 = arg0_2.taskGroup[arg0_2.nday][1]
		local var8_2 = arg0_2.taskGroup[arg0_2.nday][2]
		local var9_2 = arg0_2.taskProxy:getTaskVO(var7_2)
		local var10_2 = arg0_2.taskProxy:getTaskVO(var8_2)

		if var9_2:isReceive() and var10_2:isReceive() then
			var2_2 = var1_2[2]
		else
			var2_2 = var0_2[arg0_2.nday]
		end
	else
		var2_2 = var0_2[arg0_2.nday]
	end

	print("story name:" .. var2_2)
	pg.NewStoryMgr.GetInstance():Play(var2_2)
end

return var0_0
