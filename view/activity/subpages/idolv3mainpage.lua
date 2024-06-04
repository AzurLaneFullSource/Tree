local var0 = class("IdolV3MainPage", import(".TemplatePage.PreviewTemplatePage"))
local var1 = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6"
}
local var2 = 2
local var3 = 0.4

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.paintTF = arg0:findTF("Image", arg0.bg)
end

function var0.OnUpdateFlush(arg0)
	arg0.timer = Timer.New(function()
		arg0:ShowNextPainting()
	end, var2 + var3, -1)

	arg0.timer:Start()
end

function var0.ShowNextPainting(arg0)
	if not arg0.curIndex then
		arg0.curIndex = 1
	end

	arg0.curIndex = arg0.curIndex + 1

	if arg0.curIndex > #var1 then
		arg0.curIndex = 1
	end

	local var0 = var1[arg0.curIndex]

	seriesAsync({
		function(arg0)
			arg0:managedTween(LeanTween.value, nil, go(arg0.paintTF), 1, 0, var3 / 2):setOnUpdate(System.Action_float(function(arg0)
				GetOrAddComponent(arg0.paintTF, typeof(CanvasGroup)).alpha = arg0
			end)):setOnComplete(System.Action(function()
				arg0()
			end))
		end,
		function(arg0)
			GetSpriteFromAtlasAsync("ui/activityuipage/idolv3mainpage_atlas", var0, function(arg0)
				arg0.paintTF:GetComponent(typeof(Image)).sprite = arg0

				arg0()
			end)
		end,
		function(arg0)
			arg0:managedTween(LeanTween.value, nil, go(arg0.paintTF), 0, 1, var3 / 2):setOnUpdate(System.Action_float(function(arg0)
				GetOrAddComponent(arg0.paintTF, typeof(CanvasGroup)).alpha = arg0
			end)):setOnComplete(System.Action(function()
				arg0()
			end))
		end
	})
end

function var0.OnHideFlush(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	arg0:cleanManagedTween()
end

function var0.OnDestroy(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

return var0
