local var0_0 = class("GuildEventBasePage", import("....base.BaseSubView"))

function var0_0.Show(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1:UpdateData(arg1_1, arg2_1, arg3_1)
	var0_0.super.Show(arg0_1)
	assert(arg0_1._tf)
	pg.UIMgr:GetInstance():BlurPanel(arg0_1._tf)
	arg0_1:OnShow()

	arg0_1.inAnim = true

	arg0_1:EnterAnim(function()
		arg0_1.inAnim = false
	end)
end

function var0_0.SetHideCallBack(arg0_3, arg1_3)
	arg0_3.exitCallback = arg1_3
end

function var0_0.UpdateData(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4.guild = arg1_4
	arg0_4.player = arg2_4
	arg0_4.extraData = arg3_4
end

function var0_0.Hide(arg0_5, arg1_5)
	local function var0_5()
		arg0_5.inAnim = false

		var0_0.super.Hide(arg0_5)
		assert(arg0_5._tf)
		assert(arg0_5._parentTf)
		pg.UIMgr:GetInstance():UnblurPanel(arg0_5._tf, arg0_5._parentTf)

		if not arg1_5 and arg0_5.exitCallback then
			arg0_5.exitCallback()
		end
	end

	if not arg1_5 then
		arg0_5.inAnim = true

		arg0_5:ExistAnim(var0_5)
	else
		var0_5()
	end
end

function var0_0.OnDestroy(arg0_7)
	arg0_7:Hide(true)
end

function var0_0.emit(arg0_8, ...)
	if arg0_8.inAnim then
		return
	end

	var0_0.super.emit(arg0_8, ...)
end

function var0_0.EnterAnim(arg0_9, arg1_9)
	arg1_9()
end

function var0_0.ExistAnim(arg0_10, arg1_10)
	arg1_10()
end

function var0_0.OnShow(arg0_11)
	return
end

return var0_0
