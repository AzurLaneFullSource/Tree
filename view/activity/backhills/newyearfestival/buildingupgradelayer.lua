local var0 = class("BuildingUpgradeLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "BuildingUpgradePanel"
end

function var0.init(arg0)
	arg0.btnUpgrade = arg0:findTF("window/frame/upgrade_btn")

	setText(arg0:findTF("window/frame/costback/label"), i18n("word_consume"))
	setText(arg0:findTF("window/frame/upgrade_btn/Image"), i18n("msgbox_text_upgrade"))

	arg0.loader = AutoLoader.New()
end

function var0.UpdateActivity(arg0, arg1)
	arg0.activity = arg1
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	onButton(arg0, arg0:findTF("window/top/btnBack"), function()
		arg0:closeView()
	end)
	onButton(arg0, arg0:findTF("mengban"), function()
		arg0:closeView()
	end)
	arg0:Set(arg0.activity)
end

function var0.Set(arg0, arg1, arg2)
	arg2 = arg2 or arg0.contextData.buildingID

	local var0 = pg.activity_event_building[arg2]

	assert(var0, "Can't Find activity_event_building Config ID: " .. arg2)

	arg0.contextData.buildingID = arg2

	local var1 = #var0.buff
	local var2 = arg1.data1KeyValueList[2][arg2] or 1
	local var3 = var0.material[var2]

	assert(#var3 == 1)

	local var4 = var3[1][2]
	local var5 = arg1.data1KeyValueList[1][var4] or 0
	local var6 = var1 <= var2
	local var7 = var6 or var5 >= var3[1][3]

	setText(arg0:findTF("window/top/name"), var0.name)
	setText(arg0:findTF("window/top/name/lv"), "Lv." .. var2)
	setScrollText(arg0:findTF("window/frame/describe/text"), var0.desc)
	setText(arg0:findTF("window/frame/content/title/lv/current"), "Lv." .. var2)
	setActive(arg0:findTF("window/frame/content/title/lv/next"), not var6)

	if not var6 then
		setText(arg0:findTF("window/frame/content/title/lv/next"), "Lv." .. var2 + 1)
	end

	local var8 = var0.buff[var2]
	local var9 = pg.benefit_buff_template[var8]

	assert(var9, "Can't Find benefit_buff_template Config ID: " .. var8)
	setText(arg0:findTF("window/frame/content/preview/current"), var9.desc)
	setActive(arg0:findTF("window/frame/content/preview/arrow"), not var6)
	setActive(arg0:findTF("window/frame/content/preview/next"), not var6)

	if not var6 then
		local var10 = var0.buff[var2 + 1]
		local var11 = pg.benefit_buff_template[var10]

		assert(var11, "Can't Find benefit_buff_template Config ID: " .. var10)
		setText(arg0:findTF("window/frame/content/preview/next"), var11.desc)
	end

	arg0.loader:GetSprite(Item.getConfigData(var4).icon, "", arg0:findTF("window/frame/costback/icon"))
	setText(arg0:findTF("window/frame/costback/cost"), var0.material[var2] or 0)
	onButton(arg0, arg0.btnUpgrade, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("building_upgrade_tip"),
			onYes = function()
				if var6 then
					return
				elseif var7 then
					arg0:emit(BuildingUpgradeMediator.ACTIVITY_OPERATION, {
						cmd = 1,
						activity_id = arg0.activity.id,
						arg1 = arg2
					})
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("building_tip"))
				end
			end
		})
	end)
	setGray(arg0.btnUpgrade, var6)
	setButtonEnabled(arg0.btnUpgrade, not var6)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
