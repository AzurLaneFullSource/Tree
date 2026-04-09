local var0_0 = class("PlayRoomRankItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiRankText, i18n("match_ui_window_out"))
end

function var0_0.didEnter(arg0_3, arg1_3)
	if arg1_3 == nil then
		return
	end

	local var0_3 = arg1_3.rankIndex

	if var0_3 == 1 then
		setActive(arg0_3.uiNum1, true)
		setActive(arg0_3.uiNum2, false)
		setActive(arg0_3.uiNum3, false)
		setActive(arg0_3.uiRankNumText, false)
		setActive(arg0_3.uiRankText, false)
		setImageColor(arg0_3.uiBgImage, Color.NewHex("FFFCB0"))
		setActive(arg0_3.uiBgImage, true)
	elseif var0_3 == 2 then
		setActive(arg0_3.uiNum1, false)
		setActive(arg0_3.uiNum2, true)
		setActive(arg0_3.uiNum3, false)
		setActive(arg0_3.uiRankNumText, false)
		setActive(arg0_3.uiRankText, false)
		setImageColor(arg0_3.uiBgImage, Color.NewHex("B2EAFF"))
		setActive(arg0_3.uiBgImage, true)
	elseif var0_3 == 3 then
		setActive(arg0_3.uiNum1, false)
		setActive(arg0_3.uiNum2, false)
		setActive(arg0_3.uiNum3, true)
		setActive(arg0_3.uiRankNumText, false)
		setActive(arg0_3.uiRankText, false)
		setImageColor(arg0_3.uiBgImage, Color.NewHex("FDDFC7"))
		setActive(arg0_3.uiBgImage, true)
	else
		setActive(arg0_3.uiNum1, false)
		setActive(arg0_3.uiNum2, false)
		setActive(arg0_3.uiNum3, false)
		setActive(arg0_3.uiRankNumText, var0_3 ~= 0)
		setActive(arg0_3.uiRankText, var0_3 == 0)
		setText(arg0_3.uiRankNumText, string.format("%02d", var0_3))
		setActive(arg0_3.uiBgImage, false)
	end

	local var1_3 = arg1_3.playerData

	setText(arg0_3.uiNameText, var1_3.name)
	setText(arg0_3.uiLevelText, string.format("Lv.%s", var1_3.level))
	setText(arg0_3.uiPtCntText, arg1_3.score)
	setText(arg0_3.uiServerText, PlayRoomTools.GetServerName(var1_3.id))
	setActive(arg0_3.uiGuildText, var1_3.guildName ~= "")
	setText(arg0_3.uiGuildText, var1_3.guildName)

	local var2_3

	if var0_3 == 0 then
		var2_3 = getProxy(PlayerProxy):getData():GetFlagShip()
	else
		var2_3 = Ship.New({
			configId = var1_3.display.icon
		})
	end

	LoadSpriteAsync("qicon/" .. var2_3:getPrefab(), function(arg0_4)
		arg0_3.uiIcon.sprite = arg0_4
	end)

	local var3_3 = PlayRoomTools.GetPtScoreIcon(PlayRoomTools.GetGameTypeID())

	GetImageSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var3_3, "", arg0_3.uiPtIcon)
end

function var0_0.willExit(arg0_5)
	arg0_5:detach()
end

return var0_0
