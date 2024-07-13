local var0_0 = class("BuildingCafeUpgradeLayer", import(".BuildingUpgradeLayer"))
local var1_0 = {
	17,
	18
}

function var0_0.Set(arg0_1, arg1_1, arg2_1)
	arg2_1 = arg2_1 or arg0_1.contextData.buildingID

	local var0_1 = pg.activity_event_building[arg2_1]

	assert(var0_1, "Can't Find activity_event_building Config ID: " .. arg2_1)

	arg0_1.contextData.buildingID = arg2_1

	local var1_1 = #var0_1.buff
	local var2_1 = arg1_1.data1KeyValueList[2][arg2_1] or 1
	local var3_1 = var0_1.material[var2_1]

	assert(#var3_1 == 1)

	local var4_1 = var3_1[1][2]
	local var5_1 = arg1_1.data1KeyValueList[1][var4_1] or 0
	local var6_1 = var1_1 <= var2_1
	local var7_1 = var6_1 or var5_1 >= var3_1[1][3]
	local var8_1 = table.indexof(var1_0, arg2_1)
	local var9_1 = var1_0[3 - var8_1]
	local var10_1 = arg1_1.data1KeyValueList[2][var9_1] or 1
	local var11_1 = var2_1 <= var10_1
	local var12_1 = var2_1 + var10_1

	setText(arg0_1:findTF("window/top/name"), var0_1.name)
	setText(arg0_1:findTF("window/top/name/lv"), "Lv." .. var2_1)
	setScrollText(arg0_1:findTF("window/frame/describe/text"), var0_1.desc)
	setText(arg0_1:findTF("window/frame/content/title/lv/current"), "Lv." .. var2_1)
	setActive(arg0_1:findTF("window/frame/content/title/lv/next"), not var6_1)

	if not var6_1 then
		setText(arg0_1:findTF("window/frame/content/title/lv/next"), "Lv." .. var2_1 + 1)
	end

	local var13_1 = var0_1.buff[var2_1]
	local var14_1 = pg.benefit_buff_template[var13_1]

	assert(var14_1, "Can't Find benefit_buff_template Config ID: " .. var13_1)
	setText(arg0_1:findTF("window/frame/content/preview/current"), var14_1.desc)
	setActive(arg0_1:findTF("window/frame/content/preview/arrow"), not var6_1)
	setActive(arg0_1:findTF("window/frame/content/preview/next"), not var6_1)

	if not var6_1 then
		local var15_1 = var0_1.buff[var2_1 + 1]
		local var16_1 = pg.benefit_buff_template[var15_1]

		assert(var16_1, "Can't Find benefit_buff_template Config ID: " .. var15_1)
		setText(arg0_1:findTF("window/frame/content/preview/next"), var16_1.desc)
	end

	arg0_1.loader:GetSprite(Item.getConfigData(var4_1).icon, "", arg0_1:findTF("window/frame/costback/icon"))
	setText(arg0_1:findTF("window/frame/costback/cost"), var0_1.material[var2_1] or 0)
	onButton(arg0_1, arg0_1.btnUpgrade, function()
		if not var11_1 then
			local var0_2 = pg.activity_event_building[var9_1].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("backhill_cantupbuilding", var0_2))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("building_upgrade_tip"),
			onYes = function()
				if var6_1 then
					return
				elseif var7_1 then
					arg0_1:emit(BuildingUpgradeMediator.ACTIVITY_OPERATION, {
						cmd = 1,
						activity_id = arg0_1.activity.id,
						arg1 = arg2_1
					})
				elseif var12_1 < 8 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("backhill_notenoughbuilding"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("building_tip"))
				end
			end
		})
	end)
	setGray(arg0_1.btnUpgrade, var6_1 or not var11_1)
	setButtonEnabled(arg0_1.btnUpgrade, not var6_1)
end

return var0_0
