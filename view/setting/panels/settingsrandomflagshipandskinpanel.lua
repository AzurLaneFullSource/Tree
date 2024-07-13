local var0_0 = class("SettingsRandomFlagShipAndSkinPanel", import(".SettingsBasePanel"))

var0_0.EVT_UPDTAE = "SettingsRandomFlagShipAndSkinPanel:EVT_UPDTAE"
var0_0.SHIP_FREQUENTLYUSED = 1
var0_0.SHIP_LOCKED = 2
var0_0.COUSTOM = 3

function var0_0.GetUIName(arg0_1)
	return "RandomFlagShipAndSkin"
end

function var0_0.GetTitle(arg0_2)
	return i18n("random_ship_and_skin_title")
end

function var0_0.GetTitleEn(arg0_3)
	return "                                                                                      / RANDOM RANGE"
end

function var0_0.OnInit(arg0_4)
	arg0_4.subTitleTxt = arg0_4._tf:Find("title"):GetComponent(typeof(Text))
	arg0_4.shipToggles = {
		[var0_0.SHIP_FREQUENTLYUSED] = arg0_4._tf:Find("1"),
		[var0_0.SHIP_LOCKED] = arg0_4._tf:Find("2"),
		[var0_0.COUSTOM] = arg0_4._tf:Find("3")
	}
	arg0_4.shipToggleTxts = {
		[var0_0.SHIP_FREQUENTLYUSED] = i18n("random_ship_frequse_mode"),
		[var0_0.SHIP_LOCKED] = i18n("random_ship_locked_mode"),
		[var0_0.COUSTOM] = i18n("random_ship_custom_mode")
	}
	arg0_4.editBtn = findTF(arg0_4._tf, "edit_btn")

	arg0_4:UpdateSelected()
	arg0_4:InitToggles()
end

function var0_0.InitToggles(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.shipToggles) do
		onToggle(arg0_5, iter1_5, function(arg0_6)
			if arg0_6 then
				arg0_5:UpdateShipRandomMode(iter0_5)
			end
		end, SFX_PANEL)
		setText(iter1_5:Find("Text"), arg0_5.shipToggleTxts[iter0_5])
	end

	onButton(arg0_5, arg0_5.editBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.RANDOM_DOCKYARD)
	end, SFX_PANEL)
end

function var0_0.UpdateShipRandomMode(arg0_8, arg1_8)
	if arg1_8 == var0_0.COUSTOM and not arg0_8.refreshFlag and #getProxy(PlayerProxy):getRawData():GetCustomRandomShipList() == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_custom_mode_empty"))
	end

	arg0_8.refreshFlag = nil

	if arg0_8.randomFlagShipMode ~= arg1_8 then
		pg.m02:sendNotification(GAME.CHANGE_RANDOM_SHIP_MODE, {
			mode = arg1_8
		})
	end
end

function var0_0.UpdateSelected(arg0_9)
	local var0_9 = getProxy(PlayerProxy):getRawData():GetRandomFlagShipMode()

	arg0_9.randomFlagShipMode = var0_9

	triggerToggle(arg0_9.shipToggles[var0_9], true)
end

function var0_0.OnRandomFlagshipFlagUpdate(arg0_10)
	arg0_10.refreshFlag = true

	arg0_10:UpdateSelected()
end

return var0_0
