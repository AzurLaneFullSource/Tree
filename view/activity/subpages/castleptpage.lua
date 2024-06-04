local var0 = class("CastlePtPage", import(".TemplatePage.PtTemplatePage"))

var0.MAIN_ID = ActivityConst.CASTLE_ACT_ID

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0:findTF("main_btn", arg0.bg), function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CASTLE_MAIN)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	arg0.mainAct = getProxy(ActivityProxy):getActivityById(var0.MAIN_ID)

	local var0 = arg0.mainAct.data2
	local var1 = arg0.mainAct.data1

	if table.contains({
		4565,
		4568,
		4571,
		4574,
		4577,
		4580,
		4583,
		4586
	}, var1) and not pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var1)) then
		var0 = var0 - 1
	end

	setText(arg0:findTF("main_btn/Text", arg0.bg), i18n("roll_times_left", var0))
	setText(arg0:findTF("description", arg0.bg), i18n("activity_kill"))
end

return var0
