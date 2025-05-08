local var0_0 = class("IslandMissionPanel")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1

	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/confirm"), function()
		arg0_1:onClickConfirm()
	end, SFX_CONFIRM)
end

function var0_0.setData(arg0_3, arg1_3)
	arg0_3.buildType = arg1_3
end

function var0_0.onClickConfirm(arg0_4)
	arg0_4:setActive(false)
end

function var0_0.setActive(arg0_5, arg1_5)
	setActive(arg0_5._tf, arg1_5)
end

function var0_0.dispose(arg0_6)
	return
end

return var0_0
