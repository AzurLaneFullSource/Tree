local var0 = class("BossRushEXBattleResultLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "BattleResultBossRushEXUI"
end

function var0.init(arg0)
	setText(arg0._tf:Find("TotalScore/Desc"), i18n("series_enemy_total_score"))
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	local var0 = arg0.contextData.seriesData

	onButton(arg0, arg0._tf:Find("Confirm"), function()
		arg0:emit(BossRushBattleResultMediator.ON_SETTLE)
	end, SFX_PANEL)

	local var1 = var0 and var0:GetFinalResults() or {}
	local var2 = var0 and var0:GetEXScores()
	local var3 = 0

	arg0.retPaintings = {}

	_.each(_.range(#var2), function(arg0)
		local var0 = arg0._tf:Find("List"):GetChild(arg0 - 1)
		local var1 = arg0._tf:Find("Paintings"):GetChild(arg0 - 1)
		local var2 = var0:Find("content/text")
		local var3 = var0:Find("content/desc")
		local var4 = var1:Find("mask/painting")

		setActive(var0, arg0 <= #var2)
		setActive(var1, arg0 <= #var2)

		if arg0 > #var2 then
			return
		end

		setText(var2, var2[arg0])
		setText(var3, i18n("series_enemy_score") .. " ")

		var3 = var3 + var2[arg0]

		local var5 = (function()
			local var0 = var1[arg0]

			if not var0 then
				return
			end

			local var1 = (function()
				if var0.mvp ~= 0 then
					return var0.mvp
				end

				return var0.newShips[1] and var0.newShips[1].id or nil
			end)()

			if not var1 then
				return
			end

			local var2 = getProxy(BayProxy):RawGetShipById(var1)

			if not var2 then
				return
			end

			return var2:getPainting()
		end)() or "changdao"

		arg0:setPainting(var4, var5)
		table.insert(arg0.retPaintings, {
			var4,
			var5
		})
	end)
	setText(arg0._tf:Find("TotalScore/Text"), var3)
	arg0:loadUI()
end

function var0.shareEx(arg0)
	return
end

function var0.setPainting(arg0, arg1, arg2, arg3)
	setPaintingPrefabAsync(arg1, arg2, "biandui", arg3)
end

function var0.retPainting(arg0, arg1, arg2)
	retPaintingPrefab(arg1, arg2)
end

function var0.onBackPressed(arg0)
	triggerButton(arg0._tf:Find("Confirm"))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.retPaintings and #arg0.retPaintings > 0 then
		for iter0, iter1 in ipairs(arg0.retPaintings) do
			arg0:retPainting(iter1[1], iter1[2])
		end
	end
end

function var0.loadUI(arg0)
	PoolMgr.GetInstance():GetUI("ShareUI", false, function(arg0)
		local var0 = arg0.transform
		local var1 = var0:Find("panel")
		local var2 = var0:Find("panel_pink")

		setParent(var0, arg0._tf)

		local var3 = var0:Find("deck")

		setActive(var1, false)
		setActive(var2, false)

		local var4 = var0:Find("deck/logo")

		GetComponent(var4, "Image"):SetNativeSize()

		local var5 = pg.share_template[pg.ShareMgr.TypeBossRushEX]

		assert(var5, "share_template not exist: " .. pg.ShareMgr.TypeBossRushEX)

		local var6 = getProxy(PlayerProxy):getRawData()
		local var7 = getProxy(UserProxy):getRawData()
		local var8 = getProxy(ServerProxy):getRawData()[var7 and var7.server or 0]
		local var9 = var6 and var6.name or ""
		local var10 = var8 and var8.name or ""
		local var11 = pg.ShareMgr.ANCHORS_TYPE[var5.deck] or {
			0.5,
			0.5,
			0.5,
			0.5
		}

		var3.anchorMin = Vector2(var11[1], var11[2])
		var3.anchorMax = Vector2(var11[3], var11[4])

		setText(var3:Find("name/value"), var9)
		setText(var3:Find("server/value"), var10)
		setText(var3:Find("lv/value"), var6.level)

		if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
			setActive(var3:Find("code_bg"), true)
		else
			setActive(var3:Find("code_bg"), false)
		end

		var3.anchoredPosition3D = Vector3(var5.qrcode_location[1], var5.qrcode_location[2], -100)
		var3.anchoredPosition = Vector2(var5.qrcode_location[1], var5.qrcode_location[2])
	end)
end

return var0
