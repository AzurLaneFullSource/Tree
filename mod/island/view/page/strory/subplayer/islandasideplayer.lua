local var0_0 = class("IslandAsidePlayer", import("Mgr.Story.model.animation.StoryAnimtion"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.asideUIlist = UIItemList.New(arg1_1:Find("list"), arg1_1:Find("list/tpl"))
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	arg0_2.asideUIlist:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			setText(arg2_3, arg1_2[arg1_3 + 1].text)

			GetOrAddComponent(arg2_3, typeof(CanvasGroup)).alpha = 0
		end
	end)
	arg0_2.asideUIlist:align(#arg1_2)

	local var0_2 = {}

	arg0_2.asideUIlist:eachActive(function(arg0_4, arg1_4)
		table.insert(var0_2, function(arg0_5)
			arg0_2:TweenValueForcanvasGroup(GetOrAddComponent(arg1_4, typeof(CanvasGroup)), 0, 1, 0.2, arg1_2[arg0_4 + 1].delay, arg0_5)
		end)
	end)
	parallelAsync(var0_2, function()
		arg0_2:Clear()
		arg0_2:DelayCall(1, arg2_2)
	end)
end

function var0_0.Clear(arg0_7)
	arg0_7:ClearAnimation()
end

function var0_0.Dispose(arg0_8)
	arg0_8:Clear()
end

return var0_0
