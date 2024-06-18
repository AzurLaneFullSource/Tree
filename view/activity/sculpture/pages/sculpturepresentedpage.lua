local var0_0 = class("SculpturePresentedPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SculpturePresentedUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.container = arg0_2:findTF("frame/container")
	arg0_2.sendBtn = arg0_2:findTF("frame/btn")

	setAnchoredPosition(arg0_2.container, {
		x = 0,
		y = -80
	})
end

function var0_0.OnInit(arg0_3)
	return
end

function var0_0.Show(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4:Clear()
	var0_0.super.Show(arg0_4)

	arg0_4.id = arg1_4
	arg0_4.activity = arg2_4

	if arg3_4 then
		arg3_4()
	end

	seriesAsync({
		function(arg0_5)
			arg0_4:LoadSculpture(arg0_5)
		end
	}, function()
		arg0_4:RegisterEvent()
	end)
	pg.BgmMgr.GetInstance():Push(arg0_4.__cname, "story-richang-8")
end

function var0_0.LoadSculpture(arg0_7, arg1_7)
	local var0_7 = arg0_7.activity:GetResorceName(arg0_7.id)
	local var1_7 = "gift_" .. var0_7

	PoolMgr.GetInstance():GetSpineChar(var1_7, true, function(arg0_8)
		arg0_8.transform:SetParent(arg0_7.container)

		arg0_8.transform.localScale = Vector3.one
		arg0_8.transform.localPosition = Vector3(0, 0, 0)

		arg0_8:GetComponent(typeof(SpineAnimUI)):SetAction("normal", 0)

		arg0_7.charName = var1_7
		arg0_7.charGo = arg0_8

		if arg1_7 then
			arg1_7()
		end
	end)
end

function var0_0.RegisterEvent(arg0_9)
	onButton(arg0_9, arg0_9.sendBtn, function()
		arg0_9:emit(SculptureScene.OPEN_GRATITUDE_PAGE, arg0_9.id)
	end, SFX_PANEL)
end

function var0_0.Clear(arg0_11)
	if arg0_11.charGo then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_11.charName, arg0_11.charGo)
	end
end

function var0_0.Hide(arg0_12)
	var0_0.super.Hide(arg0_12)
	pg.BgmMgr.GetInstance():Pop(arg0_12.__cname)
end

function var0_0.OnDestroy(arg0_13)
	arg0_13:Clear()
end

return var0_0
