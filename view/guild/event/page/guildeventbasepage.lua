local var0 = class("GuildEventBasePage", import("....base.BaseSubView"))

function var0.Show(arg0, arg1, arg2, arg3)
	arg0:UpdateData(arg1, arg2, arg3)
	var0.super.Show(arg0)
	assert(arg0._tf)
	pg.UIMgr:GetInstance():BlurPanel(arg0._tf)
	arg0:OnShow()

	arg0.inAnim = true

	arg0:EnterAnim(function()
		arg0.inAnim = false
	end)
end

function var0.SetHideCallBack(arg0, arg1)
	arg0.exitCallback = arg1
end

function var0.UpdateData(arg0, arg1, arg2, arg3)
	arg0.guild = arg1
	arg0.player = arg2
	arg0.extraData = arg3
end

function var0.Hide(arg0, arg1)
	local var0 = function()
		arg0.inAnim = false

		var0.super.Hide(arg0)
		assert(arg0._tf)
		assert(arg0._parentTf)
		pg.UIMgr:GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

		if not arg1 and arg0.exitCallback then
			arg0.exitCallback()
		end
	end

	if not arg1 then
		arg0.inAnim = true

		arg0:ExistAnim(var0)
	else
		var0()
	end
end

function var0.OnDestroy(arg0)
	arg0:Hide(true)
end

function var0.emit(arg0, ...)
	if arg0.inAnim then
		return
	end

	var0.super.emit(arg0, ...)
end

function var0.EnterAnim(arg0, arg1)
	arg1()
end

function var0.ExistAnim(arg0, arg1)
	arg1()
end

function var0.OnShow(arg0)
	return
end

return var0
