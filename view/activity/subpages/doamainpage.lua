local var0_0 = class("DoaMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.charactorTf = arg0_1:findTF("charactor", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2:findTF("btnMiniGame", arg0_2.bg), function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.DOALINK_ISLAND)
	end)
end

function var0_0.OnUpdateFlush(arg0_4)
	local var0_4 = math.random(1, 9)

	for iter0_4 = 1, 9 do
		setActive(findTF(arg0_4.charactorTf, "charactor" .. iter0_4), var0_4 == iter0_4)
	end
end

return var0_0
