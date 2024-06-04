local var0 = class("CourtYardFeastPedestalModule", import("..CourtYardBaseModule"))

function var0.OnInit(arg0)
	arg0.storey = arg0.data
	arg0.scrollView = arg0._tf.parent:Find("scroll_view")
end

function var0.AddListeners(arg0)
	arg0:AddListener(CourtYardEvent.UPDATE_STOREY, arg0.OnUpdate)
end

function var0.RemoveListeners(arg0)
	arg0:RemoveListener(CourtYardEvent.UPDATE_STOREY, arg0.OnUpdate)
end

function var0.OnUpdate(arg0, arg1)
	arg0.level = arg1

	arg0:InitScrollRect(arg1)
end

function var0.InitScrollRect(arg0, arg1)
	local var0 = 1080 + (arg1 - 1) * 150

	arg0._tf.sizeDelta = Vector2(arg0._tf.sizeDelta.x, var0)

	scrollTo(arg0.scrollView, 0.5, 0.5)
end

function var0.OnDispose(arg0)
	return
end

return var0
