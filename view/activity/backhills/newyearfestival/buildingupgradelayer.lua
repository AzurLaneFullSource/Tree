local var0_0 = class("BuildingUpgradeLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BuildingUpgradePanel"
end

function var0_0.init(arg0_2)
	arg0_2.btnUpgrade = arg0_2:findTF("window/frame/upgrade_btn")

	setText(arg0_2:findTF("window/frame/costback/label"), i18n("word_consume"))
	setText(arg0_2:findTF("window/frame/upgrade_btn/Image"), i18n("msgbox_text_upgrade"))

	arg0_2.loader = AutoLoader.New()
end

function var0_0.UpdateActivity(arg0_3, arg1_3)
	arg0_3.activity = arg1_3
end

function var0_0.didEnter(arg0_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
	onButton(arg0_4, arg0_4:findTF("window/top/btnBack"), function()
		arg0_4:closeView()
	end)
	onButton(arg0_4, arg0_4:findTF("mengban"), function()
		arg0_4:closeView()
	end)
	arg0_4:Set(arg0_4.activity)
end

function var0_0.Set(arg0_7, arg1_7, arg2_7)
	arg2_7 = arg2_7 or arg0_7.contextData.buildingID

	local var0_7 = pg.activity_event_building[arg2_7]

	assert(var0_7, "Can't Find activity_event_building Config ID: " .. arg2_7)

	arg0_7.contextData.buildingID = arg2_7

	local var1_7 = #var0_7.buff
	local var2_7 = arg1_7.data1KeyValueList[2][arg2_7] or 1
	local var3_7 = var0_7.material[var2_7]

	assert(#var3_7 == 1)

	local var4_7 = var3_7[1][2]
	local var5_7 = arg1_7.data1KeyValueList[1][var4_7] or 0
	local var6_7 = var1_7 <= var2_7
	local var7_7 = var6_7 or var5_7 >= var3_7[1][3]

	setText(arg0_7:findTF("window/top/name"), var0_7.name)
	setText(arg0_7:findTF("window/top/name/lv"), "Lv." .. var2_7)
	setScrollText(arg0_7:findTF("window/frame/describe/text"), var0_7.desc)
	setText(arg0_7:findTF("window/frame/content/title/lv/current"), "Lv." .. var2_7)
	setActive(arg0_7:findTF("window/frame/content/title/lv/next"), not var6_7)

	if not var6_7 then
		setText(arg0_7:findTF("window/frame/content/title/lv/next"), "Lv." .. var2_7 + 1)
	end

	local var8_7 = var0_7.buff[var2_7]
	local var9_7 = pg.benefit_buff_template[var8_7]

	assert(var9_7, "Can't Find benefit_buff_template Config ID: " .. var8_7)
	setText(arg0_7:findTF("window/frame/content/preview/current"), var9_7.desc)
	setActive(arg0_7:findTF("window/frame/content/preview/arrow"), not var6_7)
	setActive(arg0_7:findTF("window/frame/content/preview/next"), not var6_7)

	if not var6_7 then
		local var10_7 = var0_7.buff[var2_7 + 1]
		local var11_7 = pg.benefit_buff_template[var10_7]

		assert(var11_7, "Can't Find benefit_buff_template Config ID: " .. var10_7)
		setText(arg0_7:findTF("window/frame/content/preview/next"), var11_7.desc)
	end

	arg0_7.loader:GetSprite(Item.getConfigData(var4_7).icon, "", arg0_7:findTF("window/frame/costback/icon"))
	setText(arg0_7:findTF("window/frame/costback/cost"), var0_7.material[var2_7] or 0)
	onButton(arg0_7, arg0_7.btnUpgrade, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("building_upgrade_tip"),
			onYes = function()
				if var6_7 then
					return
				elseif var7_7 then
					arg0_7:emit(BuildingUpgradeMediator.ACTIVITY_OPERATION, {
						cmd = 1,
						activity_id = arg0_7.activity.id,
						arg1 = arg2_7
					})
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("building_tip"))
				end
			end
		})
	end)
	setGray(arg0_7.btnUpgrade, var6_7)
	setButtonEnabled(arg0_7.btnUpgrade, not var6_7)
end

function var0_0.willExit(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf)
end

return var0_0
