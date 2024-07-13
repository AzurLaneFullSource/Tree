local var0_0 = class("StoryPerformPlayer", import(".BasePerformPlayer"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.noDrawGraphicCom = arg0_1._tf.parent:GetComponent("NoDrawingGraphic")
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	arg0_2:Show()

	arg0_2.noDrawGraphicCom.enabled = false

	pg.NewStoryMgr.GetInstance():Play(arg1_2.param or "", function()
		arg0_2.noDrawGraphicCom.enabled = true

		if arg2_2 then
			arg2_2()
		end
	end, true)
end

function var0_0.Clear(arg0_4)
	arg0_4:Hide()
end

return var0_0
