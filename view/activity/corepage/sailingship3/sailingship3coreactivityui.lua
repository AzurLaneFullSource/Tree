local var0_0 = class("SailingShip3CoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "SailingShip3CoreActivityUI"
end

function var0_0.loadingQueue(arg0_2)
	local var0_2 = "play_jjufengyuziyouqundao_fullscreen_" .. getProxy(PlayerProxy):getPlayerId()

	if PlayerPrefs.GetInt(var0_2, 0) == 1 then
		return nil
	else
		return function(arg0_3)
			pg.SceneAnimMgr.GetInstance():CommonSceneChange("jufengyuziyouqundao_fullscreen", function(arg0_4)
				return arg0_3(function()
					PlayerPrefs.SetInt(var0_2, 1)
					existCall(arg0_4)
				end)
			end)
		end
	end
end

function var0_0.init(arg0_6, ...)
	var0_0.super.init(arg0_6, ...)

	local var0_6

	setText(arg0_6._tf:Find("adapt/top/btn_back/back"), i18n("word_back"))
	arg0_6.tabsList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = underscore.detect(arg0_6.activities, function(arg0_8)
				return tostring(arg0_8:getConfig("is_show")) == arg2_7.name
			end)

			if not var0_7 or var0_7:isEnd() then
				setActive(arg2_7, false)
			elseif not arg0_6.pageDic[var0_7.id] then
				warning(string.format("without page in act:", var0_7.id))
			else
				arg0_6:ONToggleName(arg2_7, var0_7)

				local var1_7 = arg0_6.pageDic[var0_7.id]

				if var1_7 ~= nil then
					local var2_7 = arg2_7:Find("tip")
					local var3_7 = var1_7:IsShowReminder()

					if var3_7 == nil then
						setActive(var2_7, var0_7:readyToAchieve())
					else
						setActive(var2_7, var3_7)
					end

					onToggle(arg0_6, arg2_7, function(arg0_9)
						if arg0_9 then
							if var0_6 ~= var0_7.id then
								arg0_6:selectActivity(var0_7)
								arg0_6:OnplayAnimation(arg2_7)
							end

							var0_6 = var0_7.id
						end
					end, SFX_PANEL)
				end
			end
		end
	end)

	arg0_6.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_10, arg1_10)
		arg0_6:UpdateAdapt()
	end)

	arg0_6:UpdateAdapt()
end

function var0_0.UpdateAdapt(arg0_11)
	local var0_11 = 1.33333333333333
	local var1_11 = 2.33333333333333
	local var2_11 = pg.CameraFixMgr.GetInstance()
	local var3_11 = var2_11.currentWidth / var2_11.currentHeight
	local var4_11 = math.clamp(var3_11, var0_11, var1_11)

	arg0_11._tf:GetComponent(typeof(AspectRatioFitter)).aspectRatio = var4_11

	setSizeDelta(arg0_11._tf:Find("adapt"), {
		x = 0,
		y = 0
	})

	local var5_11 = NotchAdapt.CheckNotchRatio == math.clamp(NotchAdapt.CheckNotchRatio, var0_11, var1_11)

	SetComponentEnabled(arg0_11._tf:Find("adapt"), "NotchAdapt", var5_11)
end

function var0_0.ONToggleName(arg0_12, arg1_12, arg2_12)
	setText(arg1_12:Find("off/name"), i18n("fengfanV3_20251023_Sidebar" .. arg2_12:getConfig("is_show")))
	setText(arg1_12:Find("on/name"), i18n("fengfanV3_20251023_Sidebar" .. arg2_12:getConfig("is_show")))
end

function var0_0.OnplayAnimation(arg0_13, arg1_13)
	quickPlayAnimation(arg1_13, "Anim_SailingShip3SkinActUI_tabs_on_click")
end

function var0_0.didEnter(arg0_14)
	var0_0.super.didEnter(arg0_14)

	if not arg0_14.contextData.activeScenario then
		arg0_14._tf:GetComponent(typeof(Animation)).enabled = true
	end

	onButton(arg0_14, arg0_14.btnBack, function()
		local var0_15 = arg0_14.pageDic[arg0_14.activity.id]

		if var0_15:IsShowingPopWindow() then
			var0_15:ClosePopWindow()
		else
			arg0_14:emit(var0_0.ON_BACK)
		end
	end, SOUND_BACK)
end

function var0_0.willExit(arg0_16)
	var0_0.super.willExit(arg0_16)

	if arg0_16.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_16.camEventId)

		arg0_16.camEventId = nil
	end
end

return var0_0
