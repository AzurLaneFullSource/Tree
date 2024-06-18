local var0_0 = class("ChargeAwardPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("bg")
	arg0_1.charge = arg0_1:findTF("charge")
	arg0_1.take = arg0_1:findTF("take")
	arg0_1.finish = arg0_1:findTF("finish")
end

function var0_0.OnDataSetting(arg0_2)
	return
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.charge, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_DIAMOND
		})
	end)
	onButton(arg0_3, arg0_3.take, function()
		arg0_3:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_3.activity.id
		})
	end)
end

function var0_0.OnUpdateFlush(arg0_6)
	setActive(arg0_6.charge, arg0_6.activity.data2 == 0 and arg0_6.activity.data1 == 0)
	setButtonEnabled(arg0_6.take, arg0_6.activity.data2 == 0)
	setActive(arg0_6.take, arg0_6.activity.data1 > 0)
	setActive(arg0_6.finish, arg0_6.activity.data2 == 1)
end

function var0_0.OnDestroy(arg0_7)
	clearImageSprite(arg0_7.bg)
end

return var0_0
