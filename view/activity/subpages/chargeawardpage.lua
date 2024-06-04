local var0 = class("ChargeAwardPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.charge = arg0:findTF("charge")
	arg0.take = arg0:findTF("take")
	arg0.finish = arg0:findTF("finish")
end

function var0.OnDataSetting(arg0)
	return
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.charge, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_DIAMOND
		})
	end)
	onButton(arg0, arg0.take, function()
		arg0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0.activity.id
		})
	end)
end

function var0.OnUpdateFlush(arg0)
	setActive(arg0.charge, arg0.activity.data2 == 0 and arg0.activity.data1 == 0)
	setButtonEnabled(arg0.take, arg0.activity.data2 == 0)
	setActive(arg0.take, arg0.activity.data1 > 0)
	setActive(arg0.finish, arg0.activity.data2 == 1)
end

function var0.OnDestroy(arg0)
	clearImageSprite(arg0.bg)
end

return var0
