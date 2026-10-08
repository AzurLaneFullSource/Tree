local var0_0 = class("MainTipActivityRemasterSequence")

var0_0.isTip = false

function var0_0.Execute(arg0_1, arg1_1)
	if var0_0.isTip then
		arg1_1()

		return
	end

	if not getProxy(ActivityRemasterProxy):ShouldShowActiveBtn() then
		arg1_1()

		return
	end

	arg0_1:ShowTips(arg1_1)
end

function var0_0.ShowTips(arg0_2, arg1_2)
	var0_0.isTip = true

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTREMASTE)
end

return var0_0
