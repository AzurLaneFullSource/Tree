local var0 = class("BuildingCafeUpgradeLayer", import(".BuildingUpgradeLayer"))
local var1 = {
	17,
	18
}

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
	local var8 = table.indexof(var1, arg2)
	local var9 = var1[3 - var8]
	local var10 = arg1.data1KeyValueList[2][var9] or 1
	local var11 = var2 <= var10
	local var12 = var2 + var10

	setText(arg0:findTF("window/top/name"), var0.name)
	setText(arg0:findTF("window/top/name/lv"), "Lv." .. var2)
	setScrollText(arg0:findTF("window/frame/describe/text"), var0.desc)
	setText(arg0:findTF("window/frame/content/title/lv/current"), "Lv." .. var2)
	setActive(arg0:findTF("window/frame/content/title/lv/next"), not var6)

	if not var6 then
		setText(arg0:findTF("window/frame/content/title/lv/next"), "Lv." .. var2 + 1)
	end

	local var13 = var0.buff[var2]
	local var14 = pg.benefit_buff_template[var13]

	assert(var14, "Can't Find benefit_buff_template Config ID: " .. var13)
	setText(arg0:findTF("window/frame/content/preview/current"), var14.desc)
	setActive(arg0:findTF("window/frame/content/preview/arrow"), not var6)
	setActive(arg0:findTF("window/frame/content/preview/next"), not var6)

	if not var6 then
		local var15 = var0.buff[var2 + 1]
		local var16 = pg.benefit_buff_template[var15]

		assert(var16, "Can't Find benefit_buff_template Config ID: " .. var15)
		setText(arg0:findTF("window/frame/content/preview/next"), var16.desc)
	end

	arg0.loader:GetSprite(Item.getConfigData(var4).icon, "", arg0:findTF("window/frame/costback/icon"))
	setText(arg0:findTF("window/frame/costback/cost"), var0.material[var2] or 0)
	onButton(arg0, arg0.btnUpgrade, function()
		if not var11 then
			local var0 = pg.activity_event_building[var9].name

			pg.TipsMgr.GetInstance():ShowTips(i18n("backhill_cantupbuilding", var0))

			return
		end

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
				elseif var12 < 8 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("backhill_notenoughbuilding"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("building_tip"))
				end
			end
		})
	end)
	setGray(arg0.btnUpgrade, var6 or not var11)
	setButtonEnabled(arg0.btnUpgrade, not var6)
end

return var0
