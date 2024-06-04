local var0 = class("LevelAwardPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.award = arg0:findTF("scroll/award")
	arg0.content = arg0:findTF("scroll/content")
	arg0.scrollTF = arg0:findTF("scroll")
	arg0.pageSignDownTF = arg0:findTF("sign")
	arg0.pageSignUpTF = arg0:findTF("sign_up")
end

function var0.OnDataSetting(arg0)
	arg0.config = pg.activity_level_award[arg0.activity:getConfig("config_id")]
end

function var0.OnFirstFlush(arg0)
	setActive(arg0.award, false)

	for iter0 = 1, #arg0.config.front_drops do
		local var0 = arg0.config.front_drops[iter0]
		local var1 = var0[1]
		local var2 = cloneTplTo(arg0.award, arg0.content, "award" .. tostring(iter0))
		local var3 = arg0:findTF("limit_label/labelLevel", var2)
		local var4 = arg0:findTF("btnAchieve", var2)
		local var5 = arg0:findTF("items", var2)
		local var6 = arg0:findTF("item", var2)

		setActive(var6, false)
		GetImageSpriteFromAtlasAsync("ui/activityuipage/level_award_atlas", tostring(var1), var3, true)

		for iter1 = 2, #var0 do
			local var7 = cloneTplTo(var6, var5)
			local var8 = var0[iter1]
			local var9 = {
				type = var8[1],
				id = var8[2],
				count = var8[3]
			}

			updateDrop(var7, var9)
			onButton(arg0, var7, function()
				arg0:emit(BaseUI.ON_DROP, var9)
			end, SFX_PANEL)
		end

		onButton(arg0, var4, function()
			arg0:emit(ActivityMediator.EVENT_OPERATION, {
				cmd = 1,
				activity_id = arg0.activity.id,
				arg1 = var1
			})
		end, SFX_PANEL)
		onScroll(arg0, arg0.scrollTF, function(arg0)
			setActive(arg0.pageSignDownTF, arg0.y > 0.01)
			setActive(arg0.pageSignUpTF, arg0.y < 0.99)
		end)
	end
end

function var0.OnUpdateFlush(arg0)
	for iter0 = 1, #arg0.config.front_drops do
		local var0 = arg0.config.front_drops[iter0]
		local var1 = arg0:findTF("award" .. tostring(iter0), arg0.content)
		local var2 = arg0:findTF("btnAchieve", var1)
		local var3 = arg0:findTF("achieve_sign", var1)
		local var4 = _.include(arg0.activity.data1_list, var0[1])

		if var4 then
			var1.transform:SetAsLastSibling()
		end

		setGray(arg0:findTF("limit_label", var1), var4)
		setGray(arg0:findTF("items", var1), var4)
		setActive(var3, var4)
		setActive(var2, arg0.shareData.player.level >= var0[1] and not var4)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
