pg = pg or {}

local var0_0 = singletonClass("WatermarkingMgr")

pg.WatermarkingMgr = var0_0

function var0_0.Init(arg0_1, arg1_1)
	arg0_1.state = STATE_LOADING

	LoadAndInstantiateAsync("ui", "WatermarkingUI", function(arg0_2)
		arg0_1.UIOverlay = GameObject.Find("Overlay/UIEffect")

		arg0_2.transform:SetParent(arg0_1.UIOverlay.transform, false)
		arg0_1:InitMain(arg1_1, arg0_2)
	end, true, true)
end

function var0_0.InitMain(arg0_3, arg1_3, arg2_3)
	setText(arg2_3.transform:Find("uid"), "UID" .. arg1_3.id)
end
