local var0_0 = class("ShadowCityOmenPage", import("view.activity.CorePage.OutPost.OutPostOmenPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("bg")
	arg0_1.dayTF = arg0_1.bg:Find("total_progress/day")
	arg0_1.maxDayTF = arg0_1.bg:Find("total_progress/max_day")
	arg0_1.item = arg0_1.bg:Find("item")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.btnDetail = arg0_1.bg:Find("btn_detail")
	arg0_1.txtDetail = arg0_1.btnDetail:Find("detail")
	arg0_1.btnStory = arg0_1.bg:Find("btn_story")
	arg0_1.taskWindow = ShadowCityOmenTaskWindow.New(arg0_1._tf, arg0_1.event)

	setActive(arg0_1.item, false)

	arg0_1.progressLabel = arg0_1.bg:Find("total_progress/label")

	setText(arg0_1.progressLabel, i18n("Outpost_20250904_Progress"))
	setText(arg0_1.txtDetail, i18n("Outpost_20260514_Detail"))
end

function var0_0.GetProgressColor(arg0_2)
	return "#25A1FF", "#393A3C"
end

function var0_0.UpdateTask(arg0_3, arg1_3, arg2_3)
	var0_0.super.UpdateTask(arg0_3, arg1_3, arg2_3)

	local var0_3 = arg1_3 + 1
	local var1_3 = arg0_3.taskGroup[arg0_3.nday][var0_3]
	local var2_3 = arg0_3.taskProxy:getTaskById(var1_3) or arg0_3.taskProxy:getFinishTaskById(var1_3)

	changeToScrollText(arg2_3:Find("description"), var2_3:getConfig("desc"))
end

function var0_0.PlayStory(arg0_4)
	local var0_4 = arg0_4.activity:getConfig("config_client").story
	local var1_4 = 1

	pg.NewStoryMgr.GetInstance():Play(var0_4[arg0_4.nday][var1_4], function()
		var1_4 = var1_4 + 1

		if var0_4[arg0_4.nday][var1_4] then
			pg.NewStoryMgr.GetInstance():Play(var0_4[arg0_4.nday][var1_4])
		end
	end)
end

return var0_0
