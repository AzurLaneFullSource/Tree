local var0_0 = class("SpringFesMainPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.go1 = arg0_1:findTF("1", arg0_1.bg)
	arg0_1.go2 = arg0_1:findTF("2", arg0_1.bg)
	arg0_1.go3 = arg0_1:findTF("3", arg0_1.bg)
	arg0_1.go4 = arg0_1:findTF("4", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.go1, function()
		arg0_2:emit(ActivityMediator.SELECT_ACTIVITY, 470)
	end)
	onButton(arg0_2, arg0_2.go2, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.COLORING)
	end)
	onButton(arg0_2, arg0_2.go3, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = 4
		})
	end)
	onButton(arg0_2, arg0_2.go4, function()
		arg0_2:emit(ActivityMediator.SELECT_ACTIVITY, 473)
	end)
end

return var0_0
