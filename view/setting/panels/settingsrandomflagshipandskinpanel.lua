local var0 = class("SettingsRandomFlagShipAndSkinPanel", import(".SettingsBasePanel"))

var0.EVT_UPDTAE = "SettingsRandomFlagShipAndSkinPanel:EVT_UPDTAE"
var0.SHIP_FREQUENTLYUSED = 1
var0.SHIP_LOCKED = 2
var0.COUSTOM = 3

function var0.GetUIName(arg0)
	return "RandomFlagShipAndSkin"
end

function var0.GetTitle(arg0)
	return i18n("random_ship_and_skin_title")
end

function var0.GetTitleEn(arg0)
	return "                                                                                      / RANDOM RANGE"
end

function var0.OnInit(arg0)
	arg0.subTitleTxt = arg0._tf:Find("title"):GetComponent(typeof(Text))
	arg0.shipToggles = {
		[var0.SHIP_FREQUENTLYUSED] = arg0._tf:Find("1"),
		[var0.SHIP_LOCKED] = arg0._tf:Find("2"),
		[var0.COUSTOM] = arg0._tf:Find("3")
	}
	arg0.shipToggleTxts = {
		[var0.SHIP_FREQUENTLYUSED] = i18n("random_ship_frequse_mode"),
		[var0.SHIP_LOCKED] = i18n("random_ship_locked_mode"),
		[var0.COUSTOM] = i18n("random_ship_custom_mode")
	}
	arg0.editBtn = findTF(arg0._tf, "edit_btn")

	arg0:UpdateSelected()
	arg0:InitToggles()
end

function var0.InitToggles(arg0)
	for iter0, iter1 in pairs(arg0.shipToggles) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				arg0:UpdateShipRandomMode(iter0)
			end
		end, SFX_PANEL)
		setText(iter1:Find("Text"), arg0.shipToggleTxts[iter0])
	end

	onButton(arg0, arg0.editBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.RANDOM_DOCKYARD)
	end, SFX_PANEL)
end

function var0.UpdateShipRandomMode(arg0, arg1)
	if arg1 == var0.COUSTOM and not arg0.refreshFlag and #getProxy(PlayerProxy):getRawData():GetCustomRandomShipList() == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("random_ship_custom_mode_empty"))
	end

	arg0.refreshFlag = nil

	if arg0.randomFlagShipMode ~= arg1 then
		pg.m02:sendNotification(GAME.CHANGE_RANDOM_SHIP_MODE, {
			mode = arg1
		})
	end
end

function var0.UpdateSelected(arg0)
	local var0 = getProxy(PlayerProxy):getRawData():GetRandomFlagShipMode()

	arg0.randomFlagShipMode = var0

	triggerToggle(arg0.shipToggles[var0], true)
end

function var0.OnRandomFlagshipFlagUpdate(arg0)
	arg0.refreshFlag = true

	arg0:UpdateSelected()
end

return var0
