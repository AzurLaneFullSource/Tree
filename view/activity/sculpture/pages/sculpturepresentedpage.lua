local var0 = class("SculpturePresentedPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SculpturePresentedUI"
end

function var0.OnLoaded(arg0)
	arg0.container = arg0:findTF("frame/container")
	arg0.sendBtn = arg0:findTF("frame/btn")

	setAnchoredPosition(arg0.container, {
		x = 0,
		y = -80
	})
end

function var0.OnInit(arg0)
	return
end

function var0.Show(arg0, arg1, arg2, arg3)
	arg0:Clear()
	var0.super.Show(arg0)

	arg0.id = arg1
	arg0.activity = arg2

	if arg3 then
		arg3()
	end

	seriesAsync({
		function(arg0)
			arg0:LoadSculpture(arg0)
		end
	}, function()
		arg0:RegisterEvent()
	end)
	pg.BgmMgr.GetInstance():Push(arg0.__cname, "story-richang-8")
end

function var0.LoadSculpture(arg0, arg1)
	local var0 = arg0.activity:GetResorceName(arg0.id)
	local var1 = "gift_" .. var0

	PoolMgr.GetInstance():GetSpineChar(var1, true, function(arg0)
		arg0.transform:SetParent(arg0.container)

		arg0.transform.localScale = Vector3.one
		arg0.transform.localPosition = Vector3(0, 0, 0)

		arg0:GetComponent(typeof(SpineAnimUI)):SetAction("normal", 0)

		arg0.charName = var1
		arg0.charGo = arg0

		if arg1 then
			arg1()
		end
	end)
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0.sendBtn, function()
		arg0:emit(SculptureScene.OPEN_GRATITUDE_PAGE, arg0.id)
	end, SFX_PANEL)
end

function var0.Clear(arg0)
	if arg0.charGo then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.charName, arg0.charGo)
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.BgmMgr.GetInstance():Pop(arg0.__cname)
end

function var0.OnDestroy(arg0)
	arg0:Clear()
end

return var0
