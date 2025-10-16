local var0_0 = class("CombatPreviewLayer", import("view.base.BaseSubView"))
local var1_0 = 12
local var2_0 = 3
local var3_0 = Vector3(0, 1, 40)

function var0_0.getUIName(arg0_1)
	return "CombatPreviewUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2.OverlayMain = pg.UIMgr.GetInstance().OverlayMain

	setParent(arg0_2._go, arg0_2.OverlayMain)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)

	arg0_2.preview = arg0_2._tf:Find("preview")
	arg0_2.uiLayer = arg0_2._tf:Find("preview/ui")
	arg0_2.sea = arg0_2._tf:Find("preview/sea")
	arg0_2.rawImage = arg0_2.sea:GetComponent("RawImage")

	setText(arg0_2.preview:Find("bg/title/Image"), i18n("word_preview"))
	onButton(arg0_2, arg0_2.preview, function()
		arg0_2.callBack()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_4, arg1_4, arg2_4)
	arg0_4.callBack = arg2_4

	local var0_4 = pg.item_data_battleui[arg1_4].key
	local var1_4 = "CombatUI" .. var0_4
	local var2_4 = "CombatHPBar" .. var0_4
	local var3_4
	local var4_4
	local var5_4

	seriesAsync({
		function(arg0_5)
			PoolMgr.GetInstance():GetUI(var2_4, true, function(arg0_6)
				var4_4 = arg0_6

				arg0_5()
			end)
		end,
		function(arg0_7)
			PoolMgr.GetInstance():GetUI(var2_4, true, function(arg0_8)
				var5_4 = arg0_8

				arg0_7()
			end)
		end,
		function(arg0_9)
			PoolMgr.GetInstance():GetUI(var1_4, true, function(arg0_10)
				var3_4 = arg0_10

				arg0_9()
			end)
		end
	}, function()
		var3_4.transform:SetParent(arg0_4.uiLayer, false)
		var4_4.transform:SetParent(arg0_4.uiLayer, false)
		var5_4.transform:SetParent(arg0_4.uiLayer, false)

		local var0_11 = arg0_4.sea.rect.width
		local var1_11 = arg0_4.sea.rect.height

		var3_4.transform.localScale = Vector3(var0_11 / 1920, var1_11 / 1080, 1)
		arg0_4.previewer = CombatUIPreviewer.New(arg0_4.rawImage)

		arg0_4.previewer:setDisplayWeapon({
			100
		})
		arg0_4.previewer:setCombatUI(var3_4, var4_4, var5_4, var0_4)

		local var2_11 = Ship.New({
			id = 100001,
			configId = 100001,
			skin_id = 100000
		})
		local var3_11 = Ship.New({
			id = 100011,
			configId = 100011,
			skin_id = 100010
		})

		arg0_4.previewer:load(40000, var2_11, var3_11, {}, function()
			return
		end)
	end)
end

function var0_0.OnDestroy(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf)

	if arg0_13.previewer then
		arg0_13.previewer:clear()

		arg0_13.previewer = nil
	end
end

return var0_0
