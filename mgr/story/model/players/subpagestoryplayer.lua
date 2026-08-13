local var0_0 = class("SubPageStoryPlayer", import(".StoryPlayer"))

function var0_0.OnEnter(arg0_1, arg1_1, arg2_1, arg3_1)
	seriesAsync({
		function(arg0_2)
			arg0_1:OpenPage(arg1_1, arg0_2)
		end
	}, arg3_1)
end

function var0_0.OpenPage(arg0_3, arg1_3, arg2_3)
	arg0_3.page = arg1_3:GetSubPageCls().New(pg.NewStoryMgr.GetInstance()._tf)

	arg0_3.page:ExecuteAction("Show", arg2_3)
end

function var0_0.RegisetEvent(arg0_4, arg1_4, arg2_4)
	var0_0.super.RegisetEvent(arg0_4, arg1_4, arg2_4)

	if arg0_4.page then
		arg0_4.page:Destroy()
	end

	arg0_4.page = nil

	triggerButton(arg0_4._go)
end

return var0_0
