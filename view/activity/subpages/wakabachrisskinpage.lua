local var0_0 = class("WakabaChrisSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	arg0_1.nday = arg0_1.activity.data3

	local var0_1 = {}
	local var1_1 = arg0_1.activity:getConfig("config_client").story
	local var2_1 = pg.NewStoryMgr.GetInstance()

	for iter0_1 = 1, arg0_1.nday do
		if checkExist(var1_1, {
			iter0_1
		}, {
			1
		}) and not var2_1:IsPlayed(var1_1[iter0_1][1]) then
			table.insert(var0_1, function(arg0_2)
				var2_1:Play(var1_1[iter0_1][1], arg0_2)
			end)
		end
	end

	seriesAsync(var0_1, function()
		print("story play number", #var0_1)
	end)
	setText(arg0_1.dayTF, arg0_1.nday .. "/" .. #arg0_1.taskGroup)
	arg0_1.uilist:align(#arg0_1.taskGroup[arg0_1.nday])
end

return var0_0
