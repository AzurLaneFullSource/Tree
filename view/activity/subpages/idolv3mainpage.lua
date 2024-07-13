local var0_0 = class("IdolV3MainPage", import(".TemplatePage.PreviewTemplatePage"))
local var1_0 = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6"
}
local var2_0 = 2
local var3_0 = 0.4

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.paintTF = arg0_1:findTF("Image", arg0_1.bg)
end

function var0_0.OnUpdateFlush(arg0_2)
	arg0_2.timer = Timer.New(function()
		arg0_2:ShowNextPainting()
	end, var2_0 + var3_0, -1)

	arg0_2.timer:Start()
end

function var0_0.ShowNextPainting(arg0_4)
	if not arg0_4.curIndex then
		arg0_4.curIndex = 1
	end

	arg0_4.curIndex = arg0_4.curIndex + 1

	if arg0_4.curIndex > #var1_0 then
		arg0_4.curIndex = 1
	end

	local var0_4 = var1_0[arg0_4.curIndex]

	seriesAsync({
		function(arg0_5)
			arg0_4:managedTween(LeanTween.value, nil, go(arg0_4.paintTF), 1, 0, var3_0 / 2):setOnUpdate(System.Action_float(function(arg0_6)
				GetOrAddComponent(arg0_4.paintTF, typeof(CanvasGroup)).alpha = arg0_6
			end)):setOnComplete(System.Action(function()
				arg0_5()
			end))
		end,
		function(arg0_8)
			GetSpriteFromAtlasAsync("ui/activityuipage/idolv3mainpage_atlas", var0_4, function(arg0_9)
				arg0_4.paintTF:GetComponent(typeof(Image)).sprite = arg0_9

				arg0_8()
			end)
		end,
		function(arg0_10)
			arg0_4:managedTween(LeanTween.value, nil, go(arg0_4.paintTF), 0, 1, var3_0 / 2):setOnUpdate(System.Action_float(function(arg0_11)
				GetOrAddComponent(arg0_4.paintTF, typeof(CanvasGroup)).alpha = arg0_11
			end)):setOnComplete(System.Action(function()
				arg0_10()
			end))
		end
	})
end

function var0_0.OnHideFlush(arg0_13)
	if arg0_13.timer then
		arg0_13.timer:Stop()

		arg0_13.timer = nil
	end

	arg0_13:cleanManagedTween()
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14.timer then
		arg0_14.timer:Stop()

		arg0_14.timer = nil
	end
end

return var0_0
