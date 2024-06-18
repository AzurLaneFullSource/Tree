local var0_0 = class("LevelAwardPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("bg")
	arg0_1.award = arg0_1:findTF("scroll/award")
	arg0_1.content = arg0_1:findTF("scroll/content")
	arg0_1.scrollTF = arg0_1:findTF("scroll")
	arg0_1.pageSignDownTF = arg0_1:findTF("sign")
	arg0_1.pageSignUpTF = arg0_1:findTF("sign_up")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.config = pg.activity_level_award[arg0_2.activity:getConfig("config_id")]
end

function var0_0.OnFirstFlush(arg0_3)
	setActive(arg0_3.award, false)

	for iter0_3 = 1, #arg0_3.config.front_drops do
		local var0_3 = arg0_3.config.front_drops[iter0_3]
		local var1_3 = var0_3[1]
		local var2_3 = cloneTplTo(arg0_3.award, arg0_3.content, "award" .. tostring(iter0_3))
		local var3_3 = arg0_3:findTF("limit_label/labelLevel", var2_3)
		local var4_3 = arg0_3:findTF("btnAchieve", var2_3)
		local var5_3 = arg0_3:findTF("items", var2_3)
		local var6_3 = arg0_3:findTF("item", var2_3)

		setActive(var6_3, false)
		GetImageSpriteFromAtlasAsync("ui/activityuipage/level_award_atlas", tostring(var1_3), var3_3, true)

		for iter1_3 = 2, #var0_3 do
			local var7_3 = cloneTplTo(var6_3, var5_3)
			local var8_3 = var0_3[iter1_3]
			local var9_3 = {
				type = var8_3[1],
				id = var8_3[2],
				count = var8_3[3]
			}

			updateDrop(var7_3, var9_3)
			onButton(arg0_3, var7_3, function()
				arg0_3:emit(BaseUI.ON_DROP, var9_3)
			end, SFX_PANEL)
		end

		onButton(arg0_3, var4_3, function()
			arg0_3:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0_3.activity.id,
				arg1 = var1_3
			})
		end, SFX_PANEL)
		onScroll(arg0_3, arg0_3.scrollTF, function(arg0_6)
			setActive(arg0_3.pageSignDownTF, arg0_6.y > 0.01)
			setActive(arg0_3.pageSignUpTF, arg0_6.y < 0.99)
		end)
	end
end

function var0_0.OnUpdateFlush(arg0_7)
	for iter0_7 = 1, #arg0_7.config.front_drops do
		local var0_7 = arg0_7.config.front_drops[iter0_7]
		local var1_7 = arg0_7:findTF("award" .. tostring(iter0_7), arg0_7.content)
		local var2_7 = arg0_7:findTF("btnAchieve", var1_7)
		local var3_7 = arg0_7:findTF("achieve_sign", var1_7)
		local var4_7 = _.include(arg0_7.activity.data1_list, var0_7[1])

		if var4_7 then
			var1_7.transform:SetAsLastSibling()
		end

		setGray(arg0_7:findTF("limit_label", var1_7), var4_7)
		setGray(arg0_7:findTF("items", var1_7), var4_7)
		setActive(var3_7, var4_7)
		setActive(var2_7, arg0_7.shareData.player.level >= var0_7[1] and not var4_7)
	end
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
