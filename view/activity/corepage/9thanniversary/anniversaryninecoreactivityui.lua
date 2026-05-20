local var0_0 = class("AnniversaryNineCoreActivityUI", import("view.activity.CorePage.CoreAdaptActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryNineCoreActivityUI"
end

var0_0.optionsPath = {
	"adapt/TopPage/top/btn_home"
}

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	arg0_2.topPage = arg0_2._tf:Find("adapt/TopPage")

	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("HelenaCoreActivity_title"))
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("HelenaCoreActivity_title2"))

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
				setText(arg2_3:Find("off/name"), arg0_2:GetButtonNameText(var0_3))
				setText(arg2_3:Find("on/name"), arg0_2:GetButtonNameText(var0_3))

				if arg0_2.pageDic[var0_3.id] ~= nil then
					local var1_3 = arg0_2.pageDic[var0_3.id]
					local var2_3 = arg2_3:Find("tip")
					local var3_3 = var1_3:IsShowReminder()

					setActive(var2_3, var0_3:readyToAchieve())
					onToggle(arg0_2, arg2_3, function(arg0_5)
						if arg0_5 then
							arg0_2:selectActivity(var0_3)

							if var0_2 ~= var0_3.id then
								arg0_2:OnClickBtn(arg2_3, var0_3.id)
							end

							var0_2 = var0_3.id
						end
					end, SFX_PANEL)
				end
			end
		end
	end)
end

function var0_0.GetButtonNameText(arg0_6, arg1_6)
	return i18n(string.format(arg1_6:getConfig("title_res_tag")))
end

return var0_0
