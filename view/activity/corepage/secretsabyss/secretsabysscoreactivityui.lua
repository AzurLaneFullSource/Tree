local var0_0 = class("SecretsAbyssCoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "SecretsAbyssCoreActivityUI"
end

var0_0.optionsPath = {
	"adapt/TopPage/top/btn_home"
}

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)
	quickPlayAnimation(arg0_2._tf:Find("adapt/TopPage/top"), "Anim_SecretsAbyssCoreActivityUI_top_In")
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("masaina_main_title"))
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("masaina_main_title_en"))

	local var0_2

	arg0_2.tabsList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = underscore.detect(arg0_2.activities, function(arg0_4)
				return tostring(arg0_4:getConfig("is_show")) == arg2_3.name
			end)

			if not var0_3 or var0_3:isEnd() then
				setActive(arg2_3, false)
			elseif not arg0_2.pageDic[var0_3.id] then
				warning(string.format("without page in act:", var0_3.id))
			else
				arg0_2:UpdateBtnText(var0_3, arg2_3)

				if arg0_2.pageDic[var0_3.id] ~= nil then
					setActive(arg2_3:Find("tip"), var0_3:readyToAchieve())
					onToggle(arg0_2, arg2_3, function(arg0_5)
						if arg0_5 then
							arg0_2:selectActivity(var0_3)

							if var0_2 ~= var0_3.id then
								quickPlayAnimation(arg2_3, "Anim_SecretsAbyssCoreActivityUI_tabs_on_In")
							end

							var0_2 = var0_3.id
						end
					end, SFX_PANEL)
				end
			end
		end
	end)

	arg0_2.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_6, arg1_6)
		arg0_2:UpdateAdapt()
	end)

	arg0_2:UpdateAdapt()
	onButton(arg0_2, arg0_2._tf:Find("adapt/TopPage/top/btn_back"), function()
		arg0_2:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
end

function var0_0.UpdateBtnText(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8:getConfig("title_res_tag")

	if pg.gametip[var0_8] then
		local var1_8 = i18n(var0_8)

		setText(arg2_8:Find("off/name"), var1_8)
		setText(arg2_8:Find("on/name"), var1_8)
	else
		setText(arg2_8:Find("off/name"), i18n("masaina_main_sheet" .. arg1_8:getConfig("is_show")))
		setText(arg2_8:Find("on/name"), i18n("masaina_main_sheet" .. arg1_8:getConfig("is_show")))
	end
end

function var0_0.UpdateAdapt(arg0_9)
	local var0_9 = 1.33333333333333
	local var1_9 = 2.16666666666667
	local var2_9 = pg.CameraFixMgr.GetInstance()
	local var3_9 = var2_9.currentWidth / var2_9.currentHeight
	local var4_9 = math.clamp(var3_9, var0_9, var1_9)

	arg0_9._tf:GetComponent(typeof(AspectRatioFitter)).aspectRatio = var4_9
end

function var0_0.willExit(arg0_10)
	var0_0.super.willExit(arg0_10)

	if arg0_10.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_10.camEventId)

		arg0_10.camEventId = nil
	end
end

return var0_0
