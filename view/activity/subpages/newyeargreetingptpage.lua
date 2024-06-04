local var0 = class("NewYearGreetingPtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.awardGotTag = arg0:findTF("award_got", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setActive(arg0.awardGotTag, not arg0.ptData:CanGetNextAward())
end

return var0
