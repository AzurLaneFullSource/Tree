local var0 = class("StoryPerformPlayer", import(".BasePerformPlayer"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.noDrawGraphicCom = arg0._tf.parent:GetComponent("NoDrawingGraphic")
end

function var0.Play(arg0, arg1, arg2)
	arg0:Show()

	arg0.noDrawGraphicCom.enabled = false

	pg.NewStoryMgr.GetInstance():Play(arg1.param or "", function()
		arg0.noDrawGraphicCom.enabled = true

		if arg2 then
			arg2()
		end
	end, true)
end

function var0.Clear(arg0)
	arg0:Hide()
end

return var0
