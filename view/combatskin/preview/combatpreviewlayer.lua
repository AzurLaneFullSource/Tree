local var0_0 = class("CombatPreviewLayer", import("view.base.BaseSubView"))
local var1_0 = 12
local var2_0 = 3
local var3_0 = Vector3(0, 1, 40)

function var0_0.getUIName(arg0_1)
	return "CombatPreviewUI"
end

function var0_0.PushAllResource()
	local var0_2 = {}

	local function var1_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	for iter0_2, iter1_2 in ipairs(pg.item_data_battleui.all) do
		local var2_2 = pg.item_data_battleui[iter1_2]

		if var2_2 and noEmptyStr(var2_2.key) then
			var1_2("ui/CombatUI" .. var2_2.key)
			var1_2("ui/CombatHPBar" .. var2_2.key)
			var1_2(ys.Battle.BattleResourceManager.GetUIPath("CombatHPPop" .. var2_2.key))
		end
	end

	return var0_2
end

function var0_0.OnInit(arg0_4)
	arg0_4.OverlayMain = pg.UIMgr.GetInstance().OverlayMain

	setParent(arg0_4._go, arg0_4.OverlayMain)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)

	arg0_4.preview = arg0_4._tf:Find("preview")
	arg0_4.uiLayer = arg0_4._tf:Find("preview/ui")
	arg0_4.sea = arg0_4._tf:Find("preview/sea")
	arg0_4.rawImage = arg0_4.sea:GetComponent("RawImage")

	setText(arg0_4.preview:Find("bg/title/Image"), i18n("word_preview"))
	onButton(arg0_4, arg0_4.preview, function()
		arg0_4.callBack()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	arg0_6.callBack = arg2_6

	local var0_6 = pg.item_data_battleui[arg1_6].key
	local var1_6 = "CombatUI" .. var0_6
	local var2_6 = "CombatHPBar" .. var0_6
	local var3_6
	local var4_6
	local var5_6

	seriesAsync({
		function(arg0_7)
			PoolMgr.GetInstance():GetUI(var2_6, true, function(arg0_8)
				var4_6 = arg0_8

				arg0_7()
			end)
		end,
		function(arg0_9)
			PoolMgr.GetInstance():GetUI(var2_6, true, function(arg0_10)
				var5_6 = arg0_10

				arg0_9()
			end)
		end,
		function(arg0_11)
			PoolMgr.GetInstance():GetUI(var1_6, true, function(arg0_12)
				var3_6 = arg0_12

				arg0_11()
			end)
		end
	}, function()
		var3_6.transform:SetParent(arg0_6.uiLayer, false)
		var4_6.transform:SetParent(arg0_6.uiLayer, false)
		var5_6.transform:SetParent(arg0_6.uiLayer, false)

		local var0_13 = arg0_6.sea.rect.width
		local var1_13 = arg0_6.sea.rect.height

		var3_6.transform.localScale = Vector3(var0_13 / 1920, var1_13 / 1080, 1)
		arg0_6.previewer = CombatUIPreviewer.New(arg0_6.rawImage)

		arg0_6.previewer:setDisplayWeapon({
			100
		})
		arg0_6.previewer:setCombatUI(var3_6, var4_6, var5_6, var0_6)

		local var2_13 = Ship.New({
			id = 100001,
			configId = 100001,
			skin_id = 100000
		})
		local var3_13 = Ship.New({
			id = 100011,
			configId = 100011,
			skin_id = 100010
		})

		arg0_6.previewer:load(40000, var2_13, var3_13, {}, function()
			return
		end)
	end)
end

function var0_0.OnDestroy(arg0_15)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._tf)

	if arg0_15.previewer then
		arg0_15.previewer:clear()

		arg0_15.previewer = nil
	end
end

return var0_0
