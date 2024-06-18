local var0_0 = class("CourtYardFeastPedestalModule", import("..CourtYardBaseModule"))

function var0_0.OnInit(arg0_1)
	arg0_1.storey = arg0_1.data
	arg0_1.scrollView = arg0_1._tf.parent:Find("scroll_view")
end

function var0_0.AddListeners(arg0_2)
	arg0_2:AddListener(CourtYardEvent.UPDATE_STOREY, arg0_2.OnUpdate)
end

function var0_0.RemoveListeners(arg0_3)
	arg0_3:RemoveListener(CourtYardEvent.UPDATE_STOREY, arg0_3.OnUpdate)
end

function var0_0.OnUpdate(arg0_4, arg1_4)
	arg0_4.level = arg1_4

	arg0_4:InitScrollRect(arg1_4)
end

function var0_0.InitScrollRect(arg0_5, arg1_5)
	local var0_5 = 1080 + (arg1_5 - 1) * 150

	arg0_5._tf.sizeDelta = Vector2(arg0_5._tf.sizeDelta.x, var0_5)

	scrollTo(arg0_5.scrollView, 0.5, 0.5)
end

function var0_0.OnDispose(arg0_6)
	return
end

return var0_0
