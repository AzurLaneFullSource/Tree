local var0_0 = class("LevelAwardPage", import("...base.BaseActivityPage"))

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {
		"ui/activityuipage/level_award_atlas"
	}

	table.insertto(var0_1, var0_0.super.getResource(arg0_1, arg1_1))

	return var0_1
end

function var0_0.OnInit(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.award = arg0_2._tf:Find("scroll/award")
	arg0_2.content = arg0_2._tf:Find("scroll/content")
	arg0_2.scrollTF = arg0_2._tf:Find("scroll")
	arg0_2.pageSignDownTF = arg0_2._tf:Find("sign")
	arg0_2.pageSignUpTF = arg0_2._tf:Find("sign_up")
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.config = pg.activity_level_award[arg0_3.activity:getConfig("config_id")]
end

function var0_0.OnFirstFlush(arg0_4)
	setActive(arg0_4.award, false)

	for iter0_4 = 1, #arg0_4.config.front_drops do
		local var0_4 = arg0_4.config.front_drops[iter0_4]
		local var1_4 = var0_4[1]
		local var2_4 = cloneTplTo(arg0_4.award, arg0_4.content, "award" .. tostring(iter0_4))
		local var3_4 = var2_4:Find("limit_label/labelLevel")
		local var4_4 = var2_4:Find("btnAchieve")
		local var5_4 = var2_4:Find("items")
		local var6_4 = var2_4:Find("item")

		setActive(var6_4, false)
		GetImageSpriteFromAtlasAsync("ui/activityuipage/level_award_atlas", tostring(var1_4), var3_4, true)

		for iter1_4 = 2, #var0_4 do
			local var7_4 = cloneTplTo(var6_4, var5_4)
			local var8_4 = var0_4[iter1_4]
			local var9_4 = {
				type = var8_4[1],
				id = var8_4[2],
				count = var8_4[3]
			}

			updateDrop(var7_4, var9_4)
			onButton(arg0_4, var7_4, function()
				arg0_4:emit(BaseUI.ON_DROP, var9_4)
			end, SFX_PANEL)
		end

		onButton(arg0_4, var4_4, function()
			arg0_4:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0_4.activity.id,
				arg1 = var1_4
			})
		end, SFX_PANEL)
		onScroll(arg0_4, arg0_4.scrollTF, function(arg0_7)
			setActive(arg0_4.pageSignDownTF, arg0_7.y > 0.01)
			setActive(arg0_4.pageSignUpTF, arg0_7.y < 0.99)
		end)
	end
end

function var0_0.OnUpdateFlush(arg0_8)
	for iter0_8 = 1, #arg0_8.config.front_drops do
		local var0_8 = arg0_8.config.front_drops[iter0_8]
		local var1_8 = arg0_8.content:Find("award" .. tostring(iter0_8))
		local var2_8 = var1_8:Find("btnAchieve")
		local var3_8 = var1_8:Find("achieve_sign")
		local var4_8 = _.include(arg0_8.activity.data1_list, var0_8[1])

		if var4_8 then
			var1_8.transform:SetAsLastSibling()
		end

		setGray(var1_8:Find("limit_label"), var4_8)
		setGray(var1_8:Find("items"), var4_8)
		setActive(var3_8, var4_8)
		setActive(var2_8, arg0_8.shareData.player.level >= var0_8[1] and not var4_8)
	end
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
