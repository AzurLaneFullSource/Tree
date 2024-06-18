local var0_0 = class("CastlePtPage", import(".TemplatePage.PtTemplatePage"))

var0_0.MAIN_ID = ActivityConst.CASTLE_ACT_ID

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1:findTF("main_btn", arg0_1.bg), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CASTLE_MAIN)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	arg0_3.mainAct = getProxy(ActivityProxy):getActivityById(var0_0.MAIN_ID)

	local var0_3 = arg0_3.mainAct.data2
	local var1_3 = arg0_3.mainAct.data1

	if table.contains({
		4565,
		4568,
		4571,
		4574,
		4577,
		4580,
		4583,
		4586
	}, var1_3) and not pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var1_3)) then
		var0_3 = var0_3 - 1
	end

	setText(arg0_3:findTF("main_btn/Text", arg0_3.bg), i18n("roll_times_left", var0_3))
	setText(arg0_3:findTF("description", arg0_3.bg), i18n("activity_kill"))
end

return var0_0
