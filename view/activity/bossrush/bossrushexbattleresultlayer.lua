local var0_0 = class("BossRushEXBattleResultLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BattleResultBossRushEXUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2._tf:Find("TotalScore/Desc"), i18n("series_enemy_total_score"))
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)

	local var0_3 = arg0_3.contextData.seriesData

	onButton(arg0_3, arg0_3._tf:Find("Confirm"), function()
		arg0_3:emit(BossRushBattleResultMediator.ON_SETTLE)
	end, SFX_PANEL)

	local var1_3 = var0_3 and var0_3:GetFinalResults() or {}
	local var2_3 = var0_3 and var0_3:GetEXScores()
	local var3_3 = 0

	arg0_3.retPaintings = {}

	_.each(_.range(#var2_3), function(arg0_5)
		local var0_5 = arg0_3._tf:Find("List"):GetChild(arg0_5 - 1)
		local var1_5 = arg0_3._tf:Find("Paintings"):GetChild(arg0_5 - 1)
		local var2_5 = var0_5:Find("content/text")
		local var3_5 = var0_5:Find("content/desc")
		local var4_5 = var1_5:Find("mask/painting")

		setActive(var0_5, arg0_5 <= #var2_3)
		setActive(var1_5, arg0_5 <= #var2_3)

		if arg0_5 > #var2_3 then
			return
		end

		setText(var2_5, var2_3[arg0_5])
		setText(var3_5, i18n("series_enemy_score") .. " ")

		var3_3 = var3_3 + var2_3[arg0_5]

		local var5_5 = (function()
			local var0_6 = var1_3[arg0_5]

			if not var0_6 then
				return
			end

			local var1_6 = (function()
				if var0_6.mvp ~= 0 then
					return var0_6.mvp
				end

				return var0_6.newShips[1] and var0_6.newShips[1].id or nil
			end)()

			if not var1_6 then
				return
			end

			local var2_6 = getProxy(BayProxy):RawGetShipById(var1_6)

			if not var2_6 then
				return
			end

			return var2_6:getPainting()
		end)() or "changdao"

		arg0_3:setPainting(var4_5, var5_5)
		table.insert(arg0_3.retPaintings, {
			var4_5,
			var5_5
		})
	end)
	setText(arg0_3._tf:Find("TotalScore/Text"), var3_3)
	arg0_3:loadUI()
end

function var0_0.shareEx(arg0_8)
	return
end

function var0_0.setPainting(arg0_9, arg1_9, arg2_9, arg3_9)
	setPaintingPrefabAsync(arg1_9, arg2_9, "biandui", arg3_9)
end

function var0_0.retPainting(arg0_10, arg1_10, arg2_10)
	retPaintingPrefab(arg1_10, arg2_10)
end

function var0_0.onBackPressed(arg0_11)
	triggerButton(arg0_11._tf:Find("Confirm"))
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_12._tf)

	if arg0_12.retPaintings and #arg0_12.retPaintings > 0 then
		for iter0_12, iter1_12 in ipairs(arg0_12.retPaintings) do
			arg0_12:retPainting(iter1_12[1], iter1_12[2])
		end
	end
end

function var0_0.loadUI(arg0_13)
	PoolMgr.GetInstance():GetUI("ShareUI", false, function(arg0_14)
		local var0_14 = arg0_14.transform
		local var1_14 = var0_14:Find("panel")
		local var2_14 = var0_14:Find("panel_pink")

		setParent(var0_14, arg0_13._tf)

		local var3_14 = var0_14:Find("deck")

		setActive(var1_14, false)
		setActive(var2_14, false)

		local var4_14 = var0_14:Find("deck/logo")

		GetComponent(var4_14, "Image"):SetNativeSize()

		local var5_14 = pg.share_template[pg.ShareMgr.TypeBossRushEX]

		assert(var5_14, "share_template not exist: " .. pg.ShareMgr.TypeBossRushEX)

		local var6_14 = getProxy(PlayerProxy):getRawData()
		local var7_14 = getProxy(UserProxy):getRawData()
		local var8_14 = getProxy(ServerProxy):getRawData()[var7_14 and var7_14.server or 0]
		local var9_14 = var6_14 and var6_14.name or ""
		local var10_14 = var8_14 and var8_14.name or ""
		local var11_14 = pg.ShareMgr.ANCHORS_TYPE[var5_14.deck] or {
			0.5,
			0.5,
			0.5,
			0.5
		}

		var3_14.anchorMin = Vector2(var11_14[1], var11_14[2])
		var3_14.anchorMax = Vector2(var11_14[3], var11_14[4])

		setText(var3_14:Find("name/value"), var9_14)
		setText(var3_14:Find("server/value"), var10_14)
		setText(var3_14:Find("lv/value"), var6_14.level)

		if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
			setActive(var3_14:Find("code_bg"), true)
		else
			setActive(var3_14:Find("code_bg"), false)
		end

		var3_14.anchoredPosition3D = Vector3(var5_14.qrcode_location[1], var5_14.qrcode_location[2], -100)
		var3_14.anchoredPosition = Vector2(var5_14.qrcode_location[1], var5_14.qrcode_location[2])
	end)
end

return var0_0
